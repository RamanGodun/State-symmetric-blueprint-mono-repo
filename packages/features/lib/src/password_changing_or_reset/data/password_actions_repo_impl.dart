import 'package:core/base_modules/errors_handling/core_of_module/_errors_handling_entry_point.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/src/password_changing_or_reset/data/remote_database_contract.dart';
import 'package:features/src/password_changing_or_reset/domain/repo_contract.dart';

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
