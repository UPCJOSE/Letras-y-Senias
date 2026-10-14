import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';

class SignRepository {
  SignRepository({this.firestore});

  final FirebaseFirestore? firestore;
  FirebaseFirestore get _db => firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _signs =>
      _db.collection('signs');
  CollectionReference<Map<String, dynamic>> get _categories =>
      _db.collection('categories');

  Future<List<SignEntry?>> resolveReferences(
    List<TranslationReference> sequence,
  ) async {
    final signRequests = <String, Future<SignEntry?>>{};
    for (final id in sequence.map((reference) => reference.signId).nonNulls) {
      signRequests.putIfAbsent(id, () async {
        try {
          final snapshot = await _signs.doc(id).get();
          if (snapshot.exists && snapshot.data() != null) {
            return _signFromData(snapshot.id, snapshot.data()!);
          }
        } on FirebaseException {
          return null;
        }
        return null;
      });
    }
    return Future.wait(
      sequence.map(
        (reference) => reference.signId == null
            ? Future<SignEntry?>.value(null)
            : signRequests[reference.signId]!,
      ),
    );
  }

  Future<List<SignEntry>> getPublishedSigns() async {
    final snapshot = await _signs
        .where('status', isEqualTo: 'validated')
        .where('active', isEqualTo: true)
        .get();
    return snapshot.docs
        .map((doc) => _signFromData(doc.id, doc.data()))
        .toList();
  }

  Stream<List<SignEntry>> watchPublishedSigns() {
    return _signs
        .where('status', isEqualTo: 'validated')
        .where('active', isEqualTo: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => _signFromData(doc.id, doc.data()))
              .toList(),
        );
  }

  Stream<List<SignEntry>> watchAllSigns() {
    return _signs.snapshots().map(
      (snapshot) =>
          snapshot.docs.map((doc) => _signFromData(doc.id, doc.data())).toList()
            ..sort(
              (a, b) => a.term.toLowerCase().compareTo(b.term.toLowerCase()),
            ),
    );
  }

  Stream<List<SignCategory>> watchCategories({bool includeDrafts = false}) {
    final query = includeDrafts
        ? _categories
        : _categories
              .where('status', isEqualTo: 'validated')
              .where('active', isEqualTo: true);
    return query.snapshots().map((snapshot) {
      final categories =
          snapshot.docs
              .map(
                (doc) => SignCategory(
                  id: doc.id,
                  name: doc.data()['name'] as String? ?? doc.id,
                  active: doc.data()['active'] as bool? ?? false,
                ),
              )
              .toList()
            ..sort(
              (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
            );
      return categories;
    });
  }

  Future<void> saveDraft({
    required String term,
    required String category,
    required String animationKey,
    required List<String> aliases,
    required String source,
  }) async {
    final categoryId = _slug(category);
    await _db.runTransaction((transaction) async {
      final categoryReference = _categories.doc(categoryId);
      final categorySnapshot = await transaction.get(categoryReference);
      if (!categorySnapshot.exists) {
        transaction.set(categoryReference, {
          'name': category.trim(),
          'status': 'draft',
          'active': false,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      transaction.set(_signs.doc(), {
        'term': term.trim(),
        'aliases': aliases,
        'category': category.trim(),
        'categoryId': categoryId,
        'animationKey': animationKey.trim(),
        'source': source.trim(),
        'status': 'draft',
        'validated': false,
        'active': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> validateSign(String id) async {
    final signReference = _signs.doc(id);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(signReference);
      final data = snapshot.data();
      if (data == null) throw StateError('La seña ya no existe.');
      final categoryId =
          data['categoryId'] as String? ??
          _slug(data['category'] as String? ?? 'sin-categoria');
      final categoryReference = _categories.doc(categoryId);
      final categorySnapshot = await transaction.get(categoryReference);
      transaction.update(signReference, {
        'status': 'validated',
        'validated': true,
        'active': true,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      transaction.set(categoryReference, {
        'name': data['category'] as String? ?? 'Sin categoría',
        'status': 'validated',
        'active': true,
        if (!categorySnapshot.exists) 'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    });
  }

  Future<int> validateSigns(List<String> ids) async {
    final uniqueIds = ids.toSet().toList();
    if (uniqueIds.isEmpty) return 0;
    if (uniqueIds.length > 200) {
      throw StateError('Valida máximo 200 señas por lote.');
    }
    return _db.runTransaction((transaction) async {
      final references = uniqueIds.map(_signs.doc).toList();
      final snapshots = await Future.wait(references.map(transaction.get));
      final pending =
          <(DocumentReference<Map<String, dynamic>>, Map<String, dynamic>)>[];
      final categories = <String, String>{};
      for (var index = 0; index < snapshots.length; index++) {
        final data = snapshots[index].data();
        if (data == null) {
          throw StateError(
            'Una de las señas ya no existe. Actualiza la lista.',
          );
        }
        if (data['status'] == 'validated' || data['validated'] == true) {
          continue;
        }
        if (SignMedia.fromMap(data['media']) == null) {
          throw StateError(
            'La seña "${data['term'] ?? snapshots[index].id}" no tiene un recurso LSC70 válido.',
          );
        }
        pending.add((references[index], data));
        final category = data['category'] as String? ?? 'Sin categoría';
        final categoryId = data['categoryId'] as String? ?? _slug(category);
        categories[categoryId] = category;
      }
      final categorySnapshots = await Future.wait(
        categories.keys.map((id) => transaction.get(_categories.doc(id))),
      );
      for (final (reference, _) in pending) {
        transaction.update(reference, {
          'status': 'validated',
          'validated': true,
          'active': true,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      for (var index = 0; index < categorySnapshots.length; index++) {
        final id = categories.keys.elementAt(index);
        transaction.set(_categories.doc(id), {
          'name': categories[id],
          'status': 'validated',
          'active': true,
          if (!categorySnapshots[index].exists)
            'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
      return pending.length;
    });
  }

  String _slug(String value) {
    var normalized = value.toLowerCase().trim();
    const accents = {
      'á': 'a',
      'é': 'e',
      'í': 'i',
      'ó': 'o',
      'ú': 'u',
      'ü': 'u',
      'ñ': 'n',
    };
    for (final entry in accents.entries) {
      normalized = normalized.replaceAll(entry.key, entry.value);
    }
    return normalized
        .replaceAll(RegExp(r'[^a-z0-9]+'), '-')
        .replaceAll(RegExp(r'^-|-$'), '');
  }

  SignEntry _signFromData(String id, Map<String, dynamic> data) {
    return SignEntry(
      id: id,
      term: data['term'] as String? ?? id,
      category: data['category'] as String? ?? 'Sin categoría',
      animationKey: data['animationKey'] as String? ?? '',
      aliases: (data['aliases'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
      validated: data['status'] == 'validated' || data['validated'] == true,
      active: data['active'] as bool? ?? false,
      source: data['source'] as String?,
      media: SignMedia.fromMap(data['media']),
      kind: data['kind'] == 'letter' ? SignKind.letter : SignKind.word,
    );
  }

  Future<int> importMediaManifest(List<Map<String, dynamic>> entries) async {
    final refs = <DocumentReference<Map<String, dynamic>>>[];
    final all = await _signs.get();
    for (final entry in entries) {
      final key = (entry['animationKey'] as String).trim();
      final term = (entry['term'] as String).trim().toLowerCase();
      final kind = entry['kind'] as String? ?? 'word';
      final keyMatches = all.docs
          .where((doc) => (doc.data()['animationKey'] as String? ?? '') == key)
          .toList();
      if (keyMatches.any(
        (doc) => (doc.data()['kind'] as String? ?? 'word') != kind,
      )) {
        throw StateError(
          'La clave "$key" ya pertenece a una entrada de otro tipo.',
        );
      }
      final matches = all.docs.where((doc) {
        final data = doc.data();
        return (data['animationKey'] as String? ?? '') == key ||
            ((data['term'] as String? ?? '').trim().toLowerCase() == term &&
                (data['kind'] as String? ?? 'word') == kind);
      }).toList();
      if (matches.length > 1) {
        throw StateError(
          'La clave "$key" o el término "$term" coincide con varias señas.',
        );
      }
      refs.add(matches.isEmpty ? _signs.doc() : matches.single.reference);
    }
    final batch = _db.batch();
    for (var i = 0; i < entries.length; i++) {
      final row = entries[i];
      final media = SignMedia.fromMap({
        'provider': 'cloudinary',
        'type': 'imageSequence',
        'frameUrls': row['frameUrls'],
        'frameDurationMs': row['frameDurationMs'] ?? 167,
        'dataset': 'LSC70',
        'datasetVersion': '2',
        'subset': row['subset'],
        'sourceLabel': row['sourceLabel'],
        'participantId': row['participantId'],
        'license': 'CC BY 4.0',
        'attribution':
            'Muñoz Galindez, Villota Coral y Vargas Cañas, Data in Brief 58 (2025), CC BY 4.0, DOI: 10.1016/j.dib.2024.111213; dataset DOI: 10.17632/9ssyn8tff5.2',
      });
      if (media == null) {
        throw StateError('La secuencia de "${row['term']}" no es válida.');
      }
      final existing =
          refs[i].id.isNotEmpty && all.docs.any((doc) => doc.id == refs[i].id);
      final payload = <String, dynamic>{
        'media': media.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      };
      if (existing) {
        batch.update(refs[i], payload);
      } else {
        final category = row['category'] as String? ?? 'LSC70';
        batch.set(refs[i], {
          ...payload,
          'aliases': row['aliases'] ?? [],
          'term': row['term'],
          'category': category,
          'categoryId': _slug(category),
          'animationKey': row['animationKey'],
          'kind': row['kind'] ?? 'word',
          'source': 'LSC70 v2 · ${row['subset']} · ${row['sourceLabel']}',
          'status': 'draft',
          'validated': false,
          'active': false,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
    }
    await batch.commit();
    return entries.length;
  }
}
