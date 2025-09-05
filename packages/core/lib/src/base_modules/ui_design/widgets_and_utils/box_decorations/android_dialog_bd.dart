part of '_box_decorations_factory.dart';

/// 🧱 [AndroidDialogsDecoration] — Material 3-style dialogs
/// 🟤 Light/dark themed with shadows and rounded corners
/// Cached internally for fast access
//
final class AndroidDialogsDecoration {
  /// ──────────────────────────────--
  const AndroidDialogsDecoration._();
  //

  ///
  static const BoxDecoration _lightThemeDecoration = BoxDecoration(
    color: AppColors.lightSurface,
    borderRadius: UIConstants.commonBorderRadius,
    boxShadow: AppShadows.forAndroidLightThemeDialog,
  );

  ///
  static const BoxDecoration _darkThemeDecoration = BoxDecoration(
    color: AppColors.darkSurface,
    borderRadius: UIConstants.commonBorderRadius,
    boxShadow: AppShadows.forAndroidDarkThemeDialog,
  );

  /// 📦 Memoized lookup map
  static final Map<bool, BoxDecoration> _cache = {
    false: _lightThemeDecoration,
    true: _darkThemeDecoration,
  };

  /// 📦 Returns appropriate dialog box style
  static BoxDecoration fromTheme({required bool isDark}) =>
      _cache[isDark] ?? (throw ArgumentError('Unknown brightness value'));

  //
}
