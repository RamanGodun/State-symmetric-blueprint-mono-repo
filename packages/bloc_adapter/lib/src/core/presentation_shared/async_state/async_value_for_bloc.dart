import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:equatable/equatable.dart';

/// 🧩 [AsyncValueForBLoC] — Riverpod-like async union tailored for BLoC UI.
/// ✅ Now supports “loading with previous data/error” and `copyWithPrevious(...)`
/// ✅ Type-safe Failure, Equatable-friendly, and exhaustively pattern-matchable
//
sealed class AsyncValueForBLoC<T> extends Equatable {
  ///---------------------------------------------
  const AsyncValueForBLoC();

  /// ⏳ Loading — awaiting a result
  const factory AsyncValueForBLoC.loading() = AsyncLoadingForBLoC<T>;
  //
  /// ✅ Data — successful result
  const factory AsyncValueForBLoC.data(T value) = AsyncDataForBLoC<T>;
  //
  /// 🧨 Error — domain Failure
  const factory AsyncValueForBLoC.error(Failure failure) = AsyncErrorForBLoC<T>;
  //

  /// 🧭 True when current state is some kind of loading
  bool get isLoading =>
      this is AsyncLoadingForBLoC<T> ||
      this is AsyncLoadingWithDataForBLoC<T> ||
      this is AsyncLoadingWithErrorForBLoC<T>;

  /// 🧭 True when a value is currently available (incl. loading-with-data)
  bool get hasValue =>
      this is AsyncDataForBLoC<T> || this is AsyncLoadingWithDataForBLoC<T>;

  /// 🧭 True when an error is currently available (incl. loading-with-error)
  bool get hasError =>
      this is AsyncErrorForBLoC<T> || this is AsyncLoadingWithErrorForBLoC<T>;

  /// 🧭 Loading + prev data
  bool get isRefreshing => isLoading && hasValue;

  /// 🧭 Loading + prev error
  bool get isReloading => isLoading && hasError;

  /// 📦 Current value or `null` (also available during loading-with-data)
  T? get valueOrNull => switch (this) {
    AsyncDataForBLoC<T>(:final value) => value,
    AsyncLoadingWithDataForBLoC<T>(:final previousValue) => previousValue,
    _ => null,
  };

  /// 🧩 Current failure or `null` (also available during loading-with-error)
  Failure? get failureOrNull => switch (this) {
    AsyncErrorForBLoC<T>(:final failure) => failure,
    AsyncLoadingWithErrorForBLoC<T>(:final previousFailure) => previousFailure,
    _ => null,
  };

  /// 🔁 Exhaustive match over loading/data/error (NOT including loading-with-previous directly)
  ///
  /// NOTE:
  /// - Loading-with-previous variants funnel through the `loading` branch by default.
  ///   If you need to treat them specially, detect them *before* calling `when(...)`
  ///   or use a dedicated adapter in the UI layer.
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  /// 🔁 Non-exhaustive match with fallback
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

  /// 🔀 Map value in the data branch, preserve loading/error variants
  AsyncValueForBLoC<R> map<R>(R Function(T) mapper) => when(
    loading: AsyncValueForBLoC<R>.loading,
    data: (v) => AsyncValueForBLoC<R>.data(mapper(v)),
    error: AsyncValueForBLoC<R>.error,
  );

  /// 🔗 Riverpod parity: preserve previous data/error during a new `loading()`.
  /// Usage (BLoC):
  /// `emit(AsyncValueForBLoC<T>.loading().copyWithPrevious(state));`
  AsyncValueForBLoC<T> copyWithPrevious(AsyncValueForBLoC<T> previous) {
    return switch (this) {
      // Only the fresh "loading" gets blended with previous
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
        _ => this, // previous had nothing to preserve
      },
      _ => this, // non-loading states don't copy
    };
  }

  /// 🧲 Strict accessor (throws if no data currently available)
  T get requireValue {
    return switch (this) {
      AsyncDataForBLoC<T>(:final value) => value,
      AsyncLoadingWithDataForBLoC<T>(:final previousValue) => previousValue,
      _ => throw StateError('No value present in AsyncValueForBLoC'),
    };
  }

  //
}

////
////

/// ⏳ Loading — equals any other Loading of same T.
/// Lightweight + stable key for deduped rebuilds.
//
final class AsyncLoadingForBLoC<T> extends AsyncValueForBLoC<T> {
  ///--------------------------------------------------------
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

/// ✅ Data — equality relies on [value].
/// Prefer T being Equatable for deep equality in rebuilds.
//
final class AsyncDataForBLoC<T> extends AsyncValueForBLoC<T> {
  ///------------------------------------------------------
  const AsyncDataForBLoC(this.value);
  //
  /// 📦 Payload
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

/// 🧨 Error — equals by semantic code + message.
/// Holds a domain-level Failure (type-safe).
//
final class AsyncErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------
  const AsyncErrorForBLoC(this.failure);

  /// 🧩 Domain failure (type-safe)
  final Failure failure;

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => error(failure);

  @override
  List<Object?> get props => [failure.safeCode, failure.message];
}

////
////

/// ⏳➕📦 Loading *while preserving previous data*
//
/// UX: allows showing stale content while a background refresh is in-flight.
/// Default `when(loading: ...)` is kept for exhaustive switches,
/// but you can surface `previousValue` via `.valueOrNull` or in the adapter.
//
final class AsyncLoadingWithDataForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-----------------------------------------------------------------
  const AsyncLoadingWithDataForBLoC(this.previousValue);
  //
  /// 📦 The previously loaded value we preserve during reload
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

/// ⏳➕🧨 Loading *while preserving previous error*
//
/// UX: allows showing a subtle “retrying…” state while keeping the last error.
/// As above, default `when` routes to `loading` — adapters/UI can inspect flags.
//
final class AsyncLoadingWithErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------------------
  const AsyncLoadingWithErrorForBLoC(this.previousFailure);
  //
  /// 🧩 The previous failure we preserve during reload
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
