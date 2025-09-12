import 'package:flutter/widgets.dart';

/// Helper for submit (returns null if submit is not available)
VoidCallback? onSubmittedOrNull(
  VoidCallback action, {
  required bool canSubmit,
}) => canSubmit ? action : null;

/// Next field focus request
void focusNext(FocusNode next) => next.requestFocus();
