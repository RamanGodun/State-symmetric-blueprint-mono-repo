import 'package:app_bootstrap/bootstrap_contracts/_remote_database.dart'
    show IRemoteDataBase;
import 'package:app_bootstrap/bootstrap_contracts/contracts_barrel.dart'
    show IAppBootstrap;
import 'package:app_bootstrap/utils/platform_validation.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/di_container_init.dart';
import 'package:app_on_bloc/app_bootstrap/firebase_initializer.dart';
import 'package:app_on_bloc/app_bootstrap/local_storage_init.dart';
import 'package:bloc_adapter/base_modules/observer/bloc_observer.dart';
import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter/material.dart' show WidgetsFlutterBinding;
import 'package:flutter/rendering.dart' show debugRepaintRainbowEnabled;
import 'package:flutter_bloc/flutter_bloc.dart';

/// 🧰 [DefaultAppBootstrap] — Handles all critical bootstrapping (with injectable stacks for testing/mocks).
//
final class DefaultAppBootstrap implements IAppBootstrap {
  ///-------------------------------------------
  /// Constructor allows the injection of custom/mock implementations.
  const DefaultAppBootstrap({
    ILocalStorage? localStorageStack,
    IRemoteDataBase? firebaseStack,
  }) : _remoteDataBase = firebaseStack ?? const FirebaseRemoteDataBase(),
       _localStorage = localStorageStack ?? const HydratedLocalStorage();
  //
  final ILocalStorage _localStorage;
  final IRemoteDataBase _remoteDataBase;

  ////
  ////

  /// Main entrypoint: sequentially bootstraps all core app services
  @override
  Future<void> initAllServices() async {
    //
    debugPrint('🚀 [Bootstrap] Starting full initialization...');
    await startUp();
    //
    /// Initializes remote database (currently, Firebase).
    await initRemoteDataBase();
    //
    /// 📦  Register dependencies via GetIt
    await initGlobalDIContainer();
    //
    /// Ensures EasyLocalization is initialized before runApp.
    await initEasyLocalization();
    //
    /// Initializes local storage (currently, GetStorage).
    await initLocalStorage();

    //
    /// Initializes optional/miscellaneous services.
    initOptionalMiscServices();
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
    await PlatformValidationUtil.run();
    //
    /// Controls visual debugging options (e.g., repaint highlighting).
    debugRepaintRainbowEnabled = false;
    //
    /// Custom bloc observer
    Bloc.observer = const AppBlocObserver();
    //
    /// ... (other debug tools)
    debugPrint('✅ [Startup] Flutter bindings and platform validation done.');
    //
  }

  ////

  @override
  Future<void> initGlobalDIContainer() async {
    //
    debugPrint('📦 [DI] Initializing global dependency container...');
    // 📦  Register dependencies via GetIt
    await DIContainer.initFull();
    debugPrint('✅ [DI] Dependency container ready.');
  }

  ////

  @override
  Future<void> initLocalStorage() async {
    //
    debugPrint('💾 [Storage] Initializing local storage...');
    // Setup HydratedBloc storage currently
    await _localStorage.init();
    debugPrint('✅ [Storage] Local storage initialized.');
  }

  ////

  @override
  Future<void> initRemoteDataBase() async {
    //
    debugPrint('🗄️ [RemoteDB] Initializing remote database...');
    // Initializes remote database (currently, Firebase).
    await _remoteDataBase.init();
    debugPrint('✅ [RemoteDB] Remote database initialized.');
  }

  ////

  Future<void> initEasyLocalization() async {
    //
    debugPrint('🌍 Initializing EasyLocalization...');
    await EasyLocalization.ensureInitialized();
    //
    /// 🌍 Sets up the global localization resolver for the app.
    AppLocalizer.init(resolver: (key) => key.tr());
    // ? when app without localization, then instead previous method use next:
    // AppLocalizer.initWithFallback();
    debugPrint('✅ EasyLocalization initialized!');
    //
  }

  ////

  void initOptionalMiscServices() {
    /// Set URL strategy for web
    // setPathUrlStrategy();
    //
    /// Configure default ID generator
    // Id.generator = () => const Uuid().v4(); // or nanoid() / ulid()
  }

  //
}
