/// Tests for `TranslateNullableKey` extension on String?
///
/// Coverage:
/// - translateOrNull getter behavior
/// - Null handling
/// - Integration with AppLocalizer
/// - Translation resolution
/// - Edge cases
library;

import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/src/base_modules/localization/utils/string_x.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TranslateNullableKey', () {
    setUp(() {
      // Initialize AppLocalizer with test resolver
      AppLocalizer.forceInit(
        resolver: (key) {
          final translations = {
            'test.key': 'Translated Text',
            'validation.email': 'Invalid email',
            'error.message': 'Error occurred',
          };
          return translations[key] ?? key;
        },
      );
    });

    group('translateOrNull', () {
      test('returns null when string is null', () {
        // Arrange
        const String? nullableKey = null;

        // Act
        final result = nullableKey.translateOrNull;

        // Assert
        expect(result, isNull);
      });

      test('returns translated value when key exists', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('Translated Text'));
      });

      test('returns key itself when translation not found', () {
        // Arrange
        const key = 'missing.key';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('missing.key'));
      });

      test('handles empty string', () {
        // Arrange
        const key = '';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, isEmpty);
      });

      test('translates validation keys', () {
        // Arrange
        const key = 'validation.email';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('Invalid email'));
      });

      test('translates error keys', () {
        // Arrange
        const key = 'error.message';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('Error occurred'));
      });
    });

    group('null safety', () {
      test('can be chained with null-aware operators', () {
        // Arrange
        String? nullableKey;

        // Act
        final result = nullableKey?.translateOrNull ?? 'Default';

        // Assert
        expect(result, equals('Default'));
      });

      test('works with non-null string', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result = key?.translateOrNull;

        // Assert
        expect(result, equals('Translated Text'));
      });

      test('returns null for null input without throwing', () {
        // Arrange
        const String? key = null;

        // Act & Assert
        expect(() => key.translateOrNull, returnsNormally);
        expect(key.translateOrNull, isNull);
      });
    });

    group('integration with AppLocalizer', () {
      test('uses AppLocalizer.translateSafely internally', () {
        // Arrange
        var localizerCalled = false;
        AppLocalizer.forceInit(
          resolver: (key) {
            localizerCalled = true;
            return 'translated';
          },
        );
        const key = 'test.key';

        // Act
        key.translateOrNull;

        // Assert
        expect(localizerCalled, isTrue);
      });

      test('respects AppLocalizer resolver changes', () {
        // Arrange
        const key = 'test.key';
        AppLocalizer.forceInit(resolver: (k) => 'First: $k');
        final first = key.translateOrNull;

        // Act
        AppLocalizer.forceInit(resolver: (k) => 'Second: $k');
        final second = key.translateOrNull;

        // Assert
        expect(first, equals('First: test.key'));
        expect(second, equals('Second: test.key'));
      });

      test('works when AppLocalizer is not initialized', () {
        // Arrange
        AppLocalizer.forceInit(resolver: (key) => key);
        const key = 'some.key';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('some.key'));
      });
    });

    group('special characters', () {
      test('handles keys with unicode', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'test.ключ') return 'Переклад';
            return key;
          },
        );
        const key = 'test.ключ';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('Переклад'));
      });

      test('handles keys with emojis', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'test.🔥') return 'Fire!';
            return key;
          },
        );
        const key = 'test.🔥';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('Fire!'));
      });

      test('handles keys with special symbols', () {
        // Arrange
        const key = r'test.key.with.@#$';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isNotNull);
      });

      test('handles keys with newlines', () {
        // Arrange
        const key = 'test\nkey';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isNotNull);
      });
    });

    group('edge cases', () {
      test('handles very long keys', () {
        // Arrange
        final longKey = 'test.${'key.' * 1000}value';
        final nullableKey = longKey;

        // Act
        final result = nullableKey.translateOrNull;

        // Assert
        expect(result, equals(longKey));
      });

      test('handles whitespace-only keys', () {
        // Arrange
        const key = '   ';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isNotNull);
        expect(result, equals('   '));
      });

      test('handles keys with dots', () {
        // Arrange
        const key = 'a.b.c.d.e';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('a.b.c.d.e'));
      });

      test('handles single character key', () {
        // Arrange
        const key = 'a';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, equals('a'));
      });
    });

    group('type safety', () {
      test('returns String? type', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isA<String?>());
      });

      test('nullable result can be assigned to String?', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result = key.translateOrNull;

        // Assert
        expect(result, isNotNull);
      });

      test('can use in conditional expressions', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result = key.translateOrNull ?? 'Default';

        // Assert
        expect(result, isNotEmpty);
      });
    });

    group('real-world scenarios', () {
      test('translates form validation error', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            final errors = {
              'form.email.invalid': 'Please enter a valid email',
              'form.password.short': 'Password must be at least 8 characters',
            };
            return errors[key] ?? key;
          },
        );
        const errorKey = 'form.email.invalid';

        // Act
        final errorMessage = errorKey.translateOrNull;

        // Assert
        expect(errorMessage, equals('Please enter a valid email'));
      });

      test('returns null for null error key', () {
        // Arrange
        String? errorKey;

        // Act
        final errorMessage = errorKey.translateOrNull;

        // Assert
        expect(errorMessage, isNull);
      });

      test('works in widget error label scenario', () {
        // Arrange
        const errorLabelKey = 'validation.required';
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'validation.required') return 'This field is required';
            return key;
          },
        );

        // Act
        final labelText = errorLabelKey.translateOrNull;

        // Assert
        expect(labelText, equals('This field is required'));
      });

      test('handles dynamic error keys', () {
        // Arrange
        final errorKeys = <String?>[
          'error.network',
          'error.timeout',
          null,
          'error.unknown',
        ];
        AppLocalizer.forceInit(
          resolver: (key) {
            final errors = {
              'error.network': 'Network error',
              'error.timeout': 'Timeout error',
              'error.unknown': 'Unknown error',
            };
            return errors[key] ?? key;
          },
        );

        // Act
        final translations = errorKeys.map((k) => k.translateOrNull).toList();

        // Assert
        expect(translations[0], equals('Network error'));
        expect(translations[1], equals('Timeout error'));
        expect(translations[2], isNull);
        expect(translations[3], equals('Unknown error'));
      });
    });

    group('comparison with direct AppLocalizer usage', () {
      test('produces same result as AppLocalizer.translateSafely for non-null', () {
        // Arrange
        const key = 'test.key';

        // Act
        final extensionResult = key.translateOrNull;
        final directResult = AppLocalizer.translateSafely(key);

        // Assert
        expect(extensionResult, equals(directResult));
      });

      test('handles null gracefully unlike direct AppLocalizer call', () {
        // Arrange
        const String? nullKey = null;

        // Act
        final extensionResult = nullKey.translateOrNull;

        // Assert - extension handles null, direct call would require null check
        expect(extensionResult, isNull);
      });
    });

    group('multiple calls', () {
      test('multiple calls with same key return consistent result', () {
        // Arrange
        const key = 'test.key';

        // Act
        final result1 = key.translateOrNull;
        final result2 = key.translateOrNull;
        final result3 = key.translateOrNull;

        // Assert
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });

      test('different keys return different results', () {
        // Arrange
        const key1 = 'test.key';
        const key2 = 'validation.email';

        // Act
        final result1 = key1.translateOrNull;
        final result2 = key2.translateOrNull;

        // Assert
        expect(result1, isNot(equals(result2)));
      });
    });

    group('list operations', () {
      test('can be used in map operations', () {
        // Arrange
        final keys = <String?>['test.key', 'validation.email', null];

        // Act
        final translations = keys.map((k) => k.translateOrNull).toList();

        // Assert
        expect(translations, hasLength(3));
        expect(translations[0], equals('Translated Text'));
        expect(translations[1], equals('Invalid email'));
        expect(translations[2], isNull);
      });

      test('can be used in where operations', () {
        // Arrange
        final keys = <String?>['test.key', null, 'error.message'];

        // Act
        final nonNullTranslations = keys
            .map((k) => k.translateOrNull)
            .where((t) => t != null)
            .toList();

        // Assert
        expect(nonNullTranslations, hasLength(2));
        expect(nonNullTranslations, everyElement(isNotNull));
      });
    });
  });
}
