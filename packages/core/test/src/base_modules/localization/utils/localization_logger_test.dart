/// Tests for `LocalizationLogger` utility
///
/// Coverage:
/// - missingKey logging
/// - fallbackUsed logging
/// - debugPrint integration
/// - Edge cases with special characters
library;

import 'package:core/src/base_modules/localization/utils/localization_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LocalizationLogger', () {
    group('missingKey', () {
      test('logs missing key with fallback', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: 'test.missing.key',
          fallback: 'Default Text',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('[Localization]'));
        expect(messages.first, contains('Missing'));
        expect(messages.first, contains('test.missing.key'));
        expect(messages.first, contains('Default Text'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('includes emoji indicator in log', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: 'some.key',
          fallback: 'fallback',
        );

        // Assert
        expect(messages.first, contains('🔍'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles empty key', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: '',
          fallback: 'Fallback',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('""'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles empty fallback', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: 'test.key',
          fallback: '',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('test.key'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles keys with special characters', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: 'test.key.with.@#\$',
          fallback: 'Fallback',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('test.key.with.@#\$'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles unicode in key and fallback', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(
          key: 'test.ключ.🔥',
          fallback: 'Запасний текст',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('test.ключ.🔥'));
        expect(messages.first, contains('Запасний текст'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles very long key', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };
        final longKey = 'test.${'key.' * 100}value';

        // Act
        LocalizationLogger.missingKey(
          key: longKey,
          fallback: 'Fallback',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains(longKey));

        // Cleanup
        debugPrintOverride = null;
      });
    });

    group('fallbackUsed', () {
      test('logs fallback usage', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('test.key', 'Fallback Value');

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('[Localization]'));
        expect(messages.first, contains('Fallback'));
        expect(messages.first, contains('test.key'));
        expect(messages.first, contains('Fallback Value'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('includes emoji indicator in log', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('key', 'value');

        // Assert
        expect(messages.first, contains('📄'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles empty key', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('', 'Fallback');

        // Assert
        expect(messages, hasLength(1));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles empty fallback', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('test.key', '');

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('test.key'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles unicode characters', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed(
          'test.ключ',
          'Значення по замовчуванню',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('test.ключ'));
        expect(messages.first, contains('Значення по замовчуванню'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles newlines in fallback', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed(
          'test.key',
          'Line 1\nLine 2\nLine 3',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('Line 1\nLine 2\nLine 3'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles special characters', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed(
          'test.key',
          'Value with @#\$%^&*()',
        );

        // Assert
        expect(messages, hasLength(1));
        expect(messages.first, contains('Value with @#\$%^&*()'));

        // Cleanup
        debugPrintOverride = null;
      });
    });

    group('multiple calls', () {
      test('logs multiple missing keys independently', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(key: 'key1', fallback: 'fallback1');
        LocalizationLogger.missingKey(key: 'key2', fallback: 'fallback2');
        LocalizationLogger.missingKey(key: 'key3', fallback: 'fallback3');

        // Assert
        expect(messages, hasLength(3));
        expect(messages[0], contains('key1'));
        expect(messages[1], contains('key2'));
        expect(messages[2], contains('key3'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('logs multiple fallback usages independently', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('key1', 'value1');
        LocalizationLogger.fallbackUsed('key2', 'value2');

        // Assert
        expect(messages, hasLength(2));
        expect(messages[0], contains('key1'));
        expect(messages[1], contains('key2'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('distinguishes between missingKey and fallbackUsed', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(key: 'key', fallback: 'fallback');
        LocalizationLogger.fallbackUsed('key', 'fallback');

        // Assert
        expect(messages, hasLength(2));
        expect(messages[0], contains('Missing'));
        expect(messages[0], contains('🔍'));
        expect(messages[1], contains('Fallback'));
        expect(messages[1], contains('📄'));

        // Cleanup
        debugPrintOverride = null;
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

    group('integration with debugPrint', () {
      test('respects debugPrint override', () {
        // Arrange
        var customCalled = false;
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          customCalled = true;
        };

        // Act
        LocalizationLogger.missingKey(key: 'test', fallback: 'fallback');

        // Assert
        expect(customCalled, isTrue);

        // Cleanup
        debugPrintOverride = null;
      });

      test('works when debugPrintOverride is null', () {
        // Arrange
        debugPrintOverride = null;

        // Act & Assert - should not throw
        expect(
          () => LocalizationLogger.missingKey(key: 'test', fallback: 'fb'),
          returnsNormally,
        );
      });
    });

    group('log format consistency', () {
      test('missingKey has consistent format', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.missingKey(key: 'test.key', fallback: 'fallback');

        // Assert
        final log = messages.first;
        expect(log, startsWith('[Localization]'));
        expect(log, contains('🔍'));
        expect(log, contains('Missing'));
        expect(log, contains('"test.key"'));
        expect(log, contains('Fallback:'));
        expect(log, contains('"fallback"'));

        // Cleanup
        debugPrintOverride = null;
      });

      test('fallbackUsed has consistent format', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('test.key', 'fallback');

        // Assert
        final log = messages.first;
        expect(log, startsWith('[Localization]'));
        expect(log, contains('📄'));
        expect(log, contains('Fallback'));
        expect(log, contains('"test.key"'));
        expect(log, contains('"fallback"'));

        // Cleanup
        debugPrintOverride = null;
      });
    });

    group('edge cases', () {
      test('handles same key logged multiple times', () {
        // Arrange
        final messages = <String>[];
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          if (message != null) messages.add(message);
        };

        // Act
        LocalizationLogger.fallbackUsed('same.key', 'value');
        LocalizationLogger.fallbackUsed('same.key', 'value');
        LocalizationLogger.fallbackUsed('same.key', 'value');

        // Assert
        expect(messages, hasLength(3));
        expect(messages, everyElement(contains('same.key')));

        // Cleanup
        debugPrintOverride = null;
      });

      test('handles null in debugPrintOverride parameter', () {
        // Arrange
        var nullReceived = false;
        debugPrintOverride = (String? message, {int? wrapWidth}) {
          nullReceived = message == null;
        };

        // Act
        LocalizationLogger.missingKey(key: 'key', fallback: 'fallback');

        // Assert
        expect(nullReceived, isFalse);

        // Cleanup
        debugPrintOverride = null;
      });
    });
  });
}
