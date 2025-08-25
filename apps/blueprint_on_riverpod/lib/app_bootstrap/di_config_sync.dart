import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router__provider.dart';
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:firebase_bootstrap_config/firebase_constants.dart';
import 'package:firebase_bootstrap_config/utils/auth/firebase_auth_gateway.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;
import 'package:specific_for_riverpod/auth/auth_stream_adapter.dart';
import 'package:specific_for_riverpod/auth/firebase_auth_providers.dart';
import 'package:specific_for_riverpod/base_modules/observing/riverpod_observer.dart';
import 'package:specific_for_riverpod/base_modules/overlays/overlay_dispatcher_provider.dart';
import 'package:specific_for_riverpod/base_modules/theme_providers/theme_provider.dart';
import 'package:specific_for_riverpod/di_container/i_di_config.dart';

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
      (ref) => FirebaseAuthGateway(FirebaseConstants.fbAuthInstance),
    ),
    firebaseAuthProvider.overrideWithValue(FirebaseConstants.fbAuthInstance),
    usersCollectionProviderManual.overrideWithValue(
      FirebaseConstants.usersCollection,
    ),

    /*
?USAGE:
final auth = ref.watch(firebaseAuthProvider);
final users = ref.watch(usersCollectionProvider);

 */
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
