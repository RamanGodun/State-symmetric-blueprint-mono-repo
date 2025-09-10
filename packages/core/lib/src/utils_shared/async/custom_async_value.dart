//
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart'
    show Failure;

sealed class CoreAsync<T> {
  const CoreAsync();

  const factory CoreAsync.loading() = CoreAsyncLoading<T>;
  factory CoreAsync.data(T value) = CoreAsyncData<T>;
  factory CoreAsync.error(Failure failure) = CoreAsyncError<T>;

  bool get isLoading => this is CoreAsyncLoading<T>;
  bool get hasError => this is CoreAsyncError<T>;
  bool get hasValue => this is CoreAsyncData<T>;

  T? get valueOrNull =>
      this is CoreAsyncData<T> ? (this as CoreAsyncData<T>).value : null;
  Object? get errorOrNull =>
      this is CoreAsyncError<T> ? (this as CoreAsyncError<T>).failure : null;

  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

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

  CoreAsync<R> map<R>(R Function(T) mapper) => when(
    loading: CoreAsync<R>.loading,
    data: (v) => CoreAsync<R>.data(mapper(v)),
    error: CoreAsync<R>.error,
  );
}

final class CoreAsyncLoading<T> extends CoreAsync<T> {
  const CoreAsyncLoading();
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => loading();
}

final class CoreAsyncData<T> extends CoreAsync<T> {
  const CoreAsyncData(this.value);
  final T value;
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => data(value);
}

final class CoreAsyncError<T> extends CoreAsync<T> {
  const CoreAsyncError(this.failure);
  final Failure failure;
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) => error(failure);
}
