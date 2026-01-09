import 'package:flutter_riverpod/flutter_riverpod.dart' show ProviderContainer;

/// 🌐 [GlobalDIContainer] — Singleton DI container for usage outside of widget tree
/// ✅ Supports logic that runs outside Flutter context: bootstrapping, background tasks, isolates, tests.
/// ✅ Used as `.parent` in ProviderScope to inject global dependencies in app runtime.
//
final class GlobalDIContainer {
  ///-----------------------

  /// Singleton instance holder
  static ProviderContainer? _instance;

  /// 🔍 Whether the global container is already initialized
  static bool get isInitialized => _instance != null;

  /// 🚪 Accessor for the current global container instance
  /// ❗ Throws if accessed before initialization
  static ProviderContainer get instance {
    if (_instance == null) {
      throw StateError('DIContainer.instance is not initialized!');
    }
    return _instance!;
  }

  /// 🧱 Initializes the global DI container
  /// ❗ Can only be called once — subsequent calls will throw
  static void initialize(ProviderContainer container) {
    if (_instance != null) {
      throw StateError('DIContainer.instance already initialized!');
    }
    _instance = container;
  }

  /// 🔄 Resets global DI container (for testing purposes)
  /// ! Within tests don't forget between cases to CALL GlobalDIContainer.reset(), or will catch previous test state
  static void reset() => _instance = null;

  /// 🧼 Properly disposes the global container and clears reference
  static Future<void> dispose() async {
    if (_instance != null) {
      _instance!.dispose();
      _instance = null;
    }
  }

  //
}
