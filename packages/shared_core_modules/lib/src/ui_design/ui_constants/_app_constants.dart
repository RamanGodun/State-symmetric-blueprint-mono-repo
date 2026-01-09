import 'package:flutter/material.dart'
    show
        Border,
        BorderRadius,
        BorderSide,
        BoxShadow,
        EdgeInsets,
        IconData,
        Icons,
        Offset,
        Radius;
import 'package:shared_core_modules/src/ui_design/ui_constants/app_colors.dart';

part 'app_icons.dart';
part 'app_shadows.dart';
part 'app_spacing.dart';

/// 📦 [UIConstants] — centralized place for static constants, used across the app.
//
abstract final class UIConstants {
  ///-----------------------------
  const UIConstants._();
  //

  /// 🎯 Common border radius for UI elements (e.g. buttons, cards)
  //───────────────────-------------------------------------------
  //
  static const BorderRadius commonBorderRadius = BorderRadius.all(
    Radius.circular(AppSpacing.xm),
  );

  ///
  static const BorderRadius borderRadius6 = BorderRadius.all(
    Radius.circular(AppSpacing.xxs),
  );

  ///
  static const BorderRadius borderRadius8 = BorderRadius.all(
    Radius.circular(AppSpacing.xxxs),
  );

  ///
  static const BorderRadius borderRadius10 = BorderRadius.all(
    Radius.circular(AppSpacing.m),
  );

  ///
  static const BorderRadius borderRadius12 = BorderRadius.all(
    Radius.circular(AppSpacing.xm),
  );
  //

  /// 🎯 Card paddings
  //─────────────────
  //
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: AppSpacing.p16,
    vertical: AppSpacing.p10,
  );

  ///
  static const EdgeInsets cardPaddingV26 = EdgeInsets.symmetric(
    horizontal: AppSpacing.p26,
    vertical: AppSpacing.p10,
  );

  ///
  static const EdgeInsets zeroPadding = EdgeInsets.zero;
  //

  /// BORDERS
  //─────────
  //
  static const Border snackbarBorderDark = Border.fromBorderSide(
    BorderSide(color: AppColors.overlayDarkBorder40, width: 0.6),
  );

  ///
  static const Border snackbarBorderLight = Border.fromBorderSide(
    BorderSide(color: AppColors.overlayLightBorder50, width: 0.6),
  );
  //

  /// * Other constants...
  //───────────────────

  //
}
