import 'package:flutter/material.dart';
import 'package:movi/ui/traductor/pagina_traductor.dart';

/// Paleta amigable: blanco, azul en botones y negro en detalles.
class ColoresApp {
  static const Color blanco = Colors.white;
  static const Color fondo = Colors.white;
  static const Color azul = Color(0xFF2F80ED);
  static const Color negro = Color(0xFF1A1A1A);
  static const Color negroSuave = Color(0xFF333333);
  static const Color borde = Color(0xFF1A1A1A);
  static const Color textoAyuda = Color(0xFF757575);
}

/// Configuración general de la aplicación (tema y pantalla inicial).
class AplicacionMovi extends StatelessWidget {
  const AplicacionMovi({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movi - LSC',
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
      home: const PaginaTraductor(),
    );
  }
}
