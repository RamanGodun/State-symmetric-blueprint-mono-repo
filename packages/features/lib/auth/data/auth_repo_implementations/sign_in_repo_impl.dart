import 'package:core/base_modules/errors_handling/core_of_module/_errors_handling_entry_point.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/domain/repo_contracts.dart';

/// 🧩 [SignInRepoImpl] — sign-in in [IAuthRemoteDatabase] with errors mapping
//
final class SignInRepoImpl implements ISignInRepo {
  ///---------------------------------------------
  const SignInRepoImpl(this._remote);
  //
  final IAuthRemoteDatabase _remote;

  //
  @override
  ResultFuture<void> signIn({
    required String email,
    required String password,
  }) => (() => _remote.signIn(
    email: email,
    password: password,
  )).runWithErrorHandling();
}
