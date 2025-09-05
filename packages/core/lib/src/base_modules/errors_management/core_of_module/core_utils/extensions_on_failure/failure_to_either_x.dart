import 'package:core/src/base_modules/errors_management/core_of_module/either.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';

/// 🔄 [FailureToEitherX] — Extension for mapping [Failure] into `Either.left`
//
extension FailureToEitherX on Failure {
  /// ❌ Converts this [Failure] into an `Either.left`
  Left<Failure, T> toLeft<T>() => Left(this);
}
