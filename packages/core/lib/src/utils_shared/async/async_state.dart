import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart'
    show Failure;
import 'package:equatable/equatable.dart';

/// 🧩 [AsyncValueForBLoC] — state-agnostic async shape (BLoC side)
/// ✅ Equatable-based equality → enables distinct-emits in Cubit
/// ✅ Mirrors Riverpod's AsyncValue ergonomics
//
sealed class AsyncValueForBLoC<T> extends Equatable {
  ///-------------------------------------
  /// 🏗️ Base constructor (sealed hierarchy)
  const AsyncValueForBLoC();

  /// ⏳ Factory — creates a loading state.
  const factory AsyncValueForBLoC.loading() = AsyncLoadingForBLoC<T>;

  /// ✅ Factory — creates a data state with [value].
  const factory AsyncValueForBLoC.data(T value) = AsyncDataForBLoC<T>;

  /// 🧨 Factory — creates an error state with [failure].
  const factory AsyncValueForBLoC.error(Failure failure) = AsyncErrorForBLoC<T>;

  /// 🧭 True when current state is [AsyncLoadingForBLoC].
  bool get isLoading => this is AsyncLoadingForBLoC<T>;

  /// 🧭 True when current state is [AsyncErrorForBLoC].
  bool get hasError => this is AsyncErrorForBLoC<T>;

  /// 🧭 True when current state is [AsyncDataForBLoC].
  bool get hasValue => this is AsyncDataForBLoC<T>;

  /// 📦 Returns payload when state is [AsyncDataForBLoC], otherwise `null`.
  T? get valueOrNull =>
      this is AsyncDataForBLoC<T> ? (this as AsyncDataForBLoC<T>).value : null;

  /// 📦 Returns [Failure] when state is [AsyncErrorForBLoC], otherwise `null`.
  Failure? get failureOrNull => this is AsyncErrorForBLoC<T>
      ? (this as AsyncErrorForBLoC<T>).failure
      : null;

  /// 🔁 Exhaustive pattern-match for state rendering.
  ///
  /// - [loading] is called for [AsyncLoadingForBLoC]
  /// - [data] is called for [AsyncDataForBLoC] with payload
  /// - [error] is called for [AsyncErrorForBLoC] with [Failure]
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  /// 🔁 Non-exhaustive pattern-match with fallback [orElse].
  ///
  /// Any missing branch defaults to calling [orElse].
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

  /// 🔀 Maps payload in the data branch, preserving other branches.
  AsyncValueForBLoC<R> map<R>(R Function(T) mapper) => when(
    loading: AsyncValueForBLoC<R>.loading,
    data: (v) => AsyncValueForBLoC<R>.data(mapper(v)),
    error: AsyncValueForBLoC<R>.error,
  );

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
  ///----------------------------------------------
  /// ⏳ Constructs the loading state.
  const AsyncLoadingForBLoC();

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => loading();

  /// 🧬 Stable lightweight key to dedupe rebuilds.
  @override
  List<Object?> get props => const ['loading'];
  //
}

////

////

/// ✅ Data — equality relies on [value].
/// 💡 Prefer `T` to implement `Equatable` for deep equality.
//
final class AsyncDataForBLoC<T> extends AsyncValueForBLoC<T> {
  ///------------------------------------------
  /// ✅ Constructs the data state with [value].
  const AsyncDataForBLoC(this.value);

  /// 📦 Payload contained in the data state.
  final T value;

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => data(value);

  @override
  List<Object?> get props => [value];
  //
}

////

////

/// 🧨 Error — equals by semantic code + message.
//
final class AsyncErrorForBLoC<T> extends AsyncValueForBLoC<T> {
  ///------------------------------------------
  /// 🧨 Constructs the error state with [failure].
  const AsyncErrorForBLoC(this.failure);

  /// 🧩 Domain failure (type-safe).
  final Failure failure;

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => error(failure);

  @override
  List<Object?> get props => [failure.safeCode, failure.message];
  //
}
