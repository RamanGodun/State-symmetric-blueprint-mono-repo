//
// ignore_for_file: public_member_api_docs

import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

extension AsyncValueToCoreAsync<T> on AsyncValue<T> {
  CoreAsync<T> toCoreAsync({Failure Function(Object, StackTrace)? map}) {
    return switch (this) {
      AsyncData(:final value) => CoreAsync<T>.data(value),
      AsyncLoading() => CoreAsync<T>.loading(),
      AsyncError(:final error, :final stackTrace) => CoreAsync<T>.error(
        (map ?? _defaultMap)(error, stackTrace),
      ),
      _ => CoreAsync<T>.loading(),
    };
  }
}

Failure _defaultMap(Object e, StackTrace st) => e.mapToFailure(st);
