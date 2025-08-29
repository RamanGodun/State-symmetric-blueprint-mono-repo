import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

part 'font_family_enum.dart';
part 'font_parser.dart';

/// 🧩 [TextThemeFactory] — Entry point for accessing themed [TextTheme] & [CupertinoTextThemeData]
/// ✅ Centralized typography resolver used across both Material & Cupertino widgets
/// * Currently: Inter = primary (body/labels/titles), Montserrat = accent (display/headlines)
//
abstract final class TextThemeFactory {
  ///────────────────────────────

  /// 🎨Build Material [TextTheme] with optional primary/accent fonts.
  ///   - [font]        — base family (defaults to Inter)
  ///   - [accentFont]  — headings/accent family (defaults to Montserrat)
  static TextTheme from(
    ColorScheme colorScheme, {
    AppFontFamily? font,
    AppFontFamily? accentFont,
  }) {
    //
    final color = colorScheme.onSurface;

    /// Primary family (body, labels, most titles) — Inter by default
    final primary = (font ?? AppFontFamily.inter).value;

    /// Accent family (display + headline [+ optionally titleLarge]) — Montserrat
    final accent = (accentFont ?? AppFontFamily.montserrat).value;

    /// 🧱  Builds individual [TextTheme]
    TextStyle t(Color c, FontWeight w, double s, String f) =>
        TextStyle(fontFamily: f, fontWeight: w, fontSize: s, color: c);

    ////

    return TextTheme(
      // DISPLAY — accent (Montserrat)
      displayLarge: t(color, FontWeight.w300, 57, accent),
      displayMedium: t(color, FontWeight.w300, 45, accent),
      displaySmall: t(color, FontWeight.w400, 36, accent),

      // HEADLINE — accent (Montserrat)
      headlineLarge: t(color, FontWeight.w400, 32, accent),
      headlineMedium: t(color, FontWeight.w500, 28, accent),
      headlineSmall: t(color, FontWeight.w600, 24, accent),

      // TITLE — mix: large = accent, medium/small = primary
      titleLarge: t(color, FontWeight.w600, 22, accent),
      titleMedium: t(color, FontWeight.w500, 16, primary),
      titleSmall: t(color, FontWeight.w500, 14, primary),

      // BODY — primary (Inter)
      bodyLarge: t(color, FontWeight.w400, 16, primary),
      bodyMedium: t(color, FontWeight.w400, 14, primary),
      bodySmall: t(color, FontWeight.w400, 12, primary),

      // LABEL — primary (Inter)
      labelLarge: t(color, FontWeight.w600, 14, primary),
      labelMedium: t(color, FontWeight.w500, 12, primary),
      labelSmall: t(color, FontWeight.w500, 11, primary),
    );
  }

  //
}
