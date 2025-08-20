// 📁 lib/core/di/module.dart
/// 🧩 Base interface for all DI modules
//
abstract interface class DIModule {
  ///---------------------------
  //
  /// Module name for debugging
  String get name;

  /// Dependencies this module requires (other modules)
  List<Type> get dependencies => const [];

  /// Register all dependencies for this module
  Future<void> register();

  /// Clean up resources when module is disposed (optional)
  Future<void> dispose() async {}

  //
}
