import 'package:core/base_modules/errors_handling/core_of_module/_errors_handling_entry_point.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/src/email_verification/data/remote_database_contract.dart';
import 'package:features/src/email_verification/domain/repo_contract.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// 🧩 [IUserValidationRepoImpl] — Repo for email verification, applies error mapping and delegates to [IUserValidationRemoteDataSource]
//
final class IUserValidationRepoImpl implements IUserValidationRepo {
  ///------------------------------------------------------------
  const IUserValidationRepoImpl(this._remote);
  //
  final IUserValidationRemoteDataSource _remote;

  /// 📧 Sends verification email via [IUserValidationRemoteDataSource]
  @override
  ResultFuture<void> sendEmailVerification() {
    debugPrint('[Repo] sendEmailVerification()');
    return _remote.sendVerificationEmail.runWithErrorHandling();
  }

  /// 🔁 Reloads current user from [IUserValidationRemoteDataSource]
  @override
  ResultFuture<void> reloadUser() => _remote.reloadUser.runWithErrorHandling();

  /// ✅ Checks if user's email is verified
  @override
  ResultFuture<bool> isEmailVerified() =>
      (() async => _remote.isEmailVerified()).runWithErrorHandling();

  //
}
