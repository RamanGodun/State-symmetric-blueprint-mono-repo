import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show CoreLocaleKeys;

void main() {
  group('PasswordInputValidation', () {
    group('construction', () {
      test('creates valid pure instance with empty value', () {
        // Arrange & Act
        const input = PasswordInputValidation.pure();

        // Assert
        expect(input.value, equals(''));
        expect(input.isPure, isTrue);
        expect(input.isValid, isFalse); // Pure empty inputs are invalid
      });

      test('creates dirty instance with provided value', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.value, equals('password123'));
        expect(input.isPure, isFalse);
        expect(input.isValid, isTrue);
      });

      test('creates dirty instance with default empty value', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.value, equals(''));
        expect(input.isPure, isFalse);
      });
    });

    group('validation', () {
      test('returns null for valid password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('validpass');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('returns empty error when value is empty', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns empty error when value is only whitespace', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('   ');

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns empty error when value is tabs and spaces', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('\t  \n  ');

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test(
        'returns tooShort error when password is less than 6 characters',
        () {
          // Arrange & Act
          const input = PasswordInputValidation.dirty('pass');

          // Assert
          expect(input.error, equals(PasswordValidationError.tooShort));
          expect(input.isValid, isFalse);
        },
      );

      test('returns tooShort error for single character', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('p');

        // Assert
        expect(input.error, equals(PasswordValidationError.tooShort));
        expect(input.isValid, isFalse);
      });

      test('returns tooShort error for 5 characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass5');

        // Assert
        expect(input.error, equals(PasswordValidationError.tooShort));
        expect(input.isValid, isFalse);
      });

      test('accepts password with exactly 6 characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass12');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims leading whitespace before validation', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('   password123');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims trailing whitespace before validation', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123   ');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims both leading and trailing whitespace', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('  password123  ');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('fails when trimmed value is too short', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('  pass  ');

        // Assert
        expect(input.error, equals(PasswordValidationError.tooShort));
        expect(input.isValid, isFalse);
      });

      test('fails when trimmed value becomes empty', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('     ');

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });
    });

    group('valid password formats', () {
      test('accepts simple alphanumeric password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with special characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('p@ssw0rd!');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with uppercase and lowercase', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('PassWord123');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with only lowercase letters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with only uppercase letters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('PASSWORD');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with only numbers', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('123456');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with symbols', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(r'!@#$%^&*');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts very long password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(
          'ThisIsAVeryLongPasswordThatExceedsTheMinimumRequirement123!@#',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with unicode characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pássw0rd');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with emojis', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass😊word');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts password with non-Latin characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('пароль123');

        // Assert
        expect(input.isValid, isTrue);
      });
    });

    group('errorKey', () {
      test('returns empty key when error is empty', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.errorKey, equals(CoreLocaleKeys.form_password_required));
      });

      test('returns tooShort key when password is too short', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass');

        // Assert
        expect(input.errorKey, equals(CoreLocaleKeys.form_password_too_short));
      });

      test('returns null when password is valid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.errorKey, isNull);
      });
    });

    group('uiErrorKey', () {
      test('returns null when input is pure', () {
        // Arrange & Act
        const input = PasswordInputValidation.pure();

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns null when input is valid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns error key when dirty and invalid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.uiErrorKey, equals(CoreLocaleKeys.form_password_required));
      });

      test('returns error key when dirty and too short', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass');

        // Assert
        expect(
          input.uiErrorKey,
          equals(CoreLocaleKeys.form_password_too_short),
        );
      });
    });

    group('state transitions', () {
      test('pure to dirty maintains same value', () {
        // Arrange
        const pureInput = PasswordInputValidation.pure();

        // Act
        const dirtyInput = PasswordInputValidation.dirty();

        // Assert
        expect(pureInput.value, equals(dirtyInput.value));
      });

      test('changing value creates new instance', () {
        // Arrange
        const input1 = PasswordInputValidation.dirty('password1');

        // Act
        const input2 = PasswordInputValidation.dirty('password2');

        // Assert
        expect(input1.value, isNot(equals(input2.value)));
      });
    });

    group('isPure and isValid', () {
      test('isPure returns true for pure instance', () {
        // Arrange & Act
        const input = PasswordInputValidation.pure();

        // Assert
        expect(input.isPure, isTrue);
      });

      test('isPure returns false for dirty instance', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.isPure, isFalse);
      });

      test('isValid returns true when no error', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('password123');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('isValid returns false when error exists', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.isValid, isFalse);
      });
    });

    group('edge cases', () {
      test('handles very long password', () {
        // Arrange
        final longPassword = 'A' * 1000;

        // Act
        final input = PasswordInputValidation.dirty(longPassword);

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles password with only spaces after trim results in empty', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('     ');

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
      });

      test('handles mixed whitespace characters', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('\t\n\r  ');

        // Assert
        expect(input.error, equals(PasswordValidationError.empty));
      });

      test('handles special characters in password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(r'p@ss!#$%^&*()');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles emojis in password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass😊😎🔒');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles newline characters in password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass\nword');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles tab characters in password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass\tword');

        // Assert
        expect(input.isValid, isTrue);
      });
    });

    group('real-world scenarios', () {
      test('typical user signup with strong password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('MyP@ssw0rd!');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
        expect(input.uiErrorKey, isNull);
      });

      test('user submits empty password field', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty();

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(PasswordValidationError.empty));
        expect(input.uiErrorKey, equals(CoreLocaleKeys.form_password_required));
      });

      test('user enters weak short password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('12345');

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(PasswordValidationError.tooShort));
        expect(
          input.uiErrorKey,
          equals(CoreLocaleKeys.form_password_too_short),
        );
      });

      test('user enters minimum valid password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('pass12');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('user enters password with leading/trailing spaces', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('  MyPassword123  ');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('user accidentally enters only spaces', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('      ');

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(PasswordValidationError.empty));
      });

      test('international user with non-ASCII password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('пароль123');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('user with complex special character password', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(r'!@#$%^&*()_+-={}[]');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });
    });

    group('formz integration', () {
      test('pure instance is invalid when empty', () {
        // Arrange & Act
        const input = PasswordInputValidation.pure();

        // Assert
        expect(input.isValid, isFalse);
        expect(input.isPure, isTrue);
      });

      test('can be used in form validation', () {
        // Arrange
        const validPassword = PasswordInputValidation.dirty('password123');
        const invalidPassword = PasswordInputValidation.dirty();

        // Act
        final allValid = [validPassword].every((input) => input.isValid);
        final hasInvalid = [invalidPassword].any((input) => !input.isValid);

        // Assert
        expect(allValid, isTrue);
        expect(hasInvalid, isTrue);
      });
    });

    group('security considerations', () {
      test('does not expose password value in error messages', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('weak');

        // Assert - error keys are generic, not revealing password
        expect(input.errorKey, isNot(contains('weak')));
        expect(input.uiErrorKey, isNot(contains('weak')));
      });

      test('accepts passwords with all character types', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('Aa1!@#éñ😊');

        // Assert
        expect(input.isValid, isTrue);
      });
    });

    group('boundary conditions', () {
      test('exactly 6 characters is valid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('123456');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('exactly 5 characters is invalid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('12345');

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(PasswordValidationError.tooShort));
      });

      test('7 characters is valid', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty('1234567');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('whitespace at boundaries is trimmed for validation', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(' 12345 ');

        // Assert - after trim "12345" has 5 chars, too short
        expect(input.isValid, isFalse);
        expect(input.error, equals(PasswordValidationError.tooShort));
      });

      test('whitespace at boundaries with valid length after trim', () {
        // Arrange & Act
        const input = PasswordInputValidation.dirty(' 123456 ');

        // Assert - after trim "123456" has 6 chars, valid
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });
    });
  });
}
