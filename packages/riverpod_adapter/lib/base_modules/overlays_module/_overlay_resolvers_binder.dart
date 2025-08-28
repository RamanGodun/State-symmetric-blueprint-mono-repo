import 'package:core/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_dispatcher_provider.dart';

/// 🧷 Wires context-aware resolver once at app start
final class OverlayResolversBinder extends ConsumerStatefulWidget {
  ///------------------------------------------------------------
  const OverlayResolversBinder({required this.child, super.key});
  //
  ///
  final Widget child;
  //
  @override
  ConsumerState<OverlayResolversBinder> createState() => _BinderState();
  //
}

////
////

final class _BinderState extends ConsumerState<OverlayResolversBinder> {
  ///---------------------------------------------------------------
  var _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_done) return;
    // контекстний резольвер (потрібен там, де є BuildContext)
    setOverlayDispatcherResolver((ctx) {
      return ref.read(overlayDispatcherProvider);
    });
    _done = true;
  }

  @override
  Widget build(BuildContext context) => widget.child;
  //
}
