import 'package:flutter/material.dart';
import 'package:movi/ui/aplicacion.dart';

/// Vista de reproducción de traducción LSC (accesos rápidos).
/// El recuadro central queda vacío: ahí irá el video de la seña.
class PaginaTraduccionLsc extends StatefulWidget {
  const PaginaTraduccionLsc({
    super.key,
    required this.texto,
    this.senasDetectadas = const [],
  });

  final String texto;
  final List<String> senasDetectadas;

  @override
  State<PaginaTraduccionLsc> createState() => _EstadoPaginaTraduccionLsc();
}

class _EstadoPaginaTraduccionLsc extends State<PaginaTraduccionLsc> {
  /// Controles de reproducción (play, bucle, velocidad, barra).
  /// Ocultos por ahora; poner en `true` cuando haya video real.
  static const bool _mostrarControlesReproduccion = false;

  bool _reproduciendo = true;
  bool _bucle = false;
  double _velocidad = 1.0;
  double _progreso = 0.35;
  int _senaActiva = 0;

  @override
  Widget build(BuildContext context) {
    final senas = widget.senasDetectadas.isEmpty
        ? [widget.texto]
        : widget.senasDetectadas;

    return Scaffold(
      backgroundColor: ColoresApp.fondo,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: IconButton.styleFrom(
                      backgroundColor: ColoresApp.blanco,
                      side: const BorderSide(color: ColoresApp.borde),
                    ),
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: Text(
                      'Traducción LSC',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: ColoresApp.negro,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: ColoresApp.azulSuave,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Texto a traducir',
                          style: TextStyle(
                            fontSize: 13,
                            color: ColoresApp.azul,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.texto,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: ColoresApp.negro,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Recuadro vacío: aquí se colocarán los videos de señas.
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ColoresApp.borde),
                      ),
                      child: const Center(
                        child: Text(
                          'Área de video',
                          style: TextStyle(
                            color: ColoresApp.textoAyuda,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (_mostrarControlesReproduccion) ...[
                    const SizedBox(height: 14),
                    _panelControlesReproduccion(),
                  ],
                  const SizedBox(height: 20),
                  const Text(
                    'SEÑAS DETECTADAS',
                    style: TextStyle(
                      fontSize: 12,
                      letterSpacing: 1,
                      fontWeight: FontWeight.w600,
                      color: ColoresApp.textoAyuda,
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 110,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: senas.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        final activo = i == _senaActiva;
                        return InkWell(
                          onTap: () => setState(() => _senaActiva = i),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            width: 88,
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: activo
                                  ? ColoresApp.azulSuave
                                  : ColoresApp.blanco,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: activo
                                    ? ColoresApp.azul
                                    : ColoresApp.borde,
                                width: activo ? 1.5 : 1,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Mini recuadro (sin muñeco): preview de video.
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE8EEF8),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color: ColoresApp.borde),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  senas[i],
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: activo
                                        ? ColoresApp.azul
                                        : ColoresApp.negro,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panelControlesReproduccion() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: ColoresApp.blanco,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: ColoresApp.borde),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Material(
                color: ColoresApp.azul,
                shape: const CircleBorder(),
                child: InkWell(
                  customBorder: const CircleBorder(),
                  onTap: () {
                    setState(() => _reproduciendo = !_reproduciendo);
                  },
                  child: SizedBox(
                    width: 52,
                    height: 52,
                    child: Icon(
                      _reproduciendo ? Icons.pause : Icons.play_arrow,
                      color: ColoresApp.blanco,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              InkWell(
                onTap: () => setState(() => _bucle = !_bucle),
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _bucle
                        ? ColoresApp.azulSuave
                        : const Color(0xFFF3F4F6),
                  ),
                  child: Icon(
                    Icons.loop,
                    size: 20,
                    color: _bucle ? ColoresApp.azul : ColoresApp.textoAyuda,
                  ),
                ),
              ),
              const Spacer(),
              ...[0.5, 1.0, 1.5].map((v) {
                final activo = _velocidad == v;
                return Padding(
                  padding: const EdgeInsets.only(left: 6),
                  child: InkWell(
                    onTap: () => setState(() => _velocidad = v),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 40,
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: activo ? ColoresApp.azul : Colors.transparent,
                      ),
                      child: Text(
                        '${v}x',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: activo
                              ? ColoresApp.blanco
                              : ColoresApp.textoAyuda,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
              activeTrackColor: ColoresApp.azul,
              inactiveTrackColor: ColoresApp.borde,
              thumbColor: ColoresApp.azul,
            ),
            child: Slider(
              value: _progreso,
              onChanged: (v) => setState(() => _progreso = v),
            ),
          ),
        ],
      ),
    );
  }
}
