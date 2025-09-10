import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart'
    show Failure;

/// 🔌 [AsyncStateView] — unified async-state interface for UI
/// ✅ Single shape across Riverpod/BLoC
/// ✅ Declarative `.when(...)` rendering
///
abstract interface class AsyncStateView<T> {
  ///------------------------------------
  /// 🔁 Pattern-match style rendering: loading/data/error.
  ///
  /// - [loading] renders while awaiting
  /// - [data] renders when payload is present
  /// - [error] renders when a [Failure] occurs
  R when<R>({
    required R Function() loading,
    required R Function(T data) data,
    required R Function(Failure failure) error,
  });

  /// 🧭 True when underlying state is in loading phase.
  bool get isLoading;

  /// 🧭 True when underlying state represents an error.
  bool get hasError;

  /// 🧭 True when underlying state carries a value.
  bool get hasValue;

  /// 📦 Returns current value or `null` if none.
  T? get valueOrNull;

  /// 📦 Returns current [Failure] or `null` if none.
  Failure? get failureOrNull;
  //
}
