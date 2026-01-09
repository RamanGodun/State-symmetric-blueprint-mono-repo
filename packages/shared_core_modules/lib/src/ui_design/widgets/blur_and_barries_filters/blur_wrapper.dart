import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart'
    show
        BackdropFilter,
        BorderRadius,
        BuildContext,
        ClipRRect,
        StatelessWidget,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ShowAs;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeXOnContext, UIConstants;
import 'package:shared_core_modules/shared_core_modules.dart' show ShowAs;

/// 🧊 [BlurContainer] — Glassmorphism wrapper with built-in blur & rounding
/// - Wraps child with ClipRRect + BackdropFilter
/// - Uses `ShowAs` to resolve σX/σY or accepts direct override
/// - Rounded by default to 14 (DLS-consistent)
//
final class BlurContainer extends StatelessWidget {
  ///──────────────────────────────────────────
  const BlurContainer({
    required this.child,
    super.key,
    this.sigmaX,
    this.sigmaY,
    this.overlayType,
    this.borderRadius = UIConstants.commonBorderRadius,
  });

  ///
  final Widget child;

  ///
  final BorderRadius borderRadius;

  /// Optional override blur strength
  final double? sigmaX;

  ///
  final double? sigmaY;

  /// Optional type (used if sigma not provided)
  final ShowAs? overlayType;

  @override
  Widget build(BuildContext context) {
    //
    final isDark = context.isDarkMode;
    final resolvedX = sigmaX ?? _resolveSigmaX(overlayType, isDark);
    final resolvedY = sigmaY ?? _resolveSigmaY(overlayType, isDark);

    return ClipRRect(
      borderRadius: borderRadius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: resolvedX, sigmaY: resolvedY),
        child: child,
      ),
    );
  }

  ///

  /// Resolves σX based on [ShowAs] and theme
  double _resolveSigmaX(ShowAs? type, bool isDark) {
    return switch (type) {
      ShowAs.banner => isDark ? 16.0 : 6.0,
      ShowAs.dialog || ShowAs.infoDialog => isDark ? 6.0 : 7.0,
      ShowAs.snackbar => isDark ? 4.0 : 2.0,
      _ => 4.0,
    };
  }

  /// Resolves σY based on [ShowAs] and theme
  double _resolveSigmaY(ShowAs? type, bool isDark) {
    return switch (type) {
      ShowAs.banner => isDark ? 16.0 : 6.0,
      ShowAs.dialog || ShowAs.infoDialog => isDark ? 6.0 : 2.0,
      ShowAs.snackbar => isDark ? 4.0 : 2.0,
      _ => 4.0,
    };
  }

  //
}
