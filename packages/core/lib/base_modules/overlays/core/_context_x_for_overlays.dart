import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_entity.dart';
import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/overlays/core/_overlay_base_methods.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart';
import 'package:core/base_modules/overlays/overlays_presentation/overlay_presets/overlay_presets.dart';
import 'package:flutter/material.dart';
import 'package:specific_for_bloc/di_container_on_get_it/core/di.dart';

/// 🎯 [ContextXForOverlays] — Unified extension for overlay DSL and dispatcher access
/// ✅ Use `context.showSnackbar(...)` / `context.showBanner(...)` directly
//
extension ContextXForOverlays on BuildContext {
  ///----------------------------------------
  //
  /// 🔌 Lazily access the shared [OverlayDispatcher] via DI container
  // OverlayDispatcher get dispatcher => readDI(overlayDispatcherProvider);
  OverlayDispatcher get dispatcher => di<OverlayDispatcher>();
  //

  /// 🧠 Handles displaying [FailureUIEntity] as banner/snackbar/dialog
  /// 📌 Uses [OverlayUIPresets] and [ShowAs] to configure appearance and behavior
  void showError(
    FailureUIEntity model, {
    ShowAs showAs = ShowAs.infoDialog,
    OverlayUIPresets preset = const OverlayErrorUIPreset(),
    bool isDismissible = false,
    OverlayPriority priority = OverlayPriority.high,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    String? confirmText,
    String? cancelText,
  }) {
    //
    ///
    switch (showAs) {
      case ShowAs.banner:
        showBanner(
          message: model.localizedMessage,
          icon: model.icon,
          preset: preset,
          isError: true,
          isDismissible: isDismissible,
          priority: priority,
        );
      //
      case ShowAs.snackbar:
        showSnackbar(
          message: model.localizedMessage,
          preset: preset,
          isError: true,
          icon: model.icon,
          isDismissible: isDismissible,
          priority: priority,
        );
      //
      case ShowAs.dialog:
        showAppDialog(
          title: AppLocalizer.translateSafely(LocaleKeys.errors_error_dialog),
          content: model.localizedMessage,
          confirmText:
              confirmText ??
              AppLocalizer.translateSafely(LocaleKeys.buttons_ok),
          cancelText:
              cancelText ??
              AppLocalizer.translateSafely(LocaleKeys.buttons_cancel),
          onConfirm: onConfirm,
          onCancel: onCancel,
          preset: preset,
          isError: true,
          isDismissible: isDismissible,
          priority: priority,
        );
      //
      case ShowAs.infoDialog:
        showAppDialog(
          isInfoDialog: true,
          title: AppLocalizer.translateSafely(LocaleKeys.errors_error_dialog),
          content: model.localizedMessage,
          confirmText: AppLocalizer.translateSafely(LocaleKeys.buttons_ok),
          cancelText: AppLocalizer.translateSafely(LocaleKeys.buttons_cancel),
          onConfirm: onConfirm,
          onCancel: onCancel,
          preset: preset,
          isDismissible: isDismissible,
          priority: priority,
        );
      //
    }
  }

  ////

  /// 💬 Shows a platform-adaptive dialog manually triggered by user
  void showUserDialog({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    bool isDismissible = true,
    bool isInfoDialog = false,
  }) {
    showAppDialog(
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      preset: preset,
      isDismissible: isDismissible,
      isInfoDialog: isInfoDialog,
      priority: OverlayPriority.userDriven,
    );
  }

  ////

  /// 🪧 Shows a banner overlay triggered manually by user
  void showUserBanner({
    required String message,
    IconData? icon,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    bool isDismissible = true,
  }) {
    showBanner(
      message: message,
      icon: icon,
      preset: preset,
      isDismissible: isDismissible,
      priority: OverlayPriority.userDriven,
    );
  }

  ////

  /// 💬 Shows a platform-adaptive snackbar manually triggered by user
  void showUserSnackbar({
    required String message,
    IconData? icon,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    OverlayPriority priority = OverlayPriority.userDriven,
  }) {
    showSnackbar(
      message: message,
      icon: icon,
      preset: preset,
      priority: priority,
    );
  }

  //
}
