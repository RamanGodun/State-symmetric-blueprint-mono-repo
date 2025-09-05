//
// ignore_for_file: public_member_api_docs

import 'package:formz/formz.dart';

/// 🔁 Extension for concise and readable status checks
//
extension FormzStatusX on FormzSubmissionStatus {
  ///------------------------------------------
  //
  bool get isIdle => this == FormzSubmissionStatus.initial;
  bool get isLoading => this == FormzSubmissionStatus.inProgress;
  bool get isSuccess => this == FormzSubmissionStatus.success;
  bool get isFailure => this == FormzSubmissionStatus.failure;
  bool get isValidated => this == FormzSubmissionStatus.success;

  /// 🔄 Aliases for semantic usage
  bool get isSubmissionInProgress => isLoading;
  bool get isSubmissionFailure => isFailure;
  bool get isSubmissionSuccess => isSuccess;

  /// ✅ Safe to submit only if form validated and not submitting
  bool get canSubmit => isIdle || isFailure;

  //
}
