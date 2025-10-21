import 'package:core/public_api/core.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🎨 [OverlayAfterFrameX] — Safe overlay rendering helper
/// ✅ Centralized, dispatcher-aware entry point for showing overlays after navigation
///
/// Guarantees:
///   • ⏱️ Runs **after the current frame** (postFrame)
///   • 🧭 Uses **global overlay context** via `GoRouter.navigatorKey`
///   • 🧠 Delegates to **OverlayDispatcher** for mounted/queue/priority/debounce
///   • 🧯 Requires **no local guards** in callers
//
extension OverlayAfterFrameX on BuildContext {
  ///
  /// Quick form: just a FailureUIEntity → show with defaults.
  void showErrorAfterFrame(FailureUIEntity ui) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navState = GoRouter.of(
        this,
      ).routerDelegate.navigatorKey.currentState;
      final hostCtx = navState?.context;
      //
      // If, for any reason, overlay isn’t ready yet — fall back to the local context.
      (hostCtx ?? this).showError(ui);
    });
  }

  /// Custom form: forward UI options (dialog/snackbar/banner, confirm, etc.)
  void showErrorAfterFrameCustom({
    required FailureUIEntity ui,
    ShowAs showAs = ShowAs.infoDialog,
    OverlayUIPresets preset = const OverlayErrorUIPreset(),
    bool isDismissible = false,
    OverlayPriority priority = OverlayPriority.high,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navState = GoRouter.of(
        this,
      ).routerDelegate.navigatorKey.currentState;
      final overlayCtx = navState?.overlay?.context;
      (overlayCtx ?? this).showError(
        ui,
        showAs: showAs,
        preset: preset,
        isDismissible: isDismissible,
        priority: priority,
        onConfirm: onConfirm,
        onCancel: onCancel,
        confirmText: confirmText,
        cancelText: cancelText,
      );
    });
  }

  //
}
