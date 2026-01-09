import 'package:features_dd_layers/src/email_verification/domain/repo_contract.dart'
    show IUserValidationRepo;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture;
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

/// 📦 [EmailVerificationUseCase] — encapsulates email verification logic
//
final class EmailVerificationUseCase {
  ///------------------------------
  const EmailVerificationUseCase(this.repo, this.gateway);

  ///
  final IUserValidationRepo repo;

  ///
  final AuthGateway gateway;
  //

  /// 📧 Sends verification email
  ResultFuture<void> sendVerificationEmail() {
    debugPrint('[UseCase] sendVerificationEmail()');
    return repo.sendEmailVerification();
  }

  /// 📧 Sends verification email
  ResultFuture<void> reloadUser() => repo.reloadUser();

  /// ✅ Checks email verification status
  ResultFuture<bool> checkIfEmailVerified() async {
    await repo.reloadUser();
    return repo.isEmailVerified();
  }

  //
}
