import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔌 [AsyncStateViewForRiverpod] — AsyncLike facade for Riverpod's AsyncValue
/// ✅ Unifies UI branch rendering with BLoC's [AsyncValueForBLoC]
//
final class AsyncStateViewForRiverpod<T> implements AsyncStateView<T> {
  ///----------------------------------------------
  AsyncStateViewForRiverpod(this._value, this._map);

  /// 🌊 Source value
  final AsyncValue<T> _value;

  /// 🗺️ Error mapper (Exception/Error → Failure)
  final Failure Function(Object, StackTrace) _map;

  /// 🔁 Pattern-match style rendering: loading/data/error.
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    if (_value.isLoading && _value.hasValue) {
      return data(_value.value as T);
    }
    return _value.when(
      loading: loading,
      data: data,
      error: (e, st) => error(_map(e, st)),
    );
  }

  /// 🧭 True when underlying state is in loading phase.
  @override
  bool get isLoading => _value.isLoading;

  /// 🧭 True when underlying state carries a value.
  @override
  bool get hasValue => _value.hasValue;

  /// 🧭 True when underlying state represents an error.
  @override
  bool get hasError => _value.hasError;

  /// 📦 Returns current value or `null` if none.
  @override
  T? get valueOrNull => _value.valueOrNull;

  /// 📦 Returns current [Failure] or `null` if none.
  @override
  Failure? get failureOrNull {
    // 🧯 Backward-compat path for erased AsyncError (generic/erased)
    if (_value is AsyncError<T>) {
      final err = _value;
      return _map(err.error, err.stackTrace);
    }
    if (_value is AsyncError) {
      final err = _value as AsyncError;
      return _map(err.error, err.stackTrace);
    }
    return null;
  }

  //
}

////
////

/// ✨ Sugar: `asyncValue.asAsyncLike()` in widgets
//
extension AsAsyncLike<T> on AsyncValue<T> {
  ///-----------------------------------
  //
  /// 🔁 Convert to AsyncLike facade
  AsyncStateView<T> asRiverpodAsyncStateView({
    Failure Function(Object, StackTrace)? map,
  }) => AsyncStateViewForRiverpod<T>(this, map ?? _defaultMap);
  //
}

/// 🛡️ Default mapper: Exception/Error → Failure (centralized).
Failure _defaultMap(Object e, StackTrace st) => e.mapToFailure(st);
