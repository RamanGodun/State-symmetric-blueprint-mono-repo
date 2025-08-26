part of 'theme_variants.dart';

/// 🎨 [ThemeVariantX] — Extension for [ThemeVariantsEnum] to generate ThemeData.
///   - Provides a factory method for building fully customized [ThemeData]
///   - Applies design tokens, color schemes, and app-specific constants
///   - Centralizes all visual details for each theme variant
//
extension ThemeVariantX on ThemeVariantsEnum {
  ///--------------------------------------
  //
  /// 🏗️ Builds [ThemeData] for the given [ThemeVariantsEnum] (light, dark, amoled).
  /// - Optionally injects a custom font via [AppFontFamily]
  /// - Uses design tokens and color scheme for visual consistency across the app
  /// - Configures app bars, buttons, cards, text styles, etc.
  ThemeData build({AppFontFamily? font}) {
    return ThemeData(
      useMaterial3: true,

      /// Theme core palette
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primaryColor,
      colorScheme: colorScheme.copyWith(
        //normalization on* values, if set
        onPrimary: colorScheme.onPrimary,
        onSecondary: colorScheme.onSecondary,
        onBackground: colorScheme.onBackground,
        onSurface: colorScheme.onSurface,
      ),

      /// AppBar configuration: transparent, with custom text and icon colors
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: contrastColor,
        actionsIconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: TextThemeFactory.from(
          colorScheme,
          font: font,
        ).titleSmall,
        centerTitle: false,
      ),

      /// Buttons: consistent paddings, radius, elevation, and colors
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primary.withOpacity(
            isDark ? 0.37 : 0.72,
          ),
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: isDark
              ? AppColors.white10
              : AppColors.black12,
          disabledForegroundColor: AppColors.white24,
          surfaceTintColor: AppColors.transparent,
          shadowColor: AppColors.shadow,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xm,
            horizontal: AppSpacing.xxxm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadius8,
            side: BorderSide(
              color: isDark ? AppColors.black5 : AppColors.darkBorder,
              width: isDark ? 0.05 : 0.05,
            ),
          ),
          elevation: 0,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          animationDuration: AppDurations.ms250,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          alignment: Alignment.center,
          enableFeedback: true,
        ),
      ),

      /// Cards: unified radius, background, shadow
      cardTheme: CardThemeData(
        color: cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: UIConstants.commonBorderRadius,
        ),
        shadowColor: AppColors.shadow,
        elevation: 0,
      ),

      /// Typography: generated via factory using current palette & font
      textTheme: TextThemeFactory.from(
        colorScheme,
        font: font ?? AppFontFamily.inter, // Inter as base font
        accentFont: AppFontFamily.montserrat, // Montserrat as accent font
      ),
      //
    );
  }

  //
}
