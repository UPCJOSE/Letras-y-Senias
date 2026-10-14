import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/controllers/app_controller.dart';
import 'package:senas_app/services/auth_service.dart';

void main() {
  group('AuthService - Mapeo de errores en español', () {
    test('mapea errores comunes de FirebaseAuth a mensajes amigables', () {
      expect(
        AuthService.getSpanishErrorMessage('user-not-found'),
        'No existe una cuenta registrada con este correo electrónico.',
      );
      expect(
        AuthService.getSpanishErrorMessage('wrong-password'),
        'Contraseña incorrecta. Inténtalo de nuevo.',
      );
      expect(
        AuthService.getSpanishErrorMessage('invalid-credential'),
        'El correo electrónico o la contraseña son incorrectos.',
      );
      expect(
        AuthService.getSpanishErrorMessage('email-already-in-use'),
        'Ya existe una cuenta registrada con este correo electrónico.',
      );
      expect(
        AuthService.getSpanishErrorMessage('weak-password'),
        'La contraseña es muy débil. Debe tener al menos 6 caracteres.',
      );
      expect(
        AuthService.getSpanishErrorMessage('network-request-failed'),
        'Error de conexión. Verifica tu conexión a internet.',
      );
    });
  });

  group('AppController - Estado de autenticación', () {
    test('inicia sin usuario y con valores por defecto de invitado', () {
      final controller = AppController();
      expect(controller.isAuthenticated, isFalse);
      expect(controller.currentUser, isNull);
      expect(controller.isAuthLoading, isFalse);
      expect(controller.authError, isNull);
      expect(controller.userDisplayName, 'Usuario');
      expect(controller.userEmail, '');
    });

    test('limpia los errores de autenticación correctamente', () {
      final controller = AppController();
      controller.clearAuthError();
      expect(controller.authError, isNull);
    });
  });
}
