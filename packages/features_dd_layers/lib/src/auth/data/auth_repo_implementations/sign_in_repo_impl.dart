import 'package:features_dd_layers/src/auth/data/remote_database_contract.dart'
    show IAuthRemoteDatabase;
import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture, ResultFutureExtension;

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
