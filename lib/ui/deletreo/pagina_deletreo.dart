import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Deletreo letra a letra cuando no hay seña directa.
class PaginaDeletreo extends StatefulWidget {
  const PaginaDeletreo({super.key, this.palabra = 'Xylophone'});

  final String palabra;

  @override
  State<PaginaDeletreo> createState() => _EstadoPaginaDeletreo();
}

class _EstadoPaginaDeletreo extends State<PaginaDeletreo> {
  int _indice = 3; // demo: en la 4ª letra
  bool _reproduciendo = false;

  List<String> get _letras =>
      widget.palabra.toUpperCase().replaceAll(' ', '').split('');

  @override
  Widget build(BuildContext context) {
    final letras = _letras;
    final total = letras.length;
    final actual = (_indice + 1).clamp(1, total);

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  style: IconButton.styleFrom(
                    backgroundColor: ColoresApp.blanco,
                    side: const BorderSide(color: ColoresApp.borde),
                  ),
                  icon: const Icon(Icons.arrow_back),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Deletreo LSC',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: ColoresApp.amarilloSuave,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Letra a letra',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFFB45309),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColoresApp.amarilloSuave,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text.rich(
                TextSpan(
                  style: const TextStyle(
                    color: Color(0xFF92400E),
                    height: 1.35,
                  ),
                  children: [
                    const TextSpan(
                      text: 'Sin traducción directa\n',
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text:
                          "La palabra '${widget.palabra}' no existe en LSC. "
                          'Se realizará el deletreo letra por letra.',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Recuadro vacío para video (sin muñeco).
            AspectRatio(
              aspectRatio: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EEF8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: ColoresApp.borde),
                ),
                alignment: Alignment.center,
                child: Text(
                  _reproduciendo
                      ? 'Reproduciendo letra ${letras[_indice.clamp(0, total - 1)]}'
                      : 'Área de video',
                  style: const TextStyle(
                    color: ColoresApp.textoAyuda,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              alignment: WrapAlignment.center,
              children: List.generate(letras.length, (i) {
                final hecha = i < _indice;
                final actualLetra = i == _indice;
                return Container(
                  width: 32,
                  height: 36,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: actualLetra
                        ? ColoresApp.azul
                        : hecha
                            ? ColoresApp.azulSuave
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    letras[i],
                    style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: actualLetra
                          ? ColoresApp.blanco
                          : hecha
                              ? ColoresApp.azul
                              : ColoresApp.textoAyuda,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: ColoresApp.blanco,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: ColoresApp.borde),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Progreso del deletreo',
                          style: TextStyle(
                            fontSize: 13,
                            color: ColoresApp.textoAyuda,
                          ),
                        ),
                      ),
                      Text(
                        '$actual/$total',
                        style: const TextStyle(
                          color: ColoresApp.azul,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: actual / total,
                      minHeight: 8,
                      backgroundColor: ColoresApp.borde,
                      color: ColoresApp.azul,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _reproduciendo = true;
                              if (_indice < total - 1) _indice++;
                            });
                          },
                          icon: const Icon(Icons.play_arrow),
                          label: const Text('Reproducir'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => setState(() {
                          _indice = 0;
                          _reproduciendo = false;
                        }),
                        borderRadius: BorderRadius.circular(24),
                        child: Container(
                          width: 48,
                          height: 48,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.loop),
                        ),
                      ),
                    ],
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
