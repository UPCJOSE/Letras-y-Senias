import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Editor de avatar / keyframes (UI demo, sin muñeco animado complejo).
class PaginaEditorAvatar extends StatefulWidget {
  const PaginaEditorAvatar({super.key});

  @override
  State<PaginaEditorAvatar> createState() => _EstadoPaginaEditorAvatar();
}

class _EstadoPaginaEditorAvatar extends State<PaginaEditorAvatar> {
  double _hombroIzq = 0;
  double _codoIzq = 0;
  double _muneca = 0;
  double _hombroDer = 0;
  double _giroCabeza = 0;
  int _keyframe = 0;

  @override
  Widget build(BuildContext context) {
    final controles = [
      ('Rotación hombro izq.', _hombroIzq, -60.0, 60.0, (v) => _hombroIzq = v),
      ('Rotación codo izq.', _codoIzq, -90.0, 0.0, (v) => _codoIzq = v),
      ('Rotación muñeca', _muneca, -45.0, 45.0, (v) => _muneca = v),
      ('Rotación hombro der.', _hombroDer, -60.0, 60.0, (v) => _hombroDer = v),
      ('Giro cabeza', _giroCabeza, -20.0, 20.0, (v) => _giroCabeza = v),
    ];

    return Scaffold(
      backgroundColor: ColoresApp.adminFondo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 16, 12),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: const Color(0xFF1E293B),
                      foregroundColor: const Color(0xFFCBD5E1),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Editor de Avatar',
                      style: TextStyle(
                        color: ColoresApp.blanco,
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x33A855F7),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0x66A855F7)),
                    ),
                    child: const Text(
                      'Beta',
                      style: TextStyle(
                        color: Color(0xFFD8B4FE),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              height: 200,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFF334155)),
              ),
              child: Stack(
                children: [
                  Center(
                    child: Transform.rotate(
                      angle: _giroCabeza * 0.0174533,
                      child: Icon(
                        Icons.accessibility_new,
                        size: 120,
                        color: ColoresApp.azul.withValues(
                          alpha: 0.7 + (_hombroIzq.abs() / 200),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xCC9333EA),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'KF ${_keyframe + 1}',
                        style: const TextStyle(
                          color: ColoresApp.blanco,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'CONTROLES DE MOVIMIENTO',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.textoAyuda,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ...controles.map(
                          (c) => Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        c.$1,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: ColoresApp.textoAyuda,
                                        ),
                                      ),
                                    ),
                                    Text(
                                      '${c.$2.round()}°',
                                      style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFFC084FC),
                                      ),
                                    ),
                                  ],
                                ),
                                SliderTheme(
                                  data: SliderTheme.of(context).copyWith(
                                    activeTrackColor: const Color(0xFFA855F7),
                                    inactiveTrackColor: const Color(0xFF334155),
                                    thumbColor: const Color(0xFFC084FC),
                                    overlayColor: const Color(0x33A855F7),
                                  ),
                                  child: Slider(
                                    value: c.$2,
                                    min: c.$3,
                                    max: c.$4,
                                    onChanged: (v) => setState(() => c.$5(v)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E293B),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF334155)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'TIMELINE DE ANIMACIÓN',
                          style: TextStyle(
                            fontSize: 11,
                            letterSpacing: 0.8,
                            fontWeight: FontWeight.w600,
                            color: ColoresApp.textoAyuda,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: List.generate(4, (i) {
                            final activo = i == _keyframe;
                            return GestureDetector(
                              onTap: () => setState(() => _keyframe = i),
                              child: Column(
                                children: [
                                  AnimatedContainer(
                                    duration: const Duration(milliseconds: 150),
                                    width: activo ? 30 : 26,
                                    height: activo ? 30 : 26,
                                    decoration: BoxDecoration(
                                      color: activo
                                          ? const Color(0xFFA855F7)
                                          : const Color(0xFF334155),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: activo
                                            ? const Color(0xFFC084FC)
                                            : const Color(0xFF64748B),
                                        width: 2,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      '${i + 1}',
                                      style: TextStyle(
                                        color: activo
                                            ? ColoresApp.blanco
                                            : ColoresApp.textoAyuda,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${(i * 0.8).toStringAsFixed(1)}s',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      color: ColoresApp.textoAyuda,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Keyframe añadido (demo)'),
                              ),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE2E8F0),
                            side: const BorderSide(color: Color(0xFF475569)),
                            backgroundColor: const Color(0xFF334155),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: const Text('+ Keyframe'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.play_arrow, size: 18),
                          label: const Text('Vista previa'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4F46E5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Avatar guardado (demo)'),
                              ),
                            );
                          },
                          icon: const Icon(Icons.check, size: 18),
                          label: const Text('Guardar'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF16A34A),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
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
