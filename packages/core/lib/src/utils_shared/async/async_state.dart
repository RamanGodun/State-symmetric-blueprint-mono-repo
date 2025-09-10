import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart'
    show Failure;
import 'package:equatable/equatable.dart';

/// 🧩 [AsyncState] — state-agnostic async shape (BLoC side)
/// ✅ Equatable-based equality → enables distinct-emits in Cubit
/// ✅ Mirrors Riverpod's AsyncValue ergonomics
//
sealed class AsyncState<T> extends Equatable {
  ///-------------------------------------
  /// 🏗️ Base constructor (sealed hierarchy)
  const AsyncState();

  /// ⏳ Factory — creates a loading state.
  const factory AsyncState.loading() = AsyncStateLoading<T>;

  /// ✅ Factory — creates a data state with [value].
  const factory AsyncState.data(T value) = AsyncStateData<T>;

  /// 🧨 Factory — creates an error state with [failure].
  const factory AsyncState.error(Failure failure) = AsyncStateError<T>;

  /// 🧭 True when current state is [AsyncStateLoading].
  bool get isLoading => this is AsyncStateLoading<T>;

  /// 🧭 True when current state is [AsyncStateError].
  bool get hasError => this is AsyncStateError<T>;

  /// 🧭 True when current state is [AsyncStateData].
  bool get hasValue => this is AsyncStateData<T>;

  /// 📦 Returns payload when state is [AsyncStateData], otherwise `null`.
  T? get valueOrNull =>
      this is AsyncStateData<T> ? (this as AsyncStateData<T>).value : null;

  /// 📦 Returns [Failure] when state is [AsyncStateError], otherwise `null`.
  Failure? get failureOrNull =>
      this is AsyncStateError<T> ? (this as AsyncStateError<T>).failure : null;

  /// 🔁 Exhaustive pattern-match for state rendering.
  ///
  /// - [loading] is called for [AsyncStateLoading]
  /// - [data] is called for [AsyncStateData] with payload
  /// - [error] is called for [AsyncStateError] with [Failure]
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
  AsyncState<R> map<R>(R Function(T) mapper) => when(
    loading: AsyncState<R>.loading,
    data: (v) => AsyncState<R>.data(mapper(v)),
    error: AsyncState<R>.error,
  );
  //
}

////

////

/// ⏳ Loading — equals any other Loading of same T.
//
final class AsyncStateLoading<T> extends AsyncState<T> {
  ///----------------------------------------------
  /// ⏳ Constructs the loading state.
  const AsyncStateLoading();

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
final class AsyncStateData<T> extends AsyncState<T> {
  ///------------------------------------------
  /// ✅ Constructs the data state with [value].
  const AsyncStateData(this.value);

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
final class AsyncStateError<T> extends AsyncState<T> {
  ///------------------------------------------
  /// 🧨 Constructs the error state with [failure].
  const AsyncStateError(this.failure);

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
