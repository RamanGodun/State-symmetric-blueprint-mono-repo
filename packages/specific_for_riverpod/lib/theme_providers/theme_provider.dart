import 'package:core/base_modules/theme/module_core/app_theme_preferences.dart';
import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:core/base_modules/theme/text_theme/text_theme_factory.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

part 'theme_storage_provider.dart';

/// 🧩 [themeProvider] — StateNotifier for switching themes with injected storage
//
final themeProvider =
    StateNotifierProvider<ThemeConfigNotifier, ThemePreferences>(
      ///
      (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
      //
    );

////

////

/// 🌗 [ThemeConfigNotifier] — Manages the ThemeMode state with persistent storage
//
final class ThemeConfigNotifier extends StateNotifier<ThemePreferences> {
  ///----------------------------------------------------------------
  ThemeConfigNotifier(this._storage)
    : super(
        ThemePreferences(
          theme: _loadTheme(_storage),
          font: _loadFont(_storage),
        ),
      );

  final GetStorage _storage;
  static const _themeKey = 'selected_theme';
  static const _fontKey = 'selected_font';

  ///

  /// 🧩 Load saved theme from storage
  static ThemeVariantsEnum _loadTheme(GetStorage storage) {
    //
    final stored = storage.read<String>(_themeKey);
    return ThemeVariantsEnum.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => ThemeVariantsEnum.light,
    );
  }

  /// 🔤 Load saved font
  static AppFontFamily _loadFont(GetStorage storage) {
    //
    final stored = storage.read<String>(_fontKey);
    return AppFontFamily.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => AppFontFamily.sfPro,
    );
  }

  /// 🌓 Update theme only
  void setTheme(ThemeVariantsEnum theme) {
    //
    state = ThemePreferences(theme: theme, font: state.font);
    _storage.write(_themeKey, theme.name);
  }

  /// 🌓 Toggles between light and dark themes
  void toggleTheme() {
    final isCurrentlyDark = state.theme.isDark;
    // Light if dark, otherwise dark
    final nextTheme = isCurrentlyDark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    // Apply theme and persist
    setTheme(nextTheme);
  }

  /// 🔤 Update font only
  void setFont(AppFontFamily font) {
    //
    state = ThemePreferences(theme: state.theme, font: font);
    _storage.write(_fontKey, font.name);
  }

  /// 🧩 Update both at once
  void setThemeAndFont(ThemeVariantsEnum theme, AppFontFamily font) {
    //
    state = ThemePreferences(theme: theme, font: font);
    _storage
      ..write(_themeKey, theme.name)
      ..write(_fontKey, font.name);
  }

  //
}
