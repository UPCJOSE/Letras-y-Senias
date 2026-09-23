import 'package:movi/model/sena_media.dart';

/// Contrato del catálogo de señas.
///
/// Hoy lo implementa [RepositorioSenasLocal]. Cuando exista Supabase,
/// se sustituye por [RepositorioSenasSupabase] sin tocar la UI ni la BLL.
abstract class RepositorioSenas {
  Future<List<SenaMedia>> obtenerTodas();
}
