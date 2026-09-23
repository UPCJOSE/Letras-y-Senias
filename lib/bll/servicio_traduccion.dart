import 'package:movi/bll/normalizador_texto.dart';
import 'package:movi/data/repositorio_senas.dart';
import 'package:movi/model/sena_media.dart';
import 'package:movi/model/traduccion_frase.dart';

/// Parte una frase en señas del catálogo.
///
/// Prueba primero las expresiones más largas (`por favor`, `no poder`)
/// para no partirlas en palabras sueltas.
class ServicioTraduccion {
  ServicioTraduccion(this._repositorio);

  final RepositorioSenas _repositorio;
  Map<String, SenaMedia>? _indice;
  int _maxPalabras = 1;

  Future<TraduccionFrase> traducir(String frase) async {
    await _cargarIndice();
    final indice = _indice!;
    final normal = normalizarTexto(frase);
    if (normal.isEmpty) {
      return TraduccionFrase(textoOriginal: frase.trim(), pasos: const []);
    }

    final tokens = normal.split(' ');
    final pasos = <PasoTraduccion>[];
    var i = 0;

    while (i < tokens.length) {
      PasoTraduccion? coincidencia;
      var consumidos = 1;

      final tope = _maxPalabras.clamp(1, tokens.length - i);
      for (var n = tope; n >= 1; n--) {
        final texto = tokens.sublist(i, i + n).join(' ');
        final sena = indice[texto];
        if (sena != null) {
          coincidencia = PasoTraduccion(texto: sena.palabraVisible, sena: sena);
          consumidos = n;
          break;
        }
      }

      pasos.add(
        coincidencia ??
            PasoTraduccion(texto: tokens[i], sena: null),
      );
      i += consumidos;
    }

    return TraduccionFrase(textoOriginal: frase.trim(), pasos: pasos);
  }

  Future<void> _cargarIndice() async {
    if (_indice != null) return;
    final senas = await _repositorio.obtenerTodas();
    final indice = <String, SenaMedia>{};
    var maximo = 1;

    for (final sena in senas) {
      final claves = [sena.clave, ...sena.alias];
      for (final cruda in claves) {
        final clave = normalizarTexto(cruda);
        if (clave.isEmpty) continue;
        indice[clave] = sena;
        final largo = clave.split(' ').length;
        if (largo > maximo) maximo = largo;
      }
    }

    _indice = indice;
    _maxPalabras = maximo;
  }
}
