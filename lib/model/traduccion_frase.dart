import 'package:movi/model/sena_media.dart';

/// Un tramo de la frase: con seña del catálogo o sin media todavía.
class PasoTraduccion {
  const PasoTraduccion({required this.texto, this.sena});

  final String texto;
  final SenaMedia? sena;

  bool get encontrada => sena != null;
}

/// Resultado de traducir una frase a una secuencia de señas.
class TraduccionFrase {
  const TraduccionFrase({
    required this.textoOriginal,
    required this.pasos,
  });

  final String textoOriginal;
  final List<PasoTraduccion> pasos;

  bool get tieneSenas => pasos.any((p) => p.encontrada);
}
