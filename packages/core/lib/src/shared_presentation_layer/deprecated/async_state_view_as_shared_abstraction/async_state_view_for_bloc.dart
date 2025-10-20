/*


import 'package:bloc_adapter/src/core/presentation_shared/async_state/async_value_for_bloc.dart';
import 'package:core/public_api/core.dart';

/// 🔌 [AsyncStateViewForBloc] — AsyncStateView facade over [AsyncValueForBLoC] for Cubit/BLoC
/// ✅ Gives a single UI API: loading/data/error
///
final class AsyncStateViewForBloc<T> implements AsyncStateView<T> {
  ///-----------------------------------------------------------
  const AsyncStateViewForBloc(
    this._state, {
    this.preserveDataOnReload = true,
  });
  //
  /// 🌊 Source state
  final AsyncValueForBLoC<T> _state;
  //
  /// 🔧 If true & state — loading-with-data → gives `data(previousValue)`
  final bool preserveDataOnReload;
  //

  /// 🔁 Pattern-match style rendering: loading/data/error.
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    if (preserveDataOnReload && _state is AsyncLoadingWithDataForBLoC<T>) {
      return data(_state.previousValue);
    }
    return switch (_state) {
      AsyncLoadingForBLoC<T>() => loading(),
      AsyncLoadingWithDataForBLoC<T>() => loading(), // fallback
      AsyncLoadingWithErrorForBLoC<T>() => loading(),
      AsyncDataForBLoC<T>(:final value) => data(value),
      AsyncErrorForBLoC<T>(:final failure) => error(failure),
    };
  }

  /// 🔁 Non-exhaustive match with fallback. Partial match: missed branches → [orElse]
  @override
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

  /// 🧭 True when underlying state is in loading phase.
  @override
  bool get isLoading => _state.isLoading;

  /// 🧭 True when underlying state carries a value.
  @override
  bool get hasValue => _state.hasValue;

  /// 🧭 True when underlying state represents an error.
  @override
  bool get hasError => _state.hasError;

  /// 📦 Returns current value or `null` if none.
  @override
  T? get valueOrNull => _state.valueOrNull;

  /// 📦 Returns current [Failure] or `null` if none.
  @override
  Failure? get failureOrNull => _state.failureOrNull;
  //
}

////
////

/// ✨ Sugar: `asyncState.asAsyncStateView()` in widgets
extension AsyncStateAsViewBlocX<T> on AsyncValueForBLoC<T> {
  ///-----------------------------------------
  /// 🔁 Convert `AsyncState<T>` to [AsyncStateView] facade.
  AsyncStateView<T> asCubitAsyncStateView({
    bool preserveDataOnReload = true,
  }) => AsyncStateViewForBloc<T>(
    this,
    preserveDataOnReload: preserveDataOnReload,
  );
  //
}


/// !! Usage example:
    /// 🔌 Adapter: `AsyncState<UserEntity>` → `AsyncStateView<UserEntity>` (for state-agnostic UI)
    // final profileViewState = asyncState.asCubitAsyncStateView();


 */
