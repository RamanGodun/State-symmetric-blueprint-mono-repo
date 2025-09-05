// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:flutter/material.dart';

/// 🎞️ [AnimatedOverlayShell] — Universal animation shell for overlays
/// - Wraps child with Slide (optional) + Fade + Scale transitions
/// - Used in: banners, dialogs, snackbars (Android/iOS)
/// - Accepts [AnimationEngine] with configured transitions
//
final class AnimatedOverlayShell extends StatelessWidget {
  /// ──────────────────────────────────────────────────
  const AnimatedOverlayShell({
    required this.engine,
    required this.child,
    super.key,
  });
  //
  final AnimationEngine engine;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Compose: Slide( Fade( Scale(child) ) )
    return SlideTransition(
      position: engine.slide ?? const AlwaysStoppedAnimation(Offset.zero),
      child: FadeTransition(
        opacity: engine.opacity,
        child: ScaleTransition(
          scale: engine.scale,
          child: child,
        ),
      ),
    );
    //
  }
}
