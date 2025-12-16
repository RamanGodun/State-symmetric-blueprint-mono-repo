import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart' show equals, expect, isTrue;

/// 🧪 [ResultFutureTestX] — Fluent test helpers for async Either
/// ✅ Provides concise, chainable assertions for `Future<Either<Failure, T>>`
/// ✅ Uses proper `expect()` calls (not assert) for test framework compatibility
//
extension ResultFutureTestX<T> on Future<Either<Failure, T>> {
  ///------------------------------------------------------

  /// ✅ Expect that future resolves to Right with [expected] value
  ///
  /// Example:
  /// ```dart
  /// await operation.runWithErrorHandling().expectSuccess(42);
  /// ```
  Future<void> expectSuccess(T expected) async {
    final result = await this;
    expect(
      result.isRight,
      isTrue,
      reason: 'Expected Right but got Left: ${result.leftOrNull}',
    );
    expect(
      result.rightOrNull,
      equals(expected),
      reason: 'Expected value $expected but got ${result.rightOrNull}',
    );
  }

  /// ✅ Expect that future resolves to Left (optionally matching [code])
  ///
  /// Examples:
  /// ```dart
  /// // Just check it's a failure
  /// await operation.runWithErrorHandling().expectFailure();
  ///
  /// // Check failure code matches
  /// await operation.runWithErrorHandling().expectFailure('NETWORK');
  /// ```
  Future<void> expectFailure([String? code]) async {
    final result = await this;
    expect(
      result.isLeft,
      isTrue,
      reason: 'Expected Left but got Right: ${result.rightOrNull}',
    );
    if (code != null) {
      expect(
        result.leftOrNull?.safeCode,
        equals(code),
        reason:
            'Expected failure code $code but got ${result.leftOrNull?.safeCode}',
      );
    }
  }

  //
}
