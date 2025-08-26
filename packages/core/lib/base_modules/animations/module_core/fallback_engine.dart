part of 'animation__engine.dart';

/// 🛑 [FallbackAnimationEngine] — default no-op engine used when platform/type is unsupported
/// ✅ Always returns complete animations (opacity/scale = 1.0)
/// ✅ Avoids crashes for unhandled overlay categories
//
final class FallbackAnimationEngine extends AnimationEngine {
  ///-------------------------------------------------------
  /// 🏗️ Constructor (no-op)
  FallbackAnimationEngine();

  /// 🛠️ No initialization needed
  @override
  void initialize(TickerProvider vsync) {}

  /// ▶️ No-op play animation
  @override
  void play({Duration? durationOverride}) {}

  /// ⏪ No-op reverse animation
  @override
  Future<void> reverse({bool fast = false}) async {}

  /// 🧹 No resources to dispose
  @override
  void dispose() {}

  /// 🌫️ Always-complete opacity animation
  @override
  Animation<double> get opacity => kAlwaysCompleteAnimation;

  /// 🔍 Always-complete scale animation
  @override
  Animation<double> get scale => kAlwaysCompleteAnimation;

  /// ↕ Slide is not supported
  @override
  Animation<Offset>? get slide => null;

  //
}
