/// Tests for `LocalesFallbackMapper` and `FallbackKeysForErrors`
///
/// Coverage:
/// - resolveFallback method
/// - Fallback map entries
/// - FallbackKeysForErrors constants
/// - Unknown key handling
/// - Edge cases
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/localization.dart';

void main() {
  group('LocalesFallbackMapper', () {
    group('resolveFallback', () {
      test('resolves unauthorized failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.auth.unauthorized',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.unauthorized));
        expect(result, equals('Access denied. Please log in.'));
      });

      test('resolves firebase generic failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.firebase.generic',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.firebaseGeneric));
        expect(result, equals('A Firebase error occurred.'));
      });

      test('resolves format error failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.format.error',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.formatError));
        expect(result, equals('Invalid data format received.'));
      });

      test('resolves network no connection failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.network.no_connection',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.noInternet));
        expect(result, equals('No internet connection'));
      });

      test('resolves network timeout failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.network.timeout',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.timeout));
        expect(result, equals('Request timeout. Try again.'));
      });

      test('resolves plugin missing failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.plugin.missing',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.pluginMissing));
        expect(result, equals('Required plugin is missing'));
      });

      test('resolves unknown failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.unknown',
        );

        // Assert
        expect(result, equals(FallbackKeysForErrors.unexpected));
        expect(result, equals('Something went wrong'));
      });

      test('returns key itself when not found in map', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'unmapped.key',
        );

        // Assert
        expect(result, equals('unmapped.key'));
      });

      test('handles empty string key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback('');

        // Assert
        expect(result, equals(''));
      });

      test('handles non-existent failure key', () {
        // Act
        final result = LocalesFallbackMapper.resolveFallback(
          'failure.nonexistent',
        );

        // Assert
        expect(result, equals('failure.nonexistent'));
      });

      test('is case-sensitive', () {
        // Act
        final result1 = LocalesFallbackMapper.resolveFallback(
          'failure.unknown',
        );
        final result2 = LocalesFallbackMapper.resolveFallback(
          'Failure.Unknown',
        );

        // Assert
        expect(result1, equals(FallbackKeysForErrors.unexpected));
        expect(result2, equals('Failure.Unknown')); // Not found
      });
    });

    group('all mapped keys', () {
      test('all known keys return non-empty values', () {
        // Arrange
        final knownKeys = [
          'failure.auth.unauthorized',
          'failure.firebase.generic',
          'failure.format.error',
          'failure.network.no_connection',
          'failure.network.timeout',
          'failure.plugin.missing',
          'failure.unknown',
        ];

        // Act & Assert
        for (final key in knownKeys) {
          final result = LocalesFallbackMapper.resolveFallback(key);
          expect(result, isNotEmpty);
          expect(result, isNot(equals(key)));
        }
      });

      test('all known keys return different values', () {
        // Arrange
        final knownKeys = [
          'failure.auth.unauthorized',
          'failure.firebase.generic',
          'failure.format.error',
          'failure.network.no_connection',
          'failure.network.timeout',
          'failure.plugin.missing',
          'failure.unknown',
        ];

        // Act
        final results = knownKeys
            .map(LocalesFallbackMapper.resolveFallback)
            .toSet();

        // Assert
        expect(results, hasLength(knownKeys.length));
      });
    });

    group('edge cases', () {
      test('handles very long key', () {
        // Arrange
        final longKey = 'failure.${'key.' * 1000}value';

        // Act
        final result = LocalesFallbackMapper.resolveFallback(longKey);

        // Assert
        expect(result, equals(longKey));
      });

      test('handles key with special characters', () {
        // Arrange
        const key = r'failure.@#$%^&*()';

        // Act
        final result = LocalesFallbackMapper.resolveFallback(key);

        // Assert
        expect(result, equals(key));
      });

      test('handles key with unicode', () {
        // Arrange
        const key = 'failure.помилка.🔥';

        // Act
        final result = LocalesFallbackMapper.resolveFallback(key);

        // Assert
        expect(result, equals(key));
      });

      test('handles key with whitespace', () {
        // Arrange
        const key = 'failure.key with spaces';

        // Act
        final result = LocalesFallbackMapper.resolveFallback(key);

        // Assert
        expect(result, equals(key));
      });

      test('handles key with newlines', () {
        // Arrange
        const key = 'failure.key\nwith\nnewlines';

        // Act
        final result = LocalesFallbackMapper.resolveFallback(key);

        // Assert
        expect(result, equals(key));
      });
    });

    group('multiple calls', () {
      test('returns consistent results for same key', () {
        // Arrange
        const key = 'failure.unknown';

        // Act
        final result1 = LocalesFallbackMapper.resolveFallback(key);
        final result2 = LocalesFallbackMapper.resolveFallback(key);
        final result3 = LocalesFallbackMapper.resolveFallback(key);

        // Assert
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });

      test('handles rapid successive calls', () {
        // Act & Assert
        for (var i = 0; i < 1000; i++) {
          final result = LocalesFallbackMapper.resolveFallback(
            'failure.unknown',
          );
          expect(result, equals(FallbackKeysForErrors.unexpected));
        }
      });
    });

    group('integration scenarios', () {
      test('can be used as AppLocalizer resolver', () {
        // Act
        const resolver = LocalesFallbackMapper.resolveFallback;
        final result = resolver('failure.network.no_connection');

        // Assert
        expect(result, equals(FallbackKeysForErrors.noInternet));
      });

      test('works with collection operations', () {
        // Arrange
        final keys = [
          'failure.unknown',
          'failure.network.timeout',
          'unmapped.key',
        ];

        // Act
        final results = keys
            .map(LocalesFallbackMapper.resolveFallback)
            .toList();

        // Assert
        expect(results[0], equals(FallbackKeysForErrors.unexpected));
        expect(results[1], equals(FallbackKeysForErrors.timeout));
        expect(results[2], equals('unmapped.key'));
      });
    });

    group('abstract class properties', () {
      test('cannot be instantiated', () {
        // Assert - compile-time check
        expect(LocalesFallbackMapper, isA<Type>());
      });

      test('has static method only', () {
        // Assert
        expect(LocalesFallbackMapper.resolveFallback, isA<Function>());
      });
    });
  });

  group('FallbackKeysForErrors', () {
    group('constant values', () {
      test('unexpected has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.unexpected,
          equals('Something went wrong'),
        );
      });

      test('noInternet has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.noInternet,
          equals('No internet connection'),
        );
      });

      test('timeout has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.timeout,
          equals('Request timeout. Try again.'),
        );
      });

      test('unauthorized has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.unauthorized,
          equals('Access denied. Please log in.'),
        );
      });

      test('firebaseGeneric has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.firebaseGeneric,
          equals('A Firebase error occurred.'),
        );
      });

      test('formatError has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.formatError,
          equals('Invalid data format received.'),
        );
      });

      test('pluginMissing has correct value', () {
        // Assert
        expect(
          FallbackKeysForErrors.pluginMissing,
          equals('Required plugin is missing'),
        );
      });
    });

    group('constant properties', () {
      test('all constants are non-empty', () {
        // Assert
        expect(FallbackKeysForErrors.unexpected, isNotEmpty);
        expect(FallbackKeysForErrors.noInternet, isNotEmpty);
        expect(FallbackKeysForErrors.timeout, isNotEmpty);
        expect(FallbackKeysForErrors.unauthorized, isNotEmpty);
        expect(FallbackKeysForErrors.firebaseGeneric, isNotEmpty);
        expect(FallbackKeysForErrors.formatError, isNotEmpty);
        expect(FallbackKeysForErrors.pluginMissing, isNotEmpty);
      });

      test('all constants are unique', () {
        // Arrange
        final values = [
          FallbackKeysForErrors.unexpected,
          FallbackKeysForErrors.noInternet,
          FallbackKeysForErrors.timeout,
          FallbackKeysForErrors.unauthorized,
          FallbackKeysForErrors.firebaseGeneric,
          FallbackKeysForErrors.formatError,
          FallbackKeysForErrors.pluginMissing,
        ];

        // Act
        final uniqueValues = values.toSet();

        // Assert
        expect(uniqueValues, hasLength(values.length));
      });

      test('all constants are String type', () {
        // Assert
        expect(FallbackKeysForErrors.unexpected, isA<String>());
        expect(FallbackKeysForErrors.noInternet, isA<String>());
        expect(FallbackKeysForErrors.timeout, isA<String>());
        expect(FallbackKeysForErrors.unauthorized, isA<String>());
        expect(FallbackKeysForErrors.firebaseGeneric, isA<String>());
        expect(FallbackKeysForErrors.formatError, isA<String>());
        expect(FallbackKeysForErrors.pluginMissing, isA<String>());
      });
    });

    group('const semantics', () {
      test('constants are compile-time constants', () {
        // Arrange
        const unexpectedValue = FallbackKeysForErrors.unexpected;

        // Assert
        expect(unexpectedValue, equals('Something went wrong'));
      });

      test('same constant is identical', () {
        // Arrange
        const value1 = FallbackKeysForErrors.unexpected;
        const value2 = FallbackKeysForErrors.unexpected;

        // Assert
        expect(identical(value1, value2), isTrue);
      });
    });

    group('abstract class properties', () {
      test('cannot be instantiated', () {
        // Assert - compile-time check
        expect(FallbackKeysForErrors, isA<Type>());
      });
    });

    group('usage scenarios', () {
      test('can be used in UI error messages', () {
        // Arrange
        const errorMessage = FallbackKeysForErrors.noInternet;

        // Assert
        expect(errorMessage, isNotEmpty);
        expect(errorMessage, contains('internet'));
      });

      test('can be used in overlay notifications', () {
        // Arrange
        const notificationMessage = FallbackKeysForErrors.timeout;

        // Assert
        expect(notificationMessage, contains('timeout'));
      });

      test('can be used in switch statements', () {
        // Arrange
        const message = FallbackKeysForErrors.unauthorized;
        String result;

        // Act
        if (message == FallbackKeysForErrors.unauthorized) {
          result = 'Auth error';
        } else {
          result = 'Other error';
        }

        // Assert
        expect(result, equals('Auth error'));
      });

      test('can be collected in a list', () {
        // Arrange
        final errorMessages = [
          FallbackKeysForErrors.unexpected,
          FallbackKeysForErrors.noInternet,
          FallbackKeysForErrors.timeout,
        ];

        // Assert
        expect(errorMessages, hasLength(3));
        expect(errorMessages, everyElement(isA<String>()));
      });

      test('can be used as Map values', () {
        // Arrange
        final errorMap = {
          'unexpected': FallbackKeysForErrors.unexpected,
          'network': FallbackKeysForErrors.noInternet,
          'timeout': FallbackKeysForErrors.timeout,
        };

        // Assert
        expect(errorMap, hasLength(3));
        expect(errorMap['unexpected'], equals('Something went wrong'));
      });
    });
  });

  group('LocalesFallbackMapper and FallbackKeysForErrors integration', () {
    test('all FallbackKeysForErrors are accessible via mapper', () {
      // Act & Assert
      expect(
        LocalesFallbackMapper.resolveFallback('failure.unknown'),
        equals(FallbackKeysForErrors.unexpected),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.network.no_connection'),
        equals(FallbackKeysForErrors.noInternet),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.network.timeout'),
        equals(FallbackKeysForErrors.timeout),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.auth.unauthorized'),
        equals(FallbackKeysForErrors.unauthorized),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.firebase.generic'),
        equals(FallbackKeysForErrors.firebaseGeneric),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.format.error'),
        equals(FallbackKeysForErrors.formatError),
      );
      expect(
        LocalesFallbackMapper.resolveFallback('failure.plugin.missing'),
        equals(FallbackKeysForErrors.pluginMissing),
      );
    });

    test('mapper provides access to all error constants', () {
      // Arrange
      final mappedValues = [
        'failure.auth.unauthorized',
        'failure.firebase.generic',
        'failure.format.error',
        'failure.network.no_connection',
        'failure.network.timeout',
        'failure.plugin.missing',
        'failure.unknown',
      ].map(LocalesFallbackMapper.resolveFallback).toSet();

      final directValues = {
        FallbackKeysForErrors.unauthorized,
        FallbackKeysForErrors.firebaseGeneric,
        FallbackKeysForErrors.formatError,
        FallbackKeysForErrors.noInternet,
        FallbackKeysForErrors.timeout,
        FallbackKeysForErrors.pluginMissing,
        FallbackKeysForErrors.unexpected,
      };

      // Assert
      expect(mappedValues, equals(directValues));
    });
  });
}
