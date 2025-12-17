import 'package:core/src/base_modules/ui_design/text_theme/text_theme_factory.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('parseAppFontFamily', () {
    group('Inter font parsing', () {
      test('parses lowercase "inter" to Inter', () {
        // Act
        final result = parseAppFontFamily('inter');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('parses capitalized "Inter" to Inter', () {
        // Act
        final result = parseAppFontFamily('Inter');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('parses null to Inter as default', () {
        // Act
        final result = parseAppFontFamily(null);

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('parses empty string to Inter as default', () {
        // Act
        final result = parseAppFontFamily('');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('parses unknown font to Inter as default', () {
        // Act
        final result = parseAppFontFamily('UnknownFont');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });
    });

    group('Montserrat font parsing', () {
      test('parses lowercase "montserrat" to Montserrat', () {
        // Act
        final result = parseAppFontFamily('montserrat');

        // Assert
        expect(result, equals(AppFontFamily.montserrat));
      });

      test('parses capitalized "Montserrat" to Montserrat', () {
        // Act
        final result = parseAppFontFamily('Montserrat');

        // Assert
        expect(result, equals(AppFontFamily.montserrat));
      });
    });

    group('SF Pro font parsing (legacy support)', () {
      test('parses "sfPro" to Inter', () {
        // Act
        final result = parseAppFontFamily('sfPro');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('parses "SFProText" to Inter', () {
        // Act
        final result = parseAppFontFamily('SFProText');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });
    });

    group('case sensitivity', () {
      test('is case-sensitive for Inter variations', () {
        // Act & Assert
        expect(parseAppFontFamily('inter'), equals(AppFontFamily.inter));
        expect(parseAppFontFamily('Inter'), equals(AppFontFamily.inter));
        expect(parseAppFontFamily('INTER'), equals(AppFontFamily.inter));
        expect(parseAppFontFamily('InTeR'), equals(AppFontFamily.inter));
      });

      test('is case-sensitive for Montserrat variations', () {
        // Act & Assert
        expect(
          parseAppFontFamily('montserrat'),
          equals(AppFontFamily.montserrat),
        );
        expect(
          parseAppFontFamily('Montserrat'),
          equals(AppFontFamily.montserrat),
        );
        expect(
          parseAppFontFamily('MONTSERRAT'),
          equals(AppFontFamily.inter),
        );
        expect(
          parseAppFontFamily('MontSerrat'),
          equals(AppFontFamily.inter),
        );
      });
    });

    group('edge cases', () {
      test('handles whitespace-only string', () {
        // Act
        final result = parseAppFontFamily('   ');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles special characters', () {
        // Act
        final result = parseAppFontFamily('!@#%');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles numbers', () {
        // Act
        final result = parseAppFontFamily('12345');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles mixed case unknown font', () {
        // Act
        final result = parseAppFontFamily('RoBoto');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles font with spaces', () {
        // Act
        final result = parseAppFontFamily('Inter Pro');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles font with leading spaces', () {
        // Act
        final result = parseAppFontFamily(' Inter');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });

      test('handles font with trailing spaces', () {
        // Act
        final result = parseAppFontFamily('Inter ');

        // Assert
        expect(result, equals(AppFontFamily.inter));
      });
    });

    group('real-world scenarios', () {
      test('parsing user preference from storage', () {
        // Arrange - User saved "montserrat" in settings
        const storedValue = 'montserrat';

        // Act
        final font = parseAppFontFamily(storedValue);

        // Assert
        expect(font, equals(AppFontFamily.montserrat));
      });

      test('parsing default when no preference stored', () {
        // Arrange - First app launch, no stored preference
        const storedValue = 'null';

        // Act
        final font = parseAppFontFamily(storedValue);

        // Assert
        expect(font, equals(AppFontFamily.inter));
      });

      test('parsing legacy SF Pro preference', () {
        // Arrange - User had SF Pro selected in old version
        const storedValue = 'SFProText';

        // Act - Migration logic should map to Inter
        final font = parseAppFontFamily(storedValue);

        // Assert
        expect(font, equals(AppFontFamily.inter));
      });

      test('handling corrupted storage data', () {
        // Arrange - Storage returned corrupted data
        const storedValue = 'CorruptedFont123';

        // Act - Should fallback to default
        final font = parseAppFontFamily(storedValue);

        // Assert
        expect(font, equals(AppFontFamily.inter));
      });

      test('switching between fonts', () {
        // Arrange - User switches from Inter to Montserrat
        var currentFont = parseAppFontFamily('Inter');
        expect(currentFont, equals(AppFontFamily.inter));

        // Act - User selects Montserrat
        currentFont = parseAppFontFamily('Montserrat');

        // Assert
        expect(currentFont, equals(AppFontFamily.montserrat));
      });
    });

    group('all supported fonts', () {
      test('parses all Inter aliases', () {
        // Arrange
        const interAliases = ['inter', 'Inter', 'sfPro', 'SFProText'];

        // Act & Assert
        for (final alias in interAliases) {
          final result = parseAppFontFamily(alias);
          expect(
            result,
            equals(AppFontFamily.inter),
            reason: 'Failed to parse "$alias" to Inter',
          );
        }
      });

      test('parses all Montserrat aliases', () {
        // Arrange
        const montserratAliases = ['montserrat', 'Montserrat'];

        // Act & Assert
        for (final alias in montserratAliases) {
          final result = parseAppFontFamily(alias);
          expect(
            result,
            equals(AppFontFamily.montserrat),
            reason: 'Failed to parse "$alias" to Montserrat',
          );
        }
      });

      test('default font is Inter for all unknown inputs', () {
        // Arrange
        const unknownInputs = [
          null,
          '',
          'Unknown',
          'Arial',
          'Roboto',
          'Helvetica',
          '   ',
          '123',
          'inter-medium',
        ];

        // Act & Assert
        for (final input in unknownInputs) {
          final result = parseAppFontFamily(input);
          expect(
            result,
            equals(AppFontFamily.inter),
            reason: 'Failed to default to Inter for input: "$input"',
          );
        }
      });
    });

    group('consistency', () {
      test('returns same result for same input', () {
        // Arrange
        const input = 'Montserrat';

        // Act
        final result1 = parseAppFontFamily(input);
        final result2 = parseAppFontFamily(input);
        final result3 = parseAppFontFamily(input);

        // Assert
        expect(result1, equals(result2));
        expect(result2, equals(result3));
      });

      test('is deterministic for all inputs', () {
        // Arrange
        const inputs = [
          'Inter',
          'inter',
          'Montserrat',
          'montserrat',
          'sfPro',
          null,
          '',
          'Unknown',
        ];

        // Act & Assert
        for (final input in inputs) {
          final result1 = parseAppFontFamily(input);
          final result2 = parseAppFontFamily(input);
          expect(result1, equals(result2));
        }
      });
    });

    group('return types', () {
      test('always returns AppFontFamily enum', () {
        // Act & Assert
        expect(parseAppFontFamily('Inter'), isA<AppFontFamily>());
        expect(parseAppFontFamily('Montserrat'), isA<AppFontFamily>());
        expect(parseAppFontFamily(null), isA<AppFontFamily>());
        expect(parseAppFontFamily('Unknown'), isA<AppFontFamily>());
      });

      test('never returns null', () {
        // Arrange
        const inputs = [null, '', 'Unknown', '   ', 'Invalid'];

        // Act & Assert
        for (final input in inputs) {
          final result = parseAppFontFamily(input);
          expect(result, isNotNull);
        }
      });
    });

    group('migration support', () {
      test('supports migration from SF Pro to Inter', () {
        // Arrange - Old app versions used SF Pro
        const oldFonts = ['sfPro', 'SFProText'];

        // Act & Assert - Should map to Inter
        for (final oldFont in oldFonts) {
          final result = parseAppFontFamily(oldFont);
          expect(
            result,
            equals(AppFontFamily.inter),
            reason: 'Failed to migrate "$oldFont" to Inter',
          );
        }
      });

      test('maintains backward compatibility', () {
        // Arrange - Ensure old storage keys still work
        final _ =
            {
                'sfPro': AppFontFamily.inter,
                'SFProText': AppFontFamily.inter,
                'inter': AppFontFamily.inter,
                'Inter': AppFontFamily.inter,
                'montserrat': AppFontFamily.montserrat,
                'Montserrat': AppFontFamily.montserrat,
              }
              // Act & Assert
              ..forEach((key, value) {
                final result = parseAppFontFamily(key);
                expect(
                  result,
                  equals(value),
                  reason: 'Migration failed for "$key"',
                );
              });
      });
    });
  });
}
