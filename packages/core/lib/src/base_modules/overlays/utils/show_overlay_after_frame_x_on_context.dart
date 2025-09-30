import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🎨 [OverlayAfterFrameX] — Extension for safe overlay rendering
/// ✅ Allows to display dialogs/snackbars after navigation is complete
/// 🧯 Prevents "context unmounted" errors when calling overlays
//
extension OverlayAfterFrameX on BuildContext {
  ///
  void showErrorAfterFrame(FailureUIEntity ui) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navState = GoRouter.of(
        this,
      ).routerDelegate.navigatorKey.currentState;
      final overlayCtx = navState?.overlay?.context;
      //
      // Якщо з якоїсь причини overlay ще не готовий – остання спроба через цей context
      (overlayCtx ?? this).showError(ui);
    });
  }
}
