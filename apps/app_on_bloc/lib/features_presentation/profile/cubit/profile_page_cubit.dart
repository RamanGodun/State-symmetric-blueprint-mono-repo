import 'dart:async';

import 'package:core/core.dart';
import 'package:features/features.dart' show FetchProfileUseCase;
import 'package:flutter_bloc/flutter_bloc.dart';

part 'profile_page_state.dart';

/// 🧩 [ProfileCubit] — State manager for profile loading and errors.
/// ✅ Uses AZER (Async, Zero side effects, Error handling, Reactive) pattern.
//
final class ProfileCubit extends Cubit<ProfileState> {
  ///-----------------------------------------------
  ProfileCubit(this._fetchProfileUsecase) : super(const ProfileInitial());
  //
  final FetchProfileUseCase _fetchProfileUsecase;

  //

  /// 🚀 Loads user profile by UID
  Future<void> loadProfile(String uid) async {
    //
    emit(const ProfileLoading());

    final result = await _fetchProfileUsecase(uid);

    result.fold(
      (f) => emit(ProfileError(f.asConsumable())),
      (u) => emit(ProfileLoaded(u)),
    );
  }

  /// 🧽 Clears failure after UI consumed it
  void clearFailure() {
    if (state is ProfileError) {
      emit(const ProfileInitial());
    }
  }

  //
}
