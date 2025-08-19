import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// 🧩 [FirebaseUtils] — helper for Firebase state checks & logging
//
abstract final class FirebaseUtils {
  ///----------------------------
  const FirebaseUtils._();
  //

  /// ✅ Checks if 'DEFAULT' Firebase app is initialized
  static bool get isDefaultAppInitialized {
    return Firebase.apps.any((app) => app.name == defaultFirebaseAppName);
  }

  /// 🧾 Logs all initialized Firebase apps
  static void logAllApps() {
    for (final app in Firebase.apps) {
      debugPrint('🧩 Firebase App: ${app.name} (${app.options.projectId})');
    }
  }

  //
}

/*
! can use next (then delete ❌ GoogleService-Info.plist google-services.json)
await Firebase.initializeApp(options: EnvFirebaseOptions.currentPlatform);

! then, also use this: 
Future<void> safeFirebaseInit() async {
  if (Firebase.apps.isNotEmpty) {
    debugPrint('⚠️ Firebase already initialized');
    return;
  }

   if (kIsWeb) {
    await Firebase.initializeApp(options: EnvFirebaseOptions.currentPlatform);
  } else {
    await Firebase.initializeApp(); 
  }
  debugPrint('✅ Firebase initialized');
}

*/
