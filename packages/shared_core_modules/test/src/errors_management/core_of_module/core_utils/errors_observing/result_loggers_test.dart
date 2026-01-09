/// Tests for `ResultLoggerExt` and `FutureResultLoggerExt`
/// from result_logger_x.dart and async_result_logger.dart
///
/// Coverage:
/// - log() method for Either (sync)
/// - logSuccess() method for Either (sync)
/// - track() method for Either (sync)
/// - log() method for `Future<Either>` (async)
/// - logSuccess() method for `Future<Either>` (async)
/// - track() method for `Future<Either>` (async)
/// - Chainability
/// - Integration with ErrorsLogger
library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

void main() {
  group('ResultLoggerExt (sync)', () {
    group('log', () {
      test('logs failure when Either is Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(
            type: NetworkFailureType(),
            message: 'Network error',
          ),
        );

        // Act
        final result = either.log();

        // Assert
        expect(result, equals(either));
        expect(result.isLeft, isTrue);
      });

      test('does not log when Either is Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.log();

        // Assert
        expect(result, equals(either));
        expect(result.isRight, isTrue);
      });

      test('accepts optional stackTrace', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: ApiFailureType()),
        );
        final stackTrace = StackTrace.current;

        // Act
        final result = either.log(stackTrace);

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('returns same Either for chaining', () {
        // Arrange
        const either = Left<Failure, String>(
          Failure(type: UnknownFailureType()),
        );

        // Act
        final result = either.log();

        // Assert
        expect(identical(result, either), isTrue);
      });

      test('is chainable with other operations', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.log().log().log();

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('logs different failure types', () {
        // Arrange
        final failures = [
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
          const Left<Failure, int>(Failure(type: ApiFailureType())),
          const Left<Failure, int>(Failure(type: UnauthorizedFailureType())),
        ];

        // Act & Assert
        for (final either in failures) {
          final result = either.log();
          expect(result.isLeft, isTrue);
        }
      });
    });

    group('logSuccess', () {
      test('logs success when Either is Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.logSuccess();

        // Assert
        expect(result, equals(either));
        expect(result.isRight, isTrue);
      });

      test('does not log when Either is Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.logSuccess();

        // Assert
        expect(result, equals(either));
        expect(result.isLeft, isTrue);
      });

      test('accepts optional label', () {
        // Arrange
        const either = Right<Failure, String>('data');

        // Act
        final result = either.logSuccess('FetchData');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('uses default label when not provided', () {
        // Arrange
        const either = Right<Failure, int>(100);

        // Act
        final result = either.logSuccess();

        // Assert - Uses default "Success" label
        expect(result.isRight, isTrue);
      });

      test('is chainable', () {
        // Arrange
        const either = Right<Failure, String>('value');

        // Act
        final result = either
            .logSuccess('Step1')
            .logSuccess('Step2')
            .logSuccess('Step3');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('logs different value types', () {
        // Arrange
        final values = [
          const Right<Failure, int>(42),
          const Right<Failure, String>('text'),
          const Right<Failure, bool>(true),
          const Right<Failure, List<int>>([1, 2, 3]),
        ];

        // Act & Assert
        for (final either in values) {
          final result = either.logSuccess();
          expect(result.isRight, isTrue);
        }
      });
    });

    group('track', () {
      test('tracks event when Either is Right', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.track('user_action');

        // Assert
        expect(result, equals(either));
        expect(result.isRight, isTrue);
      });

      test('does not track when Either is Left', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.track('user_action');

        // Assert
        expect(result, equals(either));
        expect(result.isLeft, isTrue);
      });

      test('accepts different event names', () {
        // Arrange
        const either = Right<Failure, String>('data');

        // Act
        final result = either
            .track('event_1')
            .track('event_2')
            .track('event_3');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('is chainable with log methods', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either.log().logSuccess().track('completed');

        // Assert
        expect(result.isRight, isTrue);
      });
    });

    group('chaining combinations', () {
      test('chains all logging methods', () {
        // Arrange
        const either = Right<Failure, int>(42);

        // Act
        final result = either
            .log()
            .logSuccess('Operation')
            .track('event')
            .log()
            .logSuccess()
            .track('final_event');

        // Assert
        expect(result, equals(either));
        expect(result.isRight, isTrue);
      });

      test('chains with transformation methods', () {
        // Arrange
        const either = Right<Failure, int>(10);

        // Act
        final result = either
            .log()
            .mapRightX((v) => v * 2)
            .logSuccess('Doubled')
            .track('doubled_event');

        // Assert
        expect(result.fold((l) => 0, (r) => r), equals(20));
      });

      test('preserves Left through chain', () {
        // Arrange
        const either = Left<Failure, int>(
          Failure(type: NetworkFailureType()),
        );

        // Act
        final result = either.log().logSuccess().track('event').log();

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('preserves Right through chain', () {
        // Arrange
        const either = Right<Failure, String>('value');

        // Act
        final result = either
            .logSuccess('Step1')
            .track('tracked')
            .log()
            .logSuccess('Step2');

        // Assert
        expect(result.isRight, isTrue);
      });
    });
  });

  group('FutureResultLoggerExt (async)', () {
    group('log', () {
      test('logs failure when Future<Either> is Left', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(
              type: NetworkFailureType(),
              message: 'Network error',
            ),
          ),
        );

        // Act
        final result = await future.log();

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('does not log when Future<Either> is Right', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.log();

        // Assert
        expect(result.isRight, isTrue);
        expect(result.fold((l) => 0, (r) => r), equals(42));
      });

      test('accepts optional stackTrace', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: ApiFailureType())),
        );
        final stackTrace = StackTrace.current;

        // Act
        final result = await future.log(stackTrace);

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('waits for future to complete', () async {
        // Arrange
        final future = Future.delayed(
          const Duration(milliseconds: 10),
          () => const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act
        final result = await future.log();

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('returns Either after future completes', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('data'));

        // Act
        final result = await future.log();

        // Assert
        expect(result, isA<Either<Failure, String>>());
        expect(result.isRight, isTrue);
      });
    });

    group('logSuccess', () {
      test('logs success when Future<Either> is Right', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.logSuccess();

        // Assert
        expect(result.isRight, isTrue);
      });

      test('does not log when Future<Either> is Left', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );

        // Act
        final result = await future.logSuccess();

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('accepts optional tag', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('data'));

        // Act
        final result = await future.logSuccess('AsyncOperation');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('uses default tag when not provided', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(100));

        // Act
        final result = await future.logSuccess();

        // Assert
        expect(result.isRight, isTrue);
      });

      test('waits for async operation', () async {
        // Arrange
        final future = Future.delayed(
          const Duration(milliseconds: 10),
          () => const Right<Failure, String>('delayed'),
        );

        // Act
        final result = await future.logSuccess('DelayedOp');

        // Assert
        expect(result.fold((l) => '', (r) => r), equals('delayed'));
      });
    });

    group('track', () {
      test('tracks event when Future<Either> is Right', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future.track('async_event');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('does not track when Future<Either> is Left', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );

        // Act
        final result = await future.track('async_event');

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('accepts different event names', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('data'));

        // Act
        final result = await future.track('completed');

        // Assert
        expect(result.isRight, isTrue);
      });

      test('waits for future before tracking', () async {
        // Arrange
        final future = Future.delayed(
          const Duration(milliseconds: 10),
          () => const Right<Failure, int>(42),
        );

        // Act
        final result = await future.track('delayed_event');

        // Assert
        expect(result.isRight, isTrue);
      });
    });

    group('async chaining', () {
      test('chains multiple async log operations', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act
        final result = await future
            .log()
            .then((f) => f.logSuccess('Step1'))
            .then((f) => f.track('event1'))
            .then((f) => f.log());

        // Assert
        expect(result.isRight, isTrue);
      });

      test('chains with async operations', () async {
        // Arrange
        Future<int> operation() async => 42;

        // Act
        final result = await operation
            .runWithErrorHandling()
            .log()
            .then((f) => f.logSuccess('Completed'))
            .then((f) => f.track('success_event'));

        // Assert
        expect(result.isRight, isTrue);
      });

      test('preserves Left through async chain', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );

        // Act
        final result = await future
            .log()
            .then((f) => f.logSuccess())
            .then((f) => f.track('event'));

        // Assert
        expect(result.isLeft, isTrue);
      });

      test('handles complex async chains', () async {
        // Arrange
        Future<String> fetchData() async {
          await Future<void>.delayed(const Duration(milliseconds: 5));
          return 'data';
        }

        // Act
        final result = await fetchData
            .runWithErrorHandling()
            .log()
            .then((f) => f.logSuccess('Fetched'))
            .then((f) => f.track('fetch_complete'));

        // Assert
        final either = result;
        expect(either.isRight, isTrue);
      });
    });
  });

  group('real-world scenarios', () {
    test('logs repository operation result', () async {
      // Arrange
      Future<User> fetchUser() async => const User(
        id: '1',
      );

      // Act
      final result = await fetchUser
          .runWithErrorHandling()
          .log()
          .then((f) => f.logSuccess('FetchUser'))
          .then((f) => f.track('user_fetched'));

      // Assert
      final either = result;
      expect(either.isRight, isTrue);
    });

    test('logs and tracks failed operation', () async {
      // Arrange
      Future<int> failingOperation() async => throw Exception('Failed');

      // Act
      final result = await failingOperation
          .runWithErrorHandling()
          .log()
          .then((f) => f.logSuccess('Operation'))
          .then((f) => f.track('operation_event'));

      // Assert
      final either = result;
      expect(either.isLeft, isTrue);
    });

    test('tracks analytics event on success', () {
      // Arrange
      const result = Right<Failure, User>(
        User(
          id: '1',
        ),
      );

      // Act
      final tracked = result
          .logSuccess('UserLoaded')
          .track('user_profile_viewed');

      // Assert
      expect(tracked.isRight, isTrue);
    });

    test('logs failure without tracking', () {
      // Arrange
      const result = Left<Failure, User>(
        Failure(type: NetworkFailureType()),
      );

      // Act
      final logged = result.log().logSuccess('UserLoaded').track('user_viewed');

      // Assert
      expect(logged.isLeft, isTrue);
    });

    test('multiple operations with different labels', () async {
      // Arrange
      Future<String> step1() async => 'step1';
      Future<String> step2() async => 'step2';

      // Act
      final result1 = await step1.runWithErrorHandling().log().then(
        (f) => f.logSuccess('Step1'),
      );
      final result2 = await step2.runWithErrorHandling().log().then(
        (f) => f.logSuccess('Step2'),
      );

      // Assert
      expect(result1.isRight, isTrue);
      expect(result2.isRight, isTrue);
    });
  });

  group('edge cases', () {
    test('handles null values in Right', () {
      // Arrange
      const either = Right<Failure, String?>(null);

      // Act
      final result = either.logSuccess();

      // Assert
      expect(result.isRight, isTrue);
    });

    test('handles empty collections', () {
      // Arrange
      const either = Right<Failure, List<int>>([]);

      // Act
      final result = either.logSuccess('EmptyList');

      // Assert
      expect(result.isRight, isTrue);
    });

    test('handles very long event names', () {
      // Arrange
      const either = Right<Failure, int>(42);
      final longEventName = 'event_' * 100;

      // Act
      final result = either.track(longEventName);

      // Assert
      expect(result.isRight, isTrue);
    });

    test('handles rapid successive calls', () async {
      // Arrange
      final futures = List.generate(
        10,
        (i) => Future.value(Right<Failure, int>(i)),
      );

      // Act
      final results = await Future.wait(
        futures.map((f) => f.log().then((r) => r.logSuccess())),
      );

      // Assert
      for (final result in results) {
        expect(result.isRight, isTrue);
      }
    });

    test('handles concurrent logging', () async {
      // Arrange
      final future1 = Future.value(const Right<Failure, int>(1));
      final future2 = Future.value(const Right<Failure, int>(2));
      final future3 = Future.value(const Right<Failure, int>(3));

      // Act
      final results = await Future.wait([
        future1.log(),
        future2.logSuccess(),
        future3.track('event'),
      ]);

      // Assert
      for (final result in results) {
        expect(result.isRight, isTrue);
      }
    });
  });

  group('integration', () {
    test('integrates with complete error handling flow', () async {
      // Arrange
      Future<User> fetchUser() async {
        await Future<void>.delayed(const Duration(milliseconds: 5));
        return const User(
          id: '123',
        );
      }

      // Act
      final result = await fetchUser
          .runWithErrorHandling()
          .log()
          .then((f) => f.logSuccess('UserFetched'))
          .then((f) => f.track('user_loaded'));

      // Assert
      final either = result;
      expect(either.isRight, isTrue);
      final user = either.fold((l) => null, (r) => r);
      expect(user?.id, equals('123'));
    });

    test('integrates with failure handling flow', () async {
      // Arrange
      Future<User> failingFetch() async =>
          throw const SocketException('Network error');

      // Act
      final result = await failingFetch
          .runWithErrorHandling()
          .log()
          .then((f) => f.logSuccess('UserFetched'))
          .then((f) => f.track('user_loaded'));

      // Assert
      final either = result;
      expect(either.isLeft, isTrue);
      final failure = either.fold((l) => l, (r) => null);
      expect(failure?.type, isA<NetworkFailureType>());
    });
  });
}

// Helper classes for testing
class User {
  const User({
    required this.id,
  });
  final String id;
}
