import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure;
import 'package:flutter/material.dart';

/// Enter-only error transition detector.
/// Fires once when prev != error and next == error.
void handleEnterOnlyErrorTransition({
  required Failure? prevFailure,
  required Failure? nextFailure,
  required void Function(Failure) emit,
}) {
  if (prevFailure == null && nextFailure != null) {
    emit(nextFailure);
  }
}

/// Safe UI trigger. Defers the effect to the end of the frame (for safety).
void postFrame(void Function() effect) {
  WidgetsBinding.instance.addPostFrameCallback((_) => effect());
}
