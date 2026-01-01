// Tests use const constructors extensively for immutable objects
// ignore_for_file: equal_elements_in_set

/// Tests for `FailureUIEntity`
///
/// Coverage:
/// - FailureUIEntity construction
/// - Equatable props (equality, hashCode)
/// - All fields validation
/// - Edge cases
library;

import 'package:core/src/base_modules/errors_management/core_of_module/failure_ui_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FailureUIEntity', () {
    group('construction', () {
      test('creates instance with all required parameters', () {
        // Arrange & Act
        const uiEntity = FailureUIEntity(
          localizedMessage: 'No internet connection',
          formattedCode: 'NETWORK',
          icon: Icons.wifi_off,
        );

        // Assert
        expect(uiEntity, isA<FailureUIEntity>());
        expect(uiEntity.localizedMessage, equals('No internet connection'));
        expect(uiEntity.formattedCode, equals('NETWORK'));
        expect(uiEntity.icon, equals(Icons.wifi_off));
      });

      test('creates instance with HTTP status code', () {
        // Arrange & Act
        const uiEntity = FailureUIEntity(
          localizedMessage: 'Not found',
          formattedCode: '404',
          icon: Icons.error_outline,
        );

        // Assert
        expect(uiEntity.localizedMessage, equals('Not found'));
        expect(uiEntity.formattedCode, equals('404'));
        expect(uiEntity.icon, equals(Icons.error_outline));
      });

      test('creates instance with Firebase error', () {
        // Arrange & Act
        const uiEntity = FailureUIEntity(
          localizedMessage: 'Invalid credentials',
          formattedCode: 'invalid-credential',
          icon: Icons.vpn_key_off,
        );

        // Assert
        expect(uiEntity.localizedMessage, equals('Invalid credentials'));
        expect(uiEntity.formattedCode, equals('invalid-credential'));
        expect(uiEntity.icon, equals(Icons.vpn_key_off));
      });

      test('is immutable', () {
        // Arrange
        const uiEntity = FailureUIEntity(
          localizedMessage: 'Error message',
          formattedCode: 'ERROR_CODE',
          icon: Icons.error,
        );

        // Assert - attempting to modify would cause compile error
        expect(uiEntity.localizedMessage, isA<String>());
        expect(uiEntity.formattedCode, isA<String>());
        expect(uiEntity.icon, isA<IconData>());
      });
    });

    group('equality (Equatable)', () {
      test('two entities with same values are equal', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Assert
        expect(entity1, equals(entity2));
        expect(entity1.hashCode, equals(entity2.hashCode));
      });

      test('two entities with different messages are not equal', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error 1',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error 2',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('two entities with different codes are not equal', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE1',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE2',
          icon: Icons.error,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('two entities with different icons are not equal', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.warning,
        );

        // Assert
        expect(entity1, isNot(equals(entity2)));
      });

      test('hashCode is consistent for same instance', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Act
        final hash1 = entity.hashCode;
        final hash2 = entity.hashCode;

        // Assert
        expect(hash1, equals(hash2));
      });

      test('hashCode differs for different entities', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error 1',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error 2',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Assert
        expect(entity1.hashCode, isNot(equals(entity2.hashCode)));
      });
    });

    group('props', () {
      test('includes all fields in props', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Error message',
          formattedCode: 'ERR_CODE',
          icon: Icons.error_outline,
        );

        // Assert
        expect(entity.props, hasLength(3));
        expect(entity.props, contains('Error message'));
        expect(entity.props, contains('ERR_CODE'));
        expect(entity.props, contains(Icons.error_outline));
      });

      test('props order is consistent', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Message',
          formattedCode: 'CODE',
          icon: Icons.info,
        );

        // Assert
        expect(entity.props[0], equals('Message'));
        expect(entity.props[1], equals('CODE'));
        expect(entity.props[2], equals(Icons.info));
      });
    });

    group('edge cases', () {
      test('handles empty localized message', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: '',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Assert
        expect(entity.localizedMessage, equals(''));
        expect(entity.localizedMessage, isEmpty);
      });

      test('handles very long localized message', () {
        // Arrange
        final longMessage = 'Error: ' * 500;
        final entity = FailureUIEntity(
          localizedMessage: longMessage,
          formattedCode: 'LONG_ERROR',
          icon: Icons.error,
        );

        // Assert
        expect(entity.localizedMessage, equals(longMessage));
        expect(entity.localizedMessage.length, greaterThan(3000));
      });

      test('handles unicode in localized message', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Помилка: 错误 🔥',
          formattedCode: 'UNICODE',
          icon: Icons.error,
        );

        // Assert
        expect(entity.localizedMessage, contains('Помилка'));
        expect(entity.localizedMessage, contains('错误'));
        expect(entity.localizedMessage, contains('🔥'));
      });

      test('handles special characters in message', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Error: \n\t"quoted"\r\n',
          formattedCode: 'SPECIAL',
          icon: Icons.error,
        );

        // Assert
        expect(entity.localizedMessage, contains('\n'));
        expect(entity.localizedMessage, contains('\t'));
        expect(entity.localizedMessage, contains('"'));
      });

      test('handles empty formatted code', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: '',
          icon: Icons.error,
        );

        // Assert
        expect(entity.formattedCode, equals(''));
        expect(entity.formattedCode, isEmpty);
      });
    });

    group('real-world scenarios', () {
      test('represents network error for display', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'No internet connection',
          formattedCode: 'NETWORK',
          icon: Icons.signal_wifi_connected_no_internet_4,
        );

        // Assert
        expect(entity.localizedMessage, isNotEmpty);
        expect(entity.formattedCode, equals('NETWORK'));
        expect(entity.icon, equals(Icons.signal_wifi_connected_no_internet_4));
      });

      test('represents HTTP 404 error', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Resource not found',
          formattedCode: '404',
          icon: Icons.error_outline,
        );

        // Assert
        expect(entity.formattedCode, equals('404'));
        expect(entity.localizedMessage, contains('not found'));
      });

      test('represents HTTP 500 error', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Internal server error',
          formattedCode: '500',
          icon: Icons.cloud_off,
        );

        // Assert
        expect(entity.formattedCode, equals('500'));
        expect(entity.localizedMessage, contains('server'));
      });

      test('represents Firebase auth error', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Invalid email or password',
          formattedCode: 'invalid-credential',
          icon: Icons.vpn_key_off,
        );

        // Assert
        expect(entity.formattedCode, equals('invalid-credential'));
        expect(entity.icon, equals(Icons.vpn_key_off));
      });

      test('represents cache error', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Failed to read from cache',
          formattedCode: 'CACHE',
          icon: Icons.sd_storage,
        );

        // Assert
        expect(entity.formattedCode, equals('CACHE'));
        expect(entity.icon, equals(Icons.sd_storage));
      });
    });

    group('collections', () {
      test('can be stored in Set without duplicates', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity3 = FailureUIEntity(
          localizedMessage: 'Different Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Act
        final entities = {entity1, entity2, entity3};

        // Assert
        expect(entities, hasLength(2)); // entity1 == entity2
      });

      test('can be used as Map keys', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Network Error',
          formattedCode: 'NETWORK',
          icon: Icons.wifi_off,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'API Error',
          formattedCode: 'API',
          icon: Icons.cloud_off,
        );

        // Act
        final map = {
          entity1: 'Show retry button',
          entity2: 'Contact support',
        };

        // Assert
        expect(map[entity1], equals('Show retry button'));
        expect(map[entity2], equals('Contact support'));
      });

      test('can be sorted in List', () {
        // Arrange
        const entities = [
          FailureUIEntity(
            localizedMessage: 'C',
            formattedCode: '500',
            icon: Icons.error,
          ),
          FailureUIEntity(
            localizedMessage: 'A',
            formattedCode: '404',
            icon: Icons.error,
          ),
          FailureUIEntity(
            localizedMessage: 'B',
            formattedCode: '401',
            icon: Icons.error,
          ),
        ];

        // Act
        final sorted = List<FailureUIEntity>.from(entities)
          ..sort((a, b) => a.formattedCode.compareTo(b.formattedCode));

        // Assert
        expect(sorted[0].formattedCode, equals('401'));
        expect(sorted[1].formattedCode, equals('404'));
        expect(sorted[2].formattedCode, equals('500'));
      });
    });

    group('const semantics', () {
      test('can be used in const contexts', () {
        // Arrange & Act
        const entity = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const list = [entity];

        // Assert
        expect(list, hasLength(1));
        expect(list.first, equals(entity));
      });

      test('identical instances with same values', () {
        // Arrange
        const entity1 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );
        const entity2 = FailureUIEntity(
          localizedMessage: 'Error',
          formattedCode: 'CODE',
          icon: Icons.error,
        );

        // Assert
        expect(identical(entity1, entity2), isTrue);
      });

      test('compile-time constant evaluation works', () {
        // Arrange
        const entity = FailureUIEntity(
          localizedMessage: 'Compile-time error',
          formattedCode: 'COMPILE',
          icon: Icons.build,
        );

        // This would fail at compile-time if not const
        const compileTimeValue = entity;

        // Assert
        expect(compileTimeValue, equals(entity));
      });
    });

    group('icon coverage', () {
      test('supports all Material Icons', () {
        // Arrange & Act
        const entities = [
          FailureUIEntity(
            localizedMessage: 'Error',
            formattedCode: 'CODE',
            icon: Icons.error,
          ),
          FailureUIEntity(
            localizedMessage: 'Warning',
            formattedCode: 'WARN',
            icon: Icons.warning,
          ),
          FailureUIEntity(
            localizedMessage: 'Info',
            formattedCode: 'INFO',
            icon: Icons.info,
          ),
          FailureUIEntity(
            localizedMessage: 'Success',
            formattedCode: 'OK',
            icon: Icons.check_circle,
          ),
        ];

        // Assert
        for (final entity in entities) {
          expect(entity.icon, isA<IconData>());
        }
      });
    });
  });
}
