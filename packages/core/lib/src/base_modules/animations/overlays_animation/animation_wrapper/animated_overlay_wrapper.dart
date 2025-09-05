// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:flutter/material.dart';

/// 🧱 [AnimatedOverlayWrapper] — Universal animation container for overlay widgets.
///    ✅ Safely initializes the animation engine with [TickerProvider].
///    ✅ Automatically triggers the forward animation on mount.
///    ✅ Optionally auto-dismisses after [displayDuration].
///    ✅ Invokes [onDismiss] callback after reverse animation completes.
//
final class AnimatedOverlayWrapper extends StatefulWidget {
  ///-----------------------------------------------------
  const AnimatedOverlayWrapper({
    required this.engine,
    required this.builder,
    required this.displayDuration,
    this.onDismiss,
    this.placeholder,
    super.key,
  });
  //
  final AnimationEngine engine;
  final Widget Function(AnimationEngine engine) builder;
  final Duration displayDuration;
  final VoidCallback? onDismiss;
  final Widget? placeholder;

  @override
  State<AnimatedOverlayWrapper> createState() => _AnimatedOverlayWrapperState();
}

////
////

final class _AnimatedOverlayWrapperState extends State<AnimatedOverlayWrapper>
    with TickerProviderStateMixin {
  ///------------------------------------------------------------------------------------------------------

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();

    // ✅ Protection from late errors after dispose
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return; // ⛔️ Exit, if already dispose

      widget.engine.initialize(this);
      widget.engine.play();

      if (widget.displayDuration > Duration.zero) _scheduleAutoDismiss();
      if (mounted) setState(() => _isInitialized = true);

      //
    });
  }

  /// ⏱️ Auto-dismiss overlay after delay
  void _scheduleAutoDismiss() {
    Future.delayed(widget.displayDuration, () async {
      if (!mounted) return;
      await widget.engine.reverse();
      if (mounted) widget.onDismiss?.call();
    });
  }
  //

  @override
  Widget build(BuildContext context) {
    //
    // ⛔ Prevent build until engine is ready
    if (!_isInitialized) return widget.placeholder ?? const SizedBox.shrink();

    return widget.builder(widget.engine);
  }

  ///
  @override
  void dispose() {
    widget.engine.dispose(); // 🧼 Cleanup engine
    super.dispose();
  }

  //
}
