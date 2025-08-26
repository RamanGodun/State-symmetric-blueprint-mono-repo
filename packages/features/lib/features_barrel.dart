/// 🧩 Features — top-level barrel for shared domain/data across apps.
/// Import this when you need access to multiple feature modules at once.
// ignore_for_file: combinators_ordering
library;

export 'auth/auth_feature_barrel.dart';
export 'email_verification/email_verification_feature_barrel.dart';
export 'password_changing_or_reset/password_changing_or_reset_feature_barrel.dart';
export 'profile/profile_feature_barrel.dart';
