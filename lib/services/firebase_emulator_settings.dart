import 'package:flutter/foundation.dart';

class FirebaseEmulatorSettings {
  static const enabled = bool.fromEnvironment('USE_FIREBASE_EMULATORS');
  static const _hostOverride = String.fromEnvironment('FIREBASE_EMULATOR_HOST');

  static String get host => resolveHost(
    isWeb: kIsWeb,
    platform: defaultTargetPlatform,
    override: _hostOverride,
  );

  @visibleForTesting
  static String resolveHost({
    required bool isWeb,
    required TargetPlatform platform,
    required String override,
  }) {
    if (override.trim().isNotEmpty) return override.trim();
    if (!isWeb && platform == TargetPlatform.android) return '10.0.2.2';
    return '127.0.0.1';
  }
}
