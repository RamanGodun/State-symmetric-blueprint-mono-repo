import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router__provider.dart';
import 'package:core/base_modules/logging/for_riverpod/riverpod_observer.dart'
    show RiverpodLogger;
import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher_provider.dart'
    show overlayDispatcherProvider, overlayStatusProvider;
import 'package:core/base_modules/theme/theme_providers_or_cubits/theme_provider.dart'
    show ThemeConfigNotifier, themeProvider, themeStorageProvider;
import 'package:core/di_container_riverpod/i_di_config.dart';
import 'package:core/utils_shared/riverpod_specific/auth_stream_adapter.dart';
import 'package:core/utils_shared/riverpod_specific/user_auth_provider/firebase_auth_providers.dart';
import 'package:firebase_bootstrap_config/firebase_auth_gateway.dart';
import 'package:firebase_bootstrap_config/firebase_config/firebase_constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

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
    overlayDispatcherProvider.overrideWith(
      (ref) => OverlayDispatcher(
        onOverlayStateChanged: ref.read(overlayStatusProvider.notifier).update,
      ),
    ),

    ///
    authGatewayProvider.overrideWith(
      (ref) => FirebaseAuthGateway(FirebaseConstants.fbAuth),
    ),
    firebaseAuthProvider.overrideWithValue(FirebaseConstants.fbAuth),

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
