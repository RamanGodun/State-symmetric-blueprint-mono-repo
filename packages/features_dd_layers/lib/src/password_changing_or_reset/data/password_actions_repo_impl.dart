import 'package:features_dd_layers/src/password_changing_or_reset/data/remote_database_contract.dart'
    show IPasswordRemoteDatabase;
import 'package:features_dd_layers/src/password_changing_or_reset/domain/repo_contract.dart'
    show IPasswordRepo;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture, ResultFutureExtension;

/// 🧩 [PasswordRepoImpl] — Delegates password-related calls to [IPasswordRemoteDatabase]
/// 🧼 Adds unified failure handling via `.executeWithFailureHandling()`
//
final class PasswordRepoImpl implements IPasswordRepo {
  ///-----------------------------------------------
  const PasswordRepoImpl(this._remote);
  //
  final IPasswordRemoteDatabase _remote;

  /// 🔁 Changes password for the currently signed-in user
  @override
  ResultFuture<void> changePassword(String newPassword) =>
      (() => _remote.changePassword(newPassword)).runWithErrorHandling();

  /// 📩 Sends reset password link to provided email
  @override
  ResultFuture<void> sendResetLink(String email) =>
      (() => _remote.sendResetLink(email)).runWithErrorHandling();

  //
}
