part of '_context_extensions.dart';

/// 📐 [ContextPaddingX] — Safe area and insets extensions
//
extension ContextPaddingX on BuildContext {
  ///-----------------------------------

  /// 📐 Top safe area inset (e.g. notch)
  double get topPadding => mediaQuery.padding.top;

  /// 📐 Bottom safe area inset (e.g. home indicator)
  double get bottomPadding => mediaQuery.padding.bottom;

  /// 📐 Combined horizontal safe padding (left + right)
  double get horizontalPadding =>
      mediaQuery.padding.left + mediaQuery.padding.right;

  /// 📐 Combined vertical safe padding (top + bottom)
  double get verticalPadding =>
      mediaQuery.padding.top + mediaQuery.padding.bottom;

  //
}
