import 'package:app_bootstrap_and_config/contracts/bootstrap.dart';
import 'package:app_bootstrap_and_config/contracts/remote_database.dart';
import 'package:firebase_bootstrap_config/firebase_init/remote_db_init.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show WidgetsFlutterBinding;

/// 🧰 [DefaultAppBootstrap] — Handles all critical bootstrapping (with injectable stacks for testing/mocks).
//
final class DefaultAppBootstrap implements IAppBootstrap {
  ///----------------------------------------
  /// Constructor allows the injection of custom/mock implementations.
  const DefaultAppBootstrap({
    // ILocalStorage? localStorageStack,
    // IDIConfig? diConfiguration,
    IRemoteDataBase? firebaseStack,
  }) : //  _localStorage = localStorageStack ?? const LocalStorage(),
       //  _diConfiguration = diConfiguration ?? DIConfiguration(),
       _remoteDataBase = firebaseStack ?? const FirebaseRemoteDataBase();
  //
  // final ILocalStorage _localStorage;
  // final IDIConfig _diConfiguration;
  final IRemoteDataBase _remoteDataBase;

  ////
  ////

  /// Main entrypoint: sequentially bootstraps all core app services before 'runApp'
  @override
  Future<void> initAllServices() async {
    //
    debugPrint('🚀 [Bootstrap] Starting full initialization...');
    await startUp();
    //
    // await initGlobalDIContainer();
    //
    /// Ensures EasyLocalization is initialized before runApp.
    // await initEasyLocalization();
    //
    /// Initializes local storage (currently, GetStorage).
    // await initLocalStorage();
    //
    /// Initializes remote database (currently, Firebase).
    await initRemoteDataBase();
    //
    // setPathUrlStrategy();
    debugPrint('✅ [Bootstrap] All services initialized!');
    //
  }

  ////

  @override
  Future<void> startUp() async {
    //
    debugPrint('🟢 [Startup] Flutter bindings and platform checks...');
    // Ensures Flutter bindings are ready before any further setup.
    WidgetsFlutterBinding.ensureInitialized();
    //
    /// Validates platform (min. OS versions, emulator restrictions, etc).
    // await PlatformValidationUtil.run();
    //
    /// Controls visual debugging options (e.g., repaint highlighting).
    // debugRepaintRainbowEnabled = false;
    // ... (other debug tools)
    debugPrint('✅ [Startup] Flutter bindings and platform validation done.');
  }

  ////

  /// Set uo global DI container for using outside widget tree and for ProviderScope.parent,
  /// that ensures consistent of shared DI both in/out context
  @override
  Future<void> initGlobalDIContainer() async {
    //
    debugPrint('📦 [DI] Initializing global dependency container...');
    // final getGlobalContainer = ProviderContainer(
    //   overrides: _diConfiguration.overrides,
    //   observers: _diConfiguration.observers,
    // );
    // //
    // GlobalDIContainer.initialize(getGlobalContainer);
    debugPrint('✅ [DI] Dependency container ready.');
  }

  ////

  @override
  Future<void> initLocalStorage() async {
    //
    debugPrint('💾 [Storage] Initializing local storage...');
    // Initializes local storage (currently, GetStorage).
    // await _localStorage.init();
  }

  ////

  @override
  Future<void> initRemoteDataBase() async {
    /// Initializes remote database (currently, Firebase).
    await _remoteDataBase.init();
    debugPrint('✅ [Storage] Local storage initialized.');
  }

  ////

  Future<void> initEasyLocalization() async {
    //
    debugPrint('🌍 Initializing EasyLocalization...');
    // await EasyLocalization.ensureInitialized();
    //
    /// 🌍 Sets up the global localization resolver for the app.
    // AppLocalizer.init(resolver: (key) => key.tr());
    // ? when app without localization, then instead previous method use next:
    // AppLocalizer.initWithFallback();
    debugPrint('🌍 EasyLocalization initialized!');
    //
  }

  //
}
