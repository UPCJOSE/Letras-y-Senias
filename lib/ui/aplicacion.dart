import 'package:flutter/material.dart';
import 'package:movi/ui/shell/pagina_principal.dart';

/// Paleta: blanco, azul (acentos/botones) y negro (detalles).
class ColoresApp {
  static const Color blanco = Color(0xFFFFFFFF);
  static const Color fondo = Color(0xFFFFFFFF);
  static const Color azul = Color(0xFF2F80ED);
  static const Color azulSuave = Color(0xFFEEF5FF);
  static const Color azulClaro = Color(0xFFD6E8FF);
  static const Color negro = Color(0xFF1A1A1A);
  static const Color negroSuave = Color(0xFF333333);
  static const Color borde = Color(0xFFE0E0E0);
  static const Color textoAyuda = Color(0xFF757575);
  static const Color verde = Color(0xFF2E7D32);
  static const Color verdeSuave = Color(0xFFE8F5E9);
  static const Color amarilloSuave = Color(0xFFFFF8E1);
  static const Color teal = Color(0xFF26A69A);
  static const Color tealSuave = Color(0xFFE0F2F1);
}

/// Configuración general de la aplicación (tema y pantalla inicial).
class AplicacionMovi extends StatelessWidget {
  const AplicacionMovi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LSC App',
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
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
            textStyle: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      home: const PaginaPrincipal(),
    );
  }
}
