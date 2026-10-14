import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/app_controller.dart';
import 'firebase_options.dart';
import 'services/firebase_app_check_service.dart';
import 'services/firebase_emulator_settings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (FirebaseEmulatorSettings.enabled && !kDebugMode) {
    throw StateError('Los emuladores de Firebase solo se permiten en debug.');
  }

  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      if (FirebaseEmulatorSettings.enabled) {
        final host = FirebaseEmulatorSettings.host;
        await FirebaseAuth.instance.useAuthEmulator(host, 9099);
        FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
        debugPrint('Firebase conectado a emuladores locales en $host.');
      } else {
        await activateFirebaseAppCheck(Firebase.app());
      }
    } catch (error) {
      debugPrint('No se pudo iniciar Firebase/App Check: $error');
    }
  } else {
    debugPrint(
      'Aviso: Firebase no está configurado aún en lib/firebase_options.dart.',
    );
  }

  runApp(
    ChangeNotifierProvider(
      create: (_) => AppController(),
      child: const SenasApp(),
    ),
  );
}
