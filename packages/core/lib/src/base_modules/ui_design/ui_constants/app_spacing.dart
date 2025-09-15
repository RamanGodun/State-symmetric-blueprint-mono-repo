// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

part of '_app_constants.dart';

/// 📏 [AppSpacing] — Centralized collection of spacing constants for layout.
///   Use these for all paddings, margins, gaps, and geometry in your app,
///   to ensure a consistent and visually balanced design system.
///   Grouped by semantic sizing: tiny → small → medium → large → extra large.
///   Always use these constants for layout instead of hardcoded numbers.
//
abstract final class AppSpacing {
  ///-------------------------
  const AppSpacing._();

  /// No space (used to explicitly reset padding/margin)
  static const double zero = 0;

  /// ───── Tiny / Small values ─────
  static const double s = 2;
  static const double xs = 4;
  static const double xxs = 6;
  static const double xxxs = 8;

  /// ───── Medium values ─────
  static const double m = 10;
  static const double xm = 12;
  static const double xxm = 15;
  static const double xxxm = 18;

  /// ───── Large values ─────
  static const double l = 30;
  static const double xl = 40;
  static const double xxl = 50;
  static const double xxxl = 65;
  static const double xxxxl = 85;

  /// ───── Special large values ─────
  static const double huge = 100;
  static const double massive = 120;
  static const double great = 150;

  /// ───── Utility/pixel-specific values (for precise control) ─────
  static const double p7 = 7;
  static const double p10 = 10;
  static const double p16 = 16;
  static const double p26 = 26;

  //
}
