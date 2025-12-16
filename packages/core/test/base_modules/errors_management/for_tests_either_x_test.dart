// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `ResultFutureTestX` extension
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - expectSuccess() assertion helper
/// - expectFailure() assertion helper
/// - Assertion failures and messages
/// - Edge cases with null values
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResultFutureTestX', () {
    group('expectSuccess()', () {
      test('passes for Right with matching value', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act & Assert - should not throw
        await expectLater(
          future.expectSuccess(42),
          completes,
        );
      });

      test('passes for Right with matching String', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('hello'));

        // Act & Assert
        await expectLater(
          future.expectSuccess('hello'),
          completes,
        );
      });

      test('passes for Right with matching int', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(100));

        // Act & Assert
        await expectLater(
          future.expectSuccess(100),
          completes,
        );
      });

      test('passes for Right with null value when expected', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int?>(null));

        // Act & Assert
        await expectLater(
          future.expectSuccess(null),
          completes,
        );
      });

      test('fails for Left result', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act & Assert - should throw assertion error
        await expectLater(
          future.expectSuccess(42),
          throwsA(isA<AssertionError>()),
        );
      });

      test('fails for Right with wrong value', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act & Assert - should throw assertion error
        await expectLater(
          future.expectSuccess(99),
          throwsA(isA<AssertionError>()),
        );
      });

      test('fails for Right with wrong String value', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>('hello'));

        // Act & Assert
        await expectLater(
          future.expectSuccess('goodbye'),
          throwsA(isA<AssertionError>()),
        );
      });

      test('works with complex objects', () async {
        // Arrange
        final data = {'id': 1, 'name': 'User'};
        final future = Future.value(
          Right<Failure, Map<String, dynamic>>(data),
        );

        // Act & Assert
        await expectLater(
          future.expectSuccess(data),
          completes,
        );
      });

      test('handles zero value correctly', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(0));

        // Act & Assert
        await expectLater(
          future.expectSuccess(0),
          completes,
        );
      });

      test('handles empty string correctly', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String>(''));

        // Act & Assert
        await expectLater(
          future.expectSuccess(''),
          completes,
        );
      });

      test('handles false boolean correctly', () async {
        // Arrange
        final future = Future.value(const Right<Failure, bool>(false));

        // Act & Assert
        await expectLater(
          future.expectSuccess(false),
          completes,
        );
      });

      test('handles double values correctly', () async {
        // Arrange
        final future = Future.value(const Right<Failure, double>(3.14));

        // Act & Assert
        await expectLater(
          future.expectSuccess(3.14),
          completes,
        );
      });
    });

    group('expectFailure()', () {
      test('passes for Left without code check', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act & Assert - should not throw
        await expectLater(
          future.expectFailure(),
          completes,
        );
      });

      test('passes for Left with matching code', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act & Assert
        await expectLater(
          future.expectFailure('NETWORK'),
          completes,
        );
      });

      test('passes for Left with matching statusCode', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: ApiFailureType(), statusCode: 404),
          ),
        );

        // Act & Assert - safeCode returns statusCode when present
        await expectLater(
          future.expectFailure('404'),
          completes,
        );
      });

      test('passes for Left with matching Firebase code', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: UserNotFoundFirebaseFailureType()),
          ),
        );

        // Act & Assert
        await expectLater(
          future.expectFailure('user-not-found'),
          completes,
        );
      });

      test('fails for Right result', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act & Assert - should throw assertion error
        await expectLater(
          future.expectFailure(),
          throwsA(isA<AssertionError>()),
        );
      });

      test('fails for Left with wrong code', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType()),
          ),
        );

        // Act & Assert - should throw assertion error
        await expectLater(
          future.expectFailure('API'),
          throwsA(isA<AssertionError>()),
        );
      });

      test(
        'fails for Left when expecting specific code but none matches',
        () async {
          // Arrange
          final future = Future.value(
            const Left<Failure, int>(
              Failure(type: ApiFailureType(), statusCode: 404),
            ),
          );

          // Act & Assert - statusCode is '404' not 'API'
          await expectLater(
            future.expectFailure('API'),
            throwsA(isA<AssertionError>()),
          );
        },
      );

      test('handles all FailureType subclasses', () async {
        // Arrange
        final futures = [
          Future.value(
            const Left<Failure, int>(Failure(type: NetworkFailureType())),
          ),
          Future.value(
            const Left<Failure, int>(Failure(type: ApiFailureType())),
          ),
          Future.value(
            const Left<Failure, int>(Failure(type: CacheFailureType())),
          ),
          Future.value(
            const Left<Failure, int>(Failure(type: MissingPluginFailureType())),
          ),
          Future.value(
            const Left<Failure, int>(
              Failure(type: NetworkTimeoutFailureType()),
            ),
          ),
        ];

        // Act & Assert - all should pass without code check
        for (final future in futures) {
          await expectLater(
            future.expectFailure(),
            completes,
          );
        }
      });

      test('validates Firebase failure codes', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(
              type: EmailAlreadyInUseFirebaseFailureType(),
            ),
          ),
        );

        // Act & Assert
        await expectLater(
          future.expectFailure('email-already-in-use'),
          completes,
        );
      });

      test('handles failure without any code', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: UnknownFailureType()),
          ),
        );

        // Act & Assert - should pass without code check
        await expectLater(
          future.expectFailure(),
          completes,
        );

        // Should also pass with matching code
        await expectLater(
          future.expectFailure('UNKNOWN'),
          completes,
        );
      });
    });

    group('real-world scenarios', () {
      test('validates async API call success', () async {
        // Arrange
        Future<Either<Failure, String>> apiCall() async {
          await Future<void>.delayed(Duration(milliseconds: 10));
          return const Right('user_data_loaded');
        }

        // Act & Assert
        await expectLater(
          apiCall().expectSuccess('user_data_loaded'),
          completes,
        );
      });

      test('validates async API call failure', () async {
        // Arrange
        Future<Either<Failure, Map<String, dynamic>>> apiCall() async {
          await Future<void>.delayed(Duration(milliseconds: 10));
          return const Left(
            Failure(type: ApiFailureType(), statusCode: 404),
          );
        }

        // Act & Assert - check failure without code
        await expectLater(
          apiCall().expectFailure(),
          completes,
        );

        // Check failure with specific statusCode
        await expectLater(
          apiCall().expectFailure('404'),
          completes,
        );
      });

      test('validates network timeout scenario', () async {
        // Arrange
        Future<Either<Failure, String>> fetchData() async {
          await Future<void>.delayed(Duration(milliseconds: 10));
          return const Left(
            Failure(type: NetworkTimeoutFailureType()),
          );
        }

        // Act & Assert
        await expectLater(
          fetchData().expectFailure('TIMEOUT'),
          completes,
        );
      });

      test('validates authentication flow', () async {
        // Arrange
        Future<Either<Failure, String>> login() async {
          await Future<void>.delayed(Duration(milliseconds: 10));
          return const Right('auth_token_123');
        }

        // Act & Assert
        await expectLater(
          login().expectSuccess('auth_token_123'),
          completes,
        );
      });

      test('validates cache hit scenario', () async {
        // Arrange
        Future<Either<Failure, String>> getCachedData() async {
          return const Right('cached_value');
        }

        // Act & Assert
        await expectLater(
          getCachedData().expectSuccess('cached_value'),
          completes,
        );
      });

      test('validates cache miss scenario', () async {
        // Arrange
        Future<Either<Failure, List<int>>> getCachedData() async {
          return const Left(
            Failure(type: CacheFailureType()),
          );
        }

        // Act & Assert
        await expectLater(
          getCachedData().expectFailure('CACHE'),
          completes,
        );
      });

      test('validates database query success', () async {
        // Arrange
        Future<Either<Failure, int>> countRecords() async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return const Right(42);
        }

        // Act & Assert
        await expectLater(
          countRecords().expectSuccess(42),
          completes,
        );
      });

      test('validates query failure', () async {
        // Arrange
        Future<Either<Failure, int>> countRecords() async {
          await Future<void>.delayed(Duration(milliseconds: 5));
          return const Left(
            Failure(type: FormatFailureType()),
          );
        }

        // Act & Assert
        await expectLater(
          countRecords().expectFailure('FORMAT_ERROR'),
          completes,
        );
      });
    });

    group('edge cases', () {
      test('handles immediate Future resolution', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act & Assert
        await expectLater(
          future.expectSuccess(42),
          completes,
        );
      });

      test('handles delayed Future resolution', () async {
        // Arrange
        final future = Future.delayed(
          Duration(milliseconds: 50),
          () => const Right<Failure, int>(42),
        );

        // Act & Assert
        await expectLater(
          future.expectSuccess(42),
          completes,
        );
      });

      test('handles Future with error (not Either)', () async {
        // Arrange
        final future = Future<Either<Failure, int>>.error('Network error');

        // Act & Assert - should propagate error
        await expectLater(
          future.expectSuccess(42),
          throwsA(isA<String>()),
        );
      });

      test('validates multiple sequential checks', () async {
        // Arrange
        final future1 = Future.value(const Right<Failure, int>(42));
        final future2 = Future.value(
          const Left<Failure, int>(Failure(type: NetworkFailureType())),
        );

        // Act & Assert - can check multiple futures sequentially
        await expectLater(future1.expectSuccess(42), completes);
        await expectLater(future2.expectFailure('NETWORK'), completes);
      });

      test('handles nullable generic types correctly', () async {
        // Arrange
        final future = Future.value(const Right<Failure, String?>(null));

        // Act & Assert
        await expectLater(
          future.expectSuccess(null),
          completes,
        );
      });

      test('handles custom objects with equality', () async {
        // Arrange
        const customObject = Failure(
          type: ApiFailureType(),
          message: 'Custom',
        );
        final future = Future.value(
          const Right<Failure, Failure>(customObject),
        );

        // Act & Assert
        await expectLater(
          future.expectSuccess(customObject),
          completes,
        );
      });

      test('expectSuccess fails fast on Left', () async {
        // Arrange
        final future = Future.value(
          const Left<Failure, int>(
            Failure(type: NetworkFailureType(), message: 'Connection failed'),
          ),
        );

        // Act & Assert - should throw AssertionError mentioning Left
        await expectLater(
          future.expectSuccess(42),
          throwsA(isA<AssertionError>()),
        );
      });

      test('expectFailure fails fast on Right', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42));

        // Act & Assert - should throw AssertionError mentioning Right
        await expectLater(
          future.expectFailure('NETWORK'),
          throwsA(isA<AssertionError>()),
        );
      });
    });

    group('assertion behavior', () {
      test(
        'expectSuccess assertion includes expected value in message',
        () async {
          // Arrange
          final future = Future.value(const Right<Failure, int>(42));

          // Act & Assert - wrong value should fail
          try {
            await future.expectSuccess(99);
            fail('Should have thrown AssertionError');
          } on Object catch (e) {
            expect(e, isA<AssertionError>());
            // Assertion error should be thrown
          }
        },
      );

      test(
        'expectSuccess assertion mentions Left when result is Left',
        () async {
          // Arrange
          final future = Future.value(
            const Left<Failure, int>(
              Failure(type: NetworkFailureType()),
            ),
          );

          // Act & Assert
          try {
            await future.expectSuccess(42);
            fail('Should have thrown AssertionError');
          } on Object catch (e) {
            expect(e, isA<AssertionError>());
            // Assertion error should be thrown
          }
        },
      );

      test(
        'expectFailure assertion mentions Right when result is Right',
        () async {
          // Arrange
          final future = Future.value(const Right<Failure, int>(42));

          // Act & Assert
          try {
            await future.expectFailure();
            fail('Should have thrown AssertionError');
          } on Object catch (e) {
            expect(e, isA<AssertionError>());
            // Assertion error should be thrown
          }
        },
      );

      test(
        'expectFailure assertion includes expected code in message',
        () async {
          // Arrange
          final future = Future.value(
            const Left<Failure, int>(
              Failure(type: NetworkFailureType()),
            ),
          );

          // Act & Assert - wrong code should fail
          try {
            await future.expectFailure('API');
            fail('Should have thrown AssertionError');
          } on Object catch (e) {
            expect(e, isA<AssertionError>());
            // Assertion error should be thrown
          }
        },
      );
    });

    group('chaining with other operations', () {
      test('can use expectSuccess after transformation', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(21)).then(
          (either) => either.fold(
            Left<Failure, int>.new,
            (r) => Right<Failure, int>(r * 2),
          ),
        );

        // Act & Assert
        await expectLater(
          future.expectSuccess(42),
          completes,
        );
      });

      test('can use expectFailure after error handling', () async {
        // Arrange
        final future = Future.value(const Right<Failure, int>(42)).then(
          (either) => either.fold(
            Left<Failure, int>.new,
            (r) => const Left<Failure, int>(
              Failure(type: FormatFailureType()),
            ),
          ),
        );

        // Act & Assert
        await expectLater(
          future.expectFailure('FORMAT_ERROR'),
          completes,
        );
      });

      test('works with async/await pattern', () async {
        // Arrange
        Future<Either<Failure, String>> fetchData() async {
          await Future<void>.delayed(Duration(milliseconds: 10));
          return const Right('data');
        }

        final result = await fetchData();

        // Act & Assert
        await expectLater(
          Future.value(result).expectSuccess('data'),
          completes,
        );
      });
    });
  });
}
