import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../repositories/sign_repository.dart';
import '../repositories/translation_repository.dart';
import '../repositories/user_repository.dart';
import '../services/auth_service.dart';
import '../services/lsc70_manifest_service.dart';
import '../services/shared_latest_stream.dart';
import '../services/translation_service.dart';

part 'admin_controller.dart';
part 'auth_controller.dart';
part 'catalog_controller.dart';
part 'settings_controller.dart';
part 'translation_controller.dart';

/// Estado compartido de SeñasApp. La lógica vive en controladores separados:
/// autenticación, ajustes, catálogo, traducción y administración.
class AppController extends ChangeNotifier
    with
        AppControllerCore,
        SettingsController,
        CatalogController,
        TranslationController,
        AuthController,
        AdminController {
  AppController({
    TranslationService? translationService,
    AuthService? authService,
    UserRepository? userRepository,
    SignRepository? signRepository,
    TranslationRepository? translationRepository,
  }) : _translationService = translationService ?? TranslationService(),
       _authService = authService ?? AuthService(),
       _userRepository = userRepository ?? UserRepository(),
       _signRepository = signRepository ?? SignRepository(),
       _translationRepository =
           translationRepository ?? TranslationRepository() {
    _initAuthListener();
  }

  @override
  final TranslationService _translationService;
  @override
  final AuthService _authService;
  @override
  final UserRepository _userRepository;
  @override
  final SignRepository _signRepository;
  @override
  final TranslationRepository _translationRepository;

  @override
  void dispose() {
    unawaited(_authSubscription?.cancel());
    unawaited(_publicSignsStream.dispose());
    unawaited(_allSignsStream.dispose());
    unawaited(_categoriesStream.dispose());
    unawaited(_adminCategoriesStream.dispose());
    unawaited(_usersStream.dispose());
    for (final stream in _historyStreams.values) {
      unawaited(stream.dispose());
    }
    _routeRefresh.dispose();
    super.dispose();
  }
}

mixin AppControllerCore on ChangeNotifier {
  TranslationService get _translationService;
  AuthService get _authService;
  UserRepository get _userRepository;
  SignRepository get _signRepository;
  TranslationRepository get _translationRepository;

  User? _currentUser;
  AppUserProfile? _profile;
  bool _isAdmin = false;
  String? _dataError;

  User? get currentUser => _currentUser;
  AppUserProfile? get profile => _profile;
  AppRole get role => _isAdmin ? AppRole.admin : AppRole.individual;
  bool get isAdmin => _isAdmin;
  bool get isAuthenticated => _currentUser != null;
  bool get isProfileActive => _profile?.active ?? true;
  String? get dataError => _dataError;
  CommunicationProfile? get communicationProfile =>
      _profile?.communicationProfile;
  String get userDisplayName => _profile?.displayName.isNotEmpty == true
      ? _profile!.displayName
      : _currentUser?.displayName?.isNotEmpty == true
      ? _currentUser!.displayName!
      : _currentUser?.email?.split('@').first ?? 'Usuario';
  String get userEmail => _currentUser?.email ?? '';

  void clearDataError() {
    _dataError = null;
    notifyListeners();
  }

  String _friendlyError(Object error) {
    final message = error.toString();
    if (message.contains('permission-denied')) {
      return 'No tienes permiso para realizar esta acción.';
    }
    if (message.contains('unavailable') || message.contains('network')) {
      return 'No hay conexión con Firebase. Inténtalo de nuevo.';
    }
    if (message.startsWith('Exception: ')) return message.substring(11);
    return message;
  }
}
