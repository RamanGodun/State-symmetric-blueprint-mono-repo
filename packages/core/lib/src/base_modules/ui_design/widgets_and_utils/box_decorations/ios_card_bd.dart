part of '_box_decorations_factory.dart';

/// 🎨 [IOSCardsDecoration] — iOS/macOS card/banner glass style
/// 🍏 Glassmorphic style: blurred background, semi-transparent fill, border & shadow
/// Optimized for fast retrieval via theme-based caching
//
final class IOSCardsDecoration {
  /// ─────────────────────────
  const IOSCardsDecoration._();
  //

  ///
  static const BoxDecoration _lightThemeDecoration = BoxDecoration(
    color: AppColors.overlayLightBackground70,
    borderRadius: UIConstants.commonBorderRadius,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.overlayLightBorder12),
    ),
    boxShadow: AppShadows.forLightThemeCard,
  );

  ///
  static const BoxDecoration _darkThemeDecoration = BoxDecoration(
    color: AppColors.overlayDarkBackground,
    borderRadius: UIConstants.commonBorderRadius,
    border: Border.fromBorderSide(
      BorderSide(color: AppColors.overlayDarkBorder10),
    ),
    boxShadow: AppShadows.forDarkThemeCard,
  );

  /// 📦 Memoized lookup map
  static final Map<bool, BoxDecoration> _cache = {
    false: _lightThemeDecoration,
    true: _darkThemeDecoration,
  };

  /// 📦 Returns appropriate glass box based on theme brightness
  static BoxDecoration fromTheme({required bool isDark}) =>
      _cache[isDark] ?? (throw ArgumentError('Unknown brightness value'));

  //
}
