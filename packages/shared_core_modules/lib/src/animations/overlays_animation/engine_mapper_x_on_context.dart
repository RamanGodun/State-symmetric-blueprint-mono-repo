import 'package:flutter/foundation.dart' show TargetPlatform;
import 'package:flutter/material.dart' show BuildContext;
import 'package:shared_core_modules/public_api/base_modules/animations.dart'
    show
        AndroidOverlayAnimationEngine,
        AnimationEngine,
        FallbackAnimationEngine,
        IOSOverlayAnimationEngine;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show OverlayCategory, ShowAs;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeXOnContext;

/// 🎯 [OverlayAnimationEngineMapperX] — resolves the animation engine,
///     based on overlay category and platform.
//
extension OverlayAnimationEngineMapperX on BuildContext {
  ///-------------------------------------------------
  //
  AnimationEngine getEngine(OverlayCategory type) {
    return switch ((type, platform)) {
      //
      // 🍎 iOS: use shared configurable engine
      (OverlayCategory.dialog, TargetPlatform.iOS) => IOSOverlayAnimationEngine(
        ShowAs.dialog,
      ),

      (OverlayCategory.banner, TargetPlatform.iOS) => IOSOverlayAnimationEngine(
        ShowAs.banner,
      ),

      (OverlayCategory.snackbar, TargetPlatform.iOS) =>
        IOSOverlayAnimationEngine(ShowAs.snackbar),

      ////

      // 🤖 Android: use shared configurable engine
      (OverlayCategory.dialog, TargetPlatform.android) =>
        AndroidOverlayAnimationEngine(ShowAs.dialog),

      (OverlayCategory.banner, TargetPlatform.android) =>
        AndroidOverlayAnimationEngine(ShowAs.banner),

      (OverlayCategory.snackbar, TargetPlatform.android) =>
        AndroidOverlayAnimationEngine(ShowAs.snackbar),

      ////

      // 🛑 Default fallback
      _ => FallbackAnimationEngine(),

      //
    };
  }
}
