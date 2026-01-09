import 'package:equatable/equatable.dart' show Equatable;
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart'
    show Failure;

/// [AsyncValueForBLoC<T>] — Riverpod-like async union tailored for BLoC/Cubit UI.
/// - Supports "loading with previous data/error" via `copyWithPrevious(...)`.
/// - Failure-only errors (no stack traces here).
/// - Equatable-friendly and exhaustively pattern-matchable.
//
sealed class AsyncValueForBLoC<T> extends Equatable {
  ///---------------------------------------------
  const AsyncValueForBLoC();

  /// Loading — awaiting a result.
  const factory AsyncValueForBLoC.loading() = AsyncLoadingForBLoC<T>;

  /// Data — successful result.
  const factory AsyncValueForBLoC.data(T value) = AsyncDataForBLoC<T>;

  /// Error — domain Failure.
  const factory AsyncValueForBLoC.error(Failure failure) = AsyncErrorForBLoC<T>;

  // -----
  /// Flags
  // -----

  /// True if the state is any loading variant.
  bool get isLoading =>
      this is AsyncLoadingForBLoC<T> ||
      this is AsyncLoadingWithDataForBLoC<T> ||
      this is AsyncLoadingWithErrorForBLoC<T>;

  /// True if a value is available (including during loading-with-data).
  bool get hasValue =>
      this is AsyncDataForBLoC<T> || this is AsyncLoadingWithDataForBLoC<T>;

  /// True if a failure is available (including during loading-with-error).
  bool get hasError =>
      this is AsyncErrorForBLoC<T> || this is AsyncLoadingWithErrorForBLoC<T>;

  /// Loading + previous data.
  bool get isRefreshing => isLoading && hasValue;

  /// Loading + previous error.
  bool get isReloading => isLoading && hasError;

  // -----
  /// Accessors (Failure-only)
  // -----

  /// Current value or `null` (also during loading-with-data).
  T? get valueOrNull => switch (this) {
    AsyncDataForBLoC<T>(:final value) => value,
    AsyncLoadingWithDataForBLoC<T>(:final previousValue) => previousValue,
    _ => null,
  };

  /// Current failure or `null` (also during loading-with-error).
  Failure? get failureOrNull => switch (this) {
    AsyncErrorForBLoC<T>(:final failure) => failure,
    AsyncLoadingWithErrorForBLoC<T>(:final previousFailure) => previousFailure,
    _ => null,
  };

  /// Strict accessor (throws if no value is available).
  T get requireValue {
    return switch (this) {
      AsyncDataForBLoC<T>(:final value) => value,
      AsyncLoadingWithDataForBLoC<T>(:final previousValue) => previousValue,
      _ => throw StateError('No value present in AsyncValueForBLoC'),
    };
  }

  /// Alias for Riverpod API parity.
  T get value => requireValue;

  // -----
  /// Sugar accessors (ergonomic for UI)
  // -----

  /// Type-safe cast to AsyncData (or null).
  AsyncDataForBLoC<T>? get asData =>
      this is AsyncDataForBLoC<T> ? this as AsyncDataForBLoC<T> : null;

  /// Type-safe cast to AsyncError (or null).
  AsyncErrorForBLoC<T>? get asError =>
      this is AsyncErrorForBLoC<T> ? this as AsyncErrorForBLoC<T> : null;

  // -----
  /// Pattern matching
  // -----

  /// Exhaustive match over loading/data/error.
  ///
  /// Note:
  /// - "Loading-with-previous" variants route to `loading()` by default.
  ///   If you need custom behavior, detect them before calling `when(...)`,
  ///   or use a UI helper (e.g., `whenUI(...)`).
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  /// Non-exhaustive match with fallback.
  R maybeWhen<R>({
    required R Function() orElse,
    R Function()? loading,
    R Function(T data)? data,
    R Function(Failure failure)? error,
  }) {
    return when(
      loading: loading ?? orElse,
      data: data ?? (_) => orElse(),
      error: error ?? (_) => orElse(),
    );
  }

  /// Variant-level match (covers all concrete subtypes).
  R maybeMap<R>({
    required R Function() orElse,
    R Function(AsyncLoadingForBLoC<T> s)? loading,
    R Function(AsyncLoadingWithDataForBLoC<T> s)? loadingWithData,
    R Function(AsyncLoadingWithErrorForBLoC<T> s)? loadingWithError,
    R Function(AsyncDataForBLoC<T> s)? data,
    R Function(AsyncErrorForBLoC<T> s)? error,
  }) {
    return switch (this) {
      final AsyncLoadingForBLoC<T> s => loading?.call(s) ?? orElse(),
      final AsyncLoadingWithDataForBLoC<T> s =>
        loadingWithData?.call(s) ?? orElse(),
      final AsyncLoadingWithErrorForBLoC<T> s =>
        loadingWithError?.call(s) ?? orElse(),
      final AsyncDataForBLoC<T> s => data?.call(s) ?? orElse(),
      final AsyncErrorForBLoC<T> s => error?.call(s) ?? orElse(),
    };
  }

  // -----
  /// Transformations
  // -----

  /// Map value in the data branch; preserve other variants.
  AsyncValueForBLoC<R> map<R>(R Function(T) mapper) => when(
    loading: AsyncValueForBLoC<R>.loading,
    data: (v) => AsyncValueForBLoC<R>.data(mapper(v)),
    error: AsyncValueForBLoC<R>.error,
  );

  /// Transform only the data, preserving the variant shape
  /// (including loading-with-data / loading-with-error).
  AsyncValueForBLoC<R> whenData<R>(R Function(T) transform) => switch (this) {
    AsyncDataForBLoC<T>(:final value) => AsyncValueForBLoC<R>.data(
      transform(value),
    ),

    AsyncLoadingForBLoC<T>() => AsyncValueForBLoC<R>.loading(),

    AsyncErrorForBLoC<T>(:final failure) => AsyncValueForBLoC<R>.error(failure),

    AsyncLoadingWithDataForBLoC<T>(:final previousValue) =>
      AsyncLoadingWithDataForBLoC<R>(transform(previousValue)),

    AsyncLoadingWithErrorForBLoC<T>(:final previousFailure) =>
      AsyncLoadingWithErrorForBLoC<R>(previousFailure),
  };

  /// Preserve previous data/error when transitioning to a fresh `loading()`.
  ///
  /// Usage (BLoC):
  /// `emit(AsyncValueForBLoC<T>.loading().copyWithPrevious(state));`
  AsyncValueForBLoC<T> copyWithPrevious(AsyncValueForBLoC<T> previous) {
    return switch (this) {
      // Only a fresh "loading" blends with the previous state.
      AsyncLoadingForBLoC<T>() => switch (previous) {
        AsyncDataForBLoC<T>(:final value) => AsyncLoadingWithDataForBLoC<T>(
          value,
        ),
        AsyncErrorForBLoC<T>(:final failure) => AsyncLoadingWithErrorForBLoC<T>(
          failure,
        ),
        AsyncLoadingWithDataForBLoC<T>(:final previousValue) =>
          AsyncLoadingWithDataForBLoC<T>(previousValue),
        AsyncLoadingWithErrorForBLoC<T>(:final previousFailure) =>
          AsyncLoadingWithErrorForBLoC<T>(previousFailure),
        _ => this,
      },
      _ => this,
    };
  }
}

////
////
////

////
/// Concrete variants
////

/// Loading — equals any other Loading of the same T.
/// Lightweight and stable key for deduped rebuilds.
//
final class AsyncLoadingForBLoC<T> extends AsyncValueForBLoC<T> {
  ///----------------------------------------------------------
  const AsyncLoadingForBLoC();
  //
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => loading();
  //
  @override
  List<Object?> get props => const ['loading'];
}

////
////

/// Data — equality relies on [value].
/// Prefer T to be Equatable for deep equality.
//
final class AsyncDataForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------
  const AsyncDataForBLoC(this.value);
  //
  /// Payload.
  @override
  final T value;
  //
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => data(value);
  //
  @override
  List<Object?> get props => [value];
}

////
////

/// Error — equals by semantic code + message.
/// Holds a domain-level Failure (type-safe).
//
final class AsyncErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------
  const AsyncErrorForBLoC(this.failure);
  //
  /// Domain failure (type-safe).
  final Failure failure;
  //
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => error(failure);
  //
  @override
  List<Object?> get props => [failure.safeCode, failure.message];
}

////
////

/// Loading while preserving the previous data.
/// Keeps stale content visible while a background refresh is in-flight.
//
final class AsyncLoadingWithDataForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-----------------------------------------------------------------
  const AsyncLoadingWithDataForBLoC(this.previousValue);
  //
  /// Previously loaded value preserved during reload.
  final T previousValue;
  //
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => loading();
  //
  @override
  List<Object?> get props => ['loading_with_data', previousValue];
}

////
////

/// Loading while preserving the previous error.
/// Keeps the last error semantics while a retry is in-flight.
//
final class AsyncLoadingWithErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------------------
  const AsyncLoadingWithErrorForBLoC(this.previousFailure);
  //
  /// Previously observed failure preserved during reload.
  final Failure previousFailure;
  //
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => loading();
  //
  @override
  List<Object?> get props => ['loading_with_error', previousFailure];
}
