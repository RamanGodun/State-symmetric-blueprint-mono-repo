/// Test helpers and utilities for features_dd_layers package tests
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

/// Wait for async operations in tests
Future<void> wait([int milliseconds = 100]) =>
    Future<void>.delayed(Duration(milliseconds: milliseconds));

/// Extension to await multiple futures in parallel
extension FutureListX<T> on List<Future<T>> {
  Future<List<T>> awaitAll() => Future.wait(this);
}

/// Extension to create test failures
extension TestFailureX on String {
  /// Creates a Failure for testing
  Failure toFailure() => Failure(
    message: this,
    type: const UnknownFailureType(),
  );
}
