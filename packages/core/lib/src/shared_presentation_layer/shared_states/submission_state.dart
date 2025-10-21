//
// ignore_for_file: public_member_api_docs

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:equatable/equatable.dart';

/// 🧾 [SubmissionFlowStateModel] — general state for simple forms with submission.
//
sealed class SubmissionFlowStateModel extends Equatable {
  ///----------------------------------------------
  const SubmissionFlowStateModel();
  //
  @override
  List<Object?> get props => const [];
}

////
////

/// ⏳ Idle
//
final class SubmissionFlowInitialState extends SubmissionFlowStateModel {
  ///-----------------------------------------------------------
  const SubmissionFlowInitialState();
}

////

/// 🕓 In progress
//
final class ButtonSubmissionLoadingState extends SubmissionFlowStateModel {
  ///------------------------------------------------------------
  const ButtonSubmissionLoadingState();
}

////

/// ✅ Done
//
final class ButtonSubmissionSuccessState extends SubmissionFlowStateModel {
  ///------------------------------------------------------------
  const ButtonSubmissionSuccessState();
}

////

/// ❌ Failed
//
final class ButtonSubmissionErrorState extends SubmissionFlowStateModel {
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
final class ButtonSubmissionRequiresReauthState
    extends SubmissionFlowStateModel {
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
extension ButtonSubmissionStateX on SubmissionFlowStateModel {
  ///---------------------------------------------------
  bool get isLoading => this is ButtonSubmissionLoadingState;
  bool get isSuccess => this is ButtonSubmissionSuccessState;
  bool get isError => this is ButtonSubmissionErrorState;
  bool get isRequiresReauth => this is ButtonSubmissionRequiresReauthState;
}
