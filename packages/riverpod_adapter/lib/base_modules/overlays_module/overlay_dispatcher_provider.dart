// packages/riverpod_adapter/lib/base_modules/overlays_module/overlay_dispatcher_provider.dart
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_activity_port_riverpod.dart';

/// 🧠 [overlayDispatcherProvider] — DI for [OverlayDispatcher] with Riverpod port
final overlayDispatcherProvider = Provider<OverlayDispatcher>((ref) {
  final port = RiverpodOverlayActivityPort(ref); // bridge to riverpod
  return OverlayDispatcher(activityPort: port);
});
