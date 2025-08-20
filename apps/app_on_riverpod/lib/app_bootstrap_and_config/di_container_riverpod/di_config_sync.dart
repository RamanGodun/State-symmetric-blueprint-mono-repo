import 'package:app_on_riverpod/core/base_modules/navigation/module_core/provider_for_go_router.dart'
    show buildGoRouter, goRouter;
import 'package:core/base_modules/logging/for_riverpod/riverpod_observer.dart'
    show RiverpodLogger;
import 'package:core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart'
    show OverlayDispatcher;
import 'package:core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher_provider.dart'
    show overlayDispatcherProvider, overlayStatusProvider;
import 'package:core/base_modules/theme/theme_providers_or_cubits/theme_provider.dart'
    show ThemeConfigNotifier, themeProvider, themeStorageProvider;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart' show GetStorage;

/// 🔧 [IDIConfig] — Abstract contract for DI (Dependency Injection) configuration.
///     Provides lists of provider overrides and observers for Riverpod setup.
///     Useful for switching between different DI environments or for testing.
//
sealed class IDIConfig {
  //
  /// List of provider overrides for this configuration.
  List<Override> get overrides;
  //
  /// List of provider observers for this configuration.
  List<ProviderObserver> get observers;
}

////

////

/// 🛠️ [DIConfiguration] — Default DI configuration for the app.
///     Sets up storage, theme, navigation, overlays, and profile repo.
//
final class DIConfiguration extends IDIConfig {
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
  ];

  ////

  /// 👤 Profile feature: profile loading with caching
  List<Override> get otherOverrides => [
    //
    /// ? Here can be added other providers, that have to be accessible in and outside context (widget tree)
  ];

  //
}
