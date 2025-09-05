import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:flutter/widgets.dart';

/// 🔎 How CORE obtains OverlayDispatcher (context-aware)
typedef OverlayDispatcherResolver = OverlayDispatcher Function(BuildContext);
OverlayDispatcherResolver? _resolver;

/// 🔌 Optional global resolver (when no BuildContext available)
typedef OverlayDispatcherGlobalResolver = OverlayDispatcher Function();
OverlayDispatcherGlobalResolver? _globalResolver;

/// ▶️ App wires resolver here (context-aware)
void setOverlayDispatcherResolver(OverlayDispatcherResolver r) {
  _resolver = r;
}

/// ▶️ App wires resolver here (global, e.g. for NavigatorObserver)
void setGlobalOverlayDispatcherResolver(OverlayDispatcherGlobalResolver r) {
  _globalResolver = r;
}

/// ✅ Resolve dispatcher with BuildContext
OverlayDispatcher resolveOverlayDispatcher(BuildContext ctx) {
  final r = _resolver;
  if (r == null) {
    throw StateError(
      'OverlayDispatcher resolver is not set. '
      'Call setOverlayDispatcherResolver(...) in app bootstrap.',
    );
  }
  return r(ctx);
}

/// ✅ Resolve dispatcher globally (no BuildContext)
OverlayDispatcher resolveOverlayDispatcherGlobal() {
  final r = _globalResolver;
  if (r == null) {
    throw StateError(
      'Global OverlayDispatcher resolver is not set. '
      'Call setGlobalOverlayDispatcherResolver(...) in app bootstrap.',
    );
  }
  return r();
}
