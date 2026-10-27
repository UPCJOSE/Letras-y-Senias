import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_models.dart';

/// Acceso a las conversaciones compartidas en Firestore.
///
/// `conversations/{code}` guarda la sala y `conversations/{code}/messages`
/// los mensajes. El código de invitación es el identificador del documento.
class ConversationRepository {
  ConversationRepository({this.firestore, Random? random})
    : _random = random ?? Random.secure();

  /// Sin 0/O ni 1/I/L para que el código se pueda dictar sin confusiones.
  static const codeAlphabet = 'ABCDEFGHJKMNPQRSTUVWXYZ23456789';
  static const codeLength = 6;
  static const maxMessageLength = 1000;

  final FirebaseFirestore? firestore;
  final Random _random;
  FirebaseFirestore get _db => firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _conversations =>
      _db.collection('conversations');

  String generateCode() => List.generate(
    codeLength,
    (_) => codeAlphabet[_random.nextInt(codeAlphabet.length)],
  ).join();

  /// Quita espacios y guiones y pasa a mayúsculas; devuelve null si el
  /// resultado no puede ser un código válido.
  static String? normalizeCode(String input) {
    final code = input.toUpperCase().replaceAll(RegExp(r'[^A-Z0-9]'), '');
    if (code.length != codeLength) return null;
    if (code.split('').any((char) => !codeAlphabet.contains(char))) {
      return null;
    }
    return code;
  }

  static String formatCode(String code) => code.length == codeLength
      ? '${code.substring(0, 3)}-${code.substring(3)}'
      : code;

  Future<String> create({
    required String uid,
    required String name,
    required CommunicationProfile profile,
  }) async {
    for (var attempt = 0; attempt < 6; attempt++) {
      final code = generateCode();
      final reference = _conversations.doc(code);
      final created = await _db.runTransaction<bool>((transaction) async {
        final snapshot = await transaction.get(reference);
        if (snapshot.exists) return false;
        transaction.set(reference, {
          'code': code,
          'hostId': uid,
          'hostName': name,
          'hostProfile': profile.name,
          'guestId': null,
          'guestName': '',
          'guestProfile': null,
          'participantIds': [uid],
          'status': 'waiting',
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      });
      if (created) return code;
    }
    throw Exception('No se pudo generar un código. Inténtalo de nuevo.');
  }

  /// Une a [uid] a la sala. Si ya participa, solo vuelve a entrar.
  Future<Conversation> join({
    required String code,
    required String uid,
    required String name,
    required CommunicationProfile profile,
  }) {
    final reference = _conversations.doc(code);
    return _db.runTransaction<Conversation>((transaction) async {
      final snapshot = await transaction.get(reference);
      final data = snapshot.data();
      if (data == null) {
        throw Exception('No encontramos una conversación con ese código.');
      }
      final conversation = Conversation.fromMap(code, data);
      if (conversation.includes(uid)) return conversation;
      if (conversation.isClosed) {
        throw Exception('Esta conversación ya fue finalizada.');
      }
      if (conversation.hasGuest) {
        throw Exception('Esta conversación ya tiene dos personas.');
      }
      if (conversation.hostProfile == profile) {
        throw Exception(
          profile == CommunicationProfile.hearing
              ? 'Esta sala la creó otra persona oyente. '
                    'Pide un código a una persona sorda.'
              : 'Esta sala la creó otra persona sorda. '
                    'Pide un código a una persona oyente.',
        );
      }
      transaction.update(reference, {
        'guestId': uid,
        'guestName': name,
        'guestProfile': profile.name,
        'participantIds': [...conversation.participantIds, uid],
        'status': 'active',
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return Conversation(
        code: code,
        hostId: conversation.hostId,
        hostName: conversation.hostName,
        hostProfile: conversation.hostProfile,
        guestId: uid,
        guestName: name,
        guestProfile: profile,
        status: ConversationStatus.active,
        participantIds: [...conversation.participantIds, uid],
      );
    });
  }

  Stream<Conversation?> watch(String code) => _conversations
      .doc(code)
      .snapshots()
      .map(
        (snapshot) => snapshot.data() == null
            ? null
            : Conversation.fromMap(snapshot.id, snapshot.data()!),
      );

  Stream<List<ConversationMessage>> watchMessages(String code) => _conversations
      .doc(code)
      .collection('messages')
      .orderBy('createdAt')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.map((doc) {
          final timestamp = doc.data()['createdAt'];
          return ConversationMessage.fromMap(
            doc.id,
            doc.data(),
            createdAt: timestamp is Timestamp ? timestamp.toDate() : null,
          );
        }).toList(),
      );

  Future<void> sendMessage({
    required String code,
    required String uid,
    required String name,
    required CommunicationProfile profile,
    required String text,
  }) => _conversations.doc(code).collection('messages').add({
    'senderId': uid,
    'senderName': name,
    'senderProfile': profile.name,
    'text': text,
    'createdAt': FieldValue.serverTimestamp(),
  });

  Future<void> close(String code) => _conversations.doc(code).update({
    'status': 'closed',
    'updatedAt': FieldValue.serverTimestamp(),
  });
}
