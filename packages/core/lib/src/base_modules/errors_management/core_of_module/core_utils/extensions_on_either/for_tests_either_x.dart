import 'package:core/src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/either.dart'
    show Either;
import 'package:core/src/base_modules/errors_management/core_of_module/failure_entity.dart';

/// 🧪 [ResultFutureTestX] — Fluent test helpers for async Either
//
extension ResultFutureTestX<T> on Future<Either<Failure, T>> {
  ///------------------------------------------------------

  /// ✅ Expect that future resolves to Right with [expected] value
  Future<void> expectSuccess(T expected) async {
    final result = await this;
    assert(
      result.isRight,
      r'Expected Right but got Left: ${result.leftOrNull}',
    );
    assert(
      result.rightOrNull == expected,
      r'Expected value $expected but got ${result.rightOrNull}',
    );
  }

  /// ✅ Expect that future resolves to Left (optionally matching [code])
  Future<void> expectFailure([String? code]) async {
    final result = await this;
    assert(
      result.isLeft,
      r'Expected Left but got Right: ${result.rightOrNull}',
    );
    if (code != null) {
      assert(
        result.leftOrNull?.safeCode == code,
        r'Expected failure code $code but got ${result.leftOrNull?.safeCode}',
      );
    }
  }

  //
}
