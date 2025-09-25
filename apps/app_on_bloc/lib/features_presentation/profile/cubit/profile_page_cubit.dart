import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 👤 [ProfileCubit] — keeps the authenticated user's profile.
/// ✅ Mirrors the Riverpod profile provider API (prime / refresh / reset).
/// 🎯 UX: preserves existing UI on background updates (no full-screen loader).
//
final class ProfileCubit extends Cubit<AsyncState<UserEntity>> {
  ///-------------------------------------------------------
  /// Creates a cubit bound to domain [FetchProfileUseCase]
  ProfileCubit(this._fetchProfileUsecase)
    : super(const AsyncState<UserEntity>.loading());
  //
  final FetchProfileUseCase _fetchProfileUsecase;

  ////

  /// 👤 Pre-fetch profile (called by warmup).
  /// 🧩 Keeps previous UI content (no full-screen loader).
  Future<void> prime(String uid) => _load(uid, preserveUi: true);

  /// 🔄 Manual pull-to-refresh (keeps previous UI).
  Future<void> refresh(String uid) => _load(uid, preserveUi: true);

  /// 🚀 Internal loader with optional UI preservation.
  Future<void> _load(String uid, {required bool preserveUi}) async {
    // 🔑 Preserve UI? → don’t emit loading if data is already present.
    final keepUi = preserveUi && state is AsyncStateData<UserEntity>;
    if (!keepUi) emit(const AsyncState<UserEntity>.loading());
    //
    final result = await _fetchProfileUsecase(uid);
    result.fold(
      (failure) => emit(AsyncState<UserEntity>.error(failure)),
      (userData) => emit(AsyncState<UserEntity>.data(userData)),
    );
  }

  /// ♻️ Reset state (e.g., on logout).
  void resetState() => emit(const AsyncState<UserEntity>.loading());
  //
}
