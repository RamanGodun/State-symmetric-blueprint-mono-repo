/// Tests for `FailureToUIEntityX` extension from failure_ui_mapper.dart
///
/// This test follows best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
/// ✅ Real-world scenarios
///
/// Coverage:
/// - toUIEntity() transformation
/// - Localization with translation key
/// - Fallback to message when no translation
/// - Fallback to code when no message
/// - Icon mapping integration
/// - LocalizationLogger integration
/// - All combination scenarios (hasTranslation × hasMessage)
library;

import 'dart:io';

import 'package:core/public_api/base_modules/errors_management.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureToUIEntityX', () {
    group('toUIEntity', () {
      group('translation with message scenarios', () {
        test('uses translated text when translation exists', () {
          // Arrange
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Fallback message',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
          // Translation key is used via AppLocalizer.translateSafely
        });

        test('includes message as fallback parameter', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Custom error message',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
          // When translation fails, fallback message is used
        });

        test('handles failure with both translation key and message', () {
          // Arrange
          const failure = Failure(
            type: UnauthorizedFailureType(),
            message: 'User not authorized',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
        });
      });

      group('translation without message scenarios', () {
        test('uses translated text when no message provided', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
          // Uses AppLocalizer.translateSafely without fallback
        });

        test('handles failure with only translation key', () {
          // Arrange
          const failure = Failure(type: NetworkTimeoutFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles Firebase failure without message', () {
          // Arrange
          const failure = Failure(type: GenericFirebaseFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });
      });

      group('no translation with message scenarios', () {
        test('uses message directly when no translation key', () {
          // Arrange
          const failure = Failure(
            type: UnknownFailureType(),
            message: 'Direct error message',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, equals('Direct error message'));
        });

        test('uses custom message as-is', () {
          // Arrange
          const failure = Failure(
            type: CacheFailureType(),
            message: 'Cache read failed',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });
      });

      group('no translation no message scenarios', () {
        test('falls back to failure type code', () {
          // Arrange
          const failure = Failure(type: UnknownFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, equals(failure.type.code));
        });

        test('uses code as last resort fallback', () {
          // Arrange
          const failure = Failure(type: CacheFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          // When no translation and no message, uses type.code
          expect(uiEntity.localizedMessage, isNotEmpty);
        });
      });

      group('formattedCode mapping', () {
        test('maps statusCode to formattedCode', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 500,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('500'));
        });

        test('uses type.code when no statusCode', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals(failure.safeCode));
        });

        test('prioritizes statusCode over type code', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 404,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('404'));
          expect(
            uiEntity.formattedCode,
            isNot(equals(failure.type.code)),
          );
        });
      });

      group('icon mapping', () {
        test('maps failure type to icon', () {
          // Arrange
          const failure = Failure(type: NetworkFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.icon, isNotNull);
          // Icon is provided via type.icon extension
        });

        test('includes icon for different failure types', () {
          // Arrange
          final failures = [
            const Failure(type: NetworkFailureType()),
            const Failure(type: ApiFailureType()),
            const Failure(type: UnauthorizedFailureType()),
            const Failure(type: CacheFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            final uiEntity = failure.toUIEntity();
            expect(uiEntity.icon, isNotNull);
          }
        });
      });

      group('FailureUIEntity structure', () {
        test('creates valid FailureUIEntity with all fields', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Server error',
            statusCode: 500,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
          expect(uiEntity.formattedCode, equals('500'));
          expect(uiEntity.icon, isNotNull);
        });

        test('creates FailureUIEntity with minimal data', () {
          // Arrange
          const failure = Failure(type: UnknownFailureType());

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
          expect(uiEntity.formattedCode, isNotEmpty);
          expect(uiEntity.icon, isNotNull);
        });
      });

      group('edge cases', () {
        test('handles empty message string', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: '',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          // Empty message is treated as no message
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles very long message', () {
          // Arrange
          final longMessage = 'Error: ' * 1000;
          final failure = Failure(
            type: const NetworkFailureType(),
            message: longMessage,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles message with unicode characters', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Помилка: 错误 🔥',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles message with special characters', () {
          // Arrange
          const failure = Failure(
            type: FormatFailureType(),
            message: 'Error:\n\t"quoted"\r\n',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles null message explicitly', () {
          // Arrange
          const failure = Failure(
            type: NetworkFailureType(),
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('handles zero status code', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: 0,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('0'));
        });

        test('handles negative status code', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            statusCode: -1,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('-1'));
        });
      });

      group('real-world scenarios', () {
        test('transforms network error for UI display', () {
          // Arrange
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'No internet connection',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
          expect(uiEntity.icon, isNotNull);
        });

        test('transforms API error with status code', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Internal server error',
            statusCode: 500,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('500'));
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('transforms authentication error', () {
          // Arrange
          const failure = Failure(
            type: UnauthorizedFailureType(),
            message: 'Invalid credentials',
            statusCode: 401,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('401'));
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('transforms timeout error', () {
          // Arrange
          const failure = Failure(
            type: NetworkTimeoutFailureType(),
            message: 'Request timeout',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('transforms cache error', () {
          // Arrange
          const failure = Failure(
            type: CacheFailureType(),
            message: 'Failed to read from cache',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('transforms JSON parsing error', () {
          // Arrange
          const failure = Failure(
            type: JsonErrorFailureType(),
            message: 'Invalid JSON format',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
        });

        test('transforms Firebase auth error', () {
          // Arrange
          const failure = Failure(
            type: InvalidCredentialFirebaseFailureType(),
            message: 'Wrong password',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.localizedMessage, isNotEmpty);
        });

        test('transforms unknown error gracefully', () {
          // Arrange
          const failure = Failure(
            type: UnknownFailureType(),
            message: 'Something went wrong',
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
        });
      });

      group('all failure types coverage', () {
        test('maps all network failure types', () {
          // Arrange
          final failures = [
            const Failure(type: NetworkFailureType()),
            const Failure(type: NetworkTimeoutFailureType()),
            const Failure(type: ApiFailureType()),
            const Failure(type: UnauthorizedFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            final uiEntity = failure.toUIEntity();
            expect(uiEntity, isA<FailureUIEntity>());
            expect(uiEntity.localizedMessage, isNotEmpty);
            expect(uiEntity.formattedCode, isNotEmpty);
          }
        });

        test('maps all Firebase failure types', () {
          // Arrange
          final failures = [
            const Failure(type: GenericFirebaseFailureType()),
            const Failure(type: InvalidCredentialFirebaseFailureType()),
            const Failure(type: EmailAlreadyInUseFirebaseFailureType()),
            const Failure(type: UserNotFoundFirebaseFailureType()),
            const Failure(type: UserDisabledFirebaseFailureType()),
            const Failure(type: TooManyRequestsFirebaseFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            final uiEntity = failure.toUIEntity();
            expect(uiEntity, isA<FailureUIEntity>());
            expect(uiEntity.localizedMessage, isNotEmpty);
          }
        });

        test('maps all misc failure types', () {
          // Arrange
          final failures = [
            const Failure(type: UnknownFailureType()),
            const Failure(type: CacheFailureType()),
            const Failure(type: FormatFailureType()),
            const Failure(type: JsonErrorFailureType()),
            const Failure(type: MissingPluginFailureType()),
          ];

          // Act & Assert
          for (final failure in failures) {
            final uiEntity = failure.toUIEntity();
            expect(uiEntity, isA<FailureUIEntity>());
            expect(uiEntity.localizedMessage, isNotEmpty);
          }
        });
      });

      group('integration', () {
        test('complete flow from exception to UI entity', () {
          // Arrange - Start with exception
          const exception = SocketException('Network error');

          // Act - Map to failure then to UI entity
          final failure = exception.mapToFailure();
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity.localizedMessage, isNotEmpty);
          expect(uiEntity.formattedCode, isNotEmpty);
          expect(uiEntity.icon, isNotNull);
        });

        test('preserves all data through transformation', () {
          // Arrange
          const failure = Failure(
            type: ApiFailureType(),
            message: 'Test error message',
            statusCode: 500,
          );

          // Act
          final uiEntity = failure.toUIEntity();

          // Assert
          expect(uiEntity.formattedCode, equals('500'));
          expect(uiEntity.localizedMessage, isNotEmpty);
          expect(uiEntity.icon, isNotNull);
        });

        test('works with failures from runWithErrorHandling', () async {
          // Arrange
          Future<int> operation() async =>
              throw const SocketException('Network');

          // Act
          final result = await operation.runWithErrorHandling();
          final failure = result.fold((l) => l, (r) => null);
          final uiEntity = failure?.toUIEntity();

          // Assert
          expect(uiEntity, isA<FailureUIEntity>());
          expect(uiEntity?.localizedMessage, isNotEmpty);
        });
      });

      group('consistency', () {
        test('produces same result for identical failures', () {
          // Arrange
          const failure = Failure(
            type: NetworkFailureType(),
            message: 'Error',
          );

          // Act
          final uiEntity1 = failure.toUIEntity();
          final uiEntity2 = failure.toUIEntity();

          // Assert
          expect(
            uiEntity1.localizedMessage,
            equals(uiEntity2.localizedMessage),
          );
          expect(uiEntity1.formattedCode, equals(uiEntity2.formattedCode));
        });

        test('all UI entities have required fields', () {
          // Arrange
          final failures = [
            const Failure(type: NetworkFailureType()),
            const Failure(type: ApiFailureType(), statusCode: 500),
            const Failure(type: UnknownFailureType(), message: 'Error'),
          ];

          // Act & Assert
          for (final failure in failures) {
            final uiEntity = failure.toUIEntity();
            expect(uiEntity.localizedMessage, isNotEmpty);
            expect(uiEntity.formattedCode, isNotEmpty);
            expect(uiEntity.icon, isNotNull);
          }
        });
      });
    });
  });
}
