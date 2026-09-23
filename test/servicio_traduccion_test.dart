import 'package:flutter_test/flutter_test.dart';
import 'package:movi/bll/servicio_traduccion.dart';
import 'package:movi/data/repositorio_senas_local.dart';
import 'package:movi/model/sena_media.dart';

void main() {
  final servicio = ServicioTraduccion(RepositorioSenasLocal());

  test('frase con imagen y video, en orden y sin partir alias', () async {
    final r = await servicio.traducir('¡Hola, amigo!');
    expect(r.pasos.map((p) => p.texto), ['Hola', 'Amigo']);
    expect(r.pasos[0].sena!.tipo, TipoMedia.imagen);
    expect(r.pasos[1].sena!.tipo, TipoMedia.video);
    expect(r.tieneSenas, isTrue);
  });

  test('prioriza expresiones de varias palabras', () async {
    final r = await servicio.traducir('por favor no poder');
    expect(r.pasos.map((p) => p.sena!.clave), ['por favor', 'no poder']);
  });

  test('alias ayuda apunta al video ayudar', () async {
    final r = await servicio.traducir('ayuda');
    expect(r.pasos.single.sena!.ruta, contains('palabra_ayudar.mp4'));
  });

  test('palabra desconocida no trae media', () async {
    final r = await servicio.traducir('hola xylophone');
    expect(r.pasos[0].encontrada, isTrue);
    expect(r.pasos[1].encontrada, isFalse);
    expect(r.pasos[1].texto, 'xylophone');
  });
}
