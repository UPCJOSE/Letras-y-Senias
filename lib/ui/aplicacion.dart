import 'package:flutter/material.dart';
import 'package:movi/ui/auth/pagina_splash.dart';

/// Paleta del diseño SeñasApp (src/index.css).
class ColoresApp {
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color fondo = Color(0xFFF5F7FA);
  static const Color azul = Color(0xFF2563EB);
  static const Color azulOscuro = Color(0xFF1D4ED8);
  static const Color azulSuave = Color(0xFFDBEAFE);
  static const Color azulClaro = Color(0xFFBFDBFE);
  static const Color negro = Color(0xFF0F172A);
  static const Color negroSuave = Color(0xFF334155);
  static const Color borde = Color(0xFFE2E8F0);
  static const Color textoAyuda = Color(0xFF64748B);
  static const Color verde = Color(0xFF22C55E);
  static const Color verdeSuave = Color(0xFFDCFCE7);
  static const Color naranja = Color(0xFFFF8A00);
  static const Color naranjaClaro = Color(0xFFFFB347);
  static const Color amarilloSuave = Color(0xFFFFF8E1);
  static const Color teal = Color(0xFF26A69A);
  static const Color tealSuave = Color(0xFFE0F2F1);
  static const Color peligro = Color(0xFFEF4444);
  static const Color adminFondo = Color(0xFF0F172A);
}

/// Configuración general de la aplicación.
class AplicacionMovi extends StatelessWidget {
  const AplicacionMovi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SeñasApp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: ColoresApp.fondo,
        colorScheme: const ColorScheme.light(
          primary: ColoresApp.azul,
          onPrimary: ColoresApp.blanco,
          surface: ColoresApp.blanco,
          onSurface: ColoresApp.negro,
        ),
        useMaterial3: true,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColoresApp.azul,
            foregroundColor: ColoresApp.blanco,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: ColoresApp.borde),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: ColoresApp.borde),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: ColoresApp.azul, width: 1.5),
          ),
        ),
      ),
      home: const PaginaSplash(),
    );
  }
}
