import 'package:movi/data/repositorio_senas.dart';
import 'package:movi/model/sena_media.dart';

/// Pendiente: catálogo en Supabase (tabla `senas` + Storage).
///
/// Al instalar el SDK, esta clase debe devolver [SenaMedia] con
/// [OrigenMedia.remoto] y la URL pública del archivo.
class RepositorioSenasSupabase implements RepositorioSenas {
  @override
  Future<List<SenaMedia>> obtenerTodas() {
    throw UnimplementedError(
      'Supabase aún no está instalado. Usa RepositorioSenasLocal.',
    );
  }
}
