import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future<void> activateFirebaseAppCheck(FirebaseApp app) async {
  final appCheck = FirebaseAppCheck.instanceFor(app: app);
  const webSiteKey = String.fromEnvironment('FIREBASE_WEB_RECAPTCHA_SITE_KEY');
  if (kIsWeb) {
    if (kDebugMode) {
      await appCheck.activate(providerWeb: WebDebugProvider());
    } else if (webSiteKey.isNotEmpty) {
      await appCheck.activate(providerWeb: ReCaptchaV3Provider(webSiteKey));
    } else {
      debugPrint(
        'App Check web no se activó: falta FIREBASE_WEB_RECAPTCHA_SITE_KEY.',
      );
    }
  } else if (defaultTargetPlatform == TargetPlatform.android) {
    await appCheck.activate(
      providerAndroid: kDebugMode
          ? const AndroidDebugProvider()
          : const AndroidPlayIntegrityProvider(),
    );
  }
}
