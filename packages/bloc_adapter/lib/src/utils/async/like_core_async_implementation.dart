import 'package:core/core.dart'; // Failure + CoreAsync

/// 🔌 [CoreAsyncLike] — AsyncLike-інтерфейс (для Cubit/BLoC) поверх [CoreAsync<T>]
/// ✅ Дає єдиний API для UI: loading/data/error
//
final class CoreAsyncLike<T> implements AsyncLike<T> {
  ///----------------------------------------------
  CoreAsyncLike(this._state);
  final CoreAsync<T> _state;

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    return switch (_state) {
      CoreAsyncLoading<T>() => loading(),
      CoreAsyncData<T>(:final value) => data(value),
      CoreAsyncError<T>(:final failure) => error(failure),
    };
  }

  @override
  bool get isLoading => _state is CoreAsyncLoading<T>;

  @override
  bool get hasValue => _state is CoreAsyncData<T>;

  @override
  bool get hasError => _state is CoreAsyncError<T>;

  @override
  T? get valueOrNull => _state is CoreAsyncData<T> ? _state.value : null;

  @override
  Failure? get failureOrNull =>
      _state is CoreAsyncError<T> ? _state.failure : null;

  //
}

////

////

/// ✨ Зручне перетворення в AsyncLike
//
extension CoreAsyncAsLikeX<T> on CoreAsync<T> {
  ///---------------------------------------
  AsyncLike<T> asAsyncLike() => CoreAsyncLike<T>(this);
}
