import 'package:shared_core_modules/src/errors_management/core_of_module/either.dart'
    show Left;
import 'package:shared_core_modules/src/errors_management/core_of_module/failure_entity.dart'
    show Failure;

/// 🔄 [FailureToEitherX] — Extension for mapping [Failure] into `Either.left`
//
extension FailureToEitherX on Failure {
  /// ❌ Converts this [Failure] into an `Either.left`
  Left<Failure, T> toLeft<T>() => Left(this);
}
