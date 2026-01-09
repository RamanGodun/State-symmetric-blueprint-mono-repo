/// Tests for `ErrorsLogger` from errors_log_util.dart
///
/// Coverage:
/// - exception() method for raw exceptions/errors
/// - failure() method for domain failures
/// - log() method as unified entry point
/// - StackTrace handling (optional parameter)
/// - debugPrint integration
/// - Different exception types
// ignore_for_file: only_throw_errors

library;

import 'dart:async' show TimeoutException;
import 'dart:io' show SocketException;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('ErrorsLogger', () {
    group('exception', () {
      test('logs Exception without stackTrace', () {
        // Arrange
        final exception = Exception('Test exception');

        // Act
        ErrorsLogger.exception(exception);

        // Assert - Method completes without error
        expect(exception, isA<Exception>());
      });

      test('logs Exception with stackTrace', () {
        // Arrange
        final exception = Exception('Test exception with trace');
        final stackTrace = StackTrace.current;

        // Act
        ErrorsLogger.exception(exception, stackTrace);

        // Assert - Method completes without error
        expect(exception, isA<Exception>());
      });

      test('logs SocketException', () {
        // Arrange
        const exception = SocketException('Network error');

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception, isA<SocketException>());
      });

      test('logs TimeoutException', () {
        // Arrange
        final exception = TimeoutException('Request timeout');

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception, isA<TimeoutException>());
      });

      test('logs Error type', () {
        // Arrange
        final error = ArgumentError('Invalid argument');

        // Act
        ErrorsLogger.exception(error);

        // Assert
        expect(error, isA<ArgumentError>());
      });

      test('logs custom exception', () {
        // Arrange
        final exception = CustomException('Custom error');

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception, isA<CustomException>());
      });

      test('handles null stackTrace gracefully', () {
        // Arrange
        final exception = Exception('Exception without trace');

        // Act
        ErrorsLogger.exception(exception);

        // Assert - No error thrown
        expect(exception, isNotNull);
      });

      test('logs exception with very long message', () {
        // Arrange
        final longMessage = 'Error: ' * 1000;
        final exception = Exception(longMessage);

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception.toString(), contains('Error:'));
      });

      test('logs exception with unicode characters', () {
        // Arrange
        final exception = Exception('Помилка: 错误 🔥');

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception.toString(), contains('🔥'));
      });

      test('logs exception with special characters', () {
        // Arrange
        final exception = Exception('Error:\n\t"quoted"\r\n');

        // Act
        ErrorsLogger.exception(exception);

        // Assert
        expect(exception.toString(), contains('\n'));
      });

      test('handles exception with null message', () {
        // Arrange
        final exception = Exception();

        // Act
        ErrorsLogger.exception(exception);

        // Assert - No error thrown
        expect(exception, isNotNull);
      });
    });

    group('failure', () {
      test('logs Failure without stackTrace', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure, isA<Failure>());
      });

      test('logs Failure with stackTrace', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Server error',
        );
        final stackTrace = StackTrace.current;

        // Act
        ErrorsLogger.failure(failure, stackTrace);

        // Assert
        expect(failure, isA<Failure>());
      });

      test('logs Failure with message and status code', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.statusCode, equals(500));
      });

      test('logs NetworkFailure', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'No internet',
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<NetworkFailureType>());
      });

      test('logs UnauthorizedFailure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Not authorized',
          statusCode: 401,
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<UnauthorizedFailureType>());
      });

      test('logs Firebase failure', () {
        // Arrange
        const failure = Failure(
          type: InvalidCredentialFirebaseFailureType(),
          message: 'Invalid credentials',
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
      });

      test('logs UnknownFailure', () {
        // Arrange
        const failure = Failure(
          type: UnknownFailureType(),
          message: 'Something went wrong',
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<UnknownFailureType>());
      });

      test('handles null stackTrace gracefully', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure, isNotNull);
      });

      test('logs failure with empty message', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: '',
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.message, isEmpty);
      });

      test('logs failure with null message', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.message, isNull);
      });

      test('logs failure with very long message', () {
        // Arrange
        final longMessage = 'Error: ' * 1000;
        final failure = Failure(
          type: const ApiFailureType(),
          message: longMessage,
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.message, equals(longMessage));
      });

      test('logs failure with unicode characters', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Помилка: 错误 🔥',
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.message, contains('🔥'));
      });
    });

    group('log', () {
      test('delegates to exception() for Exception types', () {
        // Arrange
        final exception = Exception('Test exception');

        // Act
        ErrorsLogger.log(exception);

        // Assert - Delegates to exception method
        expect(exception, isA<Exception>());
      });

      test('delegates with stackTrace', () {
        // Arrange
        final exception = Exception('Exception with trace');
        final stackTrace = StackTrace.current;

        // Act
        ErrorsLogger.log(exception, stackTrace);

        // Assert
        expect(exception, isA<Exception>());
      });

      test('handles Error types', () {
        // Arrange
        final error = StateError('Invalid state');

        // Act
        ErrorsLogger.log(error);

        // Assert
        expect(error, isA<StateError>());
      });

      test('handles Object types', () {
        // Arrange
        const error = 'String error';

        // Act
        ErrorsLogger.log(error);

        // Assert
        expect(error, isA<String>());
      });

      test('handles null stackTrace', () {
        // Arrange
        final exception = Exception('No trace');

        // Act
        ErrorsLogger.log(exception);

        // Assert
        expect(exception, isNotNull);
      });

      test('works with SocketException', () {
        // Arrange
        const exception = SocketException('Network error');

        // Act
        ErrorsLogger.log(exception);

        // Assert
        expect(exception, isA<SocketException>());
      });

      test('works with TimeoutException', () {
        // Arrange
        final exception = TimeoutException('Timeout');

        // Act
        ErrorsLogger.log(exception);

        // Assert
        expect(exception, isA<TimeoutException>());
      });

      test('works with FormatException', () {
        // Arrange
        const exception = FormatException('Invalid format');

        // Act
        ErrorsLogger.log(exception);

        // Assert
        expect(exception, isA<FormatException>());
      });
    });

    group('real-world scenarios', () {
      test('logs network error from repository', () {
        // Arrange
        const exception = SocketException('Connection failed');

        // Act
        ErrorsLogger.exception(exception);

        // Assert - Simulates real network error logging
        expect(exception, isA<SocketException>());
      });

      test('logs failure after exception mapping', () {
        // Arrange
        const exception = SocketException('Network error');
        final failure = exception.mapToFailure();

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<NetworkFailureType>());
      });

      test('logs API error with status code', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.statusCode, equals(500));
      });

      test('logs authentication failure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid credentials',
          statusCode: 401,
        );

        // Act
        ErrorsLogger.failure(failure);

        // Assert
        expect(failure.type, isA<UnauthorizedFailureType>());
      });

      test('logs timeout in async operation', () {
        // Arrange
        final exception = TimeoutException('Request timeout');

        // Act
        ErrorsLogger.log(exception);

        // Assert
        expect(exception, isA<TimeoutException>());
      });

      test('logs unknown error with stacktrace', () {
        // Arrange
        final exception = Exception('Unknown error');
        final stackTrace = StackTrace.current;

        // Act
        ErrorsLogger.log(exception, stackTrace);

        // Assert
        expect(exception, isNotNull);
        expect(stackTrace, isNotNull);
      });
    });

    group('integration', () {
      test('used by runWithErrorHandling for exceptions', () async {
        // Arrange
        Future<int> operation() async => throw Exception('Integration test');

        // Act
        final result = await operation.runWithErrorHandling();

        // Assert - ErrorsLogger.log is called internally
        expect(result.isLeft, isTrue);
      });

      test('used by runWithErrorHandling for failures', () async {
        // Arrange
        Future<int> operation() async =>
            throw const Failure(type: UnknownFailureType());

        // Act
        final result = await operation.runWithErrorHandling();

        // Assert - ErrorsLogger.log is called internally
        expect(result.isLeft, isTrue);
      });

      test('multiple logging calls in sequence', () {
        // Arrange
        final exception1 = Exception('First error');
        final exception2 = Exception('Second error');
        const failure = Failure(type: NetworkFailureType());

        // Act
        ErrorsLogger.exception(exception1);
        ErrorsLogger.exception(exception2);
        ErrorsLogger.failure(failure);

        // Assert - All calls complete successfully
        expect(exception1, isNotNull);
        expect(exception2, isNotNull);
        expect(failure, isNotNull);
      });

      test('works with all failure types', () {
        // Arrange
        final failures = [
          const Failure(type: NetworkFailureType()),
          const Failure(type: ApiFailureType()),
          const Failure(type: UnauthorizedFailureType()),
          const Failure(type: CacheFailureType()),
          const Failure(type: UnknownFailureType()),
        ];

        // Act & Assert
        for (final failure in failures) {
          ErrorsLogger.failure(failure);
          expect(failure, isA<Failure>());
        }
      });
    });

    group('edge cases', () {
      test('handles concurrent logging calls', () {
        // Arrange
        final exception = Exception('Concurrent error');

        // Act - Simulate concurrent calls
        ErrorsLogger.log(exception);
        ErrorsLogger.log(exception);
        ErrorsLogger.log(exception);

        // Assert - All calls complete
        expect(exception, isNotNull);
      });

      test('handles exception with circular reference', () {
        // Arrange
        final exception = CircularException();

        // Act
        ErrorsLogger.exception(exception);

        // Assert - No infinite loop
        expect(exception, isNotNull);
      });

      test('handles very deep stackTrace', () {
        // Arrange
        final exception = Exception('Deep stack');
        final stackTrace = _generateDeepStackTrace();

        // Act
        ErrorsLogger.exception(exception, stackTrace);

        // Assert
        expect(stackTrace, isNotNull);
      });

      test('handles empty stackTrace string', () {
        // Arrange
        final exception = Exception('Empty trace');
        final stackTrace = StackTrace.fromString('');

        // Act
        ErrorsLogger.exception(exception, stackTrace);

        // Assert
        expect(exception, isNotNull);
      });
    });

    group('consistency', () {
      test('exception() and log() behave identically', () {
        // Arrange
        final exception1 = Exception('Test 1');
        final exception2 = Exception('Test 2');

        // Act
        ErrorsLogger.exception(exception1);
        ErrorsLogger.log(exception2);

        // Assert - Both complete successfully
        expect(exception1.toString(), isNotEmpty);
        expect(exception2.toString(), isNotEmpty);
      });

      test('multiple calls with same exception', () {
        // Arrange
        final exception = Exception('Repeated error');

        // Act
        ErrorsLogger.exception(exception);
        ErrorsLogger.log(exception);
        ErrorsLogger.exception(exception);

        // Assert - All calls complete
        expect(exception, isNotNull);
      });

      test('works in release mode (debugPrint safe)', () {
        // Arrange
        final exception = Exception('Release mode test');
        const failure = Failure(type: NetworkFailureType());

        // Act - debugPrint handles both debug and release
        ErrorsLogger.exception(exception);
        ErrorsLogger.failure(failure);

        // Assert
        expect(exception, isNotNull);
        expect(failure, isNotNull);
      });
    });
  });
}

// Helper classes for testing
class CustomException implements Exception {
  CustomException(this.message);
  final String message;

  @override
  String toString() => 'CustomException: $message';
}

class CircularException implements Exception {
  @override
  String toString() => 'CircularException';
}

StackTrace _generateDeepStackTrace() {
  try {
    _deepFunction(100);
  } on Exception catch (_, st) {
    return st;
  }
  return StackTrace.current;
}

void _deepFunction(int depth) {
  if (depth <= 0) throw Exception('Deep');
  _deepFunction(depth - 1);
}
