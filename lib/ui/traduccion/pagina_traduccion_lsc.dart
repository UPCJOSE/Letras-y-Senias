import 'package:flutter/material.dart';
import 'package:movi/bll/dependencias.dart';
import 'package:movi/bll/reproductor_secuencia.dart';
import 'package:movi/model/sena_media.dart';
import 'package:movi/model/traduccion_frase.dart';
import 'package:movi/ui/aplicacion.dart';
import 'package:video_player/video_player.dart';

/// Muestra la secuencia que armó la BLL. No decide cuándo pasa la seña.
class PaginaTraduccionLsc extends StatefulWidget {
  const PaginaTraduccionLsc({super.key, required this.traduccion});

  final TraduccionFrase traduccion;

  @override
  State<PaginaTraduccionLsc> createState() => _EstadoPaginaTraduccionLsc();
}

class _EstadoPaginaTraduccionLsc extends State<PaginaTraduccionLsc> {
  final _reproductor = ReproductorSecuencia();
  final _texto = TextEditingController();
  late TraduccionFrase _traduccion;
  bool _traduciendo = false;

  @override
  void initState() {
    super.initState();
    _traduccion = widget.traduccion;
    _texto.text = widget.traduccion.textoOriginal;
    _reproductor.addListener(_refrescar);
    _reproductor.reproducir(_traduccion.pasos);
  }

  void _refrescar() {
    if (mounted) setState(() {});
  }

  Future<void> _traducir() async {
    final limpio = _texto.text.trim();
    if (limpio.isEmpty || _traduciendo) return;
    FocusScope.of(context).unfocus();
    setState(() => _traduciendo = true);
    final traduccion = await Dependencias.traduccion.traducir(limpio);
    if (!mounted) return;
    setState(() {
      _traduccion = traduccion;
      _traduciendo = false;
    });
    await _reproductor.reproducir(traduccion.pasos);
  }

  @override
  void dispose() {
    _texto.dispose();
    _reproductor.removeListener(_refrescar);
    _reproductor.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pasos = _traduccion.pasos;
    final actual = _reproductor.pasoActual;

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
                        const SizedBox(height: 8),
                        TextField(
                          controller: _texto,
                          minLines: 1,
                          maxLines: 3,
                          textInputAction: TextInputAction.done,
                          onSubmitted: (_) => _traducir(),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: ColoresApp.negro,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Escribe otra frase...',
                            filled: true,
                            fillColor: ColoresApp.blanco,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(16),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton.icon(
                          onPressed: _traduciendo ? null : _traducir,
                          icon: _traduciendo
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: ColoresApp.blanco,
                                  ),
                                )
                              : const Icon(Icons.play_arrow),
                          label: const Text('Traducir'),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(46),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  AspectRatio(
                    aspectRatio: 4 / 3,
                    child: Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8EEF8),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: ColoresApp.borde),
                      ),
                      child: _VistaPaso(
                        paso: actual,
                        controlador: _reproductor.controlador,
                        terminado: _reproductor.terminado && actual == null,
                      ),
                    ),
                  ),
                  if (actual != null) ...[
                    const SizedBox(height: 10),
                    Text(
                      _reproductor.terminado
                          ? 'Secuencia lista'
                          : '${_reproductor.indice + 1} / ${_reproductor.total} · ${actual.texto}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: ColoresApp.textoAyuda,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
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
                    child: pasos.isEmpty
                        ? const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              'No hay palabras para traducir.',
                              style: TextStyle(color: ColoresApp.textoAyuda),
                            ),
                          )
                        : ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: pasos.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 10),
                            itemBuilder: (context, i) {
                              final paso = pasos[i];
                              final activo = i == _reproductor.indice;
                              return InkWell(
                                onTap: () => _reproductor.saltarA(i),
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
                                      Icon(
                                        paso.encontrada
                                            ? (paso.sena!.tipo == TipoMedia.video
                                                ? Icons.movie_outlined
                                                : Icons.image_outlined)
                                            : Icons.search_off,
                                        color: paso.encontrada
                                            ? ColoresApp.azul
                                            : ColoresApp.textoAyuda,
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        paso.texto,
                                        textAlign: TextAlign.center,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: paso.encontrada
                                              ? (activo
                                                  ? ColoresApp.azul
                                                  : ColoresApp.negro)
                                              : ColoresApp.textoAyuda,
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
}

class _VistaPaso extends StatelessWidget {
  const _VistaPaso({
    required this.paso,
    required this.controlador,
    required this.terminado,
  });

  final PasoTraduccion? paso;
  final VideoPlayerController? controlador;
  final bool terminado;

  @override
  Widget build(BuildContext context) {
    if (paso == null) {
      return Center(
        child: Text(
          terminado ? 'Fin de la frase' : 'Área de video',
          style: const TextStyle(
            color: ColoresApp.textoAyuda,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }

    final sena = paso!.sena;
    if (sena == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(
            'Sin seña para "${paso!.texto}"',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: ColoresApp.textoAyuda,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ),
      );
    }

    if (sena.tipo == TipoMedia.imagen) {
      final imagen = sena.origen == OrigenMedia.remoto
          ? Image.network(sena.ruta, fit: BoxFit.contain)
          : Image.asset(sena.ruta, fit: BoxFit.contain);
      return Padding(padding: const EdgeInsets.all(12), child: imagen);
    }

    final listo = controlador != null && controlador!.value.isInitialized;
    if (!listo) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: AspectRatio(
        aspectRatio: controlador!.value.aspectRatio == 0
            ? 16 / 9
            : controlador!.value.aspectRatio,
        child: VideoPlayer(controlador!),
      ),
    );
  }
}
