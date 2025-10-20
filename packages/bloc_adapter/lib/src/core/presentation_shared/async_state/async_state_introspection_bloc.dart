import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure;

/// Introspection & UI helpers for [AsyncValueForBLoC<T>].
extension AsyncStateIntrospectionBlocX<T> on AsyncValueForBLoC<T> {
  /// Current value or `null` (incl. during loading-with-data).
  T? get valueOrNull => switch (this) {
    AsyncDataForBLoC<T>(:final value) => value,
    AsyncLoadingWithDataForBLoC<T>(:final previousValue) => previousValue,
    _ => null,
  };

  /// Current failure or `null` (incl. during loading-with-error).
  Failure? get failureOrNull => switch (this) {
    AsyncErrorForBLoC<T>(:final failure) => failure,
    AsyncLoadingWithErrorForBLoC<T>(:final previousFailure) => previousFailure,
    _ => null,
  };

  /// True if state is in any loading variant.
  bool get isLoading => this.isLoading;

  /// True if state has a value (data or preserved data).
  bool get hasValue => this.hasValue;

  /// True if state has an error (failure or preserved failure).
  bool get hasError => this.hasError;

  /// True if loading while preserving previous data (refresh).
  bool get isRefreshing => this.isRefreshing;

  /// True if loading while preserving previous error (reload).
  bool get isReloading => this.isReloading;

  /// Declarative UI rendering with optional "preserve data on refresh".
  R whenUI<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
    bool preserveDataOnRefresh = true,
  }) {
    if (preserveDataOnRefresh && this is AsyncLoadingWithDataForBLoC<T>) {
      return data((this as AsyncLoadingWithDataForBLoC<T>).previousValue);
    }
    return when(loading: loading, data: data, error: error);
  }

  //
}
