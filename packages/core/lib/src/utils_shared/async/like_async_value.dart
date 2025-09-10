//
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart'
    show Failure;

/// Єдиний спільний API для "асинхронного стану"
abstract interface class AsyncLike<T> {
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  bool get isLoading;
  bool get hasError;
  bool get hasValue;

  T? get valueOrNull;
  Failure? get failureOrNull;
}
