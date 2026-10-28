part of 'app_controller.dart';

/// Personas, métricas e importación de recursos LSC70.
mixin AdminController on AuthController {
  Future<AdminDashboardStats>? _dashboardStatsFuture;
  late final SharedLatestStream<List<AppUserProfile>> _usersStream =
      SharedLatestStream(_userRepository.watchUsers);

  Stream<List<AppUserProfile>> get users => _usersStream;

  Future<AdminDashboardStats> get dashboardStats =>
      _dashboardStatsFuture ??= _translationRepository.getDashboardStats();

  Future<void> createUserByAdmin({
    required String name,
    required String email,
    required String password,
    required AppRole role,
  }) async {
    if (!_isAdmin) {
      throw StateError('Solo un administrador puede crear cuentas.');
    }
    if (name.trim().isEmpty || email.trim().isEmpty || password.length < 6) {
      throw ArgumentError(
        'Completa el nombre, correo y una contraseña de 6 caracteres o más.',
      );
    }
    if (!email.contains('@')) {
      throw ArgumentError('Escribe un correo electrónico válido.');
    }
    await _authService.createUserByAdmin(
      email: email,
      password: password,
      displayName: name,
      onCreated: (uid, normalizedEmail) => _userRepository.createManagedProfile(
        uid: uid,
        email: normalizedEmail,
        displayName: name,
        role: role,
      ),
    );
  }

  Future<int> importLsc70Manifest(String source) async {
    if (!_isAdmin) {
      throw StateError('Solo un administrador puede cargar recursos.');
    }
    final entries = Lsc70ManifestService().parse(source);
    return _signRepository.importMediaManifest(entries);
  }
}
