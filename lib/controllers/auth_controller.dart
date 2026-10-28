part of 'app_controller.dart';

/// Sesión, registro, perfil de comunicación y redirección autenticada.
mixin AuthController on SettingsController, TranslationController {
  StreamSubscription<User?>? _authSubscription;
  final ValueNotifier<int> _routeRefresh = ValueNotifier<int>(0);
  int _authRevision = 0;
  bool _authLoading = false;
  bool _authReady = false;
  String? _authError;
  CommunicationProfile? _pendingCommunicationProfile;

  bool get isAuthLoading => _authLoading;
  bool get isAuthReady => _authReady;
  String? get authError => _authError;
  Listenable get routeRefresh => _routeRefresh;

  void _initAuthListener() {
    if (!_authService.isFirebaseAvailable) {
      _authReady = true;
      _routeRefresh.value++;
      return;
    }
    _currentUser = _authService.currentUser;
    _authSubscription = _authService.authStateChanges.listen(
      (user) => unawaited(_syncUser(user)),
      onError: (Object error) {
        _authReady = true;
        _authError = _friendlyError(error);
        _routeRefresh.value++;
        notifyListeners();
      },
    );
    if (_currentUser != null) unawaited(_syncUser(_currentUser));
  }

  Future<void> _syncUser(User? user) async {
    final revision = ++_authRevision;
    final previousUid = _currentUser?.uid;
    _currentUser = user;
    _authError = null;
    _dataError = null;
    if (user?.uid != previousUid) {
      _resetPreferences();
      _resetHistoryStreams();
    }
    if (user == null) {
      _profile = null;
      _isAdmin = false;
      _authReady = true;
      _routeRefresh.value++;
      notifyListeners();
      return;
    }

    _authReady = false;
    _routeRefresh.value++;
    notifyListeners();
    try {
      await _userRepository.ensureProfile(
        uid: user.uid,
        email: user.email ?? '',
        displayName: user.displayName ?? '',
        communicationProfile: _pendingCommunicationProfile,
      );
      final profile = await _userRepository.getProfile(user.uid);
      if (revision != _authRevision) return;
      _profile = profile;
      _isAdmin = profile?.role == AppRole.admin && (profile?.active ?? false);
      if (profile != null) {
        darkMode = profile.preferences['darkMode'] as bool? ?? darkMode;
        highContrast =
            profile.preferences['highContrast'] as bool? ?? highContrast;
        notifications =
            profile.preferences['notifications'] as bool? ?? notifications;
        playbackSpeed =
            (profile.preferences['playbackSpeed'] as num?)?.toDouble() ?? 1;
      }
      if (!isProfileActive) {
        _authError = 'Esta cuenta está desactivada. Comunícate con soporte.';
      }
    } catch (error) {
      if (revision != _authRevision) return;
      _dataError = _friendlyError(error);
      _profile = null;
      _isAdmin = false;
    } finally {
      if (revision == _authRevision) {
        _authReady = true;
        _routeRefresh.value++;
        notifyListeners();
      }
    }
  }

  void clearAuthError() {
    _authError = null;
    notifyListeners();
  }

  Future<bool> login({required String email, required String password}) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();
    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );
      await _syncUser(credential.user);
      if (!isProfileActive) {
        await logout();
        _authError = 'Esta cuenta está desactivada. Comunícate con soporte.';
        return false;
      }
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
    CommunicationProfile? communicationProfile,
  }) async {
    _authLoading = true;
    _authError = null;
    _pendingCommunicationProfile = communicationProfile;
    notifyListeners();
    try {
      final credential = await _authService.register(
        email: email,
        password: password,
        displayName: name,
      );
      await _syncUser(credential.user);
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _pendingCommunicationProfile = null;
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<bool> resetPassword(String email) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();
    try {
      await _authService.sendPasswordReset(email);
      return true;
    } catch (error) {
      _authError = _friendlyError(error);
      return false;
    } finally {
      _authLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    await _syncUser(null);
  }

  Future<void> setCommunicationProfile(CommunicationProfile value) async {
    final user = _currentUser;
    final current = _profile;
    if (user == null || current == null) {
      throw StateError('Inicia sesión para elegir tu tipo de persona.');
    }
    await _userRepository.setCommunicationProfile(user.uid, value);
    _profile = AppUserProfile(
      id: current.id,
      displayName: current.displayName,
      email: current.email,
      role: current.role,
      active: current.active,
      preferences: current.preferences,
      communicationProfile: value,
    );
    notifyListeners();
  }
}
