import 'dart:async';

import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable.dart'
    show Consumable;
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_entity.dart'
    show Failure;
import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart'
    show UserEntity;
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
