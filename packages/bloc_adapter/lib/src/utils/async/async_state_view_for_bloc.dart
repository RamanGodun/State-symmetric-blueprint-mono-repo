import 'package:core/core.dart';

/// 🔌 [AsyncStateViewForBloc] — AsyncStateView facade over [AsyncValueForBLoC] for Cubit/BLoC
/// ✅ Gives a single UI API: loading/data/error
///
final class AsyncStateViewForBloc<T> implements AsyncStateView<T> {
  ///-----------------------------------------------------------
  AsyncStateViewForBloc(this._state);

  /// 🌊 Source state
  final AsyncValueForBLoC<T> _state;

  /// 🔁 Pattern-match style rendering: loading/data/error.
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    return switch (_state) {
      AsyncStateLoading<T>() => loading(),
      AsyncStateData<T>(:final value) => data(value),
      AsyncStateError<T>(:final failure) => error(failure),
    };
  }

  /// 🧭 True when underlying state is in loading phase.
  @override
  bool get isLoading => _state is AsyncStateLoading<T>;

  /// 🧭 True when underlying state carries a value.
  @override
  bool get hasValue => _state is AsyncStateData<T>;

  /// 🧭 True when underlying state represents an error.
  @override
  bool get hasError => _state is AsyncStateError<T>;

  /// 📦 Returns current value or `null` if none.
  @override
  T? get valueOrNull => _state is AsyncStateData<T> ? _state.value : null;

  /// 📦 Returns current [Failure] or `null` if none.
  @override
  Failure? get failureOrNull =>
      _state is AsyncStateError<T> ? _state.failure : null;
}

////

////

/// ✨ Sugar: `asyncState.asAsyncStateView()` in widgets
extension AsyncStateAsViewX<T> on AsyncValueForBLoC<T> {
  ///-----------------------------------------
  /// 🔁 Convert `AsyncState<T>` to [AsyncStateView] facade.
  AsyncStateView<T> asCubitAsyncStateView() => AsyncStateViewForBloc<T>(this);
  //
}
