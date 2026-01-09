import 'package:flutter/material.dart' show VoidCallback;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Failure, FailureX;

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
