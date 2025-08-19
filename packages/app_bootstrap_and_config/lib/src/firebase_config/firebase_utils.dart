import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// 🧩 [FirebaseUtils] — helper for Firebase state checks & safe initialization
abstract final class FirebaseUtils {
  ///----------------------------
  const FirebaseUtils._();
  //

  /// ✅ Checks if the DEFAULT Firebase app is already initialized.
  static bool get isDefaultAppInitialized =>
      Firebase.apps.any((app) => app.name == defaultFirebaseAppName);

  /// 🧾 Logs all initialized Firebase apps.
  static void logAllApps() {
    for (final app in Firebase.apps) {
      debugPrint('🧩 Firebase App: ${app.name} (${app.options.projectId})');
    }
  }

  /// 🛡️ Initializes Firebase once (idempotent).
  ///
  /// - If [options] provided → initializes with options (works for web and mobile w/o GoogleService files).
  /// - If [options] is null → tries default `Firebase.initializeApp()` (works when GoogleService files are present).
  static Future<void> safeFirebaseInit({
    FirebaseOptions? options,
    bool logApps = true,
  }) async {
    if (isDefaultAppInitialized) {
      debugPrint('⚠️ Firebase already initialized (checked manually)');
      if (logApps) logAllApps();
      return;
    }

    try {
      if (kIsWeb) {
        assert(
          options != null,
          'On Web you must pass FirebaseOptions.',
        );
        await Firebase.initializeApp(options: options);
      } else if (options != null) {
        await Firebase.initializeApp(options: options);
      } else {
        await Firebase.initializeApp();
      }
      debugPrint('🔥 Firebase initialized!');
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        debugPrint('⚠️ Firebase already initialized, skipping...');
      } else {
        rethrow;
      }
    }

    if (logApps) logAllApps();
  }
}
