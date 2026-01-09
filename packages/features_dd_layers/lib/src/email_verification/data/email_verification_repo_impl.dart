import 'package:features_dd_layers/public_api/email_verification/email_verification.dart'
    show IUserValidationRepo;
import 'package:features_dd_layers/src/email_verification/data/remote_database_contract.dart'
    show IUserValidationRemoteDataSource;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture, ResultFutureExtension;

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
