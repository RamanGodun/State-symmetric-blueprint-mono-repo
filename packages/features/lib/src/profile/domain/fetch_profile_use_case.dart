import 'package:core/base_modules/errors_handling/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart'
    show UserEntity;
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
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
