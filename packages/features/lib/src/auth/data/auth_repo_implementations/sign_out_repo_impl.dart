import 'package:core/base_modules/errors_management.dart';
import 'package:features/src/auth/data/remote_database_contract.dart'
    show IAuthRemoteDatabase;
import 'package:features/src/auth/domain/repo_contracts.dart' show ISignOutRepo;

/// 🧩 [SignOutRepoImpl] — sign-out from [IAuthRemoteDatabase] with errors mapping
//
final class SignOutRepoImpl implements ISignOutRepo {
  ///-----------------------------------------------
  const SignOutRepoImpl(this._remote);
  //
  final IAuthRemoteDatabase _remote;

  //
  @override
  ResultFuture<void> signOut() => _remote.signOut.runWithErrorHandling();

  //
}
