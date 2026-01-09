import 'package:firebase_core/firebase_core.dart'
    show
        Firebase,
        FirebaseApp,
        FirebaseException,
        FirebaseOptions,
        defaultFirebaseAppName;
import 'package:flutter/foundation.dart' show debugPrint;

/// 🛡️ [FirebaseInitGuard] — Safe & idempotent Firebase bootstrap with verification.
/// ✅ Prevents double-inits with wrong project
/// ✅ Verifies target project against already-initialized app
/// ✅ Returns the resolved [FirebaseApp] for further use
///
/// 📝 Usage:
/// ```dart
/// final app = await FirebaseInitGuard.ensureInitialized(
///   options: FirebaseEnvOptions.current,
///   logApps: true,
/// );
/// ```
//
abstract final class FirebaseInitGuard {
  ///-------------------------------
  const FirebaseInitGuard._();

  /// ✅ Whether the default Firebase app is already initialized.
  static bool get isDefaultAppInitialized =>
      Firebase.apps.any((app) => app.name == defaultFirebaseAppName);

  /// 🧾 Log all initialized Firebase apps (with projectId).
  static void _logAllApps() {
    for (final app in Firebase.apps) {
      debugPrint('🧩 Firebase App: ${app.name} (${app.options.projectId})');
    }
  }

  /// 🛡️ Safely bootstraps Firebase with explicit [options].
  ///
  /// Flow:
  /// - Always attempts `Firebase.initializeApp(options: ...)`
  /// - If already initialized:
  ///   - ✅ Same project → log & reuse existing app
  ///   - ❌ Different project → handle per 'onMismatch' policy
  ///
  /// Returns the resolved [FirebaseApp] (new or existing).
  static Future<void> ensureInitialized({
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
