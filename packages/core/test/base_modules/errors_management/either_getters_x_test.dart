// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `EitherGetters` extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - leftOrNull getter
/// - rightOrNull getter
/// - isLeft/isRight getters
/// - valueOrNull alias
/// - foldOrNull method
library;

import 'package:core/src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
import 'package:core/src/base_modules/errors_management/core_of_module/either.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EitherGetters', () {
    group('leftOrNull', () {
      test('returns left value when Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.leftOrNull;

        // Assert
        expect(result, equals('error'));
        expect(result, isNotNull);
      });

      test('returns null when Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.leftOrNull;

        // Assert
        expect(result, isNull);
      });

      test('preserves left value type', () {
        // Arrange
        const either = Left<int, String>(404);

        // Act
        final result = either.leftOrNull;

        // Assert
        expect(result, isA<int?>());
        expect(result, equals(404));
      });

      test('handles complex left types', () {
        // Arrange
        final either = Left<List<String>, int>(const ['error1', 'error2']);

        // Act
        final result = either.leftOrNull;

        // Assert
        expect(result, isA<List<String>?>());
        expect(result, equals(['error1', 'error2']));
      });
    });

    group('rightOrNull', () {
      test('returns right value when Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, equals(42));
        expect(result, isNotNull);
      });

      test('returns null when Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, isNull);
      });

      test('preserves right value type', () {
        // Arrange
        final either = Right<String, DateTime>(DateTime(2024));

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, isA<DateTime?>());
        expect(result, equals(DateTime(2024)));
      });

      test('handles complex right types', () {
        // Arrange
        final either = Right<String, Map<String, int>>(const {'count': 10});

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, isA<Map<String, int>?>());
        expect(result, equals({'count': 10}));
      });
    });

    group('isLeft', () {
      test('returns true when Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.isLeft;

        // Assert
        expect(result, isTrue);
      });

      test('returns false when Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.isLeft;

        // Assert
        expect(result, isFalse);
      });

      test('works with different type combinations', () {
        // Arrange
        const either1 = Left<int, String>(404);
        const either2 = Right<int, String>('success');

        // Assert
        expect(either1.isLeft, isTrue);
        expect(either2.isLeft, isFalse);
      });
    });

    group('isRight', () {
      test('returns true when Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.isRight;

        // Assert
        expect(result, isTrue);
      });

      test('returns false when Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.isRight;

        // Assert
        expect(result, isFalse);
      });

      test('works with different type combinations', () {
        // Arrange
        const either1 = Left<String, bool>('error');
        const either2 = Right<String, bool>(true);

        // Assert
        expect(either1.isRight, isFalse);
        expect(either2.isRight, isTrue);
      });
    });

    group('isLeft and isRight are opposites', () {
      test('Left has isLeft=true and isRight=false', () {
        // Arrange
        const either = Left<String, int>('error');

        // Assert
        expect(either.isLeft, isTrue);
        expect(either.isRight, isFalse);
        expect(either.isLeft, isNot(equals(either.isRight)));
      });

      test('Right has isLeft=false and isRight=true', () {
        // Arrange
        const either = Right<String, int>(42);

        // Assert
        expect(either.isLeft, isFalse);
        expect(either.isRight, isTrue);
        expect(either.isLeft, isNot(equals(either.isRight)));
      });
    });

    group('valueOrNull', () {
      test('is alias for rightOrNull', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final valueResult = either.valueOrNull;
        final rightResult = either.rightOrNull;

        // Assert
        expect(valueResult, equals(rightResult));
        expect(valueResult, equals(42));
      });

      test('returns null for Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.valueOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns value for Right', () {
        // Arrange
        const either = Right<String, int>(100);

        // Act
        final result = either.valueOrNull;

        // Assert
        expect(result, equals(100));
      });
    });

    group('foldOrNull', () {
      test('executes onLeft when Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.foldOrNull<String>(
          onLeft: (error) => 'Error: $error',
          onRight: (value) => 'Success: $value',
        );

        // Assert
        expect(result, equals('Error: error'));
      });

      test('executes onRight when Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.foldOrNull<String>(
          onLeft: (error) => 'Error: $error',
          onRight: (value) => 'Success: $value',
        );

        // Assert
        expect(result, equals('Success: 42'));
      });

      test('returns null when onLeft is not provided and Either is Left', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.foldOrNull<String>(
          onRight: (value) => 'Success: $value',
        );

        // Assert
        expect(result, isNull);
      });

      test('returns null when onRight is not provided and Either is Right', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.foldOrNull<String>(
          onLeft: (error) => 'Error: $error',
        );

        // Assert
        expect(result, isNull);
      });

      test('returns null when both callbacks are not provided', () {
        // Arrange
        const either1 = Left<String, int>('error');
        const either2 = Right<String, int>(42);

        // Act
        final result1 = either1.foldOrNull<String>();
        final result2 = either2.foldOrNull<String>();

        // Assert
        expect(result1, isNull);
        expect(result2, isNull);
      });

      test('can transform to different type', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final result = either.foldOrNull<bool>(
          onLeft: (_) => false,
          onRight: (value) => value > 0,
        );

        // Assert
        expect(result, isA<bool?>());
        expect(result, isTrue);
      });

      test('handles complex transformations', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final result = either.foldOrNull<Map<String, dynamic>>(
          onLeft: (error) => {'error': error, 'success': false},
          onRight: (value) => {'value': value, 'success': true},
        );

        // Assert
        expect(result, isA<Map<String, dynamic>?>());
        expect(result, equals({'error': 'error', 'success': false}));
      });
    });

    group('edge cases', () {
      test('handles null values in Right', () {
        // Arrange
        const either = Right<String, String?>(null);

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, isNull);
        expect(either.isRight, isTrue);
      });

      test('handles empty string in Left', () {
        // Arrange
        const either = Left<String, int>('');

        // Act
        final result = either.leftOrNull;

        // Assert
        expect(result, equals(''));
        expect(result, isEmpty);
      });

      test('handles zero value in Right', () {
        // Arrange
        const either = Right<String, int>(0);

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, equals(0));
        expect(result, isNotNull);
      });

      test('handles false value in Right', () {
        // Arrange
        const either = Right<String, bool>(false);

        // Act
        final result = either.rightOrNull;

        // Assert
        expect(result, equals(false));
        expect(result, isNotNull);
      });
    });

    group('real-world scenarios', () {
      test('safely extracts error message from API failure', () {
        // Arrange
        const either = Left<String, Map<String, dynamic>>('Network timeout');

        // Act
        final error = either.leftOrNull;

        // Assert
        expect(error, equals('Network timeout'));
        expect(either.isLeft, isTrue);
      });

      test('safely extracts success data from API response', () {
        // Arrange
        final either = Right<String, Map<String, dynamic>>(const {
          'id': 1,
          'name': 'User',
        });

        // Act
        final data = either.rightOrNull;

        // Assert
        expect(data, isNotNull);
        expect(data!['id'], equals(1));
        expect(data['name'], equals('User'));
      });

      test('conditionally shows error or success UI', () {
        // Arrange
        const either1 = Left<String, int>('Error occurred');
        const either2 = Right<String, int>(100);

        // Act
        final showError1 = either1.isLeft;
        final showError2 = either2.isLeft;

        // Assert
        expect(showError1, isTrue);
        expect(showError2, isFalse);
      });

      test('uses foldOrNull for UI state mapping', () {
        // Arrange
        const either = Right<String, int>(42);

        // Act
        final uiState = either.foldOrNull<String>(
          onLeft: (error) => 'Error: $error',
          onRight: (value) => 'Loaded: $value items',
        );

        // Assert
        expect(uiState, equals('Loaded: 42 items'));
      });

      test('safely gets value with null check', () {
        // Arrange
        const either = Right<String, int>(5);

        // Act
        final value = either.valueOrNull;
        final displayValue = value ?? 0;

        // Assert
        expect(displayValue, equals(5));
      });
    });

    group('composition with other Either methods', () {
      test('can chain with fold', () {
        // Arrange
        const either = Right<String, int>(10);

        // Act
        final value = either.rightOrNull;
        final doubled = value != null ? value * 2 : 0;

        // Assert
        expect(doubled, equals(20));
      });

      test('works with pattern matching', () {
        // Arrange
        const either = Left<String, int>('error');

        // Act
        final message = switch (either) {
          Left() => either.leftOrNull ?? 'Unknown error',
          Right() => 'Success: ${either.rightOrNull}',
        };

        // Assert
        expect(message, equals('error'));
      });

      test('combines isRight with valueOrNull', () {
        // Arrange
        const either = Right<String, int>(100);

        // Act & Assert
        if (either.isRight) {
          final value = either.valueOrNull;
          expect(value, equals(100));
        }
      });
    });
  });
}
