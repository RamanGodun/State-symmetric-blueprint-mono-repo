/// 🏁 [IAppBootstrap] — abstract contract for app startup logic.
/// Use `implements` from app packages.
//
abstract interface class IAppBootstrap {
  ///------------------
  //
  /// 🚀 Main initialization: all services and dependencies
  Future<void> initAllServices();
  //
  /// Initializes Flutter bindings and debug tools
  Future<void> startUp();
  //
  /// Creates a global DI container accessible both outside and inside the widget tree.
  Future<void> initGlobalDIContainer();
  //
  /// Initialize local storage
  Future<void> initLocalStorage();
  //
  /// Initialize remote Database
  Future<void> initRemoteDataBase();

  /// ? Why split initialization into several methods?
  /// Startup should be flexible and can be multi-phased, e.g.: displaying a loader/UI ASAP,
  /// while heavy initializations (services, Firebase, etc.) happen after.
  //
}
