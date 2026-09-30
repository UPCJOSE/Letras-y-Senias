import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  AuthService([this._auth]);

  final FirebaseAuth? _auth;

  bool get isFirebaseAvailable {
    if (_auth != null) return true;
    try {
      return Firebase.apps.isNotEmpty;
    } catch (_) {
      return false;
    }
  }

  FirebaseAuth get auth {
    if (_auth != null) return _auth;
    if (!isFirebaseAvailable) {
      throw StateError(
        'Firebase no ha sido inicializado. Configura tus credenciales en firebase_options.dart.',
      );
    }
    return FirebaseAuth.instance;
  }

  User? get currentUser => isFirebaseAvailable ? auth.currentUser : null;

  Stream<User?> get authStateChanges => isFirebaseAvailable
      ? auth.authStateChanges()
      : const Stream<User?>.empty();

  Future<UserCredential> register({
    required String email,
    required String password,
    String? displayName,
  }) async {
    try {
      final credential = await auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      if (displayName != null && displayName.trim().isNotEmpty) {
        await credential.user?.updateDisplayName(displayName.trim());
      }
      return credential;
    } on FirebaseAuthException catch (e) {
      throw getSpanishErrorMessage(e.code);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Ocurrió un error inesperado al registrar la cuenta.';
    }
  }

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      return credential;
    } on FirebaseAuthException catch (e) {
      throw getSpanishErrorMessage(e.code);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Ocurrió un error inesperado al iniciar sesión.';
    }
  }

  Future<void> sendPasswordReset(String email) async {
    try {
      await auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw getSpanishErrorMessage(e.code);
    } catch (e) {
      if (e is String) rethrow;
      throw 'Ocurrió un error al enviar el correo de recuperación.';
    }
  }

  Future<void> logout() async {
    if (isFirebaseAvailable) {
      await auth.signOut();
    }
  }

  static String getSpanishErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No existe una cuenta registrada con este correo electrónico.';
      case 'wrong-password':
        return 'Contraseña incorrecta. Inténtalo de nuevo.';
      case 'invalid-credential':
        return 'El correo electrónico o la contraseña son incorrectos.';
      case 'email-already-in-use':
        return 'Ya existe una cuenta registrada con este correo electrónico.';
      case 'weak-password':
        return 'La contraseña es muy débil. Debe tener al menos 6 caracteres.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      case 'user-disabled':
        return 'Esta cuenta ha sido deshabilitada.';
      case 'too-many-requests':
        return 'Demasiados intentos fallidos. Por favor espera unos minutos.';
      case 'network-request-failed':
        return 'Error de conexión. Verifica tu conexión a internet.';
      case 'operation-not-allowed':
        return 'El proveedor de correo y contraseña no está habilitado en Firebase Console.';
      default:
        return 'Error de autenticación ($errorCode). Inténtalo de nuevo.';
    }
  }
}
