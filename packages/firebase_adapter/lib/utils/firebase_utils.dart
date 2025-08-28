import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// 🧩 [SafeFirebaseInit] — helper class for safe, idempotent Firebase initialization.
///
/// Why?
/// - Prevents double-initialization (e.g. when native auto-config is used with .env-based options).
/// - Ensures the **correct Firebase project** is used for the given flavor.
/// - Provides detailed debug logs for all initialized Firebase apps.
/// - Throws a hard error if a wrong project is initialized (fail-fast).
///
abstract final class SafeFirebaseInit {
  ///-------------------------------
  const SafeFirebaseInit._();

  /// ✅ Checks whether the default Firebase app is already initialized.
  static bool get isDefaultAppInitialized =>
      Firebase.apps.any((app) => app.name == defaultFirebaseAppName);

  /// 🧾 Logs all currently initialized Firebase apps (with projectId).
  static void _logAllApps() {
    for (final app in Firebase.apps) {
      debugPrint('🧩 Firebase App: ${app.name} (${app.options.projectId})');
    }
  }

  /// 🛡️ Initializes Firebase in a safe and idempotent way.
  ///
  /// - [options] must always be passed (no fallback to native auto-init).
  /// - If a Firebase app is already initialized:
  ///   - ✅ Same project → only logs, no re-init.
  ///   - ❌ Different project → throws [StateError] (fail-fast).
  /// - Logs all initialized apps when [logApps] is `true`.
  ///
  static Future<void> run({
    required FirebaseOptions options,
    bool logApps = true,
  }) async {
    if (isDefaultAppInitialized) {
      final app = Firebase.app();
      final actual = app.options.projectId;
      final expected = options.projectId;

      if (actual != expected) {
        final msg =
            '❌ Firebase already initialized with WRONG project.\n'
            '   actual="$actual"\n'
            '   expected="$expected".\n'
            '👉 Remove/replace GoogleService-Info.plist (iOS) or google-services.json (Android),\n'
            '   or disable native auto-config to avoid conflicts.';

        // Debug + assert for development mode
        debugPrint(msg);
        assert(false, msg);

        // Throw in release mode to avoid silently running against wrong backend
        throw StateError(msg);
      } else {
        debugPrint('⚠️ Firebase already initialized (project OK: $actual)');
      }

      if (logApps) _logAllApps();
      return;
    }

    try {
      await Firebase.initializeApp(options: options);
      debugPrint('🔥 Firebase initialized with project: ${options.projectId}');
    } on FirebaseException catch (e) {
      if (e.code == 'duplicate-app') {
        debugPrint('⚠️ Firebase already initialized, skipping…');
      } else {
        rethrow;
      }
    }

    if (logApps) _logAllApps();
  }
}
