/// Sesión de usuario (mock del login con Google del diseño Figma).
class SesionUsuario {
  final String correo;
  final String nombre;
  final String rol; // 'admin' | 'user'

  const SesionUsuario({
    required this.correo,
    required this.nombre,
    required this.rol,
  });

  bool get esAdmin => rol == 'admin';
}
