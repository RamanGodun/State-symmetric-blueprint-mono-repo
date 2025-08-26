/// 🎬 Animations Module — centralized exports
/// Provides overlay & widget animations with platform-aware engines and
/// declarative extension methods for clean, reusable animation logic.
library;

// -----------------------------
// Core engines & contracts (export the LIBRARY, not its parts)
// -----------------------------
export 'module_core/animation__engine.dart'
    show AnimationEngine, BaseAnimationEngine, FallbackAnimationEngine;
export 'module_core/engine_configs.dart';

// -----------------------------
// Overlay animations
// -----------------------------
export 'overlays_animation/animation_wrapper/animated_overlay_shell.dart';
export 'overlays_animation/animation_wrapper/animated_overlay_wrapper.dart';
export 'overlays_animation/animation_wrapper/overlay_animation_x_for_widget.dart';

export 'overlays_animation/engine_mapper_x_on_context.dart';
export 'overlays_animation/overlays_animation_engines/android_animation_engine.dart';
export 'overlays_animation/overlays_animation_engines/ios_animation_engine.dart';

// -----------------------------
// Widget animations
// -----------------------------
export 'widget_animations/widget_animation_x.dart';
