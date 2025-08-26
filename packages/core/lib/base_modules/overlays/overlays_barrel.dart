/// 🎪 Overlays Module — barrel exports
// ignore_for_file: combinators_ordering, directives_ordering
library;

//
// ─── HIGH-LEVEL CONTEXT API ───────────────────────────────────────────────────
//
export 'core/_context_x_for_overlays.dart' show ContextXForOverlays;

//
// ─── LOW-LEVEL METHODS (optional direct control) ──────────────────────────────
//
export 'core/_overlay_base_methods.dart' show OverlayBaseMethods;

//
// ─── CORE ENUMS & TYPES ───────────────────────────────────────────────────────
//
export 'core/enums_for_overlay_module.dart'
    show
        OverlayPriority,
        OverlayCategory,
        OverlayDismissPolicy,
        OverlayReplacePolicy,
        ShowAs,
        OverlayBlurLevel;

//
// ─── GLOBAL HANDLER (tap to dismiss keyboard/overlays) ────────────────────────
//
export 'core/global_overlay_handler.dart' show GlobalOverlayHandler;

//
// ─── DISPATCHER (queueing, conflicts, lifecycle) ──────────────────────────────
//
export 'overlays_dispatcher/overlay_dispatcher.dart' show OverlayDispatcher;

//
// ─── NAVIGATION OBSERVER (auto-clean overlays on route change) ───────────────
//
export 'utils/overlays_cleaner_within_navigation.dart'
    show OverlaysCleanerWithinNavigation;

//
// ─── PRESETS & PROPS (styling for banners/snackbars/dialogs) ─────────────────
//
export 'overlays_presentation/overlay_presets/overlay_presets.dart'
    show
        OverlayUIPresets,
        OverlayInfoUIPreset,
        OverlayErrorUIPreset,
        OverlaySuccessUIPreset,
        OverlayWarningUIPreset,
        OverlayConfirmUIPreset;

export 'overlays_presentation/overlay_presets/overlay_preset_props.dart'
    show OverlayUIPresetProps;

//
// ─── UTILS ────────────────────────────────────────────────────────────────────
//
export 'utils/overlay_utils.dart' show OverlayUtils;

// NOTE:
// - Platform-specific widgets (Android/iOS) and overlay entry classes/registry
//   are intentionally NOT exported — they are internal implementation details.
// - Use the context extensions + presets for the public API.
