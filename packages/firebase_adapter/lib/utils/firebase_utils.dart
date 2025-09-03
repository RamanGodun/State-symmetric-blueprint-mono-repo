import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// 🧩 [SafeFirebaseInit] — helper for safe, idempotent Firebase initialization.
///
/// Why?
/// - Prevents double initialization (when native auto-config conflicts with .env options).
/// - Guarantees the **correct Firebase project** for the active flavor.
/// - Provides detailed logs of initialized Firebase apps.
/// - Fails fast if a wrong project is active.
abstract final class SafeFirebaseInit {
  const SafeFirebaseInit._();

  /// ✅ Whether the default Firebase app is already initialized.
  static bool get isDefaultAppInitialized =>
      Firebase.apps.any((app) => app.name == defaultFirebaseAppName);

  /// 🧾 Log all initialized Firebase apps (with projectId).
  static void _logAllApps() {
    for (final app in Firebase.apps) {
      debugPrint('🧩 Firebase App: ${app.name} (${app.options.projectId})');
    }
  }

  /// 🛡️ Initialize Firebase in a safe, idempotent way.
  ///
  /// - [options] must ALWAYS be provided (no fallback to native auto-init).
  /// - If already initialized:
  ///   - ✅ Same project → just log and return.
  ///   - ❌ Different project → throw [StateError] (fail-fast).
  /// - When [logApps] is `true`, logs all apps after init.
  static Future<void> run({
    required FirebaseOptions options,
    bool logApps = true,
  }) async {
    try {
      // ✅ Always try to initialize with the provided options
      await Firebase.initializeApp(options: options);
      debugPrint('🔥 Firebase initialized with project: ${options.projectId}');
      if (logApps) _logAllApps();
      return;
    } on FirebaseException catch (e) {
      // If already initialized — verify it’s the same project
      if (e.code == 'duplicate-app') {
        final app = Firebase.app(); // [DEFAULT]
        final actual = app.options.projectId;
        final expected = options.projectId;

        if (actual == expected) {
          debugPrint('⚠️ Firebase already initialized (project OK: $actual)');
          if (logApps) _logAllApps();
          return;
        }

        final msg =
            '''
❌ Firebase already initialized with WRONG project.
   actual="$actual"
   expected="$expected".
👉 Ensure there is NO GoogleService-Info.plist (iOS) and google-services.json is NOT auto-applied for another flavor/config.
''';
        debugPrint(msg);
        assert(false, msg);
        throw StateError(msg);
      }
      rethrow;
    }
  }
}
