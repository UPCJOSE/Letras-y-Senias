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
    apiKey: 'AIzaSyBBL50VntZz3TKG-NAJkv3YZp5nnGDGdGw',
    appId: '1:97333845335:web:f91b925982b0c0d9dfb212',
    messagingSenderId: '97333845335',
    projectId: 'senasapp-a0515',
    authDomain: 'senasapp-a0515.firebaseapp.com',
    storageBucket: 'senasapp-a0515.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD_U7j2-tfE2km-7kOIR02Nc2NXtaptmRQ',
    appId: '1:97333845335:android:0ac8ccfa9da7edbadfb212',
    messagingSenderId: '97333845335',
    projectId: 'senasapp-a0515',
    storageBucket: 'senasapp-a0515.firebasestorage.app',
  );
  /// Indica si se han configurado credenciales reales de Firebase.
  static bool get isConfigured =>
      web.apiKey != 'YOUR_WEB_API_KEY' && web.projectId != 'YOUR_PROJECT_ID';
}
