import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';

class UserRepository {
  UserRepository({this.firestore});

  final FirebaseFirestore? firestore;
  FirebaseFirestore get _db => firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _users =>
      _db.collection('users');

  Future<AppUserProfile?> getProfile(String uid) async {
    final snapshot = await _users.doc(uid).get();
    final data = snapshot.data();
    return data == null ? null : AppUserProfile.fromMap(snapshot.id, data);
  }

  Stream<AppUserProfile?> watchProfile(String uid) {
    return _users
        .doc(uid)
        .snapshots()
        .map(
          (snapshot) => snapshot.data() == null
              ? null
              : AppUserProfile.fromMap(snapshot.id, snapshot.data()!),
        );
  }

  Future<void> ensureProfile({
    required String uid,
    required String email,
    required String displayName,
    CommunicationProfile? communicationProfile,
  }) async {
    final reference = _users.doc(uid);
    await _db.runTransaction((transaction) async {
      final snapshot = await transaction.get(reference);
      if (snapshot.exists) return;
      transaction.set(reference, {
        'displayName': displayName.trim(),
        'email': email.trim().toLowerCase(),
        'role': 'individual',
        'active': true,
        'plan': 'free',
        'preferences': {
          'darkMode': false,
          'highContrast': false,
          'notifications': true,
        },
        if (communicationProfile != null)
          'communicationProfile': communicationProfile.name,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    });
  }

  Future<void> setCommunicationProfile(
    String uid,
    CommunicationProfile profile,
  ) => _users.doc(uid).update({
    'communicationProfile': profile.name,
    'updatedAt': FieldValue.serverTimestamp(),
  });

  Future<void> createManagedProfile({
    required String uid,
    required String email,
    required String displayName,
    required AppRole role,
  }) async {
    await _users.doc(uid).set({
      'displayName': displayName.trim(),
      'email': email.trim().toLowerCase(),
      'role': role.name,
      'active': true,
      'plan': 'free',
      'preferences': {
        'darkMode': false,
        'highContrast': false,
        'notifications': true,
        'playbackSpeed': 1,
      },
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<AppUserProfile>> watchUsers() {
    return _users.snapshots().map((snapshot) {
      final profiles = snapshot.docs
          .map((doc) => AppUserProfile.fromMap(doc.id, doc.data()))
          .toList();
      profiles.sort(
        (a, b) =>
            a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase()),
      );
      return profiles;
    });
  }

  Future<void> updatePreferences(
    String uid,
    Map<String, dynamic> preferences,
  ) => _users.doc(uid).update({
    'preferences': preferences,
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
