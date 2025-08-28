import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router__provider.dart'
    show buildGoRouter, goRouter;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:firebase_adapter/gateways/firebase_auth_gateway.dart'
    show FirebaseAuthGateway;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:riverpod_adapter/base_modules/observing/riverpod_observer.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_activity_port_riverpod.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_dispatcher_provider.dart';
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart';
import 'package:riverpod_adapter/di/i_di_config.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart';

/// 🛠️ [DIConfiguration] — Default DI configuration for the app.
///     Sets up storage, theme, navigation, overlays, and profile repo.
//
final class DIConfiguration implements IDIConfig {
  ///-------------------------------------------------
  //
  /// 🔁 Combined list of all feature overrides
  @override
  List<Override> get overrides => [
    ...coreOverrides,
    ...otherOverrides, // placeholder
  ];

  ///
  @override
  List<ProviderObserver> get observers => [RiverpodLogger()];
  //

  /// *🧩 FEATURE OVERRIDE MODULES
  //
  /// 🌐 Core system-wide overrides (e.g. theme, routing, overlays)
  List<Override> get coreOverrides => [
    /// 🎨 Theme storage and state
    themeStorageProvider.overrideWith((ref) => GetStorage()),
    themeProvider.overrideWith(
      (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
    ),

    /// 🧭 Routing provider (GoRouter)
    goRouter.overrideWith(buildGoRouter),

    /// 📤 Overlay dispatcher for toasts/dialogs/etc.
    overlayDispatcherProvider.overrideWith((ref) {
      final port = RiverpodOverlayActivityPort(ref);
      return OverlayDispatcher(activityPort: port);
    }),

    /// 🔐 Auth gateway (Firebase) with proper lifecycle handling
    authGatewayProvider.overrideWith((ref) {
      final g = FirebaseAuthGateway(FirebaseConstants.fbAuthInstance);
      // ♻️ Prevent leaks: close internal subjects on provider disposal
      ref.onDispose(g.dispose);
      return g;
    }),

    //
  ];

  ////

  /// 👤 Profile feature: profile loading with caching
  List<Override> get otherOverrides => [
    //
    /// ? Here can be added other providers, that have to be accessible in and outside context (widget tree)
  ];

  //
}
