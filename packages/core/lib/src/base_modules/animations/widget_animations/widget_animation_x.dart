import 'package:core/src/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';

/// 🌀 [WidgetAnimationX] — Widget animation helpers
/// ✅ Provides common animated entrance effects for widgets:
/// - fadeIn, scaleIn, slideInFromBottom, etc.
/// - Uses `TweenAnimationBuilder` / `AnimatedOpacity`
//
extension WidgetAnimationX on Widget {
  ///---------------------------------

  /// 🔶 Fades in the widget with opacity animation
  Widget fadeIn({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.easeIn,
  }) => AnimatedOpacity(
    opacity: 1,
    duration: duration,
    curve: curve,
    child: this,
  );

  /// 🔷 Scales in the widget with elastic entrance
  Widget scaleIn({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.easeOutBack,
    double begin = 0.8,
  }) => TweenAnimationBuilder<double>(
    duration: duration,
    curve: curve,
    tween: Tween<double>(begin: begin, end: 1),
    builder: (_, value, child) => Transform.scale(scale: value, child: child),
    child: this,
  );

  /// 🔽 Slides the widget in from the bottom
  Widget slideInFromBottom({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.easeOut,
    double offsetY = 50,
  }) => TweenAnimationBuilder<Offset>(
    duration: duration,
    curve: curve,
    tween: Tween(begin: Offset(0, offsetY / 100), end: Offset.zero),
    builder: (_, offset, child) => Transform.translate(
      offset: Offset(0, offset.dy * 100),
      child: child,
    ),
    child: this,
  );

  /// ◀️ Slides the widget in from the left
  Widget slideInFromLeft({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.easeOut,
    double offsetX = -50,
  }) => TweenAnimationBuilder<Offset>(
    duration: duration,
    curve: curve,
    tween: Tween(begin: Offset(offsetX / 100, 0), end: Offset.zero),
    builder: (_, offset, child) => Transform.translate(
      offset: Offset(offset.dx * 100, 0),
      child: child,
    ),
    child: this,
  );

  /// 🔁 Rotates the widget into place
  Widget rotateIn({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.easeInOut,
    double begin = -0.5,
  }) => TweenAnimationBuilder<double>(
    duration: duration,
    curve: curve,
    tween: Tween<double>(begin: begin, end: 0),
    builder: (_, angle, child) => Transform.rotate(angle: angle, child: child),
    child: this,
  );

  /// 🎯 Bounces the widget in (scale)
  Widget bounceIn({
    Duration duration = AppDurations.ms350,
    Curve curve = Curves.elasticOut,
    double begin = 0.5,
  }) => TweenAnimationBuilder<double>(
    duration: duration,
    curve: curve,
    tween: Tween<double>(begin: begin, end: 1),
    builder: (_, value, child) => Transform.scale(scale: value, child: child),
    child: this,
  );

  /// 🔄 Wraps widget in [AnimatedSwitcher] with fade + scale transition
  Widget withAnimationSwitcher({
    Duration duration = AppDurations.ms350,
    Curve switchInCurve = Curves.easeIn,
    Curve switchOutCurve = Curves.easeOut,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => AnimatedSwitcher(
    duration: duration,
    switchInCurve: switchInCurve,
    switchOutCurve: switchOutCurve,
    transitionBuilder:
        transitionBuilder ??
        (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
    child: this,
  );

  /// 🧩 Wraps widget in [AnimatedSize] + [AnimatedSwitcher]
  /// Good for smooth layout/child transitions
  Widget withAnimatedSwitcherSize({
    Duration duration = AppDurations.ms350,
    Curve sizeCurve = Curves.easeInOut,
    Curve switchInCurve = Curves.easeOut,
    Curve switchOutCurve = Curves.easeIn,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
    AnimatedSwitcherLayoutBuilder? layoutBuilder,
  }) {
    return AnimatedSize(
      duration: duration,
      curve: sizeCurve,
      child: AnimatedSwitcher(
        duration: duration,
        switchInCurve: switchInCurve,
        switchOutCurve: switchOutCurve,
        layoutBuilder:
            layoutBuilder ??
            (currentChild, previousChildren) => Stack(
              alignment: Alignment.center,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),
        transitionBuilder:
            transitionBuilder ??
            (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
        child: this,
      ),
    );
  }

  /// ✅ Simple `AnimatedSwitcher` with fade+scale
  /// Good for quick replacements without layout shifts
  Widget withSimpleSwitcher({
    Duration duration = AppDurations.ms350,
    Curve switchInCurve = Curves.easeOut,
    Curve switchOutCurve = Curves.easeIn,
    AnimatedSwitcherTransitionBuilder? transitionBuilder,
  }) => AnimatedSwitcher(
    duration: duration,
    switchInCurve: switchInCurve,
    switchOutCurve: switchOutCurve,
    transitionBuilder:
        transitionBuilder ??
        (child, animation) => FadeTransition(
          opacity: animation,
          child: ScaleTransition(scale: animation, child: child),
        ),
    child: this,
  );

  //
}
