import 'package:core/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔌 [AsyncValueToAsyncState] — bridges Riverpod async to core shape
/// ✅ Keeps UI/widgets state-agnostic between apps
///
extension AsyncValueToAsyncState<T> on AsyncValue<T> {
  ///----------------------------------------------
  /// 🔄 Converts `AsyncValue<T>` into `AsyncState<T>`.
  ///     - Maps `AsyncLoading` → `AsyncState.loading()`
  ///     - Maps `AsyncData` → `AsyncState.data(value)`
  ///     - Maps `AsyncError` → `AsyncState.error(mappedFailure)`
  ///     - Unknown states fallback to `AsyncState.loading()`
  ///
  /// [map] is a custom mapper `(Object, StackTrace) -> Failure`.
  /// If omitted, defaults to centralized `e.mapToFailure(st)`.
  AsyncState<T> toAsyncState({Failure Function(Object, StackTrace)? map}) {
    return switch (this) {
      AsyncData(:final value) => AsyncState<T>.data(value),
      AsyncLoading() => AsyncState<T>.loading(),
      AsyncError(:final error, :final stackTrace) => AsyncState<T>.error(
        (map ?? _defaultMap)(error, stackTrace),
      ),
      _ => AsyncState<T>.loading(),
    };
  }
}

////
////

/// 🛡️ Default mapper: Exception/Error → Failure (centralized).
//
Failure _defaultMap(Object e, StackTrace st) => e.mapToFailure(st);
