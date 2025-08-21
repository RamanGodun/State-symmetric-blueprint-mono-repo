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
          font: AppFontFamily.sfPro,
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

  ///
  void toggleTheme() {
    final newTheme = state.theme == ThemeVariantsEnum.dark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    emit(state.copyWith(theme: newTheme));
  }

  /// 💾 Deserialize state from JSON
  @override
  ThemePreferences? fromJson(Map<String, dynamic> json) {
    try {
      final theme = ThemeVariantsEnum.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => ThemeVariantsEnum.light,
      );
      final font = AppFontFamily.values.firstWhere(
        (e) => e.name == json['font'],
        orElse: () => AppFontFamily.sfPro,
      );
      return ThemePreferences(theme: theme, font: font);
    } on Object catch (_) {
      return null;
    }
  }
}
