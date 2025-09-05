import 'package:core/base_modules/errors_handling/core_of_module/_errors_handling_entry_point.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
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
