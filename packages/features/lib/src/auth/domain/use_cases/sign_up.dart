import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:features/src/auth/domain/repo_contracts.dart';

/// 📦 [SignUpUseCase] — Handles user registration via [ISignUpRepo]
//
final class SignUpUseCase {
  ///-------------------
  const SignUpUseCase(this.repo);

  ///
  final ISignUpRepo repo;

  //
  /// 🔐 Register a new user and returns result
  ResultFuture<void> call({
    required String name,
    required String email,
    required String password,
  }) => repo.signup(name: name, email: email, password: password)
    ..log()
    ..logSuccess('SignUpUseCase success');
  //
}
