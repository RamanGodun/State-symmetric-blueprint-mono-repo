import 'package:flutter/material.dart'
    show
        BorderRadius,
        Color,
        Colors,
        EdgeInsets,
        IconData,
        Icons,
        Radius,
        RoundedRectangleBorder,
        ShapeBorder,
        SnackBarBehavior,
        immutable;
import 'package:shared_core_modules/src/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart'
    show OverlayUIPresetProps;
import 'package:shared_utils/public_api/general_utils.dart' show AppDurations;

/// 🎨 [OverlayUIPresets] — Abstract base for UI styling presets
/// - Returns resolved [OverlayUIPresetProps] used by overlays (banners, dialogs, etc.)
/// - Presets are immutable, optimized, and support `.withOverride(...)`
//
@immutable
sealed class OverlayUIPresets {
  ///-------------------------
  const OverlayUIPresets();
  //

  /// 🎨 Resolves the current preset to styling props
  OverlayUIPresetProps resolve();

  /// 🧪 Creates a new customized preset by overriding selected fields
  OverlayUIPresets withOverride({
    IconData? icon,
    Color? color,
    Duration? duration,
    EdgeInsets? margin,
    ShapeBorder? shape,
    EdgeInsets? contentPadding,
    SnackBarBehavior? behavior,
  }) {
    return _OverlayCustomPreset(
      resolve().copyWith(
        icon: icon,
        color: color,
        duration: duration,
        margin: margin,
        shape: shape,
        contentPadding: contentPadding,
        behavior: behavior,
      ),
    );
  }
}

////
////
////

// ─────────────────────────────────────────────────────────────────────────────
// ✅ Built-in Presets (Memoized)
// ─────────────────────────────────────────────────────────────────────────────

/// ℹ️ [OverlayInfoUIPreset] — Blue info-style preset (default for neutral overlays)
/// - Used for non-blocking informational banners/snackbars
//
final class OverlayInfoUIPreset extends OverlayUIPresets {
  ///--------------------------------------------------
  const OverlayInfoUIPreset();

  static const OverlayUIPresetProps _resolved = OverlayUIPresetProps(
    icon: Icons.info_outline,
    color: Colors.blueAccent,
    duration: AppDurations.sec3,
    margin: EdgeInsets.all(12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(6)),
    ),
    contentPadding: EdgeInsets.all(14),
    behavior: SnackBarBehavior.floating,
  );

  @override
  OverlayUIPresetProps resolve() => _resolved;
  //
}

////
////

/// ❌ [OverlayErrorUIPreset] — Red error preset
/// - Used for critical errors or validation messages
//
final class OverlayErrorUIPreset extends OverlayUIPresets {
  ///---------------------------------------------------
  const OverlayErrorUIPreset();

  static const _resolved = OverlayUIPresetProps(
    icon: Icons.error_outline,
    color: Colors.redAccent,
    duration: AppDurations.sec3,
    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    behavior: SnackBarBehavior.floating,
  );

  @override
  OverlayUIPresetProps resolve() => _resolved;
  //
}

////
////

/// ✅ [OverlaySuccessUIPreset] — Green success confirmation
/// - Used for completion banners or confirmations
//
final class OverlaySuccessUIPreset extends OverlayUIPresets {
  ///-----------------------------------------------------
  const OverlaySuccessUIPreset();

  static const _resolved = OverlayUIPresetProps(
    icon: Icons.check_circle_outline,
    color: Colors.green,
    duration: AppDurations.sec2,
    margin: EdgeInsets.fromLTRB(16, 0, 16, 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(8)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    behavior: SnackBarBehavior.fixed,
  );

  @override
  OverlayUIPresetProps resolve() => _resolved;
  //
}

////
////

/// ⚠️ [OverlayWarningUIPreset] — Orange warning preset
/// - Used to alert the user without full blocking
//
final class OverlayWarningUIPreset extends OverlayUIPresets {
  ///-----------------------------------------------------
  const OverlayWarningUIPreset();

  static const _resolved = OverlayUIPresetProps(
    icon: Icons.warning_amber_rounded,
    color: Colors.orangeAccent,
    duration: AppDurations.sec4,
    margin: EdgeInsets.all(16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(10)),
    ),
    contentPadding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
    behavior: SnackBarBehavior.floating,
  );

  @override
  OverlayUIPresetProps resolve() => _resolved;
  //
}

////
////

/// ❓ [OverlayConfirmUIPreset] — Teal confirm dialog preset
/// - Used for confirmation dialogs (duration = 0, modal)
//
final class OverlayConfirmUIPreset extends OverlayUIPresets {
  ///-----------------------------------------------------
  const OverlayConfirmUIPreset();

  static const _resolved = OverlayUIPresetProps(
    icon: Icons.help_outline_rounded,
    color: Colors.teal,
    duration: Duration.zero,
    margin: EdgeInsets.symmetric(horizontal: 24, vertical: 20),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    contentPadding: EdgeInsets.all(16),
    behavior: SnackBarBehavior.fixed,
  );

  @override
  OverlayUIPresetProps resolve() => _resolved;
  //
}

////
////

/// 🧪 [_OverlayCustomPreset] — Internal override-based preset
/// - Generated by `.withOverride(...)` for customized visuals
//
final class _OverlayCustomPreset extends OverlayUIPresets {
  const _OverlayCustomPreset(this._props);

  ///------------------------------------------------------
  //
  final OverlayUIPresetProps _props;

  @override
  OverlayUIPresetProps resolve() => _props;
  //
}
