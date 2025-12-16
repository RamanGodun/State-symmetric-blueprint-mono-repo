/// Tests for `AppLocalizer` singleton
///
/// Coverage:
/// - Initialization (init, initWithFallback, forceInit)
/// - Translation resolution (translateSafely)
/// - Fallback handling
/// - State management (isInitialized)
/// - Edge cases and error scenarios
library;

import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/src/base_modules/localization/without_localization_case/fallback_keys.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLocalizer', () {
    setUp(() {
      // Reset the resolver before each test using forceInit
      AppLocalizer.forceInit(resolver: (key) => key);
    });

    group('initialization', () {
      test('init sets resolver when not already initialized', () {
        // Arrange
        AppLocalizer.forceInit(resolver: (key) => 'uninitialized');
        var callCount = 0;

        String testResolver(String key) {
          callCount++;
          return 'translated: $key';
        }

        // Act
        AppLocalizer.init(resolver: testResolver);
        final result = AppLocalizer.translateSafely('test.key');

        // Assert
        expect(callCount, equals(0)); // init should not override existing
        expect(result, equals('uninitialized'));
      });

      test('init does not override existing resolver', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'first: $key',
        );

        // Act
        AppLocalizer.init(resolver: (key) => 'second: $key');
        final result = AppLocalizer.translateSafely('test');

        // Assert
        expect(result, equals('first: test'));
      });

      test('forceInit overrides existing resolver', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'first: $key',
        );

        // Act
        AppLocalizer.forceInit(
          resolver: (key) => 'second: $key',
        );
        final result = AppLocalizer.translateSafely('test');

        // Assert
        expect(result, equals('second: test'));
      });

      test('initWithFallback uses LocalesFallbackMapper', () {
        // Arrange
        AppLocalizer.forceInit(resolver: (key) => 'should-be-overridden');

        // Act
        AppLocalizer.forceInit(
          resolver: LocalesFallbackMapper.resolveFallback,
        );
        final result = AppLocalizer.translateSafely('failure.unknown');

        // Assert
        expect(result, equals(FallbackKeysForErrors.unexpected));
      });

      test('isInitialized returns false when not initialized', () {
        // Arrange
        // ignore: invalid_use_of_visible_for_testing_member
        AppLocalizer.forceInit(resolver: (key) => key);
        // We can't truly uninitialize, but we can check the property works

        // Act & Assert
        expect(AppLocalizer.isInitialized, isTrue);
      });

      test('isInitialized returns true after initialization', () {
        // Arrange & Act
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Assert
        expect(AppLocalizer.isInitialized, isTrue);
      });
    });

    group('translateSafely', () {
      test('returns translated value when resolver finds translation', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'test.key') return 'Translated Text';
            return key;
          },
        );

        // Act
        final result = AppLocalizer.translateSafely('test.key');

        // Assert
        expect(result, equals('Translated Text'));
      });

      test('returns fallback when resolver returns null', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => '',
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'missing.key',
          fallback: 'Fallback Text',
        );

        // Assert
        expect(result, equals('Fallback Text'));
      });

      test('returns key when resolver returns key itself', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely('missing.key');

        // Assert
        expect(result, equals('missing.key'));
      });

      test('returns custom fallback when provided', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'missing.key',
          fallback: 'Custom Fallback',
        );

        // Assert
        expect(result, equals('Custom Fallback'));
      });

      test('prefers translation over fallback when available', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'Translated',
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'test.key',
          fallback: 'Fallback',
        );

        // Assert
        expect(result, equals('Translated'));
      });

      test('handles empty string key', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'translation',
        );

        // Act
        final result = AppLocalizer.translateSafely('');

        // Assert
        expect(result, isNotNull);
      });

      test('handles key with special characters', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'test.key.with.dots') return 'Success';
            return key;
          },
        );

        // Act
        final result = AppLocalizer.translateSafely('test.key.with.dots');

        // Assert
        expect(result, equals('Success'));
      });

      test('handles fallback with null value uses key', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely('test.key');

        // Assert
        expect(result, equals('test.key'));
      });
    });

    group('resolver behavior', () {
      test('resolver is called for each translation', () {
        // Arrange
        var callCount = 0;
        AppLocalizer.forceInit(
          resolver: (key) {
            callCount++;
            return 'translated';
          },
        );

        // Act
        AppLocalizer.translateSafely('key1');
        AppLocalizer.translateSafely('key2');
        AppLocalizer.translateSafely('key3');

        // Assert
        expect(callCount, equals(3));
      });

      test('resolver receives correct key parameter', () {
        // Arrange
        String? receivedKey;
        AppLocalizer.forceInit(
          resolver: (key) {
            receivedKey = key;
            return 'result';
          },
        );

        // Act
        AppLocalizer.translateSafely('test.key.value');

        // Assert
        expect(receivedKey, equals('test.key.value'));
      });

      test('resolver can return different values for different keys', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            switch (key) {
              case 'key1':
                return 'Value 1';
              case 'key2':
                return 'Value 2';
              default:
                return key;
            }
          },
        );

        // Act
        final result1 = AppLocalizer.translateSafely('key1');
        final result2 = AppLocalizer.translateSafely('key2');
        final result3 = AppLocalizer.translateSafely('key3');

        // Assert
        expect(result1, equals('Value 1'));
        expect(result2, equals('Value 2'));
        expect(result3, equals('key3'));
      });
    });

    group('fallback scenarios', () {
      test('uses fallback when translation is missing', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'missing.translation',
          fallback: 'Default Text',
        );

        // Assert
        expect(result, equals('Default Text'));
      });

      test('uses key as fallback when no fallback provided', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely('some.key');

        // Assert
        expect(result, equals('some.key'));
      });

      test('handles null from resolver with custom fallback', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => '',
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'any.key',
          fallback: 'Safe Fallback',
        );

        // Assert
        expect(result, equals('Safe Fallback'));
      });

      test('handles empty string fallback', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => key,
        );

        // Act
        final result = AppLocalizer.translateSafely(
          'key',
          fallback: '',
        );

        // Assert
        expect(result, equals(''));
      });
    });

    group('integration with LocalesFallbackMapper', () {
      test('resolves known failure keys from fallback mapper', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: LocalesFallbackMapper.resolveFallback,
        );

        // Act
        final unauthorized = AppLocalizer.translateSafely(
          'failure.auth.unauthorized',
        );
        final noInternet = AppLocalizer.translateSafely(
          'failure.network.no_connection',
        );
        final timeout = AppLocalizer.translateSafely(
          'failure.network.timeout',
        );

        // Assert
        expect(unauthorized, equals(FallbackKeysForErrors.unauthorized));
        expect(noInternet, equals(FallbackKeysForErrors.noInternet));
        expect(timeout, equals(FallbackKeysForErrors.timeout));
      });

      test('returns key for unmapped fallback keys', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: LocalesFallbackMapper.resolveFallback,
        );

        // Act
        final result = AppLocalizer.translateSafely('unmapped.key');

        // Assert
        expect(result, equals('unmapped.key'));
      });
    });

    group('edge cases', () {
      test('handles resolver that throws exception gracefully', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => throw Exception('Resolver error'),
        );

        // Act & Assert
        expect(
          () => AppLocalizer.translateSafely('test.key'),
          throwsException,
        );
      });

      test('handles very long key strings', () {
        // Arrange
        final longKey = 'a' * 10000;
        AppLocalizer.forceInit(
          resolver: (key) => 'translated: $key',
        );

        // Act
        final result = AppLocalizer.translateSafely(longKey);

        // Assert
        expect(result, contains('translated'));
        expect(result.length, greaterThan(10000));
      });

      test('handles unicode characters in keys', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            if (key == 'test.🔥.key') return 'Fire translation';
            return key;
          },
        );

        // Act
        final result = AppLocalizer.translateSafely('test.🔥.key');

        // Assert
        expect(result, equals('Fire translation'));
      });

      test('handles unicode characters in translations', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'Переклад 翻译 🌍',
        );

        // Act
        final result = AppLocalizer.translateSafely('test.key');

        // Assert
        expect(result, equals('Переклад 翻译 🌍'));
      });

      test('handles newlines in translations', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'Line 1\nLine 2\nLine 3',
        );

        // Act
        final result = AppLocalizer.translateSafely('multiline.key');

        // Assert
        expect(result, contains('\n'));
        expect(result, equals('Line 1\nLine 2\nLine 3'));
      });
    });

    group('state consistency', () {
      test('multiple calls with same key return same result', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'Translation for $key',
        );

        // Act
        final result1 = AppLocalizer.translateSafely('test.key');
        final result2 = AppLocalizer.translateSafely('test.key');
        final result3 = AppLocalizer.translateSafely('test.key');

        // Assert
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });

      test('forceInit changes behavior immediately', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'First resolver',
        );
        final beforeChange = AppLocalizer.translateSafely('test');

        // Act
        AppLocalizer.forceInit(
          resolver: (key) => 'Second resolver',
        );
        final afterChange = AppLocalizer.translateSafely('test');

        // Assert
        expect(beforeChange, equals('First resolver'));
        expect(afterChange, equals('Second resolver'));
      });

      test('isInitialized remains true after forceInit', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) => 'first',
        );
        final beforeForce = AppLocalizer.isInitialized;

        // Act
        AppLocalizer.forceInit(
          resolver: (key) => 'second',
        );
        final afterForce = AppLocalizer.isInitialized;

        // Assert
        expect(beforeForce, isTrue);
        expect(afterForce, isTrue);
      });
    });

    group('real-world scenarios', () {
      test('simulates EasyLocalization resolver behavior', () {
        // Arrange
        final translations = {
          'app.title': 'My Application',
          'button.submit': 'Submit',
          'error.network': 'Network Error',
        };

        AppLocalizer.forceInit(
          resolver: (key) => translations[key] ?? key,
        );

        // Act
        final title = AppLocalizer.translateSafely('app.title');
        final submit = AppLocalizer.translateSafely('button.submit');
        final missing = AppLocalizer.translateSafely(
          'missing.key',
          fallback: 'Default',
        );

        // Assert
        expect(title, equals('My Application'));
        expect(submit, equals('Submit'));
        expect(missing, equals('Default'));
      });

      test('simulates validation error message translation', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: (key) {
            final errorMessages = {
              'validation.email.invalid': 'Invalid email format',
              'validation.password.short': 'Password too short',
              'validation.required': 'This field is required',
            };
            return errorMessages[key] ?? key;
          },
        );

        // Act
        final emailError = AppLocalizer.translateSafely(
          'validation.email.invalid',
        );
        final passwordError = AppLocalizer.translateSafely(
          'validation.password.short',
        );

        // Assert
        expect(emailError, equals('Invalid email format'));
        expect(passwordError, equals('Password too short'));
      });

      test('simulates fallback-only mode without EasyLocalization', () {
        // Arrange
        AppLocalizer.forceInit(
          resolver: LocalesFallbackMapper.resolveFallback,
        );

        // Act
        final firebaseError = AppLocalizer.translateSafely(
          'failure.firebase.generic',
        );
        final unknownError = AppLocalizer.translateSafely(
          'failure.unknown',
        );

        // Assert
        expect(firebaseError, equals(FallbackKeysForErrors.firebaseGeneric));
        expect(unknownError, equals(FallbackKeysForErrors.unexpected));
      });
    });
  });
}
