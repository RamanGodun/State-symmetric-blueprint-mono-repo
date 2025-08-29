import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router__provider.dart'
    show buildGoRouter, goRouter;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:firebase_adapter/constants/firebase_constants.dart';
import 'package:firebase_adapter/gateways/firebase_auth_gateway.dart'
    show FirebaseAuthGateway;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:riverpod_adapter/base_modules/observing/riverpod_observer.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_adapters_providers.dart'
    show RiverpodOverlayActivityPort, overlayDispatcherProvider;
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart';
import 'package:riverpod_adapter/di/i_di_config.dart';
import 'package:riverpod_adapter/utils/auth/auth_stream_adapter.dart';
import 'package:riverpod_adapter/utils/auth/firebase_providers.dart'
    show firebaseAuthProvider, usersCollectionProvider;

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
    ...authProfileOverrides,
    ...otherOverrides, // placeholder
  ];

  ////
  ////

  /// 🌐 Core system-wide overrides (e.g. theme, routing, overlays)
  //
  List<Override> get coreOverrides => [
    //
    /// 🎨 Theme storage and state
    themeStorageProvider.overrideWith((ref) => GetStorage()),
    themeProvider.overrideWith(
      (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
    ),
    //
    /// 🧭 Routing provider (GoRouter)
    goRouter.overrideWith(buildGoRouter),
    //
    /// 📤 Overlays dispatcher (overridden for customization and test purposes)
    overlayDispatcherProvider.overrideWith((ref) {
      final port = RiverpodOverlayActivityPort(ref);
      return OverlayDispatcher(activityPort: port);
    }),

    //
  ];

  ////

  /// 👤 Profile/auth feature: profile loading with caching
  List<Override> get authProfileOverrides => [
    //
    // 🔐 Auth gateway (lifecycle-safe)
    authGatewayProvider.overrideWith((ref) {
      final auth = FirebaseAuthGateway(FirebaseConstants.fbAuthInstance);
      // ♻️ Prevent leaks: close internal subjects on provider disposal
      ref.onDispose(auth.dispose);
      return auth;
    }),
    //
    // 🔐 Auth (Firebase)
    firebaseAuthProvider.overrideWith(
      (ref) => FirebaseConstants.fbAuthInstance,
    ),
    //
    // 🗃️ Users collection (Firestore)
    usersCollectionProvider.overrideWith(
      (ref) => FirebaseConstants.usersCollection,
    ),
  ];

  ////

  /// 👤 Placeholder for others overrides
  List<Override> get otherOverrides => [
    /// ? Here can be added other providers, that have to be accessible in and outside context (widget tree)
  ];

  ////
  ////

  /// Observers setting
  @override
  List<ProviderObserver> get observers => [RiverpodLogger()];

  //
}
