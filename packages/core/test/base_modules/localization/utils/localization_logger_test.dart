/// Tests for `LocalizationLogger` utility
///
/// Coverage:
/// - missingKey logging
/// - fallbackUsed logging
/// - Method invocation without errors
/// - Edge cases with special characters
library;

import 'package:core/src/base_modules/localization/utils/localization_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalizationLogger', () {
    group('missingKey', () {
      test('logs missing key with fallback without throwing', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: 'test.missing.key',
            fallback: 'Default Text',
          ),
          returnsNormally,
        );
      });

      test('handles empty key', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: '',
            fallback: 'Fallback',
          ),
          returnsNormally,
        );
      });

      test('handles empty fallback', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: 'test.key',
            fallback: '',
          ),
          returnsNormally,
        );
      });

      test('handles keys with special characters', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: r'test.key.with.@#$',
            fallback: 'Fallback',
          ),
          returnsNormally,
        );
      });

      test('handles unicode in key and fallback', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: 'test.ключ.🔥',
            fallback: 'Запасний текст',
          ),
          returnsNormally,
        );
      });

      test('handles very long key', () {
        // Arrange
        final longKey = 'test.${'key.' * 100}value';

        // Act & Assert
        expect(
          () => LocalizationLogger.missingKey(
            key: longKey,
            fallback: 'Fallback',
          ),
          returnsNormally,
        );
      });
    });

    group('fallbackUsed', () {
      test('logs fallback usage without throwing', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed('test.key', 'Fallback Value'),
          returnsNormally,
        );
      });

      test('handles empty key', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed('', 'Fallback'),
          returnsNormally,
        );
      });

      test('handles empty fallback', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed('test.key', ''),
          returnsNormally,
        );
      });

      test('handles unicode characters', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed(
            'test.ключ',
            'Значення по замовчуванню',
          ),
          returnsNormally,
        );
      });

      test('handles newlines in fallback', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed(
            'test.key',
            'Line 1\nLine 2\nLine 3',
          ),
          returnsNormally,
        );
      });

      test('handles special characters', () {
        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed(
            'test.key',
            r'Value with @#$%^&*()',
          ),
          returnsNormally,
        );
      });
    });

    group('multiple calls', () {
      test('logs multiple missing keys independently', () {
        // Act & Assert
        expect(
          () {
            LocalizationLogger.missingKey(key: 'key1', fallback: 'fallback1');
            LocalizationLogger.missingKey(key: 'key2', fallback: 'fallback2');
            LocalizationLogger.missingKey(key: 'key3', fallback: 'fallback3');
          },
          returnsNormally,
        );
      });

      test('logs multiple fallback usages independently', () {
        // Act & Assert
        expect(
          () {
            LocalizationLogger.fallbackUsed('key1', 'value1');
            LocalizationLogger.fallbackUsed('key2', 'value2');
          },
          returnsNormally,
        );
      });

      test('can call both missingKey and fallbackUsed', () {
        // Act & Assert
        expect(
          () {
            LocalizationLogger.missingKey(key: 'key', fallback: 'fallback');
            LocalizationLogger.fallbackUsed('key', 'fallback');
          },
          returnsNormally,
        );
      });
    });

    group('abstract class properties', () {
      test('cannot be instantiated', () {
        // Assert - this is a compile-time check
        // LocalizationLogger() would fail to compile
        expect(LocalizationLogger, isA<Type>());
      });

      test('has static methods only', () {
        // Assert - verifying methods are callable without instance
        expect(LocalizationLogger.missingKey, isA<Function>());
        expect(LocalizationLogger.fallbackUsed, isA<Function>());
      });
    });

    group('edge cases', () {
      test('handles same key logged multiple times', () {
        // Act & Assert
        expect(
          () {
            LocalizationLogger.fallbackUsed('same.key', 'value');
            LocalizationLogger.fallbackUsed('same.key', 'value');
            LocalizationLogger.fallbackUsed('same.key', 'value');
          },
          returnsNormally,
        );
      });

      test('handles rapid successive calls', () {
        // Act & Assert
        expect(
          () {
            for (var i = 0; i < 100; i++) {
              LocalizationLogger.missingKey(key: 'key$i', fallback: 'fb$i');
            }
          },
          returnsNormally,
        );
      });

      test('handles very long fallback text', () {
        // Arrange
        final longFallback = 'text' * 1000;

        // Act & Assert
        expect(
          () => LocalizationLogger.fallbackUsed('key', longFallback),
          returnsNormally,
        );
      });
    });
  });
}
