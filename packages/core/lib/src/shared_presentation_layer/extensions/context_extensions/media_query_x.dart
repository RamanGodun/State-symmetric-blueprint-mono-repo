part of '_context_extensions.dart';

/// 📏 [ContextMediaX] — MediaQuery-based extensions for screen sizing & scaling
/// ✅ Provides shorthand access to screen dimensions, padding, and scale factors
//
extension ContextMediaX on BuildContext {
  ///---------------------------------

  /// 📐 Full [MediaQueryData]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// ↔️ Screen width
  double get screenWidth => mediaQuery.size.width;

  /// ↕️ Screen height
  double get screenHeight => mediaQuery.size.height;

  /// 📐 Raw size
  Size get size => mediaQuery.size;

  /// ⬅️➡️ Alias for [screenWidth]
  double get width => size.width;

  /// ⬆️⬇️ Alias for [screenHeight]
  double get height => size.height;

  /// 📱 Checks if device is a tablet (shortest side ≥ 600dp)
  bool get isTablet => size.shortestSide >= 600;

  /// 🔤 Text scale factor (for accessibility)
  double get textScale => mediaQuery.textScaleFactor;

  /// 🧪 Screen pixel density
  double get pixelRatio => mediaQuery.devicePixelRatio;

  //
}
