import 'package:core/public_api/base_modules/errors_management.dart'
    show Failure, UnknownFailureType;
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 🧩 [AsyncValueMatchX] — extension for declarative and type-safe matching over [AsyncValue].
/// ✅ Unifies success / error / loading handling for Riverpod.
/// ✅ Guarantees that the error branch always receives a [Failure] (unknown errors → [UnknownFailureType]).
/// ✅ Provides a convenient UI API via `.match(...)` and `.matchOrNull(...)`.
//
extension AsyncValueMatchX<T> on AsyncValue<T> {
  //
  /// Declarative pattern match for [AsyncValue].
  /// Calls [onSuccess] if value is loaded, [onError] - if domain [Failure], or [onLoading] when loading
  R match<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
    required R Function() onLoading,
  }) {
    switch (this) {
      case AsyncData(:final value):
        return onSuccess(value);
      case AsyncLoading():
        return onLoading();
      case AsyncError(:final error):
        if (error is Failure) return onError(error);
        return onError(
          const Failure(
            type: UnknownFailureType(),
            message: 'Unknown error',
          ),
        );
    }
    // Unreachable, but need for type safety
    return onError(
      const Failure(
        type: UnknownFailureType(),
        message: 'Unreachable state',
      ),
    );
  }

  /// Same as [match], but returns `null` instead of invoking ['onLoading'].
  /// Useful for side-effects where loading branch is ignored.
  R? matchOrNull<R>({
    required R Function(T value) onSuccess,
    required R Function(Failure failure) onError,
  }) {
    return switch (this) {
      AsyncData(:final value) => onSuccess(value),
      AsyncError(:final error) => onError(
        error is Failure
            ? error
            : const Failure(
                type: UnknownFailureType(),
                message: 'Unknown error',
              ),
      ),
      _ => null,
    };
  }

  //
}
