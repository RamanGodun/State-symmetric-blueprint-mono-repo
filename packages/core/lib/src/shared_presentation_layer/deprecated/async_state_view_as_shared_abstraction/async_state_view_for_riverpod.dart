/*


import 'package:core/public_api/core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🔌 [AsyncStateViewForRiverpod] — facade over Riverpod `AsyncValue<T>`
/// ✅ Single UI API: loading/data/error via [AsyncStateView]
/// ✅ Configurable option to "preserve data during reload"
///
final class AsyncStateViewForRiverpod<T> implements AsyncStateView<T> {
  ///---------------------------------------------------------------
  const AsyncStateViewForRiverpod(
    this._value, {
    this.preserveDataOnReload = true,
  });

  /// 🌊 Source state (native Riverpod AsyncValue)
  final AsyncValue<T> _value;

  /// 🔧 If true and reload happens while previous value exists —
  /// call `data(...)` instead of `loading()`
  final bool preserveDataOnReload;

  /// 🔁 Exhaustive render: loading/data/error
  @override
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  }) {
    // ✅ Preserve previous content during refresh (if enabled)
    if (preserveDataOnReload && _value.isLoading && _value.hasValue) {
      return data(_value.value as T);
    }

    // 🔁 Native Riverpod expansion with error → Failure mapping
    return _value.when(
      loading: loading,
      data: data,
      error: (e, st) => error(e is Failure ? e : e.mapToFailure(st)),
    );
  }

  /// 🔁 Non-exhaustive match with fallback.
  /// Partial match: skipped branches → [orElse]
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

  /// 🧭 State flags
  @override
  bool get isLoading => _value.isLoading;
  @override
  bool get hasValue => _value.hasValue;
  @override
  bool get hasError => _value.hasError;

  /// 📦 Current data / failure (if available)
  @override
  T? get valueOrNull => _value.valueOrNull;

  /// 📦 Domain [Failure] if error, else `null` (safe accessor).
  @override
  Failure? get failureOrNull {
    final v = _value;
    if (v is! AsyncError) return null;
    final err = v.error;
    if (err is Failure) return err;
    return (err ?? 'Unknown error').mapToFailure(v.stackTrace);
  }

  //
}

////
////

/// ✨ Sugar: ergonomic conversion in widgets
extension AsyncStateAsViewRiverpodX<T> on AsyncValue<T> {
  ///
  AsyncStateView<T> asRiverpodAsyncStateView({
    bool preserveDataOnReload = true,
  }) => AsyncStateViewForRiverpod<T>(
    this,
    preserveDataOnReload: preserveDataOnReload,
  );
  //
}


/// !! Usage example:
    /// 🔌 Adapter: `AsyncValue<UserEntity>` → `AsyncStateView<UserEntity>` (for state-agnostic UI)
    // final profileViewState = asyncUser.asRiverpodAsyncStateView();



 */
