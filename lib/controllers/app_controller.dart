import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../repositories/sign_repository.dart';
import '../repositories/translation_repository.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../services/translation_service.dart';
import '../services/lsc70_manifest_service.dart';
import '../services/shared_latest_stream.dart';

class AppController extends ChangeNotifier {
  AppController({
    TranslationService? translationService,
    AuthService? authService,
    UserRepository? userRepository,
    SignRepository? signRepository,
    TranslationRepository? translationRepository,
  }) : _translationService = translationService ?? TranslationService(),
       _authService = authService ?? AuthService(),
       _userRepository = userRepository ?? UserRepository(),
       _signRepository = signRepository ?? SignRepository(),
       _translationRepository =
           translationRepository ?? TranslationRepository() {
    _initAuthListener();
  }

  final TranslationService _translationService;
  final AuthService _authService;
  final UserRepository _userRepository;
  final SignRepository _signRepository;
  final TranslationRepository _translationRepository;

  StreamSubscription<User?>? _authSubscription;
  final ValueNotifier<int> _routeRefresh = ValueNotifier<int>(0);
  User? _currentUser;
  AppUserProfile? _profile;
  int _authRevision = 0;
  Future<AdminDashboardStats>? _dashboardStatsFuture;
  bool _authLoading = false;
  bool _authReady = false;
  bool _isAdmin = false;
  String? _authError;
  String? _dataError;
  String? _translationNotice;
  int _translationRevision = 0;
  bool _isTranslating = false;
  late final SharedLatestStream<List<SignEntry>> _publicSignsStream =
      SharedLatestStream(_signRepository.watchPublishedSigns);
  late final SharedLatestStream<List<SignEntry>> _allSignsStream =
      SharedLatestStream(_signRepository.watchAllSigns);
  late final SharedLatestStream<List<SignCategory>> _categoriesStream =
      SharedLatestStream(() => _signRepository.watchCategories());
  late final SharedLatestStream<List<SignCategory>> _adminCategoriesStream =
      SharedLatestStream(
        () => _signRepository.watchCategories(includeDrafts: true),
      );
  late final SharedLatestStream<List<AppUserProfile>> _usersStream =
      SharedLatestStream(_userRepository.watchUsers);
  final Map<String, SharedLatestStream<List<TranslationHistoryItem>>>
  _historyStreams = {};

  bool darkMode = false;
  bool highContrast = false;
  bool notifications = true;
  double playbackSpeed = 1;
  TranslationResult? currentTranslation;

  User? get currentUser => _currentUser;
  AppUserProfile? get profile => _profile;
  AppRole get role => _isAdmin ? AppRole.admin : AppRole.individual;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _currentUser != null;
  bool get isAuthLoading => _authLoading;
  bool get isAuthReady => _authReady;
  bool get isProfileActive => _profile?.active ?? true;
  String? get authError => _authError;
  String? get dataError => _dataError;
  String? get translationNotice => _translationNotice;
  bool get isTranslating => _isTranslating;
  Listenable get routeRefresh => _routeRefresh;
  String get userDisplayName => _profile?.displayName.isNotEmpty == true
      ? _profile!.displayName
      : _currentUser?.displayName?.isNotEmpty == true
      ? _currentUser!.displayName!
      : _currentUser?.email?.split('@').first ?? 'Usuario';
  String get userEmail => _currentUser?.email ?? '';

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

  Stream<List<SignEntry>> get publicSigns => _publicSignsStream;
  Stream<List<SignEntry>> get allSigns => _allSignsStream;
  Stream<List<SignCategory>> get categories => _categoriesStream;
  Stream<List<SignCategory>> get adminCategories => _adminCategoriesStream;
  Stream<List<AppUserProfile>> get users => _usersStream;

  Future<AdminDashboardStats> get dashboardStats =>
      _dashboardStatsFuture ??= _translationRepository.getDashboardStats();

  void _initAuthListener() {
    if (!_authService.isFirebaseAvailable) {
      _authReady = true;
      _routeRefresh.value++;
      return;
    }
    _currentUser = _authService.currentUser;
    _authSubscription = _authService.authStateChanges.listen(
      (user) => unawaited(_syncUser(user)),
      onError: (Object error) {
        _authReady = true;
        _authError = _friendlyError(error);
        _routeRefresh.value++;
        notifyListeners();
      },
    );
    if (_currentUser != null) unawaited(_syncUser(_currentUser));
  }

  Future<void> _syncUser(User? user) async {
    final revision = ++_authRevision;
    final previousUid = _currentUser?.uid;
    _currentUser = user;
    _authError = null;
    _dataError = null;
    if (user?.uid != previousUid) {
      _resetPreferences();
      for (final stream in _historyStreams.values) {
        unawaited(stream.dispose());
      }
      _historyStreams.clear();
    }
    if (user == null) {
      _profile = null;
      _isAdmin = false;
      _authReady = true;
      _routeRefresh.value++;
      notifyListeners();
      return;
    }

    _authReady = false;
    _routeRefresh.value++;
    notifyListeners();
    try {
      await _userRepository.ensureProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
      );
      final profile = await _userRepository.getProfile(user.uid);
      if (revision != _authRevision) return;
      _profile = profile;
      _isAdmin = profile?.role == AppRole.admin && (profile?.active ?? false);
      if (profile != null) {
        darkMode = profile.preferences['darkMode'] as bool? ?? darkMode;
        highContrast =
            profile.preferences['highContrast'] as bool? ?? highContrast;
        notifications =
            profile.preferences['notifications'] as bool? ?? notifications;
        playbackSpeed =
            (profile.preferences['playbackSpeed'] as num?)?.toDouble() ?? 1;
      }
      if (!isProfileActive) {
        _authError = 'Esta cuenta está desactivada. Comunícate con soporte.';
      }
    } catch (error) {
      if (revision != _authRevision) return;
      _dataError = _friendlyError(error);
      _profile = null;
      _isAdmin = false;
    } finally {
      if (revision == _authRevision) {
        _authReady = true;
        _routeRefresh.value++;
        notifyListeners();
      }
    }
  }

  void _resetPreferences() {
    darkMode = false;
    highContrast = false;
    notifications = true;
    playbackSpeed = 1;
  }

  void clearAuthError() {
    _authError = null;
    notifyListeners();
  }

  void clearDataError() {
    _dataError = null;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();
    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );
      await _syncUser(credential.user);
      if (!isProfileActive) {
        await logout();
        _authError = 'Esta cuenta está desactivada. Comunícate con soporte.';
        return false;
      }
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();
    try {
      final credential = await _authService.register(
        email: email,
        password: password,
        displayName: name,
      );
      await _syncUser(credential.user);
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();
    try {
      await _authService.sendPasswordReset(email);
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await _syncUser(null);
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setHighContrast(bool value) async {
    highContrast = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setNotifications(bool value) async {
    notifications = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setPlaybackSpeed(double value) async {
    if (![0.5, 1, 1.5].contains(value)) return;
    playbackSpeed = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final user = _currentUser;
    if (user == null) return;
    try {
      await _userRepository.updatePreferences(user.uid, {
        'darkMode': darkMode,
        'highContrast': highContrast,
        'notifications': notifications,
        'playbackSpeed': playbackSpeed,
      });
    } catch (error) {
      _dataError = _friendlyError(error);
      notifyListeners();
    }
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

  Future<void> saveDraftSign({
    required String term,
    required String category,
    required String animationKey,
    required List<String> aliases,
    required String source,
  }) => _signRepository.saveDraft(
    term: term,
    category: category,
    animationKey: animationKey,
    aliases: aliases,
    source: source,
  );

  Future<void> validateSign(String id) => _signRepository.validateSign(id);

  Future<int> validateSigns(List<String> ids) =>
      _signRepository.validateSigns(ids);

  Future<void> createUserByAdmin({
    required String name,
    required String email,
    required String password,
    required AppRole role,
  }) async {
    if (!_isAdmin) {
      throw StateError('Solo un administrador puede crear cuentas.');
    }
    if (name.trim().isEmpty || email.trim().isEmpty || password.length < 6) {
      throw ArgumentError(
        'Completa el nombre, correo y una contraseña de 6 caracteres o más.',
      );
    }
    if (!email.contains('@')) {
      throw ArgumentError('Escribe un correo electrónico válido.');
    }
    await _authService.createUserByAdmin(
      email: email,
      password: password,
      displayName: name,
      onCreated: (uid, normalizedEmail) => _userRepository.createManagedProfile(
        uid: uid,
        email: normalizedEmail,
        displayName: name,
        role: role,
      ),
    );
  }

  Future<int> importLsc70Manifest(String source) async {
    if (!_isAdmin) {
      throw StateError('Solo un administrador puede cargar recursos.');
    }
    final entries = Lsc70ManifestService().parse(source);
    return _signRepository.importMediaManifest(entries);
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('permission-denied')) {
      return 'No tienes permiso para realizar esta acción.';
    }
    if (message.contains('unavailable') || message.contains('network')) {
      return 'No hay conexión con Firebase. Inténtalo de nuevo.';
    }
    if (message.startsWith('Exception: ')) return message.substring(11);
    return message;
  }

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    unawaited(_publicSignsStream.dispose());
    unawaited(_allSignsStream.dispose());
    unawaited(_categoriesStream.dispose());
    unawaited(_adminCategoriesStream.dispose());
    unawaited(_usersStream.dispose());
    for (final stream in _historyStreams.values) {
      unawaited(stream.dispose());
    }
    _routeRefresh.dispose();
    super.dispose();
  }
}
