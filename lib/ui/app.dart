import 'package:flutter/material.dart';
import 'package:movi/ui/translator/translator_page.dart';

/// Paleta amigable: blanco, azul en botones y negro en detalles.
class AppColors {
  static const Color white = Colors.white;
  static const Color background = Colors.white;
  static const Color blue = Color(0xFF2F80ED);
  static const Color black = Color(0xFF1A1A1A);
  static const Color blackSoft = Color(0xFF333333);
  static const Color border = Color(0xFF1A1A1A);
  static const Color hint = Color(0xFF757575);
}

/// Configuración general de la aplicación (tema y ruta inicial).
class MoviApp extends StatelessWidget {
  const MoviApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movi - LSC',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: const ColorScheme.light(
          primary: AppColors.blue,
          onPrimary: AppColors.white,
          surface: AppColors.white,
          onSurface: AppColors.black,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.blue,
            foregroundColor: AppColors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const TranslatorPage(),
    );
  }
}
