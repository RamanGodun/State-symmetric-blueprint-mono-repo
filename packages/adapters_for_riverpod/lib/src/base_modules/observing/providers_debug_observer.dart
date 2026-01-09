import 'package:flutter/foundation.dart' show debugPrint, kDebugMode;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderBase, ProviderContainer, ProviderObserver;

/// 📦 [ProviderDebugObserver] — configurable Riverpod observer.
/// ✅ Logs provider lifecycle events (init/update/dispose)
/// ✅ Supports filtering by provider names
/// ✅ Useful for debugging state changes in development
//
final class ProviderDebugObserver extends ProviderObserver {
  ///---------------------------------------
  const ProviderDebugObserver({
    this.logValues = true,
    this.onlyNamed,
    this.ignore,
  });

  /// Whether to include provider values in logs.
  final bool logValues;

  /// Log only providers with these names (null = log all).
  final Set<String>? onlyNamed;

  /// Skip logging for these provider names.
  final Set<String>? ignore;

  ////

  /// 🔍 Check if a provider should be logged based on filters.
  bool _shouldLog(ProviderBase<Object?> p) {
    final name = p.name;
    if (ignore != null && name != null && ignore!.contains(name)) return false;
    if (onlyNamed != null && name != null) return onlyNamed!.contains(name);
    return true;
  }

  /// 🖨️ Print a structured debug message for provider events.
  void _print(
    String event,
    ProviderBase<Object?> p, {
    Object? prev,
    Object? next,
  }) {
    if (!kDebugMode || !_shouldLog(p)) return;
    final name = p.name ?? p.runtimeType.toString();
    final map = {
      'ts': DateTime.now().toIso8601String(),
      'event': event,
      'provider': name,
      if (logValues && prev != null) 'prev': '$prev',
      if (logValues && next != null) 'next': '$next',
    };
    debugPrint(map.toString());
  }

  ////

  /// ➕ Called when a provider is first created.
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    _print('add', provider, next: value);
    super.didAddProvider(provider, value, container);
  }

  /// ❌ Called when a provider is disposed.
  @override
  void didDisposeProvider(
    ProviderBase<Object?> provider,
    ProviderContainer container,
  ) {
    _print('dispose', provider);
    super.didDisposeProvider(provider, container);
  }

  /// 🔄 Called when a provider updates its value.
  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    _print('update', provider, prev: previousValue, next: newValue);
    super.didUpdateProvider(provider, previousValue, newValue, container);
  }

  //
}
