import 'package:flutter/material.dart'
    show
        BuildContext,
        GestureDetector,
        HitTestBehavior,
        StatelessWidget,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ContextXForOverlays;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show OtherContextX;

/// 🧩 [GlobalOverlayHandler] — Universal gesture wrapper for screen-wide UX improvements:
/// - 📱 Automatically dismisses keyboard when user taps outside input
/// - 🔕 Automatically hides currently active overlay (e.g. toast/banner)
/// - ✅ Use to wrap full screens, scrollable areas, or forms
/// - ✅ Respects external dismiss policy before closing overlay
//
final class GlobalOverlayHandler extends StatelessWidget {
  ///--------------------------------------------------
  const GlobalOverlayHandler({
    required this.child,
    super.key,
    this.dismissKeyboard = true,
    this.dismissOverlay = true,
  });

  /// 📦 The child widget to wrap (usually a full screen or form)
  final Widget child;
  //
  /// 🧯 Whether to dismiss the keyboard on tap outside
  final bool dismissKeyboard;
  //
  /// 🧹 Whether to dismiss overlays on tap (if allowed)
  final bool dismissOverlay;
  //

  @override
  Widget build(BuildContext context) {
    //
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        // 📱 Unfocus text fields
        if (dismissKeyboard) context.unfocusKeyboard();

        // 🔕 Dismiss overlay if allowed
        if (dismissOverlay) {
          final dispatcher = context.dispatcher;
          if (dispatcher.canBeDismissedExternally) {
            await dispatcher.dismissCurrent();
          }
        }
      },
      child: child,
    );
  }
}
