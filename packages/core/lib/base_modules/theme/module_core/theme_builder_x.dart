part of 'theme_variants.dart';

/// 🎨 [ThemeVariantX] — Extension for [ThemeVariantsEnum] to generate ThemeData.
///   - Provides a factory method for building fully customized [ThemeData]
///   - Applies design tokens, color schemes, and app-specific constants
///   - Centralizes all visual details for each theme variant
//
extension ThemeVariantX on ThemeVariantsEnum {
  ///--------------------------------------
  //
  /// 🔖 Quick check if the current variant is AMOLED
  bool get isAmoled => this == ThemeVariantsEnum.amoled;

  /// 🏗️ Builds [ThemeData] for the given [ThemeVariantsEnum] (light, dark, amoled).
  /// - Optionally injects a custom font via [AppFontFamily]
  /// - Uses design tokens and color scheme for visual consistency across the app
  /// - Configures app bars, buttons, cards, text styles, etc.
  //
  ThemeData build({AppFontFamily? font}) {
    //
    /// 🔤 Base text theme generated from factory
    final baseText = TextThemeFactory.from(
      colorScheme,
      font: font ?? AppFontFamily.inter, // Inter as base font
      accentFont: AppFontFamily.montserrat, // Montserrat as accent font
    );

    ///
    return ThemeData(
      //
      useMaterial3: true,

      /// 🎨 Core palette configuration
      brightness: brightness,
      scaffoldBackgroundColor: background,
      primaryColor: primaryColor,
      colorScheme: colorScheme.copyWith(
        // ✅ Normalize on* values if defined in palette
        onPrimary: colorScheme.onPrimary,
        onSecondary: colorScheme.onSecondary,
        onBackground: colorScheme.onBackground,
        onSurface: colorScheme.onSurface,
      ),

      /// 🧭 AppBar — minimalistic, transparent with custom text/icon colors
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: contrastColor,
        actionsIconTheme: IconThemeData(color: primaryColor),
        titleTextStyle: baseText.titleSmall,
        centerTitle: false,
      ),

      /// 🔘 Filled buttons — consistent style across themes
      /// AMOLED uses near-solid primary for glossy look
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: isAmoled
              ? colorScheme.primary.withOpacity(0.95)
              : colorScheme.primary.withOpacity(isDark ? 0.37 : 0.72),
          foregroundColor: colorScheme.onPrimary,
          disabledBackgroundColor: isAmoled
              ? const Color(0x24000000) // ~14% чорного
              : (isDark ? AppColors.white10 : AppColors.black12),
          disabledForegroundColor: AppColors.white24,
          surfaceTintColor: isAmoled
              ? Colors.transparent
              : AppColors.transparent,
          shadowColor: AppColors.shadow,
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.xm,
            horizontal: AppSpacing.xxxm,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: UIConstants.borderRadius8,
            side: BorderSide(
              color: isAmoled
                  ? AppColors.amoledOutline
                  : (isDark ? AppColors.black5 : AppColors.darkBorder),
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

      /// 🧱 Cards — unified radius, with AMOLED using deeper black
      cardTheme: CardThemeData(
        color: isAmoled ? AppColors.amoledCard : cardColor,
        shape: const RoundedRectangleBorder(
          borderRadius: UIConstants.commonBorderRadius,
        ),
        shadowColor: AppColors.shadow,
        elevation: 0,
      ),

      /// 🎯 Icon theme — slightly brighter on AMOLED for readability
      iconTheme: IconThemeData(
        color: isAmoled ? AppColors.amoledOnSurface : colorScheme.onSurface,
      ),

      /// ── Dividers — AMOLED gets stronger outline for better contrast
      dividerTheme: DividerThemeData(
        color: isAmoled
            ? AppColors.amoledOutline
            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
        thickness: 0.6,
        space: 0,
      ),

      /// 🅰️ Typography (generated via factory using current palette & font)
      textTheme: baseText,

      //
    );
  }

  //
}
