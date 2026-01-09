import 'package:flutter/material.dart'
    show IconData, TargetPlatform, VoidCallback, Widget;
import 'package:shared_core_modules/src/animations/module_core/animation__engine.dart';
import 'package:shared_core_modules/src/overlays/core/enums_for_overlay_module.dart';
import 'package:shared_core_modules/src/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/android/android_banner.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/android/android_dialog.dart'
    show AndroidDialog;
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/android/android_snackbar.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/ios/ios_banner.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/ios/ios_dialog.dart';
import 'package:shared_core_modules/src/overlays/overlays_presentation/widgets/ios/ios_snackbar.dart';

/// 🧭📱 [PlatformMapper] — Resolves platform-specific overlay components
/// based on platform and [ShowAs] intention (dialog/snackbar/banner).
/// Used internally by [OverlayDispatcher] system.
//
abstract final class PlatformMapper {
  ///-----------------------------
  PlatformMapper._();

  ///
  static Widget resolveAppDialog({
    required TargetPlatform platform,
    required AnimationEngine engine,
    required String title,
    required String content,
    required String confirmText,
    required String cancelText,
    required VoidCallback? onConfirm,
    required VoidCallback? onCancel,
    required OverlayUIPresetProps presetProps,
    required bool isInfoDialog,
    required bool isFromUserFlow,
  }) {
    //
    return switch (platform) {
      TargetPlatform.iOS => IOSAppDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        presetProps: presetProps,
        isInfoDialog: isInfoDialog,
        isFromUserFlow: isFromUserFlow,
        engine: engine,
      ),

      TargetPlatform.android => AndroidDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        presetProps: presetProps,
        isInfoDialog: isInfoDialog,
        isFromUserFlow: isFromUserFlow,
        engine: engine,
      ),

      _ => IOSAppDialog(
        title: title,
        content: content,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
        presetProps: presetProps,
        isInfoDialog: isInfoDialog,
        isFromUserFlow: isFromUserFlow,
        engine: engine,
      ),
    };
    //
  }

  ////

  /// 🪧 Resolves banner per platform
  static Widget resolveAppBanner({
    required TargetPlatform platform,
    required AnimationEngine engine,
    required String message,
    required IconData icon,
    required OverlayUIPresetProps presetProps,
  }) {
    ///
    return switch (platform) {
      TargetPlatform.iOS => IOSBanner(
        message: message,
        icon: icon,
        engine: engine,
        props: presetProps,
      ),

      TargetPlatform.android => AndroidBanner(
        message: message,
        icon: icon,
        props: presetProps,
        engine: engine,
      ),

      _ => IOSBanner(
        message: message,
        icon: icon,
        engine: engine,
        props: presetProps,
      ),
    };
    //
  }

  ////

  ///  🪧 Resolves snackbar per platform
  static Widget resolveAppSnackbar({
    required TargetPlatform platform,
    required AnimationEngine engine,
    required String message,
    required IconData icon,
    required OverlayUIPresetProps presetProps,
  }) {
    ///
    return switch (platform) {
      TargetPlatform.iOS => IOSToastBubble(
        message: message,
        icon: icon,
        engine: engine,
        props: presetProps,
      ),

      TargetPlatform.android => AndroidSnackbarCard(
        message: message,
        icon: icon,
        engine: engine,
        props: presetProps,
      ),

      _ => IOSToastBubble(
        message: message,
        icon: icon,
        engine: engine,
        props: presetProps,
      ),
    };
    //
  }

  //
}
