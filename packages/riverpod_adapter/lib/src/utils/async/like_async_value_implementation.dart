//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart'; // Failure + mapToFailure
import 'package:flutter_riverpod/flutter_riverpod.dart';

final class RiverpodAsyncLike<T> implements AsyncLike<T> {
  RiverpodAsyncLike(this._value, this._map);
  final AsyncValue<T> _value;
  final Failure Function(Object, StackTrace) _map;

  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    return _value.when(
      loading: loading,
      data: data,
      error: (e, st) => error(_map(e, st)),
    );
  }

  @override
  bool get isLoading => _value.isLoading;

  @override
  bool get hasValue => _value.hasValue;

  @override
  bool get hasError => _value.hasError;

  @override
  T? get valueOrNull => _value.valueOrNull;

  @override
  Failure? get failureOrNull {
    // Найнадійніше — перевірити обидва варіанти generic/erased
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
}

Failure _defaultMap(Object e, StackTrace st) => e.mapToFailure(st);

extension AsAsyncLike<T> on AsyncValue<T> {
  AsyncLike<T> asAsyncLike({
    Failure Function(Object, StackTrace)? map,
  }) => RiverpodAsyncLike<T>(this, map ?? _defaultMap);
}
