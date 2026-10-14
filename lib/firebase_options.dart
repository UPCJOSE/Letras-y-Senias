import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Opciones de inicialización de Firebase para cada plataforma.
///
/// Puedes rellenar estos valores directamente desde Firebase Console
/// (Configuración del proyecto > General > Tus apps) o generar este archivo
/// automáticamente con `flutterfire configure`.
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC-nbIMYZKqe3pZNv7OUdnYmcglOcCSfQg',
    appId: '1:417129783569:web:45e14e0994fd347b20acb0',
    messagingSenderId: '417129783569',
    projectId: 'senasapp-f4226',
    authDomain: 'senasapp-f4226.firebaseapp.com',
    storageBucket: 'senasapp-f4226.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBvMCCHhgc35k9PhbFWEe6-44RomL-GYis',
    appId: '1:417129783569:android:412f5e3e6fb2e35b20acb0',
    messagingSenderId: '417129783569',
    projectId: 'senasapp-f4226',
    storageBucket: 'senasapp-f4226.firebasestorage.app',
  );

  /// Indica si se han configurado credenciales reales de Firebase.
  static bool get isConfigured =>
      web.apiKey != 'YOUR_WEB_API_KEY' && web.projectId != 'YOUR_PROJECT_ID';
}
