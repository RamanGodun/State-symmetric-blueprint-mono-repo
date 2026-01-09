// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:shared_core_modules/src/ui_design/text_theme/text_theme_factory.dart';
import 'package:shared_core_modules/src/ui_design/ui_constants/_app_constants.dart';
import 'package:shared_core_modules/src/ui_design/ui_constants/app_colors.dart';
import 'package:shared_utils/shared_utils.dart' show AppDurations;

part 'theme_builder_x.dart';

/// 🎨 [ThemeVariantsEnum] — Enhanced enum that defines full theme variants
/// ✅ Used to generate [ThemeData] dynamically
//
enum ThemeVariantsEnum {
  ///-----------------

  light(
    brightness: Brightness.light,
    background: AppColors.lightBackground,
    primaryColor: AppColors.lightPrimary,
    cardColor: AppColors.lightOverlay,
    contrastColor: AppColors.black,
    colorScheme: ColorScheme.light(
      primary: AppColors.lightPrimary,
      secondary: AppColors.lightAccent,
      surface: AppColors.lightBackground,
      error: AppColors.forErrors,
    ),
    // font: AppFontFamily.someFont,
  ),

  ///
  dark(
    brightness: Brightness.dark,
    background: AppColors.darkBackground,
    primaryColor: AppColors.darkPrimary,
    cardColor: AppColors.darkGlassBackground,
    contrastColor: AppColors.white,
    colorScheme: ColorScheme.dark(
      primary: AppColors.darkPrimary,
      secondary: AppColors.darkAccent,
      surface: AppColors.darkBackground,
      onPrimary: AppColors.white,
      onSecondary: AppColors.white,
      error: AppColors.forErrors,
    ),
    // font: AppFontFamily.someFont,
  ),

  ///
  amoled(
    brightness: Brightness.dark,
    background: AppColors.amoledBackground,
    primaryColor: AppColors.amoledPrimary,
    cardColor: AppColors.amoledCard,
    contrastColor: AppColors.white,
    colorScheme: ColorScheme.dark(
      primary: AppColors.amoledPrimary,
      secondary: AppColors.amoledAccent,
      surface: AppColors.amoledSurface,
      onPrimary: AppColors.amoledOnPrimary,
      onSecondary: AppColors.amoledOnSecondary,
      onSurface: AppColors.amoledOnSurface,
      error: AppColors.forErrors,
      outline: AppColors.amoledOutline,
    ),
    // font: AppFontFamily.someFont,
  )
  ;

  ///
  const ThemeVariantsEnum({
    required this.brightness,
    required this.background,
    required this.primaryColor,
    required this.cardColor,
    required this.contrastColor,
    required this.colorScheme,
    // required this.font,
  });

  final Brightness brightness;
  final Color background;
  final Color primaryColor;
  final Color cardColor;
  final Color contrastColor;
  final ColorScheme colorScheme;
  // final AppFontFamily font;
  //

  /// 🔘 True getter if dark theme
  bool get isDark => brightness == Brightness.dark;

  /// 🌓 Converts to [ThemeMode]
  ThemeMode get themeMode => isDark ? ThemeMode.dark : ThemeMode.light;

  /// 🔤 Selected font family
  // AppFontFamily get defaultFont => AppFontFamily.someFont;

  //
}
