// Tests use const constructors extensively for immutable objects
// ignore_for_file: prefer_const_constructors

/// Tests for `Failure` entity - VGV Style
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Failure construction with all parameters
/// - Equatable props (equality, hashCode)
/// - safeCode getter
/// - Null handling
/// - Edge cases
library;

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure', () {
    group('construction', () {
      test('creates instance with all parameters', () {
        // Arrange & Act
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Assert
        expect(failure, isA<Failure>());
        expect(failure.type, isA<ApiFailureType>());
        expect(failure.message, equals('Internal server error'));
        expect(failure.statusCode, equals(500));
      });

      test('creates instance with only required type', () {
        // Arrange & Act
        const failure = Failure(type: NetworkFailureType());

        // Assert
        expect(failure.type, isA<NetworkFailureType>());
        expect(failure.message, isNull);
        expect(failure.statusCode, isNull);
      });

      test('creates instance with type and message', () {
        // Arrange & Act
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid credentials',
        );

        // Assert
        expect(failure.type, isA<UnauthorizedFailureType>());
        expect(failure.message, equals('Invalid credentials'));
        expect(failure.statusCode, isNull);
      });

      test('creates instance with type and statusCode', () {
        // Arrange & Act
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Assert
        expect(failure.type, isA<ApiFailureType>());
        expect(failure.message, isNull);
        expect(failure.statusCode, equals(404));
      });

      test('is immutable', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          message: 'Connection failed',
        );

        // Assert - attempting to modify would cause compile error
        expect(failure.type, isA<NetworkFailureType>());
        expect(failure.message, equals('Connection failed'));
      });
    });

    group('equality (Equatable)', () {
      test('two failures with same values are equal', () {
        // Arrange
        const failure1 = Failure(
          type: ApiFailureType(),
          message: 'Error',
          statusCode: 500,
        );
        const failure2 = Failure(
          type: ApiFailureType(),
          message: 'Error',
          statusCode: 500,
        );

        // Assert
        expect(failure1, equals(failure2));
        expect(failure1.hashCode, equals(failure2.hashCode));
      });

      test('two failures with different types are not equal', () {
        // Arrange
        const failure1 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );
        const failure2 = Failure(
          type: ApiFailureType(),
          message: 'Error',
        );

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('two failures with different messages are not equal', () {
        // Arrange
        const failure1 = Failure(
          type: ApiFailureType(),
          message: 'Error 1',
        );
        const failure2 = Failure(
          type: ApiFailureType(),
          message: 'Error 2',
        );

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('two failures with different status codes are not equal', () {
        // Arrange
        const failure1 = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );
        const failure2 = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('failure with null message equals another with null message', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: NetworkFailureType());

        // Assert
        expect(failure1, equals(failure2));
      });

      test('failure with message not equals failure without message', () {
        // Arrange
        const failure1 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );
        const failure2 = Failure(type: NetworkFailureType());

        // Assert
        expect(failure1, isNot(equals(failure2)));
      });

      test('hashCode is consistent for same instance', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error',
        );

        // Act
        final hash1 = failure.hashCode;
        final hash2 = failure.hashCode;

        // Assert
        expect(hash1, equals(hash2));
      });

      test('hashCode differs for different failures', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: ApiFailureType());

        // Assert
        expect(failure1.hashCode, isNot(equals(failure2.hashCode)));
      });
    });

    group('props', () {
      test('includes all fields in props', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error',
          statusCode: 500,
        );

        // Assert
        expect(failure.props, hasLength(3));
        expect(failure.props[0], isA<ApiFailureType>());
        expect(failure.props, contains('Error'));
        expect(failure.props, contains(500));
      });

      test('includes null values in props', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Assert
        expect(failure.props, hasLength(3));
        expect(failure.props[0], isA<NetworkFailureType>());
        expect(failure.props[1], isNull);
        expect(failure.props[2], isNull);
      });
    });

    group('safeCode', () {
      test('returns statusCode string when present', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals('500'));
      });

      test('returns type.code when statusCode is null', () {
        // Arrange
        const failure = Failure(type: NetworkFailureType());

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals(NetworkFailureType().code));
        expect(code, isA<String>());
      });

      test('prefers statusCode over type.code when both present', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 404,
        );

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals('404'));
        expect(code, isNot(equals(ApiFailureType().code)));
      });

      test('handles zero statusCode', () {
        // Arrange
        const failure = Failure(
          type: NetworkFailureType(),
          statusCode: 0,
        );

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals('0'));
      });

      test('handles negative statusCode', () {
        // Arrange
        const failure = Failure(
          type: UnknownFailureType(),
          statusCode: -1,
        );

        // Act
        final code = failure.safeCode;

        // Assert
        expect(code, equals('-1'));
      });
    });

    group('FailureType variants', () {
      test('NetworkFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: NetworkFailureType());

        // Assert
        expect(failure.type, isA<NetworkFailureType>());
      });

      test('ApiFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: ApiFailureType());

        // Assert
        expect(failure.type, isA<ApiFailureType>());
      });

      test('UnauthorizedFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: UnauthorizedFailureType());

        // Assert
        expect(failure.type, isA<UnauthorizedFailureType>());
      });

      test('JsonErrorFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: JsonErrorFailureType());

        // Assert
        expect(failure.type, isA<JsonErrorFailureType>());
      });

      test('NetworkTimeoutFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: NetworkTimeoutFailureType());

        // Assert
        expect(failure.type, isA<NetworkTimeoutFailureType>());
      });

      test('UnknownFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: UnknownFailureType());

        // Assert
        expect(failure.type, isA<UnknownFailureType>());
      });

      test('CacheFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: CacheFailureType());

        // Assert
        expect(failure.type, isA<CacheFailureType>());
      });

      test('FormatFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: FormatFailureType());

        // Assert
        expect(failure.type, isA<FormatFailureType>());
      });

      test('GenericFirebaseFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: GenericFirebaseFailureType());

        // Assert
        expect(failure.type, isA<GenericFirebaseFailureType>());
      });

      test('InvalidCredentialFirebaseFailureType is accessible', () {
        // Arrange & Act
        const failure = Failure(type: InvalidCredentialFirebaseFailureType());

        // Assert
        expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
      });
    });

    group('edge cases', () {
      test('handles empty message string', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: '',
        );

        // Assert
        expect(failure.message, equals(''));
        expect(failure.message, isEmpty);
      });

      test('handles very long message', () {
        // Arrange
        final longMessage = 'Error: ' * 1000;
        final failure = Failure(
          type: ApiFailureType(),
          message: longMessage,
        );

        // Assert
        expect(failure.message, equals(longMessage));
        expect(failure.message!.length, greaterThan(5000));
      });

      test('handles message with special characters', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Error: \n\t"quoted"\r\n',
        );

        // Assert
        expect(failure.message, contains('\n'));
        expect(failure.message, contains('\t'));
        expect(failure.message, contains('"'));
      });

      test('handles message with unicode characters', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Помилка: 错误 🔥',
        );

        // Assert
        expect(failure.message, contains('Помилка'));
        expect(failure.message, contains('错误'));
        expect(failure.message, contains('🔥'));
      });

      test('handles very large statusCode', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 999999999,
        );

        // Assert
        expect(failure.statusCode, equals(999999999));
        expect(failure.safeCode, equals('999999999'));
      });

      test('handles statusCode max int value', () {
        // Arrange
        const maxInt = 9223372036854775807; // 2^63 - 1
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: maxInt,
        );

        // Assert
        expect(failure.statusCode, equals(maxInt));
      });
    });

    group('real-world scenarios', () {
      test('represents network timeout failure', () {
        // Arrange
        const failure = Failure(
          type: NetworkTimeoutFailureType(),
          message: 'Connection timeout',
        );

        // Assert
        expect(failure.type, isA<NetworkTimeoutFailureType>());
        expect(failure.message, contains('timeout'));
      });

      test('represents HTTP 404 not found', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Resource not found',
          statusCode: 404,
        );

        // Assert
        expect(failure.statusCode, equals(404));
        expect(failure.safeCode, equals('404'));
      });

      test('represents HTTP 500 server error', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          message: 'Internal server error',
          statusCode: 500,
        );

        // Assert
        expect(failure.statusCode, equals(500));
        expect(failure.type, isA<ApiFailureType>());
      });

      test('represents authentication failure', () {
        // Arrange
        const failure = Failure(
          type: UnauthorizedFailureType(),
          message: 'Invalid username or password',
          statusCode: 401,
        );

        // Assert
        expect(failure.type, isA<UnauthorizedFailureType>());
        expect(failure.statusCode, equals(401));
      });

      test('represents JSON parsing error without statusCode', () {
        // Arrange
        const failure = Failure(
          type: JsonErrorFailureType(),
          message: 'Failed to parse response',
        );

        // Assert
        expect(failure.type, isA<JsonErrorFailureType>());
        expect(failure.statusCode, isNull);
        expect(failure.safeCode, isNotEmpty);
      });

      test('represents generic unknown error', () {
        // Arrange
        const failure = Failure(
          type: UnknownFailureType(),
          message: 'An unexpected error occurred',
        );

        // Assert
        expect(failure.type, isA<UnknownFailureType>());
      });

      test('represents Firebase invalid credential', () {
        // Arrange
        const failure = Failure(
          type: InvalidCredentialFirebaseFailureType(),
          message: 'The supplied auth credential is incorrect',
        );

        // Assert
        expect(failure.type, isA<InvalidCredentialFirebaseFailureType>());
        expect(failure.message, isNotEmpty);
      });

      test('represents cache error', () {
        // Arrange
        const failure = Failure(
          type: CacheFailureType(),
          message: 'Failed to read from cache',
        );

        // Assert
        expect(failure.type, isA<CacheFailureType>());
      });
    });

    group('collections', () {
      test('can be stored in Set without duplicates', () {
        // Arrange
        const failure1 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );
        const failure2 = Failure(
          type: NetworkFailureType(),
          message: 'Error',
        );
        const failure3 = Failure(
          type: ApiFailureType(),
          message: 'Error',
        );

        // Act
        // ignore: equal_elements_in_set
        final failures = {failure1, failure2, failure3};

        // Assert
        expect(failures, hasLength(2)); // failure1 == failure2
      });

      test('can be used as Map keys', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: ApiFailureType());

        // Act
        final map = {
          failure1: 'Network error occurred',
          failure2: 'Server error occurred',
        };

        // Assert
        expect(map[failure1], equals('Network error occurred'));
        expect(map[failure2], equals('Server error occurred'));
      });

      test('can be sorted in List', () {
        // Arrange
        const failures = [
          Failure(type: ApiFailureType(), statusCode: 500),
          Failure(type: ApiFailureType(), statusCode: 404),
          Failure(type: UnauthorizedFailureType(), statusCode: 401),
        ];

        // Act
        final sorted = List<Failure>.from(failures)
          ..sort((a, b) => (a.statusCode ?? 0).compareTo(b.statusCode ?? 0));

        // Assert
        expect(sorted[0].statusCode, equals(401));
        expect(sorted[1].statusCode, equals(404));
        expect(sorted[2].statusCode, equals(500));
      });
    });

    group('const semantics', () {
      test('can be used in const contexts', () {
        // Arrange & Act
        const failure = Failure(type: NetworkFailureType());
        const list = [failure];
        final map = {failure: 'error'}; // Removed const - Failure overrides ==

        // Assert
        expect(list, hasLength(1));
        expect(map.keys.first, equals(failure));
      });

      test('identical instances with same values', () {
        // Arrange
        const failure1 = Failure(type: NetworkFailureType());
        const failure2 = Failure(type: NetworkFailureType());

        // Assert
        expect(identical(failure1, failure2), isTrue);
      });

      test('compile-time constant evaluation works', () {
        // Arrange
        const failure = Failure(
          type: ApiFailureType(),
          statusCode: 500,
        );

        // This would fail at compile-time if not const
        const compileTimeValue = failure;

        // Assert
        expect(compileTimeValue, equals(failure));
      });
    });

    group('type hierarchy validation', () {
      test('all FailureType instances have code', () {
        // Arrange
        final types = [
          const NetworkFailureType(),
          const ApiFailureType(),
          const UnauthorizedFailureType(),
          const JsonErrorFailureType(),
          const NetworkTimeoutFailureType(),
          const UnknownFailureType(),
          const CacheFailureType(),
          const FormatFailureType(),
          const GenericFirebaseFailureType(),
          const InvalidCredentialFirebaseFailureType(),
        ];

        // Assert
        for (final type in types) {
          expect(type.code, isNotEmpty);
          expect(type.translationKey, isNotEmpty);
        }
      });

      test('different FailureType classes are not equal', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = ApiFailureType();

        // Assert
        expect(type1, isNot(equals(type2)));
        expect(type1.code, isNot(equals(type2.code)));
      });

      test('same FailureType instances are equal', () {
        // Arrange
        const type1 = NetworkFailureType();
        const type2 = NetworkFailureType();

        // Assert
        expect(type1, equals(type2));
        expect(identical(type1, type2), isTrue);
      });
    });
  });
}
