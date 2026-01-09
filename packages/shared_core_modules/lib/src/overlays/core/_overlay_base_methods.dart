import 'dart:async' show unawaited;

import 'package:flutter/material.dart'
    show BuildContext, IconData, Icons, VoidCallback;
import 'package:shared_core_modules/public_api/base_modules/animations.dart'
    show AnimatedOverlayWrapper, OverlayAnimationEngineMapperX;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show AppLocalizer, CoreLocaleKeys;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show
        ContextXForOverlays,
        OverlayCategory,
        OverlayInfoUIPreset,
        OverlayPriority,
        OverlayUIPresets;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeXOnContext;
import 'package:shared_core_modules/src/overlays/core/platform_mapper.dart'
    show PlatformMapper;
import 'package:shared_core_modules/src/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher, OverlayPolicyResolver;
import 'package:shared_core_modules/src/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart'
    show
        BannerOverlayEntry,
        DialogOverlayEntry,
        OverlayUIEntry,
        SnackbarOverlayEntry;
import 'package:shared_utils/public_api/general_utils.dart' show AppDurations;

/// 🎯 [OverlayBaseMethods] — Unified extension for low-level overlay
///  rendering methods (showBanner, showDialog, showSnackbar)
//
extension OverlayBaseMethods on BuildContext {
  ///--------------------------------------

  /// 5️⃣  📥 Adds a new request to the [OverlayDispatcher]
  void addOverlayRequest(OverlayUIEntry entry) {
    unawaited(dispatcher.enqueueRequest(this, entry));
  }

  /// 💬 Shows a short platform-adaptive dialog (iOS/Android)
  void showAppDialog({
    required String title,
    required String content,
    String? confirmText,
    String? cancelText,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    bool isError = false,
    bool isDismissible = true,
    OverlayPriority priority = OverlayPriority.normal,
    bool isInfoDialog = false,
    Duration autoDismissDuration = Duration.zero,
  }) {
    //
    // 1️⃣ Get engine for dialog, based on platform
    final engine = getEngine(OverlayCategory.dialog);

    /// ✅ Localized defaults
    confirmText ??= AppLocalizer.translateSafely(CoreLocaleKeys.buttons_ok);
    cancelText ??= AppLocalizer.translateSafely(CoreLocaleKeys.buttons_cancel);

    // 2️⃣ Resolve platform-specific dialog widget
    final dialogWidget = PlatformMapper.resolveAppDialog(
      platform: platform,
      engine: engine,
      title: title,
      content: content,
      confirmText: confirmText,
      cancelText: cancelText,
      onConfirm: onConfirm,
      onCancel: onCancel,
      presetProps: preset.resolve(),
      isInfoDialog: isInfoDialog,
      isFromUserFlow: false,
    );

    // 3️⃣ Wrap with [AnimatedOverlayWrapper], that controls lifecycle and animation
    final animatedDialog = AnimatedOverlayWrapper(
      engine: engine,
      displayDuration: autoDismissDuration,
      builder: (_) => dialogWidget,
    );

    // 4️⃣ Create overlay entry
    final entry = DialogOverlayEntry(
      widget: animatedDialog,
      dismissPolicy: OverlayPolicyResolver.resolveDismissPolicy(
        isDismissible: isDismissible,
      ),
      isError: isError,
      priority: priority,
    );

    // 5️⃣  📥 Adds a new request to the queue
    addOverlayRequest(entry);
  }

  ///

  /// 🪧 Shows a platform-aware banner (iOS/Android) using optional preset
  void showBanner({
    required String message,
    IconData? icon,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    bool isError = false,
    bool isDismissible = true,
    Duration autoDismissDuration = AppDurations.sec3,
    OverlayPriority priority = OverlayPriority.normal,
  }) {
    //
    // 1️⃣ Get engine for banner based on platform
    final engine = getEngine(OverlayCategory.banner);

    // 2️⃣ Resolve platform-specific banner widget
    final bannerWidget = PlatformMapper.resolveAppBanner(
      platform: platform,
      engine: engine,
      message: message,
      icon: icon ?? Icons.info,
      presetProps: preset.resolve(),
    );

    // 3️⃣ Wrap with [AnimatedOverlayWrapper], that controls lifecycle and animation
    final animatedBanner = AnimatedOverlayWrapper(
      engine: engine,
      displayDuration: autoDismissDuration,
      builder: (_) => bannerWidget,
    );

    // 4️⃣ Create overlay entry
    final entry = BannerOverlayEntry(
      widget: animatedBanner,
      dismissPolicy: OverlayPolicyResolver.resolveDismissPolicy(
        isDismissible: isDismissible,
      ),
      isError: isError,
      priority: priority,
    );

    // 5️⃣  📥 Adds a new request to the queue
    addOverlayRequest(entry);
  }

  ///

  /// 🍞 Shows a platform-aware snackbar (iOS/Android) using optional preset
  void showSnackbar({
    required String message,
    IconData? icon,
    OverlayUIPresets preset = const OverlayInfoUIPreset(),
    bool isError = false,
    bool isDismissible = true,
    Duration autoDismissDuration = AppDurations.sec3,
    OverlayPriority priority = OverlayPriority.normal,
  }) {
    //
    // 1️⃣ Get engine for banner based on platform
    final engine = getEngine(OverlayCategory.snackbar);

    // 2️⃣ Resolve platform-specific banner widget
    final snackbarWidget = PlatformMapper.resolveAppSnackbar(
      platform: platform,
      engine: engine,
      message: message,
      icon: icon ?? Icons.info,
      presetProps: preset.resolve(),
    );

    // 3️⃣ Wrap with [AnimatedOverlayWrapper], that controls lifecycle and animation
    final animatedSnackbar = AnimatedOverlayWrapper(
      engine: engine,
      displayDuration: autoDismissDuration,
      builder: (_) => snackbarWidget,
    );

    // 4️⃣ Create overlay entry
    final entry = SnackbarOverlayEntry(
      widget: animatedSnackbar,
      dismissPolicy: OverlayPolicyResolver.resolveDismissPolicy(
        isDismissible: isDismissible,
      ),
      isError: isError,
      priority: priority,
    );

    // 5️⃣  📥 Adds a new request to the queue
    addOverlayRequest(entry);
  }

  //
}
