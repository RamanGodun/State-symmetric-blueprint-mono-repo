import 'package:core/utils.dart' show FormFieldUiState;
import 'package:flutter/widgets.dart';

/// 🧱 [fieldUi] — factory for building [FormFieldUiState]
/// ✅ Unified approach for selectors (BlocSelector / ref.select)
/// ✅ Reduces duplication of inline tuples `(errorText, isObscure)`
FormFieldUiState fieldUi({
  required bool isObscure,
  String? error,
}) => (errorText: error, isObscure: isObscure);

////
////

/// 🎯 [goNext] — convenience callback to move focus to the next [FocusNode]
/// ✅ Used inside `onSubmitted` for input fields
/// ✅ Keeps widget code clean and declarative
VoidCallback goNext(FocusNode next) =>
    () => next.requestFocus();
