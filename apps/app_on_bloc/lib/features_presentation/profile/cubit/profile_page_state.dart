part of 'profile_page_cubit.dart';

/// 📄 [ProfileState] — Sealed representation of profile state flow.
/// ✅ Supports one-time failure feedback via [Consumable<FailureUIModel>].
//
sealed class ProfileState {
  ///--------------------
  const ProfileState();
  //
}

////
////
////

final class ProfileInitial extends ProfileState {
  ///-------------------------------------------
  const ProfileInitial();
}

////
////

final class ProfileLoading extends ProfileState {
  ///----------------------------------------
  const ProfileLoading();
}

////
////

final class ProfileLoaded extends ProfileState {
  ///----------------------------------------
  const ProfileLoaded(this.user);
  //
  ///
  final UserEntity user;
}

////
////

final class ProfileError extends ProfileState {
  ///----------------------------------------
  const ProfileError(this.failure);
  //
  ///
  final Consumable<Failure> failure;
}
