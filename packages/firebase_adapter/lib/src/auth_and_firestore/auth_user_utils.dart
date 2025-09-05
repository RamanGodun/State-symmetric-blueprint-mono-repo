import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/errors_handling/core_of_module/failure_type.dart'
    show UserMissingFirebaseFailureType;
import 'package:firebase_adapter/src/auth_and_firestore/firebase_refs.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

/// 🔐 [GuardedFirebaseUser] — safe accessors for the currently signed-in Firebase user.
/// ✅ Centralized guard for `FirebaseAuth.currentUser`
/// ✅ Used inside repositories & use-cases to avoid null checks
///
abstract final class GuardedFirebaseUser {
  ///----------------------------

  /// 👤 Returns the current [User] or throws [Failure(UserMissingFirebaseFailureType)].
  static User get currentUserOrThrow {
    final user = FirebaseRefs.auth.currentUser;
    if (user == null)
      throw const Failure(
        type: UserMissingFirebaseFailureType(),
        message: 'No authorized user!',
      );
    return user;
  }

  /// ❓ Returns the current [User] if present, otherwise `null`.
  static User? get currentUserOrNull => FirebaseRefs.auth.currentUser;

  /// 🆔 Returns the UID of the current user (throws if missing).
  static String get uid => currentUserOrThrow.uid;

  /// 📬 Returns the email of the current user (throws if missing).
  /// Falls back to `'unknown'` if Firebase returns `null`.
  static String get email => currentUserOrThrow.email ?? 'unknown';

  /// 🔄 Reloads the current user instance.
  /// - Throws if no user is signed in.
  /// - Optionally waits for a small [delay] before reloading.
  static Future<void> reloadCurrentUser({Duration? delay}) async {
    final user = currentUserOrThrow;
    if (delay != null) {
      await Future<void>.delayed(delay);
    }
    await user.reload();
  }

  // 🚧 Future extensions: ID token fetch, claims, forced refresh, etc.
}
