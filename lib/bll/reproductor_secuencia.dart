import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:movi/model/sena_media.dart';
import 'package:movi/model/traduccion_frase.dart';
import 'package:video_player/video_player.dart';

/// Reproduce la frase de una seña a la vez.
///
/// El siguiente clip no arranca hasta que el actual terminó (video) o
/// cumplió su tiempo en pantalla (imagen). Así no se solapan.
class ReproductorSecuencia extends ChangeNotifier {
  ReproductorSecuencia({
    this.duracionImagen = const Duration(milliseconds: 2200),
    this.pausaEntreSenas = const Duration(milliseconds: 280),
    this.duracionAusente = const Duration(milliseconds: 1400),
  });

  final Duration duracionImagen;
  final Duration pausaEntreSenas;
  final Duration duracionAusente;

  List<PasoTraduccion> _pasos = const [];
  int indice = -1;
  bool terminado = false;
  bool preparando = false;
  VideoPlayerController? controlador;

  Timer? _timer;
  int _token = 0;
  bool _activo = false;
  bool _finDeClip = false;
  VoidCallback? _oyenteVideo;

  PasoTraduccion? get pasoActual {
    if (indice < 0 || indice >= _pasos.length) return null;
    return _pasos[indice];
  }

  int get total => _pasos.length;

  Future<void> reproducir(List<PasoTraduccion> pasos) async {
    _activo = true;
    _pasos = List.of(pasos);
    terminado = pasos.isEmpty;
    if (pasos.isEmpty) {
      indice = -1;
      notifyListeners();
      return;
    }
    await _irA(0);
  }

  Future<void> saltarA(int i) async {
    if (i < 0 || i >= _pasos.length) return;
    _activo = true;
    terminado = false;
    await _irA(i);
  }

  Future<void> _irA(int i) async {
    final token = ++_token;
    _timer?.cancel();
    _finDeClip = false;

    if (i >= _pasos.length) {
      terminado = true;
      preparando = false;
      notifyListeners();
      return;
    }

    await _liberarControlador();
    if (!_activo || token != _token) return;

    indice = i;
    terminado = false;
    preparando = true;
    notifyListeners();

    final paso = _pasos[i];
    final sena = paso.sena;

    if (sena == null) {
      preparando = false;
      notifyListeners();
      _programar(duracionAusente, token);
      return;
    }

    if (sena.tipo == TipoMedia.imagen) {
      preparando = false;
      notifyListeners();
      _programar(duracionImagen, token);
      return;
    }

    final creado = _crearControlador(sena);
    controlador = creado;
    _oyenteVideo = () => _alTickVideo(token);
    creado.addListener(_oyenteVideo!);

    try {
      await creado.initialize();
      if (!_activo || token != _token) return;
      await creado.setLooping(false);
      preparando = false;
      notifyListeners();
      await creado.play();
    } catch (e) {
      debugPrint('No se pudo reproducir ${sena.ruta}: $e');
      if (!_activo || token != _token) return;
      await _irA(i + 1);
    }
  }

  VideoPlayerController _crearControlador(SenaMedia sena) {
    if (sena.origen == OrigenMedia.remoto) {
      return VideoPlayerController.networkUrl(Uri.parse(sena.ruta));
    }
    return VideoPlayerController.asset(sena.ruta);
  }

  void _alTickVideo(int token) {
    if (_finDeClip || token != _token || !_activo) return;
    final c = controlador;
    if (c == null || !c.value.isInitialized) return;

    final duracion = c.value.duration;
    if (duracion <= Duration.zero) return;

    final margen = duracion > const Duration(milliseconds: 400)
        ? const Duration(milliseconds: 150)
        : Duration.zero;
    final llegoAlFinal = c.value.position + margen >= duracion;
    if (!llegoAlFinal) return;

    _finDeClip = true;
    c.pause();
    _programar(pausaEntreSenas, token);
  }

  void _programar(Duration espera, int token) {
    _timer?.cancel();
    _timer = Timer(espera, () {
      if (!_activo || token != _token) return;
      _irA(indice + 1);
    });
  }

  Future<void> _liberarControlador() async {
    final c = controlador;
    final oyente = _oyenteVideo;
    controlador = null;
    _oyenteVideo = null;
    if (c == null) return;
    if (oyente != null) c.removeListener(oyente);
    await c.dispose();
  }

  @override
  void dispose() {
    _activo = false;
    _token++;
    _timer?.cancel();
    final c = controlador;
    final oyente = _oyenteVideo;
    controlador = null;
    _oyenteVideo = null;
    if (c != null) {
      if (oyente != null) c.removeListener(oyente);
      c.dispose();
    }
    super.dispose();
  }
}
