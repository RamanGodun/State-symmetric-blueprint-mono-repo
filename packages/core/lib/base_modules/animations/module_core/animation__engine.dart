import 'package:core/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';

part 'animation_base_engine.dart';
part 'fallback_engine.dart';

/// 🎯 [AnimationEngine] — base class for platform-specific dialog animations
/// ✅ Used in overlays to drive platform-native transitions
/// ✅ Provides core animation lifecycle and properties
//
sealed class AnimationEngine {
  ///----------------------

  /// 🎛️ Must initialize controllers & tweens with proper [TickerProvider]
  void initialize(TickerProvider vsync);

  /// ▶️ Starts forward animation from initial state
  void play({Duration? durationOverride});

  /// ⏪ Reverses animation with optional fast collapse for dismissal
  Future<void> reverse({bool fast});

  /// 🛑 Disposes animation controllers and internal resources
  void dispose();

  /// 🌫️ Opacity animation (used for fade transitions)
  Animation<double> get opacity;

  /// 🔍 Scale animation (used for zoom in/out)
  Animation<double> get scale;

  /// ↕️ Optional slide animation (e.g., Android bottom-to-center)
  /// Defaults to `null` if not supported
  Animation<Offset>? get slide => null;

  //
}
