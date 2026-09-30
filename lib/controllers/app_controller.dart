import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../services/auth_service.dart';
import '../services/translation_service.dart';

class AppController extends ChangeNotifier {
  AppController({
    TranslationService? translationService,
    AuthService? authService,
  })  : _translationService = translationService ?? TranslationService(),
        _authService = authService ?? AuthService() {
    _initAuthListener();
  }

  final TranslationService _translationService;
  final AuthService _authService;

  User? _currentUser;
  bool _authLoading = false;
  String? _authError;

  bool darkMode = false;
  bool highContrast = false;
  bool notifications = true;
  double playbackSpeed = 1;
  AppRole role = AppRole.individual;
  TranslationResult? currentTranslation;

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isAuthLoading => _authLoading;
  String? get authError => _authError;
  String get userDisplayName =>
      _currentUser?.displayName?.isNotEmpty == true
          ? _currentUser!.displayName!
          : _currentUser?.email?.split('@').first ?? 'Usuario';
  String get userEmail => _currentUser?.email ?? 'invitado@senasapp.com';

  final List<TranslationHistoryItem> history = [
    const TranslationHistoryItem(
      text: 'Hola, ¿cómo estás?',
      label: 'Hoy, 9:30 a. m.',
      signCount: 3,
    ),
    const TranslationHistoryItem(
      text: 'Necesito ayuda en recepción',
      label: 'Hoy, 8:15 a. m.',
      signCount: 4,
    ),
    const TranslationHistoryItem(
      text: 'Necesito una cita médica',
      label: 'Ayer, 4:15 p. m.',
      signCount: 4,
    ),
    const TranslationHistoryItem(
      text: 'Quiero ir al banco',
      label: 'Ayer, 11:40 a. m.',
      signCount: 5,
    ),
    const TranslationHistoryItem(
      text: '¿Dónde está el baño?',
      label: '14 Sep, 2:20 p. m.',
      signCount: 4,
    ),
    const TranslationHistoryItem(
      text: 'Muchas gracias',
      label: '14 Sep, 10:05 a. m.',
      signCount: 2,
    ),
    const TranslationHistoryItem(
      text: 'Buenos días, profesor',
      label: '12 Sep, 7:10 a. m.',
      signCount: 3,
    ),
  ];

  void _initAuthListener() {
    try {
      if (_authService.isFirebaseAvailable) {
        _currentUser = _authService.currentUser;
        _authService.authStateChanges.listen((user) {
          _currentUser = user;
          notifyListeners();
        });
      }
    } catch (_) {
      // Ignorado si Firebase no está inicializado (e.g. en pruebas de widgets)
    }
  }

  void clearAuthError() {
    _authError = null;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final credential = await _authService.login(
        email: email,
        password: password,
      );
      _currentUser = credential.user;
      _authLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = e.toString();
      _authLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();

    try {
      final credential = await _authService.register(
        email: email,
        password: password,
        displayName: name,
      );
      _currentUser = credential.user;
      _authLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = e.toString();
      _authLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resetPassword(String email) async {
    _authLoading = true;
    _authError = null;
    notifyListeners();

    try {
      await _authService.sendPasswordReset(email);
      _authLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _authError = e.toString();
      _authLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    darkMode = value;
    notifyListeners();
  }

  void setHighContrast(bool value) {
    highContrast = value;
    notifyListeners();
  }

  void setNotifications(bool value) {
    notifications = value;
    notifyListeners();
  }

  void setSpeed(double value) {
    playbackSpeed = value;
    notifyListeners();
  }

  void setRole(AppRole value) {
    role = value;
    notifyListeners();
  }

  TranslationResult translate(String input) {
    final result = _translationService.translate(input);
    currentTranslation = result;
    if (input.trim().isNotEmpty) {
      history.insert(
        0,
        TranslationHistoryItem(
          text: input.trim(),
          label: 'Ahora',
          signCount: result.signs.length + result.spelling.length,
        ),
      );
    }
    notifyListeners();
    return result;
  }

  String translateRoute(String input) {
    final result = translate(input);
    if (result.suggestions.isNotEmpty) return '/not-found';
    if (result.spelling.isNotEmpty) return '/spelling';
    return '/translate';
  }
}
