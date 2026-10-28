import 'package:flutter/material.dart';

enum AppRole { individual, admin }

enum CommunicationProfile {
  hearing,
  deaf;

  String get label =>
      this == CommunicationProfile.hearing ? 'Persona oyente' : 'Persona sorda';

  String get description => this == CommunicationProfile.hearing
      ? 'Escribo mensajes y la otra persona los ve en señas.'
      : 'Leo los mensajes en texto y los veo en señas.';

  IconData get icon => this == CommunicationProfile.hearing
      ? Icons.hearing_outlined
      : Icons.hearing_disabled_outlined;

  static CommunicationProfile? fromName(Object? value) {
    for (final item in CommunicationProfile.values) {
      if (item.name == value) return item;
    }
    return null;
  }
}

enum SignStatus { draft, validated }

enum SignKind { word, letter }

enum ConversationStatus { waiting, active, closed }
