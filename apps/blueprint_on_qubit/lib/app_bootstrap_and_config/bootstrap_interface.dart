part of 'app_bootstrap.dart';

/// 🧰 [IAppBootstrap] — Abstract contract for app startup logic
//
abstract interface class IAppBootstrap {
  ///----------------------------------
  const IAppBootstrap();
  //
  /// 🚀 Main initialization: all services and dependencies
  Future<void> initAllServices();
  //
  /// Initializes Flutter bindings, platform validation and debug tools
  Future<void> appStartUp();
  //
  /// Creates a global DI container accessible both outside and inside the widget tree.
  Future<void> initGlobalDIContainer();
  //
  /// Initialize local storage  (currently, HydratedBloc storage)
  Future<void> initLocalStorage();
  //
  /// Initializes remote database (currently, Firebase).
  Future<void> initRemoteDataBase();

  /// ? Why split initialization into several methods?
  ///       Startup can be multi-phased, e.g.:
  ///         - **Minimal bootstrap** — For a custom splash/loader (e.g., show initial loader while others setup runs).
  ///         -  **Full bootstrap** — For the complete initialization pipeline (all services/deps)
  //
  ///   This allows to display a loader/UI ASAP, while heavy initializations (services, Firebase, etc.) happen after.
  //
}
