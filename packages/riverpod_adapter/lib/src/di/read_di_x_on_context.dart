import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/di/global_di_container.dart';

/// 🔌 [ContextDI] — Provides access to global DI container via context.
/// ✅ Use for imperative code outside widget tree or in cases where ref/context is not available.
//
extension ContextDI on BuildContext {
  ///───────────────────────────────
  //
  /// Returns dependency from global DI container (via [GlobalDIContainer]).
  /// Use responsibly: prefer 'ref.read' inside widgets/providers.
  T readDI<T>(ProviderListenable<T> provider) {
    return GlobalDIContainer.instance.read(provider);
  }
}
