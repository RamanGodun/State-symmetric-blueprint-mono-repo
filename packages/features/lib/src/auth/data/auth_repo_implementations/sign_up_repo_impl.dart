import 'package:core/base_modules/errors_handling/core_of_module/_errors_handling_entry_point.dart';
import 'package:core/shared_data_layer/user_data_transfer_objects/user_dto_factories_x.dart'
    show UserDTOFactories;
import 'package:core/shared_data_layer/user_data_transfer_objects/user_dto_x.dart';
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/src/auth/data/remote_database_contract.dart'
    show IAuthRemoteDatabase;
import 'package:features/src/auth/domain/repo_contracts.dart' show ISignUpRepo;

/// 🧩 [SignUpRepoImpl] — Repository for sign up feature.
/// ✅ Handles mapping of errors and between primitives/DTO
//
final class SignUpRepoImpl implements ISignUpRepo {
  ///-------------------------------------------
  const SignUpRepoImpl(this._remote);
  //
  final IAuthRemoteDatabase _remote;

  @override
  ResultFuture<void> signup({
    required String name,
    required String email,
    required String password,
  }) => () async {
    // 1️⃣ Create user (get UID)
    final uid = await _remote.signUp(email: email, password: password);

    // 2️⃣ Create DTO (or just user map)
    final dto = UserDTOFactories.newUser(id: uid, name: name, email: email);

    // 3️⃣ Save DTO as raw map (data source is agnostic)
    await _remote.saveUserData(uid, dto.toJsonMap());
  }.runWithErrorHandling();
}
