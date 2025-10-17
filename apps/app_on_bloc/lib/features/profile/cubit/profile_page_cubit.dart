import 'package:bloc_adapter/bloc_adapter.dart'
    show AsyncValueForBLoC, CubitWithAsyncValue;
import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;

/// 👤 [ProfileCubit] — keeps the authenticated user's profile.
/// ✅ Mirrors the Riverpod profile provider API (prime / refresh / reset).
/// 🎯 UX: preserves existing UI on background updates (no full-screen loader).
//
final class ProfileCubit extends CubitWithAsyncValue<UserEntity> {
  ///-------------------------------------------------------
  /// Creates a cubit bound to domain [FetchProfileUseCase]
  ProfileCubit(this._fetchProfileUsecase) : super();
  final FetchProfileUseCase _fetchProfileUsecase;

  ////

  /// 👤 Pre-fetch profile (called by warmup).
  /// 🧩 Keeps previous UI content (no full-screen loader).
  Future<void> prime(String uid) => _load(uid, preserveUi: true);

  /// 🔄 Manual pull-to-refresh (keeps previous UI).
  Future<void> refresh(String uid) => _load(uid, preserveUi: true);

  /// 🚀 Internal loader with optional UI preservation.
  Future<void> _load(String uid, {required bool preserveUi}) async {
    // ⏳ Emit loading, but keep current UI if we already have data
    // emitLoading(preserveUi: preserveUi);
    final next = const AsyncValueForBLoC<UserEntity>.loading().copyWithPrevious(
      state,
    );
    emit(next);
    //
    final result = await _fetchProfileUsecase(uid);
    // ♻️ Either<Failure, UserEntity> → emit data/error
    emitFromEither(result);
  }

  /// ♻️ Hard reset back to pure `loading` (e.g. on logout).
  void resetState() => resetToLoading();
  //
}
