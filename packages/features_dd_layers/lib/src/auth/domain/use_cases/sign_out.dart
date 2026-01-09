import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart'
    show ISignOutRepo;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show FutureResultLoggerExt, ResultFuture;

/// 📦 [SignOutUseCase] — Handles sign-out logic via [ISignOutRepo]
//
final class SignOutUseCase {
  ///--------------------
  const SignOutUseCase(this.repo);

  ///
  final ISignOutRepo repo;

  ///
  ResultFuture<void> call() => repo.signOut()
    ..log()
    ..logSuccess('SignOutUseCase success');
  //
}
