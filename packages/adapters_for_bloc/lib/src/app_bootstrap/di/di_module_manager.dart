import 'package:adapters_for_bloc/src/app_bootstrap/di/di_module_interface.dart'
    show DIModule;
import 'package:flutter/foundation.dart' show debugPrint;

/// 📦 Enhanced Module Manager with s=error handling
//
final class ModuleManager {
  ///-------------------
  //
  static final Map<Type, DIModule> _modules = {};
  static final Set<Type> _registered = {};

  /// Register a single module with enhanced error handling
  static Future<void> registerModule<T extends DIModule>(T module) async {
    if (_registered.contains(module.runtimeType)) {
      debugPrint('⚠️  Module ${module.name} already registered, skipping');
      return;
    }

    // Check dependencies
    for (final dep in module.dependencies) {
      if (!_registered.contains(dep)) {
        throw StateError(
          '❌ Module "${module.name}" depends on "$dep" which is not registered.\n'
          'Registered modules: ${_registered.map((e) => e.toString()).join(', ')}',
        );
      }
    }

    try {
      debugPrint('📦 Registering module: ${module.name}');
      await module.register();
      _modules[module.runtimeType] = module;
      _registered.add(module.runtimeType);
      debugPrint('✅ Module ${module.name} registered successfully');
    } catch (e, stackTrace) {
      debugPrint('❌ Failed to register module ${module.name}: $e');
      debugPrint('Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Register multiple modules with dependency resolution
  static Future<void> registerModules(List<DIModule> modules) async {
    final remaining = List.of(modules);
    var lastCount = remaining.length;

    while (remaining.isNotEmpty) {
      final toRegister = remaining.where((module) {
        return module.dependencies.every(_registered.contains);
      }).toList();

      if (toRegister.isEmpty) {
        final remainingNames = remaining.map((m) => m.name).join(', ');
        final missingDeps = remaining
            .expand((m) => m.dependencies)
            .where((dep) => !_registered.contains(dep))
            .toSet();

        throw StateError(
          '❌ Circular dependency or missing dependencies detected!\n'
          'Remaining modules: $remainingNames\n'
          'Missing dependencies: ${missingDeps.join(', ')}\n'
          'Registered modules: ${_registered.join(', ')}',
        );
      }

      for (final module in toRegister) {
        await registerModule(module);
        remaining.remove(module);
      }

      // Safety check to prevent infinite loops
      if (remaining.length == lastCount) {
        throw StateError(
          '❌ Unable to resolve dependencies - potential circular reference',
        );
      }
      lastCount = remaining.length;
    }

    debugPrint(
      '✅ All modules registered successfully: ${_registered.join(', ')}',
    );
  }

  //
}
