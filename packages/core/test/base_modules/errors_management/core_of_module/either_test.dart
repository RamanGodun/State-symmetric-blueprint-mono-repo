/// Tests for `Either<L, R>` monadic type
///
/// Tests cover:
/// - Left and Right construction
/// - Type checking (isLeft, isRight)
/// - Pattern matching (fold)
/// - Mapping operations (map, mapBoth, mapLeft, mapRight)
/// - FlatMap operations (thenMap)
/// - Immutability and equality
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Either<L, R>', () {
    group('construction', () {
      test('Left creates instance with left value', () {
        // Arrange & Act
        const either = Left<String, int>('error');

        // Assert
        expect(either, isA<Left<String, int>>());
        expect(either, isA<Either<String, int>>());
        expect(either.value, equals('error'));
      });

      test('Right creates instance with right value', () {
        // Arrange & Act
        const either = Right<String, int>(42);

        // Assert
        expect(either, isA<Right<String, int>>());
        expect(either, isA<Either<String, int>>());
        expect(either.value, equals(42));
      });

      test('Left and Right are immutable', () {
        // Arrange
        const left = Left<String, int>('error');
        const right = Right<String, int>(42);

        // Assert - cannot reassign value (compile-time check)
        expect(left.value, equals('error'));
        expect(right.value, equals(42));
      });
    });

    group('isLeft', () {
      test('returns true for Left instance', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act & Assert
        expect(either.isLeft, isTrue);
      });

      test('returns false for Right instance', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act & Assert
        expect(either.isLeft, isFalse);
      });
    });

    group('isRight', () {
      test('returns true for Right instance', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act & Assert
        expect(either.isRight, isTrue);
      });

      test('returns false for Left instance', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act & Assert
        expect(either.isRight, isFalse);
      });
    });

    group('fold', () {
      test('executes leftOp when instance is Left', () {
        // Arrange
        const either = Left<String, int>('error');
        var leftCalled = false;
        var rightCalled = false;

        // Act
        final result = either.fold(
          (l) {
            leftCalled = true;
            return 'Left: $l';
          },
          (r) {
            rightCalled = true;
            return 'Right: $r';
          },
        );

        // Assert
        expect(result, equals('Left: error'));
        expect(leftCalled, isTrue);
        expect(rightCalled, isFalse);
      });

      test('executes rightOp when instance is Right', () {
        // Arrange
        const either = Right<String, int>(42);
        var leftCalled = false;
        var rightCalled = false;

        // Act
        final result = either.fold(
          (l) {
            leftCalled = true;
            return 'Left: $l';
          },
          (r) {
            rightCalled = true;
            return 'Right: $r';
          },
        );

        // Assert
        expect(result, equals('Right: 42'));
        expect(leftCalled, isFalse);
        expect(rightCalled, isTrue);
      });

      test('returns value of same type from both branches', () {
        // Arrange
        const left = Left<String, int>('error');
        const right = Right<String, int>(42);

        // Act
        final leftResult = left.fold(
          (l) => 0,
          (r) => r,
        );
        final rightResult = right.fold(
          (l) => 0,
          (r) => r,
        );

        // Assert
        expect(leftResult, equals(0));
        expect(rightResult, equals(42));
        expect(leftResult, isA<int>());
        expect(rightResult, isA<int>());
      });

      test('can transform to different type', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.fold(
          (l) => l.length,
          (r) => r * 2,
        );

        // Assert
        expect(result, equals(84));
      });
    });

    group('map', () {
      test('transforms both Left and Right values', () {
        // Arrange
        const left = Left<String, int>('error');
        const right = Right<String, int>(42);

        // Act
        final leftResult = left.map(
          (l) => l.length,
          (r) => r.toString(),
        );
        final rightResult = right.map(
          (l) => l.length,
          (r) => r.toString(),
        );

        // Assert
        expect(leftResult, isA<Left<int, String>>());
        expect(leftResult.fold((l) => l, (r) => 0), equals(5));
        expect(rightResult, isA<Right<int, String>>());
        expect(rightResult.fold((l) => '', (r) => r), equals('42'));
      });

      test('preserves Left/Right type after mapping', () {
        // Arrange
        const left = Left<int, String>(404);
        const right = Right<int, String>('success');

        // Act
        final leftResult = left.map((l) => l.toString(), (r) => r.length);
        final rightResult = right.map((l) => l.toString(), (r) => r.length);

        // Assert
        expect(leftResult.isLeft, isTrue);
        expect(rightResult.isRight, isTrue);
      });

      test('allows null transformations', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.map<String?, int?>(
          (l) => null,
          (r) => null,
        );

        // Assert
        expect(result.isRight, isTrue);
        expect(result.fold((l) => 'left', (r) => r), isNull);
      });
    });

    group('mapBoth', () {
      test('transforms both sides using named parameters', () {
        // Arrange
        const left = Left<String, int>('error');
        const right = Right<String, int>(42);

        // Act
        final leftResult = left.mapBoth(
          leftMapper: (l) => l.toUpperCase(),
          rightMapper: (r) => r * 2,
        );
        final rightResult = right.mapBoth(
          leftMapper: (l) => l.toUpperCase(),
          rightMapper: (r) => r * 2,
        );

        // Assert
        expect(leftResult.fold((l) => l, (r) => ''), equals('ERROR'));
        expect(rightResult.fold((l) => 0, (r) => r), equals(84));
      });

      test('is equivalent to map with same transformations', () {
        // Arrange
        const either = Right<String, int>(10);

        // Act
        final mapResult = either.map(
          (l) => l.length,
          (r) => r + 5,
        );
        final mapBothResult = either.mapBoth(
          leftMapper: (l) => l.length,
          rightMapper: (r) => r + 5,
        );

        // Assert
        expect(
          mapResult.fold((l) => l, (r) => r),
          equals(mapBothResult.fold((l) => l, (r) => r)),
        );
      });
    });

    group('mapRight', () {
      test('transforms only Right value', () {
        // Arrange
        const right = Right<String, int>(42);

        // Act
        final result = right.mapRight((r) => r * 2);

        // Assert
        expect(result, isA<Right<String, int>>());
        expect(result.fold((l) => 0, (r) => r), equals(84));
      });

      test('preserves Left value unchanged', () {
        // Arrange
        const left = Left<String, int>('error');

        // Act
        final result = left.mapRight((r) => r * 2);

        // Assert
        expect(result, isA<Left<String, int>>());
        expect(result.fold((l) => l, (r) => ''), equals('error'));
      });

      test('can change Right type while preserving Left type', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.mapRight((r) => r.toString());

        // Assert
        expect(result, isA<Right<String, String>>());
        expect(result.fold((l) => '', (r) => r), equals('42'));
      });
    });

    group('mapLeft', () {
      test('transforms only Left value', () {
        // Arrange
        const left = Left<String, int>('error');

        // Act
        final result = left.mapLeft((l) => l.toUpperCase());

        // Assert
        expect(result, isA<Left<String, int>>());
        expect(result.fold((l) => l, (r) => ''), equals('ERROR'));
      });

      test('preserves Right value unchanged', () {
        // Arrange
        const right = Right<String, int>(42);

        // Act
        final result = right.mapLeft((l) => l.toUpperCase());

        // Assert
        expect(result, isA<Right<String, int>>());
        expect(result.fold((l) => 0, (r) => r), equals(42));
      });

      test('can change Left type while preserving Right type', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.mapLeft((l) => l.length);

        // Assert
        expect(result, isA<Left<int, int>>());
        expect(result.fold((l) => l, (r) => 0), equals(5));
      });
    });

    group('thenMap (flatMap)', () {
      test('chains another Right when instance is Right', () {
        // Arrange
        const either = Right<String, int>(5);

        // Act
        final result = either.thenMap(
          (r) => Right<String, int>(r * 2),
        );

        // Assert
        expect(result, isA<Right<String, int>>());
        expect(result.fold((l) => 0, (r) => r), equals(10));
      });

      test('chains to Left when callback returns Left', () {
        // Arrange
        const either = Right<String, int>(5);

        // Act
        final result = either.thenMap(
          (r) => const Left<String, int>('computation failed'),
        );

        // Assert
        expect(result, isA<Left<String, int>>());
        expect(result.fold((l) => l, (r) => ''), equals('computation failed'));
      });

      test('preserves Left without calling callback', () {
        // Arrange
        const either = Left<String, int>('original error');
        var callbackCalled = false;

        // Act
        final result = either.thenMap(
          (r) {
            callbackCalled = true;
            return Right<String, int>(r * 2);
          },
        );

        // Assert
        expect(result, isA<Left<String, int>>());
        expect(result.fold((l) => l, (r) => ''), equals('original error'));
        expect(callbackCalled, isFalse);
      });

      test('allows chaining multiple operations', () {
        // Arrange
        const either = Right<String, int>(2);

        // Act
        final result = either
            .thenMap((r) => Right<String, int>(r + 3)) // 5
            .thenMap((r) => Right<String, int>(r * 2)) // 10
            .thenMap((r) => Right<String, int>(r - 1)); // 9

        // Assert
        expect(result.fold((l) => 0, (r) => r), equals(9));
      });

      test('stops chain on first Left', () {
        // Arrange
        const either = Right<String, int>(2);

        // Act
        final result = either
            .thenMap((r) => Right<String, int>(r + 3)) // 5
            .thenMap((r) => const Left<String, int>('error')) // stops here
            .thenMap((r) => Right<String, int>(r * 2)); // not executed

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.fold((l) => l, (r) => ''), equals('error'));
      });

      test('can change Right type in chain', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.thenMap(
          (r) => Right<String, String>(r.toString()),
        );

        // Assert
        expect(result, isA<Right<String, String>>());
        expect(result.fold((l) => '', (r) => r), equals('42'));
      });
    });

    group('edge cases', () {
      test('handles null values in Left', () {
        // Arrange
        const either = Left<int?, String>(null);

        // Act & Assert
        expect(either.isLeft, isTrue);
        expect(either.fold((l) => l, (r) => 0), isNull);
      });

      test('handles null values in Right', () {
        // Arrange
        const either = Right<String, int?>(null);

        // Act & Assert
        expect(either.isRight, isTrue);
        expect(either.fold((l) => 0, (r) => r), isNull);
      });

      test('supports complex nested types', () {
        // Arrange
        const either = Right<String, List<Map<String, int>>>(
          [
            {'a': 1, 'b': 2},
            {'c': 3},
          ],
        );

        // Act
        final result = either.mapRight((r) => r.length);

        // Assert
        expect(result.fold((l) => 0, (r) => r), equals(2));
      });

      test('works with custom objects', () {
        // Arrange
        final either = Right<Exception, DateTime>(DateTime(2024));

        // Act
        final result = either.mapRight((r) => r.year);

        // Assert
        expect(result.fold((l) => 0, (r) => r), equals(2024));
      });

      test('fold with throwing functions handles exceptions', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act & Assert
        expect(
          () => either.fold(
            (l) => throw Exception('Left'),
            (r) => throw Exception('Right'),
          ),
          throwsException,
        );
      });
    });

    group('immutability', () {
      test('Left value cannot be modified', () {
        // Arrange
        const original = Left<String, int>('error');

        // Act
        final mapped = original.mapLeft((l) => l.toUpperCase());

        // Assert
        expect(original.value, equals('error'));
        expect(mapped.fold((l) => l, (r) => ''), equals('ERROR'));
      });

      test('Right value cannot be modified', () {
        // Arrange
        const original = Right<String, int>(42);

        // Act
        final mapped = original.mapRight((r) => r * 2);

        // Assert
        expect(original.value, equals(42));
        expect(mapped.fold((l) => 0, (r) => r), equals(84));
      });

      test('operations return new instances', () {
        // Arrange
        const either = Right<String, int>(10);

        // Act
        final mapped = either.mapRight((r) => r + 5);

        // Assert
        expect(identical(either, mapped), isFalse);
      });
    });

    group('type inference', () {
      test('infers types correctly for Left', () {
        // Arrange & Act
        const either = Left<String, dynamic>('error');

        // Assert
        expect(either, isA<Left<String, dynamic>>());
      });

      test('infers types correctly for Right', () {
        // Arrange & Act
        const either = Right<dynamic, int>(42);

        // Assert
        expect(either, isA<Right<dynamic, int>>());
      });

      test('explicit type annotations work', () {
        // Arrange & Act
        const either = Left<String, int>('error');

        // Assert
        expect(either, isA<Either<String, int>>());
        expect(either, isA<Left<String, int>>());
      });
    });
  });
}
