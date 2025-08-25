import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔧 [IDIConfig] — Abstract contract for DI (Dependency Injection) configuration.
///     Provides lists of provider overrides and observers for Riverpod setup.
///     Useful for switching between different DI environments or for testing.
//
abstract interface class IDIConfig {
  //
  /// List of provider overrides for this configuration.
  List<Override> get overrides;
  //
  /// List of provider observers for this configuration.
  List<ProviderObserver> get observers;
}
