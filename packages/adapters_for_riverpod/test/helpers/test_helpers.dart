/// Test helpers and utilities for adapters_for_riverpod package tests
library;

import 'package:flutter_test/flutter_test.dart';

/// Wait for async operations in tests
Future<void> wait([int milliseconds = 100]) =>
    Future<void>.delayed(Duration(milliseconds: milliseconds));

/// Extension to await multiple futures in parallel
extension FutureListX<T> on List<Future<T>> {
  Future<List<T>> awaitAll() => Future.wait(this);
}
