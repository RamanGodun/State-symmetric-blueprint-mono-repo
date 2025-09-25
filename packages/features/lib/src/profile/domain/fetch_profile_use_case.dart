import 'package:core/base_modules/errors_management.dart';
import 'package:core/shared_layers/domain.dart' show UserEntity;
import 'package:features/src/profile/domain/repo_contract.dart';

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
