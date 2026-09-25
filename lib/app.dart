import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'controllers/app_controller.dart';
import 'routes/app_router.dart';
import 'theme/app_theme.dart';

class SenasApp extends StatelessWidget {
  const SenasApp({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<AppController>();
    return MaterialApp.router(
      title: 'SeñasApp',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(highContrast: controller.highContrast),
      darkTheme: AppTheme.dark(highContrast: controller.highContrast),
      themeMode: controller.darkMode ? ThemeMode.dark : ThemeMode.light,
      routerConfig: appRouter,
    );
  }
}
