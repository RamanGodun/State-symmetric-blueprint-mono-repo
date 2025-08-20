import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/email_verification/domain/repo_contract.dart';

/// 📦 [EmailVerificationUseCase] — encapsulates email verification logic
//
final class EmailVerificationUseCase {
  ///------------------------------
  const EmailVerificationUseCase(this.repo);

  ///
  final IUserValidationRepo repo;
  //

  /// 📧 Sends verification email
  ResultFuture<void> sendVerificationEmail() => repo.sendEmailVerification();

  /// 📧 Sends verification email
  ResultFuture<void> reloadUser() => repo.reloadUser();

  /// ✅ Checks email verification status
  ResultFuture<bool> checkIfEmailVerified() async {
    await repo.reloadUser();
    return repo.isEmailVerified();
  }

  //
}
