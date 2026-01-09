import 'package:flutter/material.dart'
    show BuildContext, VoidCallback, WidgetsBinding;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_ui_entity.dart'
    show FailureUIEntity;
import 'package:shared_core_modules/src/overlays/core/_context_x_for_overlays.dart'
    show ContextXForOverlays;
import 'package:shared_core_modules/src/overlays/core/enums_for_overlay_module.dart'
    show OverlayPriority, ShowAs;
import 'package:shared_core_modules/src/overlays/overlays_presentation/overlay_presets/overlay_presets.dart'
    show OverlayErrorUIPreset, OverlayUIPresets;

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
