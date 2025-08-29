import 'package:core/base_modules/theme/module_core/app_theme_preferences.dart';
import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:core/base_modules/theme/text_theme/text_theme_factory.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

/// 🎨 [AppThemeCubit] — manages [ThemePreferences] (theme variant + font)
/// ✅ Uses [HydratedCubit] for state persistence
final class AppThemeCubit extends HydratedCubit<ThemePreferences> {
  ///---------------------------------------------------------
  AppThemeCubit()
    : super(
        const ThemePreferences(
          theme: ThemeVariantsEnum.light,
          font: AppFontFamily.inter,
        ),
      );

  /// 🌓 Update theme only
  void setTheme(ThemeVariantsEnum theme) => emit(state.copyWith(theme: theme));

  /// 🔤 Update font only
  void setFont(AppFontFamily font) => emit(state.copyWith(font: font));

  /// 🧩 Update both theme and font
  void setThemeAndFont(ThemeVariantsEnum theme, AppFontFamily font) =>
      emit(ThemePreferences(theme: theme, font: font));

  /// 💾 Serialize state to JSON for persistence
  @override
  Map<String, dynamic>? toJson(ThemePreferences state) {
    return {'theme': state.theme.name, 'font': state.font.name};
  }

  /// 💾 Deserialize state from JSON (with legacy migration for 'sfPro')
  @override
  ThemePreferences? fromJson(Map<String, dynamic> json) {
    try {
      final theme = ThemeVariantsEnum.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => ThemeVariantsEnum.light,
      );
      final font = _parseFont(json['font']?.toString());
      return ThemePreferences(theme: theme, font: font);
    } on Exception {
      return const ThemePreferences(
        theme: ThemeVariantsEnum.light,
        font: AppFontFamily.inter,
      );
    }
  }

  /// 🔁 Legacy-safe parser for stored font names
  static AppFontFamily _parseFont(String? raw) {
    switch (raw) {
      case 'sfPro': // legacy
        return AppFontFamily.inter;
      case 'inter':
      case 'Inter':
        return AppFontFamily.inter;
      case 'montserrat':
      case 'Montserrat':
        return AppFontFamily.montserrat;
      default:
        return AppFontFamily.inter;
    }
  }

  /// 🔁 Toggle
  void toggleTheme() {
    final next = state.theme == ThemeVariantsEnum.dark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    emit(state.copyWith(theme: next));
  }

  //
}
