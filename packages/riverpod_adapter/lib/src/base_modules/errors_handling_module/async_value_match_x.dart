import 'package:core/base_modules/errors_management.dart'
    show Failure, UnknownFailureType;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧩 [AsyncValueMatchX] — extension for declarative, type-safe branching over [AsyncValue]
/// ✅ Makes UI logic concise and cubit-consistent: success, error, loading handled in one place
/// ✅ Guarantees only domain [Failure] errors are passed to onError
/// ✅ Ensures fallback even for unknown errors (never throws)
///
extension AsyncValueMatchX<T> on AsyncValue<T> {
  //
  /// Declarative pattern-match for [AsyncValue] states.
  ///
  /// - [onSuccess] called if value is loaded
  /// - [onError] called if error (only domain [Failure])
  /// - [onLoading] called if loading (optional)
  ///
  /// Ensures only [Failure] gets into [onError], unknown errors fallback to [UnknownFailureType].
  void fold({
    required void Function(T value) onSuccess, // Handler for loaded value
    required void Function(Failure failure) onError, // Handler for domain error
    void Function()? onLoading, // Optional loading handler
  }) {
    switch (this) {
      case AsyncData(:final value):
        onSuccess(value); // Success branch
      case AsyncLoading():
        onLoading?.call(); // Loading branch (optional)
      case AsyncError(:final error) when error is Failure:
        onError(error); // Failure from domain
      default:
        // Fallback for unknown error shape (guarantees domain Failure for error UI)
        onError(
          const Failure(type: UnknownFailureType(), message: 'Unknown error'),
        );
    }
  }
}
