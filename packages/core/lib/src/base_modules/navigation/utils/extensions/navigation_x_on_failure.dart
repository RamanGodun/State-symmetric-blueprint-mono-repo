import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';
import 'package:core/src/base_modules/errors_management/extensible_part/failure_extensions/failure_diagnostics_x.dart';
import 'package:flutter/material.dart';

/// 🧭 [FailureNavigationX] — Handles redirection/navigation scenarios based on failure type
/// ✅ Recommended for handling auth/navigation flows declaratively
//
extension FailureNavigationX on Failure {
  /// -----------------------------------
  //
  /// 📡 Navigates to login screen or callback when unauthorized (401)
  /// ⚠️ This is an example — replace [onUnauthorized] with actual implementation in your app
  Failure redirectIfUnauthorized(VoidCallback onUnauthorized) {
    if (isUnauthorizedFailure) onUnauthorized();
    return this;
  }
}
