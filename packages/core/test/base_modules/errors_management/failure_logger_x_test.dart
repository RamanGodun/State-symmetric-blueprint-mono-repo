/// Tests for `FailureLogger` extension
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - log() method with and without stackTrace
/// - debugLog() method
/// - debugSummary getter
/// - track() method with analytics callback
/// - Integration with Failure diagnostics
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureLogger', () {
    group('log()', () {
      test('logs failure without throwing exception', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act & Assert - should not throw
        expect(() => failure.log(), returnsNormally);
      });

      test('logs failure with stackTrace without throwing', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 500,
          message: 'Internal server error',
        );
        final stackTrace = StackTrace.current;

        // Act & Assert - should not throw
        expect(() => failure.log(stackTrace), returnsNormally);
      });

      test('logs failure with null stackTrace', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());

        // Act & Assert
        expect(() => failure.log(), returnsNormally);
      });

      test('logs failure with all properties', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid token',
          statusCode: 401,
        );

        // Act & Assert
        expect(() => failure.log(), returnsNormally);
      });

      test('logs failure with minimal properties', () {
        // Arrange
        const failure = Failure(type: UnknownFailureType());

        // Act & Assert
        expect(() => failure.log(), returnsNormally);
      });
    });

    group('debugLog()', () {
      test('returns same Failure instance after logging', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Request timeout',
        );

        // Act
        final result = failure.debugLog('NetworkCall');

        // Assert
        expect(result, equals(failure));
        expect(identical(result, failure), isTrue);
      });

      test('works with custom label', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Server error',
          statusCode: 500,
        );

        // Act
        final result = failure.debugLog('API_REQUEST');

        // Assert
        expect(result, equals(failure));
      });

      test('works without label (uses default)', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());

        // Act
        final result = failure.debugLog();

        // Assert
        expect(result, equals(failure));
      });

      test('handles null message in failure', () {
        // Arrange
        const failure = Failure(type: FormatFailureType());

        // Act
        final result = failure.debugLog('ParseError');

        // Assert
        expect(result, equals(failure));
        expect(result.message, isNull);
      });

      test('handles empty message', () {
        // Arrange
        const failure = Failure(
          type: JsonErrorFailureType(),
          message: '',
        );

        // Act
        final result = failure.debugLog();

        // Assert
        expect(result.message, isEmpty);
      });

      test('can be chained with other operations', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act
        final either = failure.debugLog('NetworkError').toLeft<String>();

        // Assert
        expect(either, isA<Left<Failure, String>>());
        expect(either.value, equals(failure));
      });
    });

    group('debugSummary', () {
      test('returns formatted summary with statusCode', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal error',
          statusCode: 500,
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains('500'));
        expect(summary, contains('Internal error'));
      });

      test('returns formatted summary without statusCode', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'No connection',
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains(failure.safeCode));
        expect(summary, isNotEmpty);
      });

      test('uses safeCode when statusCode is null', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Cache miss',
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains(failure.safeCode));
        expect(summary, contains('Cache miss'));
      });

      test('handles null message gracefully', () {
        // Arrange
        const failure = Failure(type: UnknownFailureType());

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, isNotEmpty);
        expect(summary, contains(failure.safeCode));
      });

      test('includes all diagnostic information', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Access denied',
          statusCode: 401,
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains('401'));
        expect(summary, contains('Access denied'));
      });

      test('formats consistently across different failures', () {
        // Arrange
        const failures = [
          Failure(type: NetworkFailureType(), message: 'Error 1'),
          Failure(type: ApiFailureType(), message: 'Error 2', statusCode: 404),
          Failure(type: CacheFailureType()),
        ];

        // Act
        final summaries = failures.map((f) => f.debugSummary).toList();

        // Assert
        for (final summary in summaries) {
          expect(summary, isNotEmpty);
          expect(summary, contains('['));
          expect(summary, contains(']'));
        }
      });
    });

    group('track()', () {
      test('calls tracking callback with formatted event name', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection error',
        );
        String? trackedEvent;

        // Act
        final result = failure.track((eventName) {
          trackedEvent = eventName;
        });

        // Assert
        expect(result, equals(failure));
        expect(trackedEvent, isNotNull);
        expect(trackedEvent, startsWith('failure_'));
      });

      test('returns same Failure instance after tracking', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );

        // Act
        final result = failure.track((_) {});

        // Assert
        expect(result, equals(failure));
        expect(identical(result, failure), isTrue);
      });

      test('formats event name with lowercase code', () {
        // Arrange
        const failure = Failure(type: UnauthorizedFailureType());
        String? trackedEvent;

        // Act
        failure.track((eventName) {
          trackedEvent = eventName;
        });

        // Assert
        expect(trackedEvent, isNotNull);
        expect(trackedEvent?.toLowerCase(), equals(trackedEvent));
      });

      test('uses statusCode in event name when available', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );
        String? trackedEvent;

        // Act
        failure.track((eventName) {
          trackedEvent = eventName;
        });

        // Assert
        expect(trackedEvent, contains('404'));
      });

      test('uses failure code when statusCode is null', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());
        String? trackedEvent;

        // Act
        failure.track((eventName) {
          trackedEvent = eventName;
        });

        // Assert
        expect(trackedEvent, isNotNull);
        expect(trackedEvent, startsWith('failure_'));
      });

      test('can be chained with other operations', () {
        // Arrange
        const failure = Failure(type: NetworkTimeoutFailureType());
        var trackingCalled = false;

        // Act
        final either = failure
            .track((event) => trackingCalled = true)
            .debugLog('Chained')
            .toLeft<int>();

        // Assert
        expect(trackingCalled, isTrue);
        expect(either, isA<Left<Failure, int>>());
      });

      test('callback is invoked exactly once', () {
        // Arrange
        const failure = Failure(type: FormatFailureType());
        var callCount = 0;

        // Act
        failure.track((_) => callCount++);

        // Assert
        expect(callCount, equals(1));
      });
    });

    group('edge cases', () {
      test('handles failure with very long message', () {
        // Arrange
        final longMessage = 'Error: ' * 1000;
        final failure = Failure(
          type: const ApiFailureType(),
          message: longMessage,
        );

        // Act & Assert
        expect(failure.log, returnsNormally);
        expect(failure.debugLog, returnsNormally);
        expect(failure.debugSummary, isNotEmpty);
      });

      test('handles failure with special characters in message', () {
        // Arrange
        const failure = Failure(
          type: JsonErrorFailureType(),
          message: 'Error:\n\t"quoted"\r\n',
        );

        // Act & Assert
        expect(() => failure.log(), returnsNormally);
        expect(() => failure.debugLog(), returnsNormally);
        expect(failure.debugSummary, contains('Error'));
      });

      test('handles failure with unicode characters', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Помилка: 错误 🔥',
        );

        // Act & Assert
        expect(() => failure.log(), returnsNormally);
        expect(failure.debugSummary, contains('Помилка'));
      });

      test('handles failure with zero statusCode', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 0,
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains('0'));
      });

      test('handles failure with negative statusCode', () {
        // Arrange
        const failure = Failure(
          type: UnknownFailureType(),
          statusCode: -1,
        );

        // Act
        final summary = failure.debugSummary;

        // Assert
        expect(summary, contains('-1'));
      });
    });

    group('real-world scenarios', () {
      test('logs network failure during API call', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Failed to connect to server',
        );

        // Act & Assert
        expect(
          () {
            failure
              ..log(StackTrace.current)
              ..debugLog('API_CALL')
              ..track((event) {});
          },
          returnsNormally,
        );
      });

      test('tracks authentication failure for analytics', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid credentials',
          statusCode: 401,
        );
        final events = <String>[];

        // Act
        failure.track(events.add);

        // Assert
        expect(events, hasLength(1));
        expect(events.first, contains('401'));
      });

      test('debugs cache failure during data retrieval', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Cache entry expired',
        );

        // Act
        final result = failure.debugLog('CACHE_READ');
        final summary = result.debugSummary;

        // Assert
        expect(result, equals(failure));
        expect(summary, contains('Cache entry expired'));
      });

      test('logs and tracks Firebase error', () {
        // Arrange
        const failure = Failure(
          type: GenericFirebaseFailureType(),
          message: 'Firebase operation failed',
        );
        var tracked = false;

        // Act
        failure
          ..log()
          ..track((_) => tracked = true);

        // Assert
        expect(tracked, isTrue);
      });

      test('chains logging operations in error handler', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Server error',
          statusCode: 500,
        );
        final events = <String>[];

        // Act
        final result = failure.debugLog('ERROR_HANDLER').track(events.add)
          ..log();

        // Assert
        expect(result, equals(failure));
        expect(events, hasLength(1));
      });
    });

    group('composition and chaining', () {
      test('all logging methods can be chained together', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Timeout occurred',
        );
        final events = <String>[];

        // Act
        final result = failure.debugLog('TIMEOUT').track(events.add)
          ..log(StackTrace.current);

        // Assert
        expect(result, equals(failure));
        expect(events, hasLength(1));
      });

      test('logging operations preserve failure identity', () {
        // Arrange
        final original = const Failure(type: CacheFailureType())
          // Act
          ..log();
        final debugged = original.debugLog();
        final tracked = debugged.track((_) {});

        // Assert
        expect(identical(original, debugged), isTrue);
        expect(identical(debugged, tracked), isTrue);
      });

      test('can be used in fluent API patterns', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'API call failed',
          statusCode: 503,
        );
        final events = <String>[];

        // Act
        final either = failure
            .debugLog('API')
            .track(events.add)
            .toLeft<String>();

        // Assert
        expect(either, isA<Left<Failure, String>>());
        expect(events, isNotEmpty);
      });

      test('logging does not affect Failure equality', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: NetworkFailureType());

        // Act
        failure1.log();
        final logged1 = failure1.debugLog();
        final logged2 = failure2.track((_) {});

        // Assert
        expect(logged1, equals(logged2));
      });
    });

    group('integration with diagnostics', () {
      test('debugSummary uses safeCode from diagnostics', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Act
        final summary = failure.debugSummary;
        final safeCode = failure.safeCode;

        // Assert
        expect(summary, contains(safeCode));
        expect(summary, contains('404'));
      });

      test('debugLog uses safeStatus from diagnostics', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act
        final result = failure.debugLog();
        final status = failure.safeStatus;

        // Assert
        expect(result, equals(failure));
        expect(status, isNotEmpty);
      });

      test('track uses safeCode for event naming', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          statusCode: 401,
        );
        String? eventName;

        // Act
        failure.track((e) => eventName = e);

        // Assert
        expect(eventName, contains(failure.safeCode.toLowerCase()));
      });
    });
  });
}
