import 'package:core/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/base_modules/animations/module_core/engine_configs.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';

/// 🌟 [AndroidOverlayAnimationEngine] — unified animation engine for all Android overlays
/// ✅ Centralized engine supporting dialog, banner, snackbar animations via [ShowAs] config
//
final class AndroidOverlayAnimationEngine extends BaseAnimationEngine {
  ///----------------------------------------------------------------
  /// 🏗️ Constructor, that initializes config from type
  AndroidOverlayAnimationEngine(this.overlayType)
    : _config = _resolveConfig(overlayType);
  //
  /// 🧩 Overlay type used to resolve animation config
  final ShowAs overlayType;
  // ⚙️ Resolved animation config based on [overlayType]
  final AndroidOverlayAnimationConfig _config;
  // 💫 Opacity animation
  late final Animation<double> _opacity;
  // 🔍 Scale animation
  late final Animation<double> _scale;
  // ↕ Slide animation (nullable)
  Animation<Offset>? _slide;

  /// 🧠 Resolves preset animation configuration based on [ShowAs]
  static AndroidOverlayAnimationConfig _resolveConfig(ShowAs type) {
    return switch (type) {
      //
      ShowAs.banner => const AndroidOverlayAnimationConfig(
        duration: AppDurations.ms400,
        fastDuration: AppDurations.ms150,
        opacityCurve: Curves.easeOut,
        scaleBegin: 0.98,
        scaleCurve: Curves.decelerate,
        slideCurve: Curves.easeOut,
        slideOffset: Offset(0, -0.06),
      ),

      ShowAs.snackbar => const AndroidOverlayAnimationConfig(
        duration: AppDurations.ms400,
        fastDuration: AppDurations.ms150,
        opacityCurve: Curves.easeInOut,
        scaleBegin: 0.96,
        scaleCurve: Curves.easeOut,
        slideCurve: Curves.easeOut,
        slideOffset: Offset(0, 0.1),
      ),

      ShowAs.dialog || ShowAs.infoDialog => const AndroidOverlayAnimationConfig(
        duration: AppDurations.ms400,
        fastDuration: AppDurations.ms150,
        opacityCurve: Curves.easeOut,
        scaleBegin: 0.95,
        scaleCurve: Curves.easeOut,
        slideCurve: Curves.easeOut,
        slideOffset: Offset(0, 0.12),
      ),
    };
  }

  /// ⏱️ Default animation duration
  @override
  Duration get defaultDuration => _config.duration;

  /// ⏩ Fast reverse duration (e.g. for dismiss)
  @override
  Duration get fastReverseDuration => _config.fastDuration;

  /// ⚙️ Sets up tweens for all animations
  @override
  void setupAnimations() {
    _opacity = Tween<double>(
      begin: 0,
      end: 1,
    ).chain(CurveTween(curve: _config.opacityCurve)).animate(controller);

    _scale = Tween<double>(
      begin: _config.scaleBegin,
      end: 1,
    ).chain(CurveTween(curve: _config.scaleCurve)).animate(controller);

    if (_config.slideOffset != null && _config.slideCurve != null) {
      _slide = Tween(
        begin: _config.slideOffset,
        end: Offset.zero,
      ).chain(CurveTween(curve: _config.slideCurve!)).animate(controller);
    }
  }

  /// 🌫️ Fade transition animation
  @override
  Animation<double> get opacity => _opacity;

  /// 🔍 Scale transition animation
  @override
  Animation<double> get scale => _scale;

  /// ↕ Slide transition animation (nullable)
  @override
  Animation<Offset>? get slide => _slide;

  //
}
