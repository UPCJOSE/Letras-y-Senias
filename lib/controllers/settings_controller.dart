part of 'app_controller.dart';

/// Preferencias de apariencia, notificaciones y reproducción.
mixin SettingsController on AppControllerCore {
  bool darkMode = false;
  bool highContrast = false;
  bool notifications = true;
  double playbackSpeed = 1;

  void _resetPreferences() {
    darkMode = false;
    highContrast = false;
    notifications = true;
    playbackSpeed = 1;
  }

  Future<void> setDarkMode(bool value) async {
    darkMode = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setHighContrast(bool value) async {
    highContrast = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setNotifications(bool value) async {
    notifications = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> setPlaybackSpeed(double value) async {
    if (![0.5, 1, 1.5].contains(value)) return;
    playbackSpeed = value;
    notifyListeners();
    await _savePreferences();
  }

  Future<void> _savePreferences() async {
    final user = _currentUser;
    if (user == null) return;
    try {
      await _userRepository.updatePreferences(user.uid, {
        'darkMode': darkMode,
        'highContrast': highContrast,
        'notifications': notifications,
        'playbackSpeed': playbackSpeed,
      });
    } catch (error) {
      _dataError = _friendlyError(error);
      notifyListeners();
    }
  }
}
