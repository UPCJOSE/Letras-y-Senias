import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:movi/ui/deletreo/pagina_deletreo.dart';

/// Sugerencias cuando la palabra no está en el catálogo.
class PaginaPalabraNoEncontrada extends StatelessWidget {
  const PaginaPalabraNoEncontrada({
    super.key,
    this.textoEscrito = 'Holaaa',
  });

  final String textoEscrito;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColoresApp.blanco,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: ColoresApp.fondo,
                    side: const BorderSide(color: ColoresApp.borde),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                const Expanded(
                  child: Text(
                    'Sugerencias',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 48),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: ColoresApp.amarilloSuave,
                  borderRadius: BorderRadius.circular(18),
                ),
                alignment: Alignment.center,
                child: const Text('🤔', style: TextStyle(fontSize: 36)),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'No encontramos esa palabra',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                style: const TextStyle(color: ColoresApp.textoAyuda, fontSize: 14),
                children: [
                  const TextSpan(text: 'Escribiste '),
                  TextSpan(
                    text: '"$textoEscrito"',
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      color: ColoresApp.negro,
                    ),
                  ),
                  const TextSpan(text: ' — ¿quisiste decir alguna de estas?'),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _Sugerencia(
              palabra: 'Hola',
              similitud: '96% de similitud',
              alUsar: () => Navigator.pop(context, 'Hola'),
            ),
            const SizedBox(height: 10),
            _Sugerencia(
              palabra: 'Hola',
              similitud: '88% de similitud',
              alUsar: () => Navigator.pop(context, 'Hola'),
            ),
            const SizedBox(height: 20),
            const Text(
              'TAMBIÉN PODRÍA SER',
              style: TextStyle(
                fontSize: 12,
                letterSpacing: 1,
                color: ColoresApp.textoAyuda,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: ColoresApp.blanco,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: ColoresApp.borde),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8EEF8),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '"Cachorrito" → "Cachorro"',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          'Diminutivo detectado',
                          style: TextStyle(
                            fontSize: 12,
                            color: ColoresApp.textoAyuda,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const PaginaDeletreo(
                            palabra: 'Xylophone',
                          ),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFF3F4F6),
                      foregroundColor: ColoresApp.negroSuave,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Usar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.pop(context),
              style: OutlinedButton.styleFrom(
                foregroundColor: ColoresApp.azul,
                minimumSize: const Size.fromHeight(50),
                side: const BorderSide(color: ColoresApp.azul, width: 1.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: const Text('Editar texto'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sugerencia extends StatelessWidget {
  const _Sugerencia({
    required this.palabra,
    required this.similitud,
    required this.alUsar,
  });

  final String palabra;
  final String similitud;
  final VoidCallback alUsar;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EEF8),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColoresApp.borde),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '"$palabra"',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                Text(
                  similitud,
                  style: const TextStyle(
                    fontSize: 12,
                    color: ColoresApp.textoAyuda,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: alUsar,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Usar'),
          ),
        ],
      ),
    );
  }
}
