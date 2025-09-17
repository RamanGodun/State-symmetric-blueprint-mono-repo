import 'package:core/core.dart';
import 'package:flutter/material.dart';

/// 🎨 [OverlayAfterFrameX] — Extension for safe overlay rendering
/// ✅ Allows to display dialogs/snackbars after navigation is complete
/// 🧯 Prevents "context unmounted" errors when calling overlays
//
extension OverlayAfterFrameX on BuildContext {
  /// 🕓 Show error dialog/snackbar after the next frame
  /// - Uses [globalRouterContext] (root navigator) to avoid stale contexts
  /// - Call this right after navigation (e.g., redirect to SignIn)
  /// - Safe for async listeners (Cubit/Bloc callbacks)
  void showErrorAfterFrame(FailureUIEntity ui) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      globalRouterContext?.showError(ui);
    });
  }

  //
}
