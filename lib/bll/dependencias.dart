import 'package:movi/bll/servicio_traduccion.dart';
import 'package:movi/data/repositorio_senas.dart';
import 'package:movi/data/repositorio_senas_local.dart';

/// Punto único para cambiar el origen de datos.
///
/// Para pasar a Supabase: sustituir [senas] por `RepositorioSenasSupabase()`.
class Dependencias {
  Dependencias._();

  static final RepositorioSenas senas = RepositorioSenasLocal();
  static final ServicioTraduccion traduccion = ServicioTraduccion(senas);
}
