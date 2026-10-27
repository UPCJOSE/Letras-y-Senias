import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/controllers/conversation_controller.dart';
import 'package:senas_app/models/app_models.dart';
import 'package:senas_app/repositories/conversation_repository.dart';

void main() {
  group('código de conversación', () {
    test('genera 6 caracteres sin letras ni números ambiguos', () {
      final repository = ConversationRepository();
      for (var i = 0; i < 200; i++) {
        final code = repository.generateCode();
        expect(code, hasLength(ConversationRepository.codeLength));
        expect(
          code.split('').every(ConversationRepository.codeAlphabet.contains),
          isTrue,
        );
        expect(code, isNot(matches(RegExp('[01ILO]'))));
      }
    });

    test('normaliza minúsculas, espacios y guion', () {
      expect(ConversationRepository.normalizeCode('abc-234'), 'ABC234');
      expect(ConversationRepository.normalizeCode(' abc 234 '), 'ABC234');
    });

    test('rechaza códigos incompletos o con caracteres inválidos', () {
      expect(ConversationRepository.normalizeCode('ABC23'), isNull);
      expect(ConversationRepository.normalizeCode('ABC2345'), isNull);
      expect(ConversationRepository.normalizeCode('ABC0O1'), isNull);
      expect(ConversationRepository.normalizeCode(''), isNull);
    });

    test('formatea para dictarlo en dos bloques', () {
      expect(ConversationRepository.formatCode('ABC234'), 'ABC-234');
    });
  });

  group('modelos', () {
    test('CommunicationProfile se lee por nombre y tolera valores nulos', () {
      expect(
        CommunicationProfile.fromName('hearing'),
        CommunicationProfile.hearing,
      );
      expect(CommunicationProfile.fromName('deaf'), CommunicationProfile.deaf);
      expect(CommunicationProfile.fromName('otro'), isNull);
      expect(CommunicationProfile.fromName(null), isNull);
    });

    test('un perfil anterior sin tipo queda sin elegir', () {
      final profile = AppUserProfile.fromMap('uid', {
        'displayName': 'Ana',
        'email': 'ana@example.test',
        'role': 'individual',
      });
      expect(profile.communicationProfile, isNull);
    });

    test('Conversation resuelve a la otra persona desde cada lado', () {
      final conversation = Conversation.fromMap('ABC234', {
        'hostId': 'a',
        'hostName': 'Ana',
        'hostProfile': 'hearing',
        'guestId': 'b',
        'guestName': 'Beto',
        'guestProfile': 'deaf',
        'participantIds': ['a', 'b'],
        'status': 'active',
      });
      expect(conversation.status, ConversationStatus.active);
      expect(conversation.partnerName('a'), 'Beto');
      expect(conversation.partnerName('b'), 'Ana');
      expect(conversation.partnerProfile('a'), CommunicationProfile.deaf);
      expect(conversation.partnerProfile('b'), CommunicationProfile.hearing);
      expect(conversation.includes('c'), isFalse);
    });

    test('una sala sin invitada queda en espera', () {
      final conversation = Conversation.fromMap('ABC234', {
        'hostId': 'a',
        'hostName': 'Ana',
        'hostProfile': 'deaf',
        'guestId': null,
        'participantIds': ['a'],
        'status': 'waiting',
      });
      expect(conversation.hasGuest, isFalse);
      expect(conversation.isClosed, isFalse);
    });
  });

  group('ConversationController', () {
    test('sin sesión no crea ni se une y explica el motivo', () async {
      final controller = ConversationController(
        repository: ConversationRepository(),
      );
      addTearDown(controller.dispose);
      expect(await controller.create(), isNull);
      expect(controller.error, contains('Inicia sesión'));
      expect(await controller.join('ABC-234'), isNull);
      expect(controller.error, contains('Inicia sesión'));
      expect(await controller.send('ABC234', 'Hola'), isFalse);
    });

    test('un mensaje vacío no se envía ni genera error', () async {
      final controller = ConversationController(
        repository: ConversationRepository(),
      );
      addTearDown(controller.dispose);
      expect(await controller.send('ABC234', '   '), isFalse);
      expect(controller.error, isNull);
    });
  });
}
