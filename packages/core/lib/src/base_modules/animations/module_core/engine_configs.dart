// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/animations/overlays_animation/overlays_animation_engines/android_animation_engine.dart'
    show AndroidOverlayAnimationEngine;
import 'package:flutter/material.dart' show Curve, Offset;

/// 🌟 [AndroidOverlayAnimationConfig] — defines animation presets for Android overlays
/// ✅ Used internally by [AndroidOverlayAnimationEngine] to unify animation logic
//
final class AndroidOverlayAnimationConfig {
  ///-----------------------------------
  const AndroidOverlayAnimationConfig({
    required this.duration,
    required this.fastDuration,
    required this.opacityCurve,
    required this.scaleCurve,
    required this.scaleBegin,
    this.slideCurve,
    this.slideOffset,
  });
  //
  final Duration duration;
  final Duration fastDuration;
  final Curve opacityCurve;
  final Curve scaleCurve;
  final double scaleBegin;
  final Curve? slideCurve;
  final Offset? slideOffset;
  //
}

////
////

/// 🍎 Configuration class for iOS overlay animations
/// ✅ Defines durations, curves, and scale parameters for each overlay type
//
final class IOSOverlayAnimationConfig {
  ///-------------------------------
  const IOSOverlayAnimationConfig({
    required this.duration,
    required this.fastDuration,
    required this.opacityCurve,
    required this.scaleCurve,
    required this.scaleBegin,
  });
  //
  final Duration duration;
  final Duration fastDuration;
  final Curve opacityCurve;
  final Curve scaleCurve;
  final double scaleBegin;
  //
}
