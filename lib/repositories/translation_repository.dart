import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';

class TranslationRepository {
  TranslationRepository({this.firestore});

  final FirebaseFirestore? firestore;
  FirebaseFirestore get _db => firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _translations =>
      _db.collection('translations');

  Future<void> save(String userId, TranslationResult result) async {
    await _translations.add({
      'userId': userId,
      'originalText': result.originalText,
      'normalizedText': result.normalizedText,
      'signs': result.signs.map(_signToMap).toList(),
      'missingWords': result.missingWords,
      'spelling': result.spelling,
      'playbackSequence': result.sequence
          .map((reference) => reference.toMap())
          .toList(),
      'signCount': result.signs.length + result.spelling.length,
      'hasMissingWords': result.missingWords.isNotEmpty,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<TranslationHistoryItem>> watchUserHistory(String userId) {
    // Keep Firestore's broadcast stream semantics. Wrapping it in `async*`
    // makes it single-subscription, but the controller shares this stream
    // between the home preview and the full history screen.
    return _translations.where('userId', isEqualTo: userId).snapshots().map((
      snapshot,
    ) {
      final entries =
          snapshot.docs
              .map((doc) => _historyFromData(doc.id, doc.data()))
              .toList()
            ..sort((a, b) {
              final first = a.createdAt;
              final second = b.createdAt;
              if (first == null || second == null) return 0;
              return second.compareTo(first);
            });
      return entries;
    });
  }

  Future<AdminDashboardStats> getDashboardStats() async {
    final results = await Future.wait([
      _db.collection('users').count().get(),
      _translations.count().get(),
      _db.collection('signs').where('status', isEqualTo: 'draft').count().get(),
      _translations.where('hasMissingWords', isEqualTo: true).count().get(),
    ]);
    return AdminDashboardStats(
      people: results[0].count ?? 0,
      translations: results[1].count ?? 0,
      draftSigns: results[2].count ?? 0,
      untranslatedWords: results[3].count ?? 0,
    );
  }

  Map<String, dynamic> _signToMap(SignEntry sign) => {
    'id': sign.id,
    'term': sign.term,
    'category': sign.category,
    'animationKey': sign.animationKey,
    'aliases': sign.aliases,
  };

  TranslationHistoryItem _historyFromData(
    String id,
    Map<String, dynamic> data,
  ) {
    final timestamp = data['createdAt'];
    final signs = (data['signs'] as List<dynamic>? ?? const [])
        .whereType<Map<String, dynamic>>()
        .map(
          (sign) => SignEntry(
            id: sign['id'] as String?,
            term: sign['term'] as String? ?? '',
            category: sign['category'] as String? ?? '',
            animationKey: sign['animationKey'] as String? ?? '',
            aliases: (sign['aliases'] as List<dynamic>? ?? const [])
                .whereType<String>()
                .toList(),
            kind: sign['kind'] == 'letter' ? SignKind.letter : SignKind.word,
          ),
        )
        .toList();
    final storedSequence =
        (data['playbackSequence'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(
              (value) => TranslationReference(
                label: value['label'] as String? ?? '',
                kind: value['kind'] == 'letter'
                    ? SignKind.letter
                    : SignKind.word,
                signId: value['signId'] as String?,
                animationKey: value['animationKey'] as String? ?? '',
              ),
            )
            .toList();
    final legacySequence = [
      ...signs.map(
        (sign) => TranslationReference(
          label: sign.term,
          kind: SignKind.word,
          signId: sign.id,
          animationKey: sign.animationKey,
        ),
      ),
      ...((data['spelling'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .map(
            (letter) =>
                TranslationReference(label: letter, kind: SignKind.letter),
          )),
    ];
    return TranslationHistoryItem(
      id: id,
      text: data['originalText'] as String? ?? '',
      normalizedText: data['normalizedText'] as String? ?? '',
      signCount: data['signCount'] as int? ?? 0,
      signs: signs,
      missingWords: (data['missingWords'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      spelling: (data['spelling'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
      sequence: storedSequence.isEmpty ? legacySequence : storedSequence,
    );
  }
}
