import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart'
    show UserEntity;
import 'package:core/utils_shared/type_definitions.dart' show ResultFuture;
import 'package:features/src/profile/domain/fetch_profile_use_case.dart';

/// 📦 [IProfileRepo] — Contract for [FetchProfileUseCase] repo
//
abstract interface class IProfileRepo {
  ///-------------------------------
  //
  ///
  ResultFuture<UserEntity> getProfile({required String uid});
  //
  /// ✅ Create the user profile if not exists in the database (e.g. Firestore)
  ResultFuture<void> createUserProfile(String uid);
  //
  /// Clears in-memory cache (optional, use empty implementation if not needed).
  void clearCache();
  //
}
