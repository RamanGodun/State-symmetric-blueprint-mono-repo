/*

// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'dart:async';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/theme/ui_constants/app_colors.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
// import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:core/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';

part 'overlay_widget.dart';

/// 🌟 [OverlayNotificationService] — macOS-style overlay (snackbar replacement)
/// 🧼 Shows a floating, styled, animated banner for temporary notifications
//
final class OverlayNotificationService {
  ///-----------------------------
  OverlayNotificationService._();
  //
  static OverlayEntry? _overlayEntry;
  static bool _isShowing = false;

  /// 📌 Public method, shows a transient overlay with [message] and [icon]
  static void showOverlay(
    BuildContext context, {
    required String message,
    required IconData icon,
    OverlayPosition position = OverlayPosition.center,
    Duration duration = AppDurations.sec2,
  }) {
    //
    final overlay = Overlay.of(context, rootOverlay: true);

    showOverlayViaOverlay(
      overlay,
      message: message,
      icon: icon,
      position: position,
      duration: duration,
    );
  }

  /// 🔧 Technical realization, take OverlayState
  static void showOverlayViaOverlay(
    OverlayState overlay, {
    required String message,
    required IconData icon,
    OverlayPosition position = OverlayPosition.center,
    Duration duration = AppDurations.sec2,
  }) {
    //
    if (_isShowing) return;
    _isShowing = true;

    _removeOverlay();

    _overlayEntry = OverlayEntry(
      builder:
          (_) => _AnimatedOverlayWidget(
            message: message,
            icon: icon,
            position: position,
          ),
    );

    overlay.insert(_overlayEntry!);

    Future.delayed(duration, () {
      _removeOverlay();
      _isShowing = false;
    });
  }

  /// 🧹 Removes any currently visible overlay
  static void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// 🎯 Shorthands for predefined styles
  static void success(BuildContext context, String message) =>
      showOverlay(context, message: message, icon: Icons.check_circle);

  static void error(BuildContext context, String message) =>
      showOverlay(context, message: message, icon: Icons.error);

  static void info(BuildContext context, String message) =>
      showOverlay(context, message: message, icon: Icons.info);

  //
}

////
////

enum OverlayPosition { top, center, bottom }



 */
