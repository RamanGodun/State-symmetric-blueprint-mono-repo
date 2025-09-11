import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/localization.dart' show LocaleKeys;
import 'package:core/shared_layers/data.dart'
    show UserDTO, UserDTOFactories, UserDTOX;
import 'package:core/shared_layers/domain.dart' show UserEntity;
import 'package:core/utils.dart'
    show AppDurations, CacheManager, CacheStats, ResultFuture;
import 'package:features/src/profile/data/remote_database_contract.dart';
import 'package:features/src/profile/domain/repo_contract.dart';

/// 🧩 [ProfileRepoImpl] — Repository implementation for profile feature with cache manager composition
/// ✅ Handles in-memory and in-flight cache, mapping, and error handling
//
final class ProfileRepoImpl implements IProfileRepo {
  ///─────────────────────────--------------------
  ProfileRepoImpl(
    this._remoteDatabase, {
    CacheManager<UserEntity, String>? cacheManager,
  }) : _cacheManager =
           cacheManager ??
           CacheManager<UserEntity, String>(ttl: AppDurations.min5);
  //
  //
  final IProfileRemoteDatabase _remoteDatabase;
  final CacheManager<UserEntity, String> _cacheManager;
  //

  ////

  /// Returns cached user if fresh, otherwise fetches from remote
  @override
  ResultFuture<UserEntity> getProfile({required String uid}) => (() async {
    return _cacheManager.execute(uid, () => _fetchProfile(uid));
  }).runWithErrorHandling();

  /// Force refresh profile (bypasses cache)
  ResultFuture<UserEntity> refreshProfile({required String uid}) => (() async {
    return _cacheManager.execute(
      uid,
      () => _fetchProfile(uid),
      forceRefresh: true,
    );
  }).runWithErrorHandling();

  /// Fetches user profile from remote source
  Future<UserEntity> _fetchProfile(String uid) async {
    final data = await _remoteDatabase.fetchUserMap(uid);
    if (data == null)
      throw const Failure(
        type: UserNotFoundFirebaseFailureType(),
        message: LocaleKeys.failures_firebase_user_not_found,
      );
    final dto = UserDTOFactories.fromMap(data, id: uid);
    return dto.toEntity();
  }

  ////

  /// ♻️ Clears all profile cache
  @override
  void clearCache() => _cacheManager.clear();

  /// 📊 Get cache statistics (useful for debugging)
  CacheStats get cacheStats => _cacheManager.stats;

  ////

  ////

  /// 🆕 Creates a new user profile in database for current user.
  @override
  ResultFuture<void> createUserProfile(String uid) => () async {
    final authData = await _remoteDatabase.getCurrentUserAuthData();
    if (authData == null)
      throw const Failure(
        type: UserMissingFirebaseFailureType(),
        message: LocaleKeys.failures_firebase_unauthorized,
      );
    //
    final dto = _buildUserDTO(authData, uid);
    await _remoteDatabase.createUserMap(dto.id, dto.toJsonMap());
    //
    /// Remove from cache to force fresh fetch next time
    _cacheManager.remove(uid);
  }.runWithErrorHandling();

  /// Factory for building [UserDTO] from auth data
  UserDTO _buildUserDTO(Map<String, dynamic> authData, String fallbackUid) {
    return UserDTOFactories.newUser(
      id: authData['uid'] as String,
      name: authData['name'] as String,
      email: authData['email'] as String,
    );
  }

  //
}
