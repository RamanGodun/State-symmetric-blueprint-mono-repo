import 'package:flutter/material.dart' show ThemeMode;

/// 🌓 [ThemeModeX] — Extensions for working with [ThemeMode]
/// ✅ Enables toggling & inspecting theme state
//
extension ThemeModeX on ThemeMode {
  ///---------------------------

  /// 🔁 Toggles between [ThemeMode.dark] ↔ [ThemeMode.light]
  ThemeMode toggle() =>
      this == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;

  /// ☀️ True if [ThemeMode.light]
  bool get isLight => this == ThemeMode.light;

  /// 🌙 True if [ThemeMode.dark]
  bool get isDark => this == ThemeMode.dark;

  /// ⚙️ True if [ThemeMode.system]
  bool get isSystem => this == ThemeMode.system;

  //
}
