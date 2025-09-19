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
final class ButtonSubmissionInitial extends ButtonSubmissionState {
  ///-----------------------------------------------------------
  const ButtonSubmissionInitial();
}

////

/// 🕓 In progress
//
final class ButtonSubmissionLoading extends ButtonSubmissionState {
  ///------------------------------------------------------------
  const ButtonSubmissionLoading();
}

////

/// ✅ Done
//
final class ButtonSubmissionSuccess extends ButtonSubmissionState {
  ///------------------------------------------------------------
  const ButtonSubmissionSuccess();
}

////

/// ❌ Failed
//
final class ButtonSubmissionError extends ButtonSubmissionState {
  ///----------------------------------------------------------
  const ButtonSubmissionError(this.failure);
  final Consumable<Failure>? failure;
  @override
  List<Object?> get props => [failure];
}

////

/// 🔐 [ButtonSubmissionRequiresReauth] - User must reauthenticate before
///    (currently this branch emits only in change-password feature)
//
final class ButtonSubmissionRequiresReauth extends ButtonSubmissionState {
  ///------------------------------------------------------------------
  const ButtonSubmissionRequiresReauth(this.failure);
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
  bool get isLoading => this is ButtonSubmissionLoading;
  bool get isSuccess => this is ButtonSubmissionSuccess;
  bool get isError => this is ButtonSubmissionError;
  bool get isRequiresReauth => this is ButtonSubmissionRequiresReauth;
}
