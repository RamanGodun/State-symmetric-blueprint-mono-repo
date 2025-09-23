//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:equatable/equatable.dart';

/// 🧾 [ButtonSubmissionState] — general state for simple forms with submission.
//
sealed class ButtonSubmissionState extends Equatable {
  ///----------------------------------------------
  const ButtonSubmissionState();
  //
  @override
  List<Object?> get props => const [];
}

////
////

/// ⏳ Idle
//
final class ButtonSubmissionInitialState extends ButtonSubmissionState {
  ///-----------------------------------------------------------
  const ButtonSubmissionInitialState();
}

////

/// 🕓 In progress
//
final class ButtonSubmissionLoadingState extends ButtonSubmissionState {
  ///------------------------------------------------------------
  const ButtonSubmissionLoadingState();
}

////

/// ✅ Done
//
final class ButtonSubmissionSuccessState extends ButtonSubmissionState {
  ///------------------------------------------------------------
  const ButtonSubmissionSuccessState();
}

////

/// ❌ Failed
//
final class ButtonSubmissionErrorState extends ButtonSubmissionState {
  ///----------------------------------------------------------
  const ButtonSubmissionErrorState(this.failure);
  final Consumable<Failure>? failure;
  @override
  List<Object?> get props => [failure];
}

////

/// 🔐 [ButtonSubmissionRequiresReauthState] - User must reauthenticate before
///    (currently this branch emits only in change-password feature)
//
final class ButtonSubmissionRequiresReauthState extends ButtonSubmissionState {
  ///------------------------------------------------------------------
  const ButtonSubmissionRequiresReauthState(this.failure);
  final Consumable<Failure>? failure;
  @override
  List<Object?> get props => [failure];
}

////
////

/// 🧰 [ButtonSubmissionStateX] - Convenience flags
//
extension ButtonSubmissionStateX on ButtonSubmissionState {
  ///---------------------------------------------------
  bool get isLoading => this is ButtonSubmissionLoadingState;
  bool get isSuccess => this is ButtonSubmissionSuccessState;
  bool get isError => this is ButtonSubmissionErrorState;
  bool get isRequiresReauth => this is ButtonSubmissionRequiresReauthState;
}
