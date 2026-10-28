part of 'app_controller.dart';

/// Traducción a LSC, historial y reproducción de consultas previas.
mixin TranslationController on CatalogController {
  String? _translationNotice;
  int _translationRevision = 0;
  bool _isTranslating = false;
  TranslationResult? currentTranslation;
  final Map<String, SharedLatestStream<List<TranslationHistoryItem>>>
  _historyStreams = {};

  String? get translationNotice => _translationNotice;
  bool get isTranslating => _isTranslating;

  Stream<List<TranslationHistoryItem>> get history {
    final uid = _currentUser?.uid;
    if (uid == null) return Stream.value(const []);
    return _historyStreams.putIfAbsent(
      uid,
      () => SharedLatestStream(
        () => _translationRepository.watchUserHistory(uid),
      ),
    );
  }

  void _resetHistoryStreams() {
    for (final stream in _historyStreams.values) {
      unawaited(stream.dispose());
    }
    _historyStreams.clear();
  }

  Future<String> translateRoute(String input) async {
    _isTranslating = true;
    notifyListeners();
    try {
      final publishedSigns =
          _publicSignsStream.latest ??
          await _signRepository.getPublishedSigns();
      final result = _translationService
          .withCatalog(publishedSigns)
          .translate(input);
      final revision = ++_translationRevision;
      currentTranslation = result;
      _translationNotice = null;
      final user = _currentUser;
      if (user != null) {
        unawaited(_saveHistory(user.uid, result, revision));
      } else {
        _translationNotice = 'Inicia sesión para guardar esta traducción.';
      }
      notifyListeners();
      if (result.suggestions.isNotEmpty) return '/not-found';
      if (result.spelling.isNotEmpty) return '/spelling';
      return '/translate';
    } finally {
      _isTranslating = false;
      notifyListeners();
    }
  }

  Future<void> _saveHistory(
    String uid,
    TranslationResult result,
    int revision,
  ) async {
    try {
      await _translationRepository.save(uid, result);
    } catch (_) {
      if (revision != _translationRevision || _currentUser?.uid != uid) return;
      _translationNotice =
          'La traducción está lista, pero no se pudo guardar en tu historial.';
      notifyListeners();
    }
  }

  Future<String> replayHistory(TranslationHistoryItem item) async {
    _translationNotice = null;
    currentTranslation = TranslationResult(
      originalText: item.text,
      normalizedText: item.normalizedText,
      signs: item.signs,
      missingWords: item.missingWords,
      spelling: item.spelling,
      suggestions: const [],
      sequence: item.sequence,
      sequenceEntries: await _signRepository.resolveReferences(item.sequence),
    );
    notifyListeners();
    return item.spelling.isNotEmpty ? '/spelling' : '/translate';
  }

  Future<TranslationResult> translateQuietly(String input) async {
    final publishedSigns =
        _publicSignsStream.latest ?? await _signRepository.getPublishedSigns();
    return _translationService.withCatalog(publishedSigns).translate(input);
  }
}
