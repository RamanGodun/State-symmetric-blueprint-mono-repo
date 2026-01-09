part of '_app_constants.dart';

/// 🎨 [AppShadows] — Centralized shadow presets for dialogs, cards, and buttons.
///   ✅ Ensures consistent elevation and shadow across iOS, Android, and themes.
///   ✅ Used in all major UI components for visual depth and modern look.
//
abstract final class AppShadows {
  ///----------------------------
  const AppShadows._();
  //

  /// 🍏 [forIOSLightThemeDialog] — Shadow preset for dialogs on iOS (light theme).
  static const List<BoxShadow> forIOSLightThemeDialog = [
    BoxShadow(
      color: AppColors.overlayLightShadow,
      blurRadius: 12,
      spreadRadius: 0.1,
      offset: Offset(0, 3),
    ),
  ];

  /// 🍏 [forIOSDarkThemeDialog] — Shadow preset for dialogs on iOS (dark theme).
  static const List<BoxShadow> forIOSDarkThemeDialog = [
    BoxShadow(
      color: AppColors.overlayDarkShadow,
      blurRadius: 12,
      offset: Offset(0, 2),
    ),
  ];

  /// 🤖 [forAndroidDarkThemeDialog] — Shadow preset for dialogs on Android (dark theme).
  static const List<BoxShadow> forAndroidDarkThemeDialog = [
    BoxShadow(
      color: AppColors.androidDialogShadowDark,
      blurRadius: 14,
      spreadRadius: 0.1,
      offset: Offset(0, 3),
    ),
  ];

  /// 🤖 [forAndroidLightThemeDialog] — Shadow preset for dialogs on Android (light theme).
  static const List<BoxShadow> forAndroidLightThemeDialog = [
    BoxShadow(
      color: AppColors.androidDialogShadowLight,
      blurRadius: 10,
      offset: Offset(0, 2),
    ),
  ];

  /// 🍏 [forLightThemeCard] — Card shadow for light theme (iOS/macOS style).
  static const List<BoxShadow> forLightThemeCard = [
    BoxShadow(
      color: AppColors.overlayLightShadow,
      blurRadius: 10,
      spreadRadius: 0.2,
      offset: Offset(0, 3),
    ),
  ];

  /// 🍏 [forDarkThemeCard] — Card shadow for dark theme (iOS/macOS style).
  static const List<BoxShadow> forDarkThemeCard = [
    BoxShadow(
      color: AppColors.overlayDarkShadow,
      blurRadius: 18,
      spreadRadius: 0.1,
      offset: Offset(0, 2),
    ),
  ];

  /// 🍏 [forIOSLightThemeButton] — Double shadow for buttons on iOS/macOS (light theme, modern style).
  static const List<BoxShadow> forIOSLightThemeButton = [
    BoxShadow(color: AppColors.black5, blurRadius: 20, offset: Offset(0, 2)),
  ];

  /// 🍏 [forIOSDarkThemeButton] — Double shadow for buttons on iOS/macOS (dark theme, modern style).
  static const List<BoxShadow> forIOSDarkThemeButton = [
    BoxShadow(color: AppColors.shadow, blurRadius: 20, offset: Offset(0, 2)),
  ];

  //
}
