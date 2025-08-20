import 'package:blueprint_on_qubit/features/change_or_reset_password/domain/repo_contract.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;

/// 📦 [PasswordRelatedUseCases] — encapsulates password related logic
/// 🧼 Handles Firebase logic with failure mapping
//
final class PasswordRelatedUseCases {
  ///-----------------------------
  const PasswordRelatedUseCases(this.repo);

  ///
  final IPasswordRepo repo;

  /// 🔁 Triggers password change and wraps result
  ResultFuture<void> callChangePassword(String newPassword) =>
      repo.changePassword(newPassword);

  /// 📩 Sends reset link to the provided email
  ResultFuture<void> callResetPassword(String email) =>
      repo.sendResetLink(email);

  //
}
