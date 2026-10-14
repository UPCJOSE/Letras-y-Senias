import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class SenasApp extends StatefulWidget {
  const SenasApp({super.key});

  @override
  State<SenasApp> createState() => _SenasAppState();
}

class _SenasAppState extends State<SenasApp> {
  late final router = createAppRouter(context.read<AppController>());

  @override
  void dispose() {
    router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appearance = context.select<AppController, (bool, bool)>(
      (controller) => (controller.darkMode, controller.highContrast),
    );
    return MaterialApp.router(
      title: 'SeñasApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(highContrast: appearance.$2),
      darkTheme: AppTheme.dark(highContrast: appearance.$2),
      themeMode: appearance.$1 ? ThemeMode.dark : ThemeMode.light,
      routerConfig: router,
    );
  }
}
