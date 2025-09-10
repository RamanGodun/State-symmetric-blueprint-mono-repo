import 'dart:async';

import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;

/// 👤 [ProfileCubit] — Thin orchestrator over use case (no business logic here)
/// ✅ Emits [CoreAsync<UserEntity>] to keep UI state-agnostic
//
final class ProfileCubit extends CoreAsyncCubit<UserEntity> {
  ///-----------------------------------------------
  ProfileCubit(this._fetchProfileUsecase) : super();
  //
  final FetchProfileUseCase _fetchProfileUsecase;

  //

  /// 🚀 Load profile by UID using unified loader
  Future<void> load(String uid) async {
    await loadTask(() async {
      final result = await _fetchProfileUsecase(uid);
      // Throw Failure to hit `catch` in CoreAsyncCubit or unfold explicitly:
      return result.fold((f) => throw f, (u) => u);
    });
  }

  //
}
