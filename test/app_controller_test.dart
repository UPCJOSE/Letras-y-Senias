import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/controllers/app_controller.dart';
import 'package:senas_app/models/app_models.dart';
import 'package:senas_app/repositories/sign_repository.dart';
import 'package:senas_app/repositories/translation_repository.dart';
import 'package:senas_app/repositories/user_repository.dart';
import 'package:senas_app/services/auth_service.dart';
import 'package:senas_app/services/translation_service.dart';

class _SignRepository extends SignRepository {
  @override
  Future<List<SignEntry>> getPublishedSigns() async => const [
    SignEntry(
      term: 'Hola',
      category: 'Saludos',
      animationKey: 'hola',
      validated: true,
      active: true,
    ),
  ];
}

class _EmptySignRepository extends SignRepository {
  @override
  Future<List<SignEntry>> getPublishedSigns() async => const [];
}

class _TranslationRepository extends TranslationRepository {
  int savedCount = 0;

  @override
  Future<void> save(String userId, TranslationResult result) async {
    savedCount++;
  }
}

class _PendingTranslationRepository extends TranslationRepository {
  final saved = Completer<void>();

  @override
  Future<void> save(String userId, TranslationResult result) => saved.future;
}

class _TestUser extends Fake implements User {
  @override
  String get uid => 'test-person';
  @override
  String? get email => 'person@example.test';
  @override
  String? get displayName => 'Persona';
}

class _SignedInAuthService extends AuthService {
  final User user = _TestUser();

  @override
  bool get isFirebaseAvailable => true;
  @override
  User? get currentUser => user;
  @override
  Stream<User?> get authStateChanges => Stream.value(user);
}

class _ProfileRepository extends UserRepository {
  @override
  Future<void> ensureProfile({
    required String uid,
    required String email,
    required String displayName,
    CommunicationProfile? communicationProfile,
  }) async {}

  @override
  Future<AppUserProfile?> getProfile(String uid) async => const AppUserProfile(
    id: 'test-person',
    displayName: 'Persona',
    email: 'person@example.test',
    role: AppRole.individual,
  );
}

void main() {
  test(
    'resuelve usando señas publicadas y no simula historial de invitado',
    () async {
      final history = _TranslationRepository();
      final controller = AppController(
        translationService: TranslationService(),
        signRepository: _SignRepository(),
        translationRepository: history,
      );
      addTearDown(controller.dispose);

      final route = await controller.translateRoute('Hola');

      expect(route, '/translate');
      expect(controller.currentTranslation?.signs.single.term, 'Hola');
      expect(
        controller.translationNotice,
        'Inicia sesión para guardar esta traducción.',
      );
      expect(history.savedCount, 0);
    },
  );

  test(
    'no inventa una seña cuando Firestore no tiene catálogo publicado',
    () async {
      final controller = AppController(
        translationService: TranslationService(),
        signRepository: _EmptySignRepository(),
        translationRepository: _TranslationRepository(),
      );
      addTearDown(controller.dispose);

      final route = await controller.translateRoute('Hola');

      expect(route, '/spelling');
      expect(controller.currentTranslation?.signs, isEmpty);
      expect(controller.currentTranslation?.spelling, ['H', 'O', 'L', 'A']);
    },
  );

  test(
    'muestra el resultado antes de que termine el guardado remoto',
    () async {
      final history = _PendingTranslationRepository();
      final controller = AppController(
        authService: _SignedInAuthService(),
        userRepository: _ProfileRepository(),
        signRepository: _SignRepository(),
        translationRepository: history,
      );
      addTearDown(controller.dispose);
      await Future<void>.delayed(Duration.zero);

      final destination = await controller.translateRoute('Hola');

      expect(destination, '/translate');
      expect(controller.currentTranslation?.signs.single.term, 'Hola');
      expect(history.saved.isCompleted, isFalse);
      history.saved.complete();
      await Future<void>.delayed(Duration.zero);
      expect(controller.translationNotice, isNull);
    },
  );
}
