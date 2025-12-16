/// Tests for `FailureToEitherX` extension
///
/// This test suite follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - toLeft() method
/// - Type safety verification
/// - Integration with Either type system
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureToEitherX', () {
    group('toLeft()', () {
      test('converts Failure to Left with correct type', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Act
        final result = failure.toLeft<int>();

        // Assert
        expect(result, isA<Left<Failure, int>>());
        expect(result, isA<Either<Failure, int>>());
        expect(result.value, equals(failure));
      });

      test('preserves all Failure properties in Left', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Act
        final result = failure.toLeft<String>();

        // Assert
        expect(result.value.type, isA<ApiFailureType>());
        expect(result.value.message, equals('Internal server error'));
        expect(result.value.statusCode, equals(500));
      });

      test('works with different Right types', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());

        // Act
        final intResult = failure.toLeft<int>();
        final stringResult = failure.toLeft<String>();
        final listResult = failure.toLeft<List<int>>();
        final mapResult = failure.toLeft<Map<String, dynamic>>();

        // Assert
        expect(intResult, isA<Left<Failure, int>>());
        expect(stringResult, isA<Left<Failure, String>>());
        expect(listResult, isA<Left<Failure, List<int>>>());
        expect(mapResult, isA<Left<Failure, Map<String, dynamic>>>());
      });

      test('creates immutable Left instance', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final result = failure.toLeft<bool>();

        // Assert - attempting to modify would cause compile error
        expect(result.value, equals(failure));
        expect(result, isA<Left<Failure, bool>>());
      });

      test('can be used with isLeft getter', () {
        // Arrange
        const failure = Failure(type: UnauthorizedFailureType());

        // Act
        final result = failure.toLeft<String>();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.isRight, isFalse);
      });

      test('can be used with fold()', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error occurred',
        );

        // Act
        final result = failure.toLeft<int>();
        final foldedResult = result.fold(
          (f) => 'Failure: ${f.message}',
          (r) => 'Success: $r',
        );

        // Assert
        expect(foldedResult, equals('Failure: Error occurred'));
      });

      test('works with nullable Right types', () {
        // Arrange
        const failure = Failure(type: FormatFailureType());

        // Act
        final result = failure.toLeft<int?>();

        // Assert
        expect(result, isA<Left<Failure, int?>>());
        expect(result.value, equals(failure));
      });

      test('maintains Failure equality through conversion', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: NetworkFailureType());

        // Act
        final result1 = failure1.toLeft<int>();
        final result2 = failure2.toLeft<int>();

        // Assert
        expect(result1.value, equals(result2.value));
        expect(result1.value, equals(failure1));
      });

      test('can chain with Either operations', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final result = failure
            .toLeft<int>()
            .mapLeft((f) => Failure(
                  type: f.type,
                  message: 'Mapped: ${f.message}',
                ));

        // Assert
        expect(result, isA<Left<Failure, int>>());
        result.fold(
          (f) => expect(f.message, contains('Mapped')),
          (r) => fail('Should be Left'),
        );
      });
    });

    group('integration with Either operations', () {
      test('toLeft result can be pattern matched', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Request timeout',
        );

        // Act
        final either = failure.toLeft<String>();
        String? capturedMessage;
        var rightCalled = false;

        final result = either.fold(
          (f) {
            capturedMessage = f.message;
            return 'handled';
          },
          (r) {
            rightCalled = true;
            return r;
          },
        );

        // Assert
        expect(result, equals('handled'));
        expect(capturedMessage, equals('Request timeout'));
        expect(rightCalled, isFalse);
      });

      test('toLeft result works with mapRight (no-op)', () {
        // Arrange
        const failure = Failure(type: ApiFailureType());

        // Act
        final result = failure.toLeft<int>().mapRight((r) => r * 2);

        // Assert
        expect(result, isA<Left<Failure, int>>());
        result.fold(
          (f) => expect(f, equals(failure)),
          (r) => fail('Should be Left'),
        );
      });

      test('toLeft result works with thenMap (short-circuits)', () {
        // Arrange
        const failure = Failure(type: UnknownFailureType());
        var mapperCalled = false;

        // Act
        final result = failure.toLeft<int>().thenMap((r) {
          mapperCalled = true;
          return Right<Failure, int>(r * 2);
        });

        // Assert
        expect(result, isA<Left<Failure, int>>());
        expect(mapperCalled, isFalse);
      });

      test('toLeft result can be composed with other Eithers', () {
        // Arrange
        const failure = Failure(type: CacheFailureType());
        const successValue = 42;

        // Act
        final leftEither = failure.toLeft<int>();
        const rightEither = Right<Failure, int>(successValue);

        // Assert
        expect(leftEither.isLeft, isTrue);
        expect(rightEither.isRight, isTrue);
        expect(
          leftEither.fold((f) => 0, (r) => r),
          equals(0),
        );
        expect(
          rightEither.fold((f) => 0, (r) => r),
          equals(42),
        );
      });
    });

    group('edge cases', () {
      test('handles Failure with null message', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final result = failure.toLeft<String>();

        // Assert
        expect(result.value.message, isNull);
        expect(result, isA<Left<Failure, String>>());
      });

      test('handles Failure with null statusCode', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error',
        );

        // Act
        final result = failure.toLeft<int>();

        // Assert
        expect(result.value.statusCode, isNull);
      });

      test('handles Failure with empty message', () {
        // Arrange
        const failure = Failure(
          type: FormatFailureType(),
          message: '',
        );

        // Act
        final result = failure.toLeft<bool>();

        // Assert
        expect(result.value.message, isEmpty);
      });

      test('handles complex generic types', () {
        // Arrange
        const failure = Failure(type: UnknownFailureType());

        // Act
        final result = failure.toLeft<Map<String, List<int>>>();

        // Assert
        expect(result, isA<Left<Failure, Map<String, List<int>>>>());
      });

      test('handles nested Either types', () {
        // Arrange
        const failure = Failure(type: JsonErrorFailureType());

        // Act
        final result = failure.toLeft<Either<String, int>>();

        // Assert
        expect(result, isA<Left<Failure, Either<String, int>>>());
      });
    });

    group('real-world scenarios', () {
      test('repository layer converts domain Failure to Either', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Failed to fetch user data',
        );

        // Act - simulating repository method return
        final Either<Failure, Map<String, dynamic>> repositoryResult =
            failure.toLeft();

        // Assert
        expect(repositoryResult.isLeft, isTrue);
        repositoryResult.fold(
          (f) => expect(f.message, contains('Failed to fetch')),
          (r) => fail('Should not be Right'),
        );
      });

      test('use case layer handles Failure from repository', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
          message: 'User not found',
        );

        // Act - simulating use case processing
        final Either<Failure, String> useCaseResult = failure.toLeft();
        final output = useCaseResult.fold(
          (f) => 'Error ${f.statusCode}: ${f.message}',
          (data) => 'Success: $data',
        );

        // Assert
        expect(output, equals('Error 404: User not found'));
      });

      test('converts authentication failure to Either', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          statusCode: 401,
          message: 'Invalid credentials',
        );

        // Act
        final Either<Failure, bool> loginResult = failure.toLeft();

        // Assert
        expect(loginResult.isLeft, isTrue);
        expect(
          loginResult.fold((f) => f.type, (r) => null),
          isA<UnauthorizedFailureType>(),
        );
      });

      test('handles cache miss as Either', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Cache entry not found',
        );

        // Act
        final Either<Failure, List<String>> cacheResult = failure.toLeft();
        final items = cacheResult.fold(
          (f) => <String>[],
          (data) => data,
        );

        // Assert
        expect(items, isEmpty);
      });

      test('converts Firebase error to Either for UI layer', () {
        // Arrange
        const failure = Failure(
          type: GenericFirebaseFailureType(),
          message: 'Firebase operation failed',
        );

        // Act
        final Either<Failure, void> operationResult = failure.toLeft();

        // Assert
        expect(operationResult.isLeft, isTrue);
        operationResult.fold(
          (f) {
            expect(f.type, isA<GenericFirebaseFailureType>());
            expect(f.message, contains('Firebase'));
          },
          (_) => fail('Should not succeed'),
        );
      });
    });

    group('type safety', () {
      test('enforces Left type at compile time', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final result = failure.toLeft<int>();

        // Assert - type system ensures this is Left<Failure, int>
        // ignore: unnecessary_type_check
        expect(result is Left<Failure, int>, isTrue);
      });

      test('generic type parameter is preserved', () {
        // Arrange
        const failure = Failure(type: ApiFailureType());

        // Act
        final stringResult = failure.toLeft<String>();
        final intResult = failure.toLeft<int>();

        // Assert
        expect(stringResult, isA<Either<Failure, String>>());
        expect(intResult, isA<Either<Failure, int>>());
        expect(stringResult, isNot(isA<Either<Failure, int>>()));
      });

      test('works with dynamic type', () {
        // Arrange
        const failure = Failure(type: UnknownFailureType());

        // Act
        final result = failure.toLeft<dynamic>();

        // Assert
        expect(result, isA<Left<Failure, dynamic>>());
      });

      test('works with void type', () {
        // Arrange
        const failure = Failure(type: FormatFailureType());

        // Act
        final result = failure.toLeft<void>();

        // Assert
        expect(result, isA<Left<Failure, void>>());
      });
    });

    group('composition patterns', () {
      test('multiple Failures can be converted independently', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: ApiFailureType());

        // Act
        final result1 = failure1.toLeft<int>();
        final result2 = failure2.toLeft<int>();

        // Assert
        expect(result1.value, isNot(equals(result2.value)));
        expect(result1, isA<Left<Failure, int>>());
        expect(result2, isA<Left<Failure, int>>());
      });

      test('can be used in lists of Eithers', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: ApiFailureType());

        // Act
        final results = <Either<Failure, int>>[
          failure1.toLeft(),
          const Right<Failure, int>(42),
          failure2.toLeft(),
        ];

        // Assert
        expect(results, hasLength(3));
        expect(results[0].isLeft, isTrue);
        expect(results[1].isRight, isTrue);
        expect(results[2].isLeft, isTrue);
      });

      test('enables functional error handling patterns', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Timeout',
        );

        // Act
        final result = failure.toLeft<int>();
        final recovered = result.fold(
          (f) => const Right<Failure, int>(0), // Recovery strategy
          Right<Failure, int>.new,
        );

        // Assert
        expect(recovered, isA<Right<Failure, int>>());
        expect(recovered.fold((f) => -1, (r) => r), equals(0));
      });
    });
  });
}
