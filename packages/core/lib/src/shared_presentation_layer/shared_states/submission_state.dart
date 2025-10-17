//
// ignore_for_file: public_member_api_docs

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:equatable/equatable.dart';

/// 🧾 [SubmissionFlowState] — general state for simple forms with submission.
//
sealed class SubmissionFlowState extends Equatable {
  ///----------------------------------------------
  const SubmissionFlowState();
  //
  @override
  List<Object?> get props => const [];
}

////
////

/// ⏳ Idle
//
final class SubmissionFlowInitialState extends SubmissionFlowState {
  ///-----------------------------------------------------------
  const SubmissionFlowInitialState();
}

////

/// 🕓 In progress
//
final class ButtonSubmissionLoadingState extends SubmissionFlowState {
  ///------------------------------------------------------------
  const ButtonSubmissionLoadingState();
}

////

/// ✅ Done
//
final class ButtonSubmissionSuccessState extends SubmissionFlowState {
  ///------------------------------------------------------------
  const ButtonSubmissionSuccessState();
}

////

/// ❌ Failed
//
final class ButtonSubmissionErrorState extends SubmissionFlowState {
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
final class ButtonSubmissionRequiresReauthState extends SubmissionFlowState {
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
extension ButtonSubmissionStateX on SubmissionFlowState {
  ///---------------------------------------------------
  bool get isLoading => this is ButtonSubmissionLoadingState;
  bool get isSuccess => this is ButtonSubmissionSuccessState;
  bool get isError => this is ButtonSubmissionErrorState;
  bool get isRequiresReauth => this is ButtonSubmissionRequiresReauthState;
}
