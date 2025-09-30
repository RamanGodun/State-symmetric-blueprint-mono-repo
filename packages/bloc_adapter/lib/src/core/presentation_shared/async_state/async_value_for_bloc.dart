import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:equatable/equatable.dart';

/// 🧩 [AsyncValueForBLoC] — Riverpod-like async union for BLoC UI.
/// Factories: `.loading()`, `.data(value)`, `.error(failure)` + pattern matching.
//
sealed class AsyncValueForBLoC<T> extends Equatable {
  ///---------------------------------------------
  const AsyncValueForBLoC();

  /// ⏳ Loading state
  const factory AsyncValueForBLoC.loading() = AsyncLoadingForBLoC<T>;
  //
  /// ✅ Data state with [value]
  const factory AsyncValueForBLoC.data(T value) = AsyncDataForBLoC<T>;
  //
  /// 🧨 Error state with domain [failure]
  const factory AsyncValueForBLoC.error(Failure failure) = AsyncErrorForBLoC<T>;
  //
  /// 🧭 True when current state is loading
  bool get isLoading => this is AsyncLoadingForBLoC<T>;
  //
  /// 🧭 True when current state is error
  bool get hasError => this is AsyncErrorForBLoC<T>;
  //
  /// 🧭 True when current state is data
  bool get hasValue => this is AsyncDataForBLoC<T>;
  //
  /// 📦 Value or `null` (when not data)
  T? get valueOrNull =>
      this is AsyncDataForBLoC<T> ? (this as AsyncDataForBLoC<T>).value : null;
  //
  /// 📦 Failure or `null` (when not error)
  Failure? get failureOrNull => this is AsyncErrorForBLoC<T>
      ? (this as AsyncErrorForBLoC<T>).failure
      : null;

  ////

  /// 🔁 Exhaustive pattern-match: loading/data/error
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  /// 🔁 Non-exhaustive: any missing branch falls back to [orElse]
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

  /// 🔀 Map payload in data branch; preserve loading/error
  AsyncValueForBLoC<R> map<R>(R Function(T) mapper) => when(
    loading: AsyncValueForBLoC<R>.loading,
    data: (v) => AsyncValueForBLoC<R>.data(mapper(v)),
    error: AsyncValueForBLoC<R>.error,
  );

  /// 🧲 Strict access to value (throws if not data)
  T get requireValue {
    if (this is AsyncDataForBLoC<T>) return (this as AsyncDataForBLoC<T>).value;
    throw StateError('No value present in AsyncValueForBLoC');
  }

  //
}

////
////

/// ⏳ Loading — equals any other Loading of same T.
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
  /// 🧬 Stable lightweight key to dedupe rebuilds
  @override
  List<Object?> get props => const ['loading'];
  //
}

////
////

/// ✅ Data — equality relies on [value]
/// 💡 Prefer `T` to be Equatable for deep equality
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
  //
}

////
////

/// 🧨 Error — equals by semantic code + message
//
final class AsyncErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///-------------------------------------------------------
  const AsyncErrorForBLoC(this.failure);
  //
  /// 🧩 Domain failure (type-safe)
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
  //
}
