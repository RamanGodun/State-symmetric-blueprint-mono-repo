import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart'
    show ISignInRepo;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show FutureResultLoggerExt, ResultFuture;

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
