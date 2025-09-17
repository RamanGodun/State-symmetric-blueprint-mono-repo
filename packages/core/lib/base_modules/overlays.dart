/// 🎪 Overlays Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── HIGH-LEVEL CONTEXT API ───────────────────────────────────────────────────
//
export '../src/base_modules/overlays/core/_context_x_for_overlays.dart'
    show ContextXForOverlays;
//
// ─── LOW-LEVEL METHODS (optional direct control) ──────────────────────────────
//
export '../src/base_modules/overlays/core/_overlay_base_methods.dart'
    show OverlayBaseMethods;
//
// ─── CORE ENUMS & TYPES ───────────────────────────────────────────────────────
//
export '../src/base_modules/overlays/core/enums_for_overlay_module.dart';
//
// ─── GLOBAL HANDLER (tap to dismiss keyboard/overlays) ────────────────────────
//
export '../src/base_modules/overlays/core/global_overlay_handler.dart'
    show GlobalOverlayHandler;
//
// ─── DISPATCHER (queueing, conflicts, lifecycle) ──────────────────────────────
//
export '../src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart'
    show OverlayDispatcher;
export '../src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart'
    show OverlayUIPresetProps;
//
// ─── PRESETS & PROPS (styling for banners/snackbars/dialogs) ─────────────────
//
export '../src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_presets.dart'
    show
        OverlayUIPresets,
        OverlayInfoUIPreset,
        OverlayErrorUIPreset,
        OverlaySuccessUIPreset,
        OverlayWarningUIPreset,
        OverlayConfirmUIPreset;
//
// ─── UTILS ────────────────────────────────────────────────────────────────────
//
export '../src/base_modules/overlays/utils/overlay_utils.dart'
    show OverlayUtils;
//
// ─── NAVIGATION UTILS ------------------------------------------───────────────
//
export '../src/base_modules/overlays/utils/overlays_cleaner_within_navigation.dart'
    show OverlaysCleanerWithinNavigation;
export '../src/base_modules/overlays/utils/ports/overlay_activity_port.dart';
export '../src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart';
export '../src/base_modules/overlays/utils/show_overlay_after_frame_x_on_context.dart';

// NOTE:
// - Platform-specific widgets (Android/iOS) and overlay entry classes/registry
//   are intentionally NOT exported — they are internal implementation details.
// - Use the context extensions + presets for the public API.
