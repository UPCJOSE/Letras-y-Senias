import 'enums.dart';

class Conversation {
  const Conversation({
    required this.code,
    required this.hostId,
    required this.hostName,
    required this.hostProfile,
    required this.status,
    this.guestId,
    this.guestName = '',
    this.guestProfile,
    this.participantIds = const [],
  });

  final String code;
  final String hostId;
  final String hostName;
  final CommunicationProfile hostProfile;
  final String? guestId;
  final String guestName;
  final CommunicationProfile? guestProfile;
  final ConversationStatus status;
  final List<String> participantIds;

  bool get isClosed => status == ConversationStatus.closed;
  bool get hasGuest => guestId != null;

  bool includes(String uid) => participantIds.contains(uid);

  String partnerName(String uid) => uid == hostId ? guestName : hostName;

  CommunicationProfile? partnerProfile(String uid) =>
      uid == hostId ? guestProfile : hostProfile;

  factory Conversation.fromMap(String code, Map<String, dynamic> data) {
    final status = switch (data['status']) {
      'active' => ConversationStatus.active,
      'closed' => ConversationStatus.closed,
      _ => ConversationStatus.waiting,
    };
    return Conversation(
      code: code,
      hostId: data['hostId'] as String? ?? '',
      hostName: data['hostName'] as String? ?? '',
      hostProfile:
          CommunicationProfile.fromName(data['hostProfile']) ??
          CommunicationProfile.hearing,
      guestId: data['guestId'] as String?,
      guestName: data['guestName'] as String? ?? '',
      guestProfile: CommunicationProfile.fromName(data['guestProfile']),
      status: status,
      participantIds: (data['participantIds'] as List<dynamic>? ?? const [])
          .whereType<String>()
          .toList(),
    );
  }
}

class ConversationMessage {
  const ConversationMessage({
    required this.id,
    required this.senderId,
    required this.senderName,
    required this.senderProfile,
    required this.text,
    this.createdAt,
  });

  final String id;
  final String senderId;
  final String senderName;
  final CommunicationProfile senderProfile;
  final String text;
  final DateTime? createdAt;

  factory ConversationMessage.fromMap(
    String id,
    Map<String, dynamic> data, {
    DateTime? createdAt,
  }) {
    return ConversationMessage(
      id: id,
      senderId: data['senderId'] as String? ?? '',
      senderName: data['senderName'] as String? ?? '',
      senderProfile:
          CommunicationProfile.fromName(data['senderProfile']) ??
          CommunicationProfile.hearing,
      text: data['text'] as String? ?? '',
      createdAt: createdAt,
    );
  }
}
