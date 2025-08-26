part of 'animation__engine.dart';

/// ✅ \[BaseAnimationEngine] — General base realization  of Engine
/// 🔁 Incapsulates logic of `initialize`, `play`, `reverse`, `dispose`
/// 🔧 Allows  override  tween and through methods
//
abstract base class BaseAnimationEngine extends AnimationEngine {
  ///---------------------------------------------------------
  //
  AnimationController? _controller;
  bool _isInitialized = false;

  /// 🎛️ [controller] — Safe getter for animation controller
  // Throws assert if accessed before `initialize()` was called
  AnimationController get controller {
    assert(
      _controller != null,
      '❗ BaseAnimationEngine: controller accessed before initialize() was called',
    );
    return _controller!;
  }

  /// 🛠️ Initializes the animation engine with [TickerProvider]
  // Creates controller and triggers setup of tweens
  @override
  void initialize(TickerProvider vsync, {Duration? duration}) {
    if (_isInitialized) return;

    _controller = AnimationController(
      vsync: vsync,
      duration: duration ?? defaultDuration,
    );
    setupAnimations();
    _isInitialized = true;
  }

  /// 🔧 Hook for defining tweens, called after controller created.
  void setupAnimations();

  /// ▶️ Plays forward animation from start
  // Optional override of duration for custom speed
  @override
  void play({Duration? durationOverride}) {
    if (!_isInitialized || _controller == null) return;
    if (durationOverride != null) controller.duration = durationOverride;
    controller.forward(from: 0);
  }

  /// ⏪ Reverses animation (with optional fast collapse)
  // Used for dismiss transitions
  @override
  Future<void> reverse({bool fast = false}) async {
    if (!_isInitialized) return;

    final d = fast ? fastReverseDuration : controller.duration;
    await controller.animateBack(0, duration: d);
  }

  /// ⏱️ Default duration for animations
  Duration get defaultDuration;

  /// ⏩ Duration for fast reverse
  Duration get fastReverseDuration => AppDurations.ms150;

  /// 🧼 Disposes the animation controller
  // Releases internal resources and resets state
  @override
  void dispose() {
    _controller?.dispose();
    _controller = null;
    _isInitialized = false;
  }

  //
}
