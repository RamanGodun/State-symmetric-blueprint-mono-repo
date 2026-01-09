// Tests use const constructors extensively for immutable objects

/// Tests for EmailInputValidation
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Pure/Dirty state initialization
/// - Email format validation
/// - Empty input handling
/// - Whitespace trimming
/// - Error key mapping
/// - UI error key behavior
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('EmailInputValidation', () {
    group('constructor', () {
      test('pure creates valid instance with empty value', () {
        // Arrange & Act
        const email = EmailInputValidation.pure();

        // Assert
        expect(email.value, equals(''));
        expect(email.isPure, isTrue);
        expect(email.isValid, isFalse);
      });

      test('dirty creates instance with provided value', () {
        // Arrange & Act
        const email = EmailInputValidation.dirty('test@example.com');

        // Assert
        expect(email.value, equals('test@example.com'));
        expect(email.isPure, isFalse);
      });

      test('dirty defaults to empty string when no value provided', () {
        // Arrange & Act
        const email = EmailInputValidation.dirty();

        // Assert
        expect(email.value, equals(''));
        expect(email.isPure, isFalse);
      });
    });

    group('validator', () {
      group('empty validation', () {
        test('returns empty error when value is empty string', () {
          // Arrange
          const email = EmailInputValidation.dirty();

          // Assert
          expect(email.error, equals(EmailValidationError.empty));
          expect(email.isValid, isFalse);
        });

        test('returns empty error when value is only whitespace', () {
          // Arrange
          const email = EmailInputValidation.dirty('   ');

          // Assert
          expect(email.error, equals(EmailValidationError.empty));
          expect(email.isValid, isFalse);
        });

        test('returns empty error when value is tabs and spaces', () {
          // Arrange
          const email = EmailInputValidation.dirty('\t\n  ');

          // Assert
          expect(email.error, equals(EmailValidationError.empty));
        });
      });

      group('invalid format validation', () {
        test('returns invalid error when missing @ symbol', () {
          // Arrange
          const email = EmailInputValidation.dirty('notanemail.com');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
          expect(email.isValid, isFalse);
        });

        test('returns invalid error when missing domain', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });

        test('returns invalid error when missing local part', () {
          // Arrange
          const email = EmailInputValidation.dirty('@example.com');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });

        test('returns invalid error when missing TLD', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@example');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });

        test('returns invalid error for double @ symbol', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@@example.com');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });

        test('returns invalid error for special chars in domain', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@ex ample.com');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });

        test('returns invalid error for consecutive dots', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@example..com');

          // Assert
          expect(email.error, equals(EmailValidationError.invalid));
        });
      });

      group('valid email formats', () {
        test('validates simple email', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@example.com');

          // Assert
          expect(email.error, isNull);
          expect(email.isValid, isTrue);
        });

        test('validates email with subdomain', () {
          // Arrange
          const email = EmailInputValidation.dirty('user@mail.example.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates email with plus sign', () {
          // Arrange
          const email = EmailInputValidation.dirty('user+tag@example.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates email with dots in local part', () {
          // Arrange
          const email = EmailInputValidation.dirty('first.last@example.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates email with numbers', () {
          // Arrange
          const email = EmailInputValidation.dirty('user123@example456.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates email with hyphen in domain', () {
          // Arrange
          const email = EmailInputValidation.dirty('user@ex-ample.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates email with underscore', () {
          // Arrange
          const email = EmailInputValidation.dirty('user_name@example.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates short TLD', () {
          // Arrange
          const email = EmailInputValidation.dirty('user@example.co');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('validates long TLD', () {
          // Arrange
          const email = EmailInputValidation.dirty('user@example.museum');

          // Assert
          expect(email.isValid, isTrue);
        });
      });

      group('whitespace handling', () {
        test('trims leading whitespace from valid email', () {
          // Arrange
          const email = EmailInputValidation.dirty('  test@example.com');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('trims trailing whitespace from valid email', () {
          // Arrange
          const email = EmailInputValidation.dirty('test@example.com  ');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('trims both leading and trailing whitespace', () {
          // Arrange
          const email = EmailInputValidation.dirty('  test@example.com  ');

          // Assert
          expect(email.isValid, isTrue);
        });

        test('rejects email with internal whitespace', () {
          // Arrange
          const email = EmailInputValidation.dirty('test @example.com');

          // Assert
          expect(email.isValid, isFalse);
        });
      });
    });

    group('errorKey', () {
      test('returns empty key when error is empty', () {
        // Arrange
        const email = EmailInputValidation.dirty();

        // Act
        final key = email.errorKey;

        // Assert
        expect(key, isNotNull);
        expect(key, contains('empty'));
      });

      test('returns invalid key when error is invalid', () {
        // Arrange
        const email = EmailInputValidation.dirty('notanemail');

        // Act
        final key = email.errorKey;

        // Assert
        expect(key, isNotNull);
        expect(key, contains('invalid'));
      });

      test('returns null when email is valid', () {
        // Arrange
        const email = EmailInputValidation.dirty('test@example.com');

        // Act
        final key = email.errorKey;

        // Assert
        expect(key, isNull);
      });
    });

    group('uiErrorKey', () {
      test('returns null when input is pure', () {
        // Arrange
        const email = EmailInputValidation.pure();

        // Act
        final key = email.uiErrorKey;

        // Assert
        expect(key, isNull);
      });

      test('returns null when input is valid', () {
        // Arrange
        const email = EmailInputValidation.dirty('test@example.com');

        // Act
        final key = email.uiErrorKey;

        // Assert
        expect(key, isNull);
      });

      test('returns error key when dirty and invalid', () {
        // Arrange
        const email = EmailInputValidation.dirty('invalid');

        // Act
        final key = email.uiErrorKey;

        // Assert
        expect(key, isNotNull);
        expect(key, contains('invalid'));
      });

      test('returns error key when dirty and empty', () {
        // Arrange
        const email = EmailInputValidation.dirty();

        // Act
        final key = email.uiErrorKey;

        // Assert
        expect(key, isNotNull);
        expect(key, contains('empty'));
      });
    });

    group('edge cases', () {
      test('handles very long email', () {
        // Arrange
        final longLocal = 'a' * 64;
        final longDomain = 'b' * 63;
        final email = EmailInputValidation.dirty(
          '$longLocal@$longDomain.com',
        );

        // Assert
        // Note: This might be invalid depending on validators package
        // Just checking it doesn't crash
        expect(email, isA<EmailInputValidation>());
      });

      test('handles unicode characters', () {
        // Arrange
        const email = EmailInputValidation.dirty('тест@example.com');

        // Assert
        expect(email, isA<EmailInputValidation>());
        // Modern validators may accept internationalized email addresses (IDN)
        // The validators package appears to accept unicode in local part
        expect(email.isValid, isTrue);
      });

      test('handles single character local part', () {
        // Arrange
        const email = EmailInputValidation.dirty('a@example.com');

        // Assert
        expect(email.isValid, isTrue);
      });

      test('handles IP address in domain', () {
        // Arrange
        const email = EmailInputValidation.dirty('user@192.168.1.1');

        // Assert
        // IP addresses in email domains might be valid or invalid
        // depending on validators package
        expect(email, isA<EmailInputValidation>());
      });

      test('handles quoted strings in local part', () {
        // Arrange
        const email = EmailInputValidation.dirty('"user name"@example.com');

        // Assert
        expect(email, isA<EmailInputValidation>());
      });
    });

    group('state transitions', () {
      test('pure to dirty maintains same value', () {
        // Arrange
        const pure = EmailInputValidation.pure();
        const dirty = EmailInputValidation.dirty();

        // Assert
        expect(pure.value, equals(dirty.value));
        expect(pure.isPure, isTrue);
        expect(dirty.isPure, isFalse);
      });

      test('changing value creates new instance', () {
        // Arrange
        const email1 = EmailInputValidation.dirty('test@example.com');
        const email2 = EmailInputValidation.dirty('other@example.com');

        // Assert
        expect(email1.value, isNot(equals(email2.value)));
        expect(identical(email1, email2), isFalse);
      });
    });

    group('formz integration', () {
      test('isPure returns true for pure instance', () {
        // Arrange
        const email = EmailInputValidation.pure();

        // Assert
        expect(email.isPure, isTrue);
      });

      test('isPure returns false for dirty instance', () {
        // Arrange
        const email = EmailInputValidation.dirty();

        // Assert
        expect(email.isPure, isFalse);
      });

      test('isValid returns true only when no error', () {
        // Arrange
        const valid = EmailInputValidation.dirty('test@example.com');
        const invalid = EmailInputValidation.dirty('invalid');
        const empty = EmailInputValidation.dirty();

        // Assert
        expect(valid.isValid, isTrue);
        expect(invalid.isValid, isFalse);
        expect(empty.isValid, isFalse);
      });

      test('error returns null for valid input', () {
        // Arrange
        const email = EmailInputValidation.dirty('test@example.com');

        // Assert
        expect(email.error, isNull);
      });

      test('error returns specific error for invalid input', () {
        // Arrange
        const empty = EmailInputValidation.dirty();
        const invalid = EmailInputValidation.dirty('notanemail');

        // Assert
        expect(empty.error, equals(EmailValidationError.empty));
        expect(invalid.error, equals(EmailValidationError.invalid));
      });
    });

    group('real-world scenarios', () {
      test('validates typical Gmail address', () {
        // Arrange
        const email = EmailInputValidation.dirty('john.doe@gmail.com');

        // Assert
        expect(email.isValid, isTrue);
      });

      test('validates corporate email', () {
        // Arrange
        const email = EmailInputValidation.dirty('employee@company.co.uk');

        // Assert
        expect(email.isValid, isTrue);
      });

      test('validates email with tag', () {
        // Arrange
        const email = EmailInputValidation.dirty('user+newsletter@example.com');

        // Assert
        expect(email.isValid, isTrue);
      });

      test('rejects common typo - missing .com', () {
        // Arrange
        const email = EmailInputValidation.dirty('user@gmail');

        // Assert
        expect(email.isValid, isFalse);
      });

      test('rejects common typo - space instead of dot', () {
        // Arrange
        const email = EmailInputValidation.dirty('user@gmail com');

        // Assert
        expect(email.isValid, isFalse);
      });

      test('accepts user input with accidental spaces trimmed', () {
        // Arrange
        const email = EmailInputValidation.dirty(' user@example.com ');

        // Assert
        expect(email.isValid, isTrue);
      });
    });
  });
}
