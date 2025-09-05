import 'package:core/base_modules/ui_design.dart'
    show AppFontFamily, ThemePreferences, ThemeVariantsEnum, parseAppFontFamily;
import 'package:hydrated_bloc/hydrated_bloc.dart';

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
    return {'theme': state.theme.name, 'font': state.font.name};
  }

  /// 💾 Deserialize state from JSON (з безпечним дефолтом)
  @override
  ThemePreferences? fromJson(Map<String, dynamic> json) {
    try {
      final theme = ThemeVariantsEnum.values.firstWhere(
        (e) => e.name == json['theme'],
        orElse: () => ThemeVariantsEnum.light,
      );
      final font = parseAppFontFamily(
        json['font']?.toString(),
      ); // ⟵ спільний парсер
      return ThemePreferences(theme: theme, font: font);
    } on Exception catch (_) {
      // «soft» recovery
      return const ThemePreferences(
        theme: ThemeVariantsEnum.light,
        font: AppFontFamily.inter,
      );
    }
  }

  /// 🔁 Toggle light ↔ dark (як було)
  void toggleTheme() {
    final next = state.theme == ThemeVariantsEnum.dark
        ? ThemeVariantsEnum.light
        : ThemeVariantsEnum.dark;
    emit(state.copyWith(theme: next));
  }

  /// 🔁 Опційно: циклічний toggle light → dark → amoled → light
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
