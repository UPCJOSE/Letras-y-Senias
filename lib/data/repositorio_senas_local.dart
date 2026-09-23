import 'package:movi/data/repositorio_senas.dart';
import 'package:movi/model/sena_media.dart';

/// Catálogo temporal con los archivos de la carpeta `Palabras/`.
///
/// Cada fila equivale a lo que después será un registro en Supabase
/// (clave, tipo, ruta/url y alias).
class RepositorioSenasLocal implements RepositorioSenas {
  static const _carpeta = 'Palabras';

  static final List<SenaMedia> _catalogo = [
    _img('bien', 'Bien', 'palabra_bien.png'),
    _img('comer', 'Comer', 'palabra-comer.png'),
    _img('decir adios', 'Decir adiós', 'palabra_decir-adios.png', ['adios']),
    _img('gracias', 'Gracias', 'palabra_gracias.png'),
    _img('hola', 'Hola', 'palabra_hola.png'),
    _img('mal', 'Mal', 'palabra_mal.png'),
    _img('mundo', 'Mundo', 'palabra_mundo.png'),
    _img('no', 'No', 'palabra-no.png'),
    _img('por favor', 'Por favor', 'palabra_por-favor.png'),
    _img('si', 'Sí', 'palabra-si.png'),
    _img('tu', 'Tú', 'palabra-tu.png'),
    _img('yo', 'Yo', 'palabra-yo.png'),
    _vid('amigo', 'Amigo', 'palabra_amigo.mp4'),
    _vid('ayudar', 'Ayudar', 'palabra_ayudar.mp4', ['ayuda']),
    _vid('casa', 'Casa', 'palabra_casa.mp4'),
    _vid('no poder', 'No poder', 'palabra_no_poder.mp4'),
    _vid('poder', 'Poder', 'palabra_poder.mp4'),
  ];

  static SenaMedia _img(
    String clave,
    String visible,
    String archivo, [
    List<String> alias = const [],
  ]) {
    return SenaMedia(
      clave: clave,
      palabraVisible: visible,
      tipo: TipoMedia.imagen,
      origen: OrigenMedia.asset,
      ruta: '$_carpeta/$archivo',
      alias: alias,
    );
  }

  static SenaMedia _vid(
    String clave,
    String visible,
    String archivo, [
    List<String> alias = const [],
  ]) {
    return SenaMedia(
      clave: clave,
      palabraVisible: visible,
      tipo: TipoMedia.video,
      origen: OrigenMedia.asset,
      ruta: '$_carpeta/$archivo',
      alias: alias,
    );
  }

  @override
  Future<List<SenaMedia>> obtenerTodas() async => List.unmodifiable(_catalogo);
}
