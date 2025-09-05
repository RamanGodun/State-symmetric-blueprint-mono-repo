import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';
import 'package:flutter/material.dart' show Border, BorderSide, BoxDecoration;

part 'android_card_bd.dart';
part 'android_dialog_bd.dart';
part 'ios_buttons_bd.dart';
part 'ios_card_bd.dart';
part 'ios_dialog_bd.dart';

/// 🧬 [BoxDecorationFactory] — Centralized entry point for theme-based [BoxDecoration]
/// 📦 Provides access to iOS/Android-specific box decorations
/// Used across overlay components and modals
//
sealed class BoxDecorationFactory {
  /// ────────────────────────────
  const BoxDecorationFactory._();
  //

  /// 🍏 iOS banner (glassmorphism)
  static BoxDecoration iosCard({required bool isDark}) =>
      IOSCardsDecoration.fromTheme(isDark: isDark);

  /// 🍏 iOS dialog (glassmorphism)
  static BoxDecoration iosDialog({required bool isDark}) =>
      IOSDialogsDecoration.fromTheme(isDark: isDark);

  /// 🤖 Android dialog (Material 3)
  static BoxDecoration androidDialog({required bool isDark}) =>
      AndroidDialogsDecoration.fromTheme(isDark: isDark);

  /// 🍞 Android snackbar
  static BoxDecoration androidCard({required bool isDark}) =>
      AndroidCardsDecoration.fromTheme(isDark: isDark);

  //
}
