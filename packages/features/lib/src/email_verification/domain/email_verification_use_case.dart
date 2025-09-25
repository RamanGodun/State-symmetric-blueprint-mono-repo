import 'package:core/base_modules/errors_management.dart';
import 'package:core/utils.dart' show AuthGateway;
import 'package:features/src/email_verification/domain/repo_contract.dart';
import 'package:flutter/foundation.dart' show debugPrint;

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
