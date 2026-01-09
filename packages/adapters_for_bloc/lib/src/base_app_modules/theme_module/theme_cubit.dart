import 'package:hydrated_bloc/hydrated_bloc.dart' show HydratedCubit;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppFontFamily, ThemePreferences, ThemeVariantsEnum, parseAppFontFamily;

/// 🎨 [AppThemeCubit] — manages [ThemePreferences] (theme variant + font)
/// ✅ Uses [HydratedCubit] for state persistence
//
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

  /// 💾 Serialize state to JSON
  @override
  Map<String, dynamic>? toJson(ThemePreferences state) {
    // HydratedCubit's API requires Map<String, dynamic>
    return <String, dynamic>{
      'theme': state.theme.name,
      'font': state.font.name,
    };
  }

  /// 💾 Deserialize state from JSON (з безпечним дефолтом)
  @override
  ThemePreferences? fromJson(Map<String, dynamic> json) {
    final Object? themeRaw = json['theme'];
    final Object? fontRaw = json['font'];
    //
    ThemeVariantsEnum parseTheme(Object? v) {
      final name = v is String ? v : v?.toString();
      for (final e in ThemeVariantsEnum.values) {
        if (e.name == name) return e;
      }
      return ThemeVariantsEnum.light; // default
    }

    final theme = parseTheme(themeRaw);
    final font = parseAppFontFamily(fontRaw?.toString());
    //
    return ThemePreferences(theme: theme, font: font);
  }

  /// 🔁 Toggle light ↔ dark (як було)
  void toggleTheme() {
    final next = state.theme == ThemeVariantsEnum.dark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    emit(state.copyWith(theme: next));
  }

  /// 🔁 Optional: cycle toggle light → dark → amoled → light
  void toggleThemeCycled() {
    emit(state.copyWith(theme: _cycleThemeVariant(state.theme)));
  }

  ThemeVariantsEnum _cycleThemeVariant(ThemeVariantsEnum t) => switch (t) {
    ThemeVariantsEnum.light => ThemeVariantsEnum.dark,
    ThemeVariantsEnum.dark => ThemeVariantsEnum.amoled,
    ThemeVariantsEnum.amoled => ThemeVariantsEnum.light,
  };

  //
}
