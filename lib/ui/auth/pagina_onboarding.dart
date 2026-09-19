import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/auth/pagina_inicio_sesion.dart';

/// Onboarding de 3 slides.
class PaginaOnboarding extends StatefulWidget {
  const PaginaOnboarding({super.key});

  @override
  State<PaginaOnboarding> createState() => _EstadoPaginaOnboarding();
}

class _EstadoPaginaOnboarding extends State<PaginaOnboarding> {
  int _slide = 0;

  static const _slides = [
    (
      'Traduce texto a Lengua de Señas Colombiana',
      'Escribe cualquier palabra o frase y verás la seña al instante.',
    ),
    (
      'Entendemos palabras similares y errores de escritura',
      'La búsqueda inteligente corrige tipográficos y sugiere la seña correcta.',
    ),
    (
      'Úsala como persona o como institución',
      'Diseñada para ciudadanos, hospitales, colegios y empresas.',
    ),
  ];

  void _irLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const PaginaInicioSesion()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final s = _slides[_slide];

    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _irLogin,
                child: const Text('Omitir'),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 180,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ColoresApp.borde),
                      ),
                      alignment: Alignment.center,
                      child: const Text(
                        'Área de preview',
                        style: TextStyle(
                          color: ColoresApp.textoAyuda,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    Text(
                      s.$1,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: ColoresApp.negro,
                        height: 1.25,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      s.$2,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 14,
                        color: ColoresApp.textoAyuda,
                        height: 1.45,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 28),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(3, (i) {
                      final activo = i == _slide;
                      return GestureDetector(
                        onTap: () => setState(() => _slide = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 3),
                          width: activo ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: activo
                                ? ColoresApp.azul
                                : ColoresApp.azulClaro,
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_slide < 2) {
                        setState(() => _slide++);
                      } else {
                        _irLogin();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(52),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(_slide < 2 ? 'Siguiente' : 'Comenzar'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
