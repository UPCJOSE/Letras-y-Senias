import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'controllers/app_controller.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (DefaultFirebaseOptions.isConfigured) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e) {
      debugPrint('Error al inicializar Firebase: $e');
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
