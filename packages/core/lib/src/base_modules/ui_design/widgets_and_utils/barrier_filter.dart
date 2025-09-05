import 'dart:ui';

import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart'
    show OverlayBlurLevel, ShowAs;
import 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';
import 'package:flutter/material.dart';

/// 🧊 [OverlayBarrierFilter] — Consistent blurred overlay backgrounds
/// - Used in: dialogs, banners, snackbars (iOS + Android)
/// - Supports [ShowAs] or override with [OverlayBlurLevel]
//
final class OverlayBarrierFilter {
  /// ───────────────────────────
  const OverlayBarrierFilter._();
  //

  /// 📦 Main resolver: theme + type + optional [level] override
  static Widget resolve({
    required bool isDark,
    ShowAs? type,
    OverlayBlurLevel? level,
  }) {
    final (sigmaX, sigmaY) = switch (level) {
      OverlayBlurLevel.soft => (2.0, 2.0),
      OverlayBlurLevel.medium => (6.0, 6.0),
      OverlayBlurLevel.strong => (12.0, 12.0),
      null => _resolveSigma(type, isDark),
    };

    final color = isDark
        ? AppColors.overlayDarkBarrier
        : AppColors.overlayLightBarrier;

    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: Container(color: color),
      ),
    );

    //
  }

  ///

  /// 🎚️ Theme + [ShowAs]-based blur config
  static (double, double) _resolveSigma(ShowAs? type, bool isDark) {
    return switch (type) {
      ShowAs.banner => isDark ? (12, 12) : (6, 6),
      ShowAs.dialog || ShowAs.infoDialog => isDark ? (6, 6) : (3, 3),
      ShowAs.snackbar => isDark ? (4, 4) : (2, 2),
      _ => (2.5, 2.5),
    };
  }

  //
}
