import 'package:flutter/foundation.dart';

import '../models/app_models.dart';
import '../services/translation_service.dart';

class AppController extends ChangeNotifier {
  AppController({TranslationService? translationService})
    : _translationService = translationService ?? TranslationService();
  final TranslationService _translationService;
  bool darkMode = false;
  bool highContrast = false;
  bool notifications = true;
  double playbackSpeed = 1;
  AppRole role = AppRole.individual;
  TranslationResult? currentTranslation;
  final List<TranslationHistoryItem> history = [
    const TranslationHistoryItem(
      text: 'Hola, ¿cómo estás?',
      label: 'Hoy, 9:30 a. m.',
      signCount: 3,
    ),
    const TranslationHistoryItem(
      text: 'Necesito una cita médica',
      label: 'Ayer, 4:15 p. m.',
      signCount: 4,
    ),
    const TranslationHistoryItem(
      text: '¿Dónde está el baño?',
      label: '14 Sep',
      signCount: 4,
    ),
  ];

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
}
