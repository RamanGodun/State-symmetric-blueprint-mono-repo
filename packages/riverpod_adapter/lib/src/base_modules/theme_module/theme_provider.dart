import 'package:core/base_modules/ui_design.dart'
    show AppFontFamily, ThemePreferences, ThemeVariantsEnum, parseAppFontFamily;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

part 'theme_storage_provider.dart';

/// 🧩 [themeProvider] — [StateNotifier<ThemePreferences>] with persistent storage.
//
final themeProvider =
    StateNotifierProvider<ThemeConfigNotifier, ThemePreferences>(
      ///
      (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
      //
    );

////

////

/// 🌗 [ThemeConfigNotifier] — manages theme/font preferences with GetStorage.
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
    final stored = storage.read<String>(_themeKey);
    return ThemeVariantsEnum.values.firstWhere(
      (e) => e.name == stored,
      orElse: () => ThemeVariantsEnum.light,
    );
  }

  /// 🔤 Load saved font (з legacy-міграцією)
  static AppFontFamily _loadFont(GetStorage storage) {
    final stored = storage.read<String>(_fontKey);
    return parseAppFontFamily(stored); // ⟵ спільний парсер
  }

  /// 🌓 Update theme only
  void setTheme(ThemeVariantsEnum theme) {
    state = ThemePreferences(theme: theme, font: state.font);
    _storage.write(_themeKey, theme.name);
  }

  /// 🌓 Toggle light ↔ dark (залишає AMOLED поза циклом — як і було)
  void toggleTheme() {
    final isCurrentlyDark = state.theme.isDark;
    final nextTheme = isCurrentlyDark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    setTheme(nextTheme);
  }

  /// 🌓 Опційно: циклічне перемикання light → dark → amoled → light
  void toggleThemeCycled() {
    setTheme(_cycleThemeVariant(state.theme));
  }

  /// 🔤 Update font only
  void setFont(AppFontFamily font) {
    state = ThemePreferences(theme: state.theme, font: font);
    _storage.write(_fontKey, font.name);
  }

  /// 🧩 Update both at once
  void setThemeAndFont(ThemeVariantsEnum theme, AppFontFamily font) {
    state = ThemePreferences(theme: theme, font: font);
    _storage
      ..write(_themeKey, theme.name)
      ..write(_fontKey, font.name);
  }

  ///
  ThemeVariantsEnum _cycleThemeVariant(ThemeVariantsEnum t) => switch (t) {
    ThemeVariantsEnum.light => ThemeVariantsEnum.dark,
    ThemeVariantsEnum.dark => ThemeVariantsEnum.amoled,
    ThemeVariantsEnum.amoled => ThemeVariantsEnum.light,
  };

  //
}
