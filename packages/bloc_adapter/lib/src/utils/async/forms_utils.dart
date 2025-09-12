import 'package:core/utils.dart' show FieldUiState;
import 'package:flutter/widgets.dart';
import 'package:formz/formz.dart';

/// 🌀 [BlocFormStatusX] — extension for [FormzSubmissionStatus]
/// ✅ Quick check if form is still in initial (idle) state
/// ✅ Used to simplify conditional UI logic
extension BlocFormStatusX on FormzSubmissionStatus {
  ///
  bool get isIdle => this == FormzSubmissionStatus.initial;
}

////
////

/// 🧱 [BlocFieldSelector] — builder typedef for field UI slices
/// ✅ Extracts `error` and `isObscure` into [FieldUiState]
/// ✅ Keeps BlocSelector usage clean and consistent
typedef BlocFieldSelector<Cubit, State> =
    FieldUiState Function(
      State state, {
      required bool isObscure,
      String? error,
    });

////
////

/// 🧱 [fieldUi] — factory for creating [FieldUiState]
/// ✅ Unified approach across widgets/selectors
/// ✅ Eliminates repetitive inline tuples
FieldUiState fieldUi({
  required bool isObscure,
  String? error,
}) => (errorText: error, isObscure: isObscure);

////
////

/// 🎯 [goNext] — convenience callback for moving to the next [FocusNode]
/// ✅ Used in `onSubmitted` for form fields
/// ✅ Keeps focus traversal clean and declarative
VoidCallback goNext(FocusNode next) =>
    () => next.requestFocus();

////
////

/// 📩 [IsValidatedSelector] — typedef for extracting validation flag
/// ✅ Used in submit buttons to enable/disable state
typedef IsValidatedSelector<State> = bool Function(State);

////
////

/// 📩 [StatusSelector] — typedef for extracting form submission status
/// ✅ Used in buttons and loaders to reflect submission progress
typedef StatusSelector<State> = FormzSubmissionStatus Function(State);
