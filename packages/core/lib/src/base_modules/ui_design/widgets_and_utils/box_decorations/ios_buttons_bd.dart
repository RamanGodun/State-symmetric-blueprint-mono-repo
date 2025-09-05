part of '_box_decorations_factory.dart';

/// 🍏 [IOSButtonsDecoration] — Apple-style filled buttons with blur + glass effect
/// Used for CustomFilledButton or similar adaptive elements
//
final class IOSButtonsDecoration {
  /// ───────────────────────────────
  const IOSButtonsDecoration._();

  /// 📦 Light Theme Decoration
  static const BoxDecoration _lightThemeDecoration = BoxDecoration(
    color: AppColors.lightPrimary08,
    borderRadius: UIConstants.commonBorderRadius,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.white10),
    ),
    boxShadow: AppShadows.forIOSLightThemeButton,
  );

  /// 📦 Dark Theme Decoration
  static const BoxDecoration _darkThemeDecoration = BoxDecoration(
    color: AppColors.white5,
    borderRadius: UIConstants.commonBorderRadius,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.white10),
    ),
    boxShadow: AppShadows.forIOSDarkThemeButton,
  );

  static final Map<bool, BoxDecoration> _cache = {
    false: _lightThemeDecoration,
    true: _darkThemeDecoration,
  };

  /// 📦 Resolves by theme
  static BoxDecoration fromTheme({required bool isDark}) =>
      _cache[isDark] ?? _lightThemeDecoration;

  //
}
