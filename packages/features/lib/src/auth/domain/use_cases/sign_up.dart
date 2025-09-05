import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/result_loggers/result_logger_x.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
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
