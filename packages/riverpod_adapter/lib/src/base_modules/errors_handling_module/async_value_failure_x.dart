import 'package:core/base_modules/errors_management.dart' show Failure;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncError, AsyncValue;

/// 🧩 [AsyncValueFailureX] — extensions for extracting domain [Failure] from [AsyncValue].
/// ✅ Works only if error is a [Failure]
/// ✅ Null-safe: returns `null` otherwise
///
extension AsyncValueFailureX<T> on AsyncValue<T> {
  /// ❌ Extracts [Failure] if this is an [AsyncError] with a domain failure.
  /// Returns `null` when error is not a [Failure].
  Failure? get failureOrNull {
    if (this is AsyncError<T>) {
      final e = (this as AsyncError<T>).error;
      if (e is Failure) return e;
    }
    return null;
  }

  /// 🔄 Alias for [failureOrNull] (semantic sugar for readability).
  Failure? get asFailure => failureOrNull;

  //
}
