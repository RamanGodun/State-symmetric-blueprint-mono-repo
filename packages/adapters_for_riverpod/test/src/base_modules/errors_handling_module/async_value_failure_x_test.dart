/// Tests for AsyncValueFailureX extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - failureOrNull getter for all AsyncValue states
/// - asFailure alias
/// - Edge cases (non-Failure errors, null states)
library;

import 'package:adapters_for_riverpod/src/base_modules/errors_handling_module/async_value_failure_x.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('AsyncValueFailureX', () {
    group('failureOrNull', () {
      test('returns Failure when AsyncError contains Failure', () {
        // Arrange
        const failure = Failure(
          message: 'Test failure',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, isA<Failure>());
        expect(result?.message, equals('Test failure'));
      });

      test('returns null when AsyncError contains non-Failure error', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('Regular exception'),
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns null when AsyncValue is data state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.data('test data');

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns null when AsyncValue is loading state', () {
        // Arrange
        const asyncValue = AsyncValue<String>.loading();

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('handles Failure with different types', () {
        // Arrange
        const networkFailure = Failure(
          message: 'Network error',
          type: NetworkFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          networkFailure,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result?.type, isA<NetworkFailureType>());
        expect(result?.message, equals('Network error'));
      });

      test('handles AsyncError with String error', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          'String error',
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('works with different generic types', () {
        // Arrange
        const failure = Failure(
          message: 'Integer failure',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<int>.error(
          failure,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, isA<Failure>());
      });
    });

    group('asFailure', () {
      test('is alias for failureOrNull', () {
        // Arrange
        const failure = Failure(
          message: 'Test failure',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );

        // Act
        final resultFromFailureOrNull = asyncValue.failureOrNull;
        final resultFromAsFailure = asyncValue.asFailure;

        // Assert
        expect(resultFromAsFailure, equals(resultFromFailureOrNull));
        expect(resultFromAsFailure, isNotNull);
        expect(resultFromAsFailure, isA<Failure>());
      });

      test('returns same null when not a Failure', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          Exception('Not a failure'),
          StackTrace.current,
        );

        // Act
        final resultFromFailureOrNull = asyncValue.failureOrNull;
        final resultFromAsFailure = asyncValue.asFailure;

        // Assert
        expect(resultFromAsFailure, equals(resultFromFailureOrNull));
        expect(resultFromAsFailure, isNull);
      });

      test('provides semantic sugar for readability', () {
        // Arrange
        const failure = Failure(
          message: 'Semantic test',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );

        // Act - Both should work identically
        final usingFailureOrNull = asyncValue.failureOrNull;
        final usingAsFailure = asyncValue.asFailure;

        // Assert
        expect(usingAsFailure?.message, equals(usingFailureOrNull?.message));
      });
    });

    group('edge cases', () {
      test('handles AsyncError with different error types', () {
        // Arrange
        final asyncValue = AsyncValue<String>.error(
          const FormatException('Format error'),
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        expect(result, isNull);
      });

      test('handles complex object in error', () {
        // Arrange
        final complexError = {
          'code': 500,
          'message': 'Server error',
        };
        final asyncValue = AsyncValue<String>.error(
          complexError,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        // Should return null because error is not a Failure
        expect(result, isNull);
      });

      test('handles list of errors', () {
        // Arrange
        final errorList = ['Error 1', 'Error 2'];
        final asyncValue = AsyncValue<String>.error(
          errorList,
          StackTrace.current,
        );

        // Act
        final result = asyncValue.failureOrNull;

        // Assert
        // Should return null because error is not a Failure
        expect(result, isNull);
      });
    });

    group('real-world scenarios', () {
      test('extracts Failure from failed API call', () {
        // Arrange - Simulate API failure
        const apiFailure = Failure(
          message: 'API request failed: 404 Not Found',
          type: NetworkFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          apiFailure,
          StackTrace.current,
        );

        // Act
        final failure = asyncValue.failureOrNull;

        // Assert - Can extract and handle domain failure
        expect(failure, isNotNull);
        expect(failure?.message, contains('404'));
        expect(failure?.type, isA<NetworkFailureType>());
      });

      test('distinguishes between domain and system errors', () {
        // Arrange
        const domainFailure = Failure(
          message: 'User not found',
          type: UnknownFailureType(),
        );
        final domainError = AsyncValue<String>.error(
          domainFailure,
          StackTrace.current,
        );

        final systemError = AsyncValue<String>.error(
          StateError('System exception'),
          StackTrace.current,
        );

        // Act
        final domainResult = domainError.failureOrNull;
        final systemResult = systemError.failureOrNull;

        // Assert
        expect(domainResult, isNotNull); // Domain failure extracted
        expect(systemResult, isNull); // System error not extracted
      });

      test('used in error handling flow', () {
        // Arrange - Simulate provider error state
        const failure = Failure(
          message: 'Authentication failed',
          type: UnknownFailureType(),
        );
        final asyncValue = AsyncValue<String>.error(
          failure,
          StackTrace.current,
        );

        // Act - Check if we can display user-friendly error
        final userFacingError = asyncValue.asFailure;
        final shouldShowDialog = userFacingError != null;
        final errorMessage = userFacingError?.message ?? 'Unknown error';

        // Assert
        expect(shouldShowDialog, isTrue);
        expect(errorMessage, equals('Authentication failed'));
      });
    });
  });
}
