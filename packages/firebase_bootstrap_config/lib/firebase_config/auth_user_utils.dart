import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/base_modules/errors_handling/core_of_module/failure_type.dart'
    show UserMissingFirebaseFailureType;
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:firebase_bootstrap_config/firebase_config/firebase_constants.dart';

/// 🧩 [AuthUserUtils] — centralized utils for accessing current user
/// 🛡️ Guarantees null-safe usage of FirebaseAuth.currentUser
/// 🧼 Use in Repositories or UseCases

abstract final class AuthUserUtils {
  //-------------------------------

  /// 👤 Returns current user or throws [UserMissingFirebaseFailureType]
  static User get currentUserOrThrow {
    final user = FirebaseConstants.fbAuth.currentUser;
    if (user == null)
      throw const Failure(
        type: UserMissingFirebaseFailureType(),
        message: 'No authorized user!',
      );
    return user;
  }

  /// ❓ Returns current user if present, or `null`
  static User? get currentUserOrNull => FirebaseConstants.fbAuth.currentUser;

  /// 🆔 Returns user UID or throws
  static String get uid => currentUserOrThrow.uid;

  /// 📬 Returns user email or throws
  static String get email => currentUserOrThrow.email ?? 'unknown';

  /// 🔄 Reload current user (throw Exception if user == null)
  static Future<void> reloadCurrentUser({Duration? delay}) async {
    final user = currentUserOrThrow;
    if (delay != null) {
      await Future<void>.delayed(delay);
    }
    await user.reload();
  }

  // (here can be add methods, tokens, refresh ...)
}
