import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:features/src/auth/domain/repo_contracts.dart';

/// 📦 [SignInUseCase] — Handles user authentication logic, using [ISignInRepo]
//
final class SignInUseCase {
  ///-------------------
  const SignInUseCase(this.authRepo);

  ///
  final ISignInRepo authRepo;

  //
  /// 🔐 Signs in with provided credentials
  ResultFuture<void> call({required String email, required String password}) =>
      authRepo.signIn(email: email, password: password)
        ..log()
        ..logSuccess('SignInUseCase success');
  //
}
