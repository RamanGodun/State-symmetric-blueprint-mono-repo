import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/password_changing_or_reset/domain/repo_contract.dart';

/// 📦 [PasswordRelatedUseCases] — encapsulates password related logic
/// 🧼 Handles Firebase logic with failure mapping
//
final class PasswordRelatedUseCases {
  ///-----------------------------
  const PasswordRelatedUseCases(this.repo);

  ///
  final IPasswordRepo repo;
  //

  /// 🔁 Triggers password change and wraps result
  ResultFuture<void> callChangePassword(String newPassword) =>
      repo.changePassword(newPassword);

  /// 📩 Sends reset link to the provided email
  ResultFuture<void> callResetPassword(String email) =>
      repo.sendResetLink(email);

  //
}
