import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../repositories/conversation_repository.dart';
import 'app_controller.dart';

/// Coordina las conversaciones compartidas entre una persona oyente y una
/// persona sorda: crear/unirse con código, enviar mensajes y traducirlos a
/// señas con el diccionario publicado en Firestore.
class ConversationController extends ChangeNotifier {
  ConversationController({ConversationRepository? repository})
    : _repository = repository ?? ConversationRepository();

  final ConversationRepository _repository;
  AppController? _app;

  bool _busy = false;
  String? _error;
  final Map<String, Future<TranslationResult>> _translations = {};

  bool get isBusy => _busy;
  String? get error => _error;

  String get uid => _app?.currentUser?.uid ?? '';
  String get displayName => _app?.userDisplayName ?? '';
  CommunicationProfile? get profile => _app?.communicationProfile;
  double get playbackSpeed => _app?.playbackSpeed ?? 1;

  /// Lo invoca el `ChangeNotifierProxyProvider` cada vez que cambia la sesión.
  void bindApp(AppController app) {
    final previousUid = uid;
    _app = app;
    if (previousUid != uid) _translations.clear();
  }

  Future<void> chooseProfile(CommunicationProfile value) =>
      _run(() async => _requireApp().setCommunicationProfile(value));

  /// Crea una sala nueva y devuelve su código, o null si falló ([error]).
  Future<String?> create() => _run(() async {
    final profile = _requireProfile();
    return _repository.create(uid: uid, name: displayName, profile: profile);
  });

  /// Entra a una sala con el código escrito por la persona.
  Future<String?> join(String input) => _run(() async {
    final profile = _requireProfile();
    final code = ConversationRepository.normalizeCode(input);
    if (code == null) {
      throw Exception('Escribe el código de 6 caracteres que te compartieron.');
    }
    await _repository.join(
      code: code,
      uid: uid,
      name: displayName,
      profile: profile,
    );
    return code;
  });

  Stream<Conversation?> watch(String code) => _repository.watch(code);

  Stream<List<ConversationMessage>> watchMessages(String code) =>
      _repository.watchMessages(code);

  Future<bool> send(String code, String input) async {
    final text = input.trim();
    if (text.isEmpty) return false;
    final result = await _run(() async {
      if (text.length > ConversationRepository.maxMessageLength) {
        throw Exception(
          'El mensaje no puede superar '
          '${ConversationRepository.maxMessageLength} caracteres.',
        );
      }
      await _repository.sendMessage(
        code: code,
        uid: uid,
        name: displayName,
        profile: _requireProfile(),
        text: text,
      );
      return true;
    }, showBusy: false);
    return result ?? false;
  }

  Future<bool> finish(String code) async {
    final result = await _run(() async {
      await _repository.close(code);
      return true;
    });
    return result ?? false;
  }

  /// Traduce un mensaje a la secuencia de señas del diccionario. El resultado
  /// se guarda por mensaje para no repetir la consulta en cada redibujado.
  Future<TranslationResult> translate(String messageId, String text) =>
      _translations.putIfAbsent(
        messageId,
        () => _requireApp().translateQuietly(text).catchError((Object error) {
          _translations.remove(messageId);
          throw error;
        }),
      );

  void clearError() {
    if (_error == null) return;
    _error = null;
    notifyListeners();
  }

  AppController _requireApp() {
    final app = _app;
    if (app == null || !app.isAuthenticated) {
      throw Exception('Inicia sesión para usar las conversaciones.');
    }
    return app;
  }

  CommunicationProfile _requireProfile() {
    _requireApp();
    final value = profile;
    if (value == null) {
      throw Exception('Elige primero si eres persona oyente o sorda.');
    }
    return value;
  }

  Future<T?> _run<T>(
    Future<T> Function() action, {
    bool showBusy = true,
  }) async {
    if (showBusy) _busy = true;
    _error = null;
    notifyListeners();
    try {
      return await action();
    } catch (error) {
      _error = _friendly(error);
      return null;
    } finally {
      _busy = false;
      notifyListeners();
    }
  }

  String _friendly(Object error) {
    final message = error.toString();
    if (message.contains('permission-denied')) {
      return 'No tienes permiso para esta conversación.';
    }
    if (message.contains('unavailable') || message.contains('network')) {
      return 'No hay conexión con Firebase. Inténtalo de nuevo.';
    }
    if (message.startsWith('Exception: ')) return message.substring(11);
    if (message.startsWith('Bad state: ')) return message.substring(11);
    return message;
  }
}
