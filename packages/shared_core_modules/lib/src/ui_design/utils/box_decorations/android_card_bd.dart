part of '_box_decorations_factory.dart';

/// 🍞 [AndroidCardsDecoration] — Native Android snackbar/card appearance
/// 🟤 Includes subtle border, surface color, and corner radius
/// Cached internally per theme brightness
//
final class AndroidCardsDecoration {
  /// ────────────────────────────--
  const AndroidCardsDecoration._();
  //

  ///
  static const BoxDecoration _lightThemeDecoration = BoxDecoration(
    color: AppColors.snackbarLight,
    borderRadius: UIConstants.borderRadius6,
    border: UIConstants.snackbarBorderLight,
  );

  ///
  static const BoxDecoration _darkThemeDecoration = BoxDecoration(
    color: AppColors.snackbarDark,
    borderRadius: UIConstants.borderRadius6,
    border: UIConstants.snackbarBorderDark,
  );

  /// 📦 Memoized lookup map
  static final Map<bool, BoxDecoration> _cache = {
    false: _lightThemeDecoration,
    true: _darkThemeDecoration,
  };

  /// 📦 Resolved by theme
  static BoxDecoration fromTheme({required bool isDark}) =>
      _cache[isDark] ?? (throw ArgumentError('Unknown brightness value'));

  //
}
