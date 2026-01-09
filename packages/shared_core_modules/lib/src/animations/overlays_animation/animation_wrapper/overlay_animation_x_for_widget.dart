import 'package:flutter/material.dart' show VoidCallback, Widget;
import 'package:shared_core_modules/public_api/base_modules/animations.dart'
    show AnimatedOverlayWrapper;
import 'package:shared_core_modules/shared_core_modules.dart'
    show AnimatedOverlayWrapper;
import 'package:shared_core_modules/src/animations/overlays_animation/animation_wrapper/animated_overlay_wrapper.dart'
    show AnimatedOverlayWrapper;

/// 🔌 Extension on [Widget] to enable dynamic injection of overlay dismissal logic.
/// 🧠 Wraps an [AnimatedOverlayWrapper] with a new onDismiss callback.
/// If this widget is already an [AnimatedOverlayWrapper], it creates a new instance
/// with the same `engine`, `builder`, and `displayDuration`, but overrides the `onDismiss` callback.
/// Useful for injecting lifecycle control at runtime (e.g., in overlay dispatchers).
/// Returns `this` if the widget is not an [AnimatedOverlayWrapper].
//
extension OverlayWidgetX on Widget {
  ///------------------------------
  //
  Widget withDispatcherOverlayControl({required VoidCallback onDismiss}) {
    if (this is AnimatedOverlayWrapper) {
      final wrapper = this as AnimatedOverlayWrapper;
      return AnimatedOverlayWrapper(
        engine: wrapper.engine,
        builder: wrapper.builder,
        displayDuration: wrapper.displayDuration,
        onDismiss: onDismiss,
      );
    }
    return this;
  }
}
