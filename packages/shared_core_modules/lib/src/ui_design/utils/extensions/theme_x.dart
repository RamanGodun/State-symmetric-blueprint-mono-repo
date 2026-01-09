import 'package:flutter/material.dart'
    show
        Brightness,
        BuildContext,
        ColorScheme,
        TargetPlatform,
        TextTheme,
        Theme,
        ThemeData;

/// 🎨 [ThemeXOnContext] — Theme-related extensions on [BuildContext]
/// ✅ Simplifies access to [ThemeData], [ColorScheme], [TextTheme], and brightness
//
extension ThemeXOnContext on BuildContext {
  ///------------------------------------

  /// 🎨 Full [ThemeData] object
  ThemeData get theme => Theme.of(this);

  /// 🌗 Checks if current theme is dark
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// 🔤 [TextTheme] for current theme
  TextTheme get textTheme => theme.textTheme;

  /// 🎨 [ColorScheme] for current theme
  ColorScheme get colorScheme => theme.colorScheme;

  /// 📱 Short-hand platform access for UI entries
  TargetPlatform get platform => theme.platform;

  //
}
