import 'package:core/base_modules/errors_management.dart';
import 'package:core/utils.dart' show ResultFuture;
import 'package:features/src/auth/data/remote_database_contract.dart'
    show IAuthRemoteDatabase;
import 'package:features/src/auth/domain/repo_contracts.dart' show ISignInRepo;

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
