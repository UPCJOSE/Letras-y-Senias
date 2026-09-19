import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/auth/pagina_onboarding.dart';

/// Splash inicial (2.4s → onboarding).
class PaginaSplash extends StatefulWidget {
  const PaginaSplash({super.key});

  @override
  State<PaginaSplash> createState() => _EstadoPaginaSplash();
}

class _EstadoPaginaSplash extends State<PaginaSplash> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const PaginaOnboarding()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    color: ColoresApp.azul,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: ColoresApp.azul.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: const Text('🤟', style: TextStyle(fontSize: 48)),
                ),
                const SizedBox(height: 28),
                const Text(
                  'SeñasApp',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w900,
                    color: ColoresApp.negro,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Conectando personas a través de la\nLengua de Señas Colombiana',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    color: ColoresApp.textoAyuda,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 6,
                      decoration: BoxDecoration(
                        color: ColoresApp.azul,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _punto(),
                    const SizedBox(width: 6),
                    _punto(),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _punto() => Container(
        width: 6,
        height: 6,
        decoration: BoxDecoration(
          color: ColoresApp.azul.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
      );
}
