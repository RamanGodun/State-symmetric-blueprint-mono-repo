import 'package:features_dd_layers/src/profile/domain/repo_contract.dart'
    show IProfileRepo;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show EitherGetters, FailureLogger, ResultFuture;
import 'package:shared_layers/public_api/domain_layer_shared.dart'
    show UserEntity;

/// 🧩 [FetchProfileUseCase] — Encapsulates domain logic of
//     loading profile (with "fetch-or-create" user logic)
//
final class FetchProfileUseCase {
  ///-------------------------
  const FetchProfileUseCase(this._repo);
  //
  final IProfileRepo _repo;

  /// 🚀 Loads user profile by UID; creates if missing, then reloads.
  ResultFuture<UserEntity> call(String uid) async {
    // 1️⃣ Try to load profile
    final result = await _repo.getProfile(uid: uid);
    if (result.isRight) return result;

    // 2️⃣ If not found, log and create profile
    result.leftOrNull?.log();
    await _repo.createUserProfile(uid);

    // 3️⃣ Try again after creation
    return _repo.getProfile(uid: uid);
  }
}
