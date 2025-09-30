import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:features/src/auth/domain/repo_contracts.dart';

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
