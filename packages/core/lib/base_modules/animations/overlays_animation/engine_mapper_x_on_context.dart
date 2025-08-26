import 'package:core/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/base_modules/animations/overlays_animation/overlays_animation_engines/android_animation_engine.dart';
import 'package:core/base_modules/animations/overlays_animation/overlays_animation_engines/ios_animation_engine.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:flutter/material.dart';

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
