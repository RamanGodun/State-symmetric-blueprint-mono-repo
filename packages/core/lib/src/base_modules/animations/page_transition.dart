import 'package:core/src/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// 🚀 [AppTransitions] — Centralized transitions for GoRouter navigation
//
abstract final class AppTransitions {
  ///----------------------
  AppTransitions._();

  /// 🍎 iOS-style fade animation
  static CustomTransitionPage<T> fade<T>(Widget child) {
    return CustomTransitionPage<T>(
      child: child,
      transitionDuration: AppDurations.ms250,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  // 📦 Ready for extension:
  // static CustomTransitionPage<T> slide<T>(Widget child) => ...
  // static CustomTransitionPage<T> scale<T>(Widget child) => ...

  /// ? MAYBE should add slide, scale, fadeThrough, sharedAxis
}
