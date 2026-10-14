import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:senas_app/services/firebase_emulator_settings.dart';

void main() {
  test('usa loopback en web y desktop', () {
    expect(
      FirebaseEmulatorSettings.resolveHost(
        isWeb: true,
        platform: TargetPlatform.android,
        override: '',
      ),
      '127.0.0.1',
    );
    expect(
      FirebaseEmulatorSettings.resolveHost(
        isWeb: false,
        platform: TargetPlatform.windows,
        override: '',
      ),
      '127.0.0.1',
    );
  });

  test('usa el host puente en Android y respeta el override físico', () {
    expect(
      FirebaseEmulatorSettings.resolveHost(
        isWeb: false,
        platform: TargetPlatform.android,
        override: '',
      ),
      '10.0.2.2',
    );
    expect(
      FirebaseEmulatorSettings.resolveHost(
        isWeb: false,
        platform: TargetPlatform.android,
        override: ' 192.168.1.8 ',
      ),
      '192.168.1.8',
    );
  });
}
