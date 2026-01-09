import 'package:features_dd_layers/src/profile/domain/fetch_profile_use_case.dart'
    show FetchProfileUseCase;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show ResultFuture;
import 'package:shared_layers/shared_layers.dart' show UserEntity;

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
