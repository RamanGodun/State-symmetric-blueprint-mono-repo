import 'package:core/base_modules/errors_handling/core_of_module/_run_errors_handling.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/auth/data/remote_database_contract.dart';
import 'package:features/auth/domain/repo_contracts.dart';

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
