import 'package:core/public_api/base_modules/errors_management.dart'
    show ExceptionToFailureX, Failure;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AsyncStateIntrospectionRiverpodX] — introspection & UI helpers for [AsyncValue<T>].
/// - Adds domain-aware failure extraction.
/// - Provides lightweight flag aliases to avoid name clashes.
/// - Supplies a UI-friendly `.whenUI(...)` API for refresh-preserving rendering.
//
extension AsyncStateIntrospectionRiverpodX<T> on AsyncValue<T> {
  /// Domain [Failure] if present; non-Failure errors are mapped.
  Failure? get failureOrNull {
    return maybeWhen(
      data: (_) => null,
      loading: () => null,
      error: (e, st) => e is Failure ? e : e.mapToFailure(st),
      orElse: () => null,
    );
  }

  /// True if AsyncValue is currently loading (any variant).
  bool get isLoadingFast => isLoading;

  /// True if AsyncValue contains a value (data or preserved data).
  bool get hasValueFast => hasValue;

  /// True if AsyncValue contains an error (Failure or preserved error).
  bool get hasErrorFast => hasError;

  /// True if state is loading while preserving previous data (refresh).
  bool get isRefreshingFast => isRefreshing;

  /// True if state is loading while preserving previous error (reload).
  bool get isReloadingFast => isReloading;

  /// Declarative UI matching with optional "preserve previous data during refresh".
  R whenUI<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
    bool preserveDataOnRefresh = true,
  }) {
    if (preserveDataOnRefresh && isLoading && hasValue) {
      return data(value as T);
    }
    return when(
      loading: loading,
      data: data,
      error: (e, st) => error(e is Failure ? e : e.mapToFailure(st)),
    );
  }

  //
}
