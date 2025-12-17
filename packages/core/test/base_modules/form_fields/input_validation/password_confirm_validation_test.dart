import 'package:core/src/base_modules/form_fields/input_validation/validation_enums.dart';
import 'package:core/src/base_modules/localization/generated/locale_keys.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ConfirmPasswordInputValidation', () {
    group('construction', () {
      test('creates valid pure instance with empty value and password', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.pure();

        // Assert
        expect(input.value, equals(''));
        expect(input.password, equals(''));
        expect(input.isPure, isTrue);
        expect(input.isValid, isFalse); // Pure empty inputs are invalid
      });

      test('creates pure instance with specified password', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.pure(
          password: 'mypass123',
        );

        // Assert
        expect(input.value, equals(''));
        expect(input.password, equals('mypass123'));
        expect(input.isPure, isTrue);
      });

      test('creates dirty instance with provided password and value', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'mypass123',
          value: 'mypass123',
        );

        // Assert
        expect(input.value, equals('mypass123'));
        expect(input.password, equals('mypass123'));
        expect(input.isPure, isFalse);
        expect(input.isValid, isTrue);
      });

      test('creates dirty instance with default empty value', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'mypass123',
        );

        // Assert
        expect(input.value, equals(''));
        expect(input.password, equals('mypass123'));
        expect(input.isPure, isFalse);
      });

      test('stores password reference correctly', () {
        // Arrange & Act
        const password = 'TestPassword123';
        const input = ConfirmPasswordInputValidation.dirty(
          password: password,
          value: password,
        );

        // Assert
        expect(input.password, equals(password));
      });
    });

    group('validation', () {
      test('returns null when passwords match', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('returns empty error when value is empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns empty error when value is only whitespace', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: '   ',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns mismatch error when passwords do not match', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password456',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
        expect(input.isValid, isFalse);
      });

      test('returns mismatch error for case-sensitive mismatch', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'Password123',
          value: 'password123',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
        expect(input.isValid, isFalse);
      });

      test('trims value before validation', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: '  password123  ',
        );

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('returns mismatch when trimmed value differs', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: '  password456  ',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
        expect(input.isValid, isFalse);
      });

      test('empty check takes priority over mismatch', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: '   ',
        );

        // Assert - should be empty, not mismatch
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('validates against empty password', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: '',
        );

        // Assert - both empty means value is empty (trimmed)
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
        expect(input.isValid, isFalse);
      });
    });

    group('password matching scenarios', () {
      test('matches simple password', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'simple',
          value: 'simple',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('matches complex password with special characters', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: r'P@ssw0rd!#$',
          value: r'P@ssw0rd!#$',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('matches password with unicode characters', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pássw0rd',
          value: 'pássw0rd',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('matches password with emojis', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass😊word',
          value: 'pass😊word',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('matches very long password', () {
        // Arrange
        final longPassword = 'A' * 100;

        // Act
        final input = ConfirmPasswordInputValidation.dirty(
          password: longPassword,
          value: longPassword,
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('detects single character difference', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password124',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
      });

      test('detects extra character at end', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password',
          value: 'password1',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
      });

      test('detects missing character at end', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password1',
          value: 'password',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
      });
    });

    group('errorKey', () {
      test('returns empty key when error is empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
        );

        // Assert
        expect(
          input.errorKey,
          equals(LocaleKeys.form_confirm_password_is_empty),
        );
      });

      test('returns mismatch key when passwords do not match', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password456',
        );

        // Assert
        expect(
          input.errorKey,
          equals(LocaleKeys.form_confirm_password_mismatch),
        );
      });

      test('returns null when passwords match', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );

        // Assert
        expect(input.errorKey, isNull);
      });
    });

    group('uiErrorKey', () {
      test('returns null when input is pure', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.pure(password: 'test');

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns null when input is valid', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns error key when dirty and empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
        );

        // Assert
        expect(
          input.uiErrorKey,
          equals(LocaleKeys.form_confirm_password_is_empty),
        );
      });

      test('returns error key when dirty and mismatch', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password456',
        );

        // Assert
        expect(
          input.uiErrorKey,
          equals(LocaleKeys.form_confirm_password_mismatch),
        );
      });
    });

    group('updatePassword', () {
      test('creates new instance with updated password', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'oldpass',
          value: 'oldpass',
        );

        // Act
        final updated = input.updatePassword('newpass');

        // Assert
        expect(updated.password, equals('newpass'));
        expect(updated.value, equals('oldpass'));
        expect(updated.isPure, isFalse);
      });

      test('preserves value when updating password', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass1',
          value: 'myvalue',
        );

        // Act
        final updated = input.updatePassword('pass2');

        // Assert
        expect(updated.value, equals('myvalue'));
      });

      test('revalidates after password update - creates mismatch', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );

        // Act
        final updated = input.updatePassword('newpassword');

        // Assert
        expect(input.isValid, isTrue);
        expect(updated.isValid, isFalse);
        expect(updated.error, equals(ConfirmPasswordValidationError.mismatch));
      });

      test('revalidates after password update - creates match', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'oldpass',
          value: 'newpass',
        );

        // Act
        final updated = input.updatePassword('newpass');

        // Assert
        expect(input.isValid, isFalse);
        expect(updated.isValid, isTrue);
      });

      test('maintains dirty state after update', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass1',
          value: 'test',
        );

        // Act
        final updated = input.updatePassword('pass2');

        // Assert
        expect(updated.isPure, isFalse);
      });

      test('can update to empty password', () {
        // Arrange
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password',
        );

        // Act
        final updated = input.updatePassword('');

        // Assert
        expect(updated.password, equals(''));
        expect(updated.value, equals(''));
      });
    });

    group('state transitions', () {
      test('pure to dirty maintains password reference', () {
        // Arrange
        const pureInput = ConfirmPasswordInputValidation.pure(
          password: 'mypass',
        );

        // Act
        const dirtyInput = ConfirmPasswordInputValidation.dirty(
          password: 'mypass',
        );

        // Assert
        expect(pureInput.password, equals(dirtyInput.password));
      });

      test('changing value creates new instance', () {
        // Arrange
        const input1 = ConfirmPasswordInputValidation.dirty(
          password: 'pass',
          value: 'value1',
        );

        // Act
        const input2 = ConfirmPasswordInputValidation.dirty(
          password: 'pass',
          value: 'value2',
        );

        // Assert
        expect(input1.value, isNot(equals(input2.value)));
      });

      test('changing password creates new validation context', () {
        // Arrange
        const input1 = ConfirmPasswordInputValidation.dirty(
          password: 'pass1',
          value: 'test',
        );

        // Act
        const input2 = ConfirmPasswordInputValidation.dirty(
          password: 'pass2',
          value: 'test',
        );

        // Assert
        expect(input1.password, isNot(equals(input2.password)));
      });
    });

    group('isPure and isValid', () {
      test('isPure returns true for pure instance', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.pure(password: 'test');

        // Assert
        expect(input.isPure, isTrue);
      });

      test('isPure returns false for dirty instance', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'test',
          value: 'test',
        );

        // Assert
        expect(input.isPure, isFalse);
      });

      test('isValid returns true when passwords match', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('isValid returns false when empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
        );

        // Assert
        expect(input.isValid, isFalse);
      });

      test('isValid returns false when mismatch', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password456',
        );

        // Assert
        expect(input.isValid, isFalse);
      });
    });

    group('edge cases', () {
      test('handles very long matching passwords', () {
        // Arrange
        final longPassword = 'A' * 1000;

        // Act
        final input = ConfirmPasswordInputValidation.dirty(
          password: longPassword,
          value: longPassword,
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles password with only spaces after trim results in empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password',
          value: '     ',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
      });

      test('handles mixed whitespace characters', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password',
          value: '\t\n\r  ',
        );

        // Assert
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
      });

      test('handles special characters matching', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: r'p@ss!#$%^&*()',
          value: r'p@ss!#$%^&*()',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles emojis matching', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass😊😎🔒',
          value: 'pass😊😎🔒',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles newline characters in password', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass\nword',
          value: 'pass\nword',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('detects different whitespace types as mismatch', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'pass word',
          value: 'pass\tword',
        );

        // Assert
        expect(input.isValid, isFalse);
      });
    });

    group('real-world scenarios', () {
      test('typical user signup - entering matching passwords', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'MyP@ssw0rd!',
          value: 'MyP@ssw0rd!',
        );

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
        expect(input.uiErrorKey, isNull);
      });

      test('user makes typo in confirmation', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'MyPassword123',
          value: 'MyPassword124',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
        expect(
          input.uiErrorKey,
          equals(LocaleKeys.form_confirm_password_mismatch),
        );
      });

      test('user forgets to fill confirmation field', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'MyPassword123',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.empty));
        expect(
          input.uiErrorKey,
          equals(LocaleKeys.form_confirm_password_is_empty),
        );
      });

      test('user copies password with extra whitespace', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'MyPassword123',
          value: '  MyPassword123  ',
        );

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('user enters wrong case', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'MyPassword',
          value: 'mypassword',
        );

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
      });

      test('password changes mid-form - revalidation needed', () {
        // Arrange
        const initial = ConfirmPasswordInputValidation.dirty(
          password: 'oldpass',
          value: 'oldpass',
        );

        // Act - user changes original password
        final afterUpdate = initial.updatePassword('newpass');

        // Assert - confirmation now invalid
        expect(initial.isValid, isTrue);
        expect(afterUpdate.isValid, isFalse);
        expect(
          afterUpdate.error,
          equals(ConfirmPasswordValidationError.mismatch),
        );
      });

      test('international user with non-ASCII password matching', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'пароль123',
          value: 'пароль123',
        );

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('user with complex special character password matching', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: r'!@#$%^&*()_+-={}[]|:;<>,.?/',
          value: r'!@#$%^&*()_+-={}[]|:;<>,.?/',
        );

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });
    });

    group('formz integration', () {
      test('pure instance is invalid when empty', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.pure(password: 'test');

        // Assert
        expect(input.isValid, isFalse);
        expect(input.isPure, isTrue);
      });

      test('can be used in form validation with password field', () {
        // Arrange
        const password = PasswordInputValidation.dirty('password123');
        const validConfirm = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password123',
        );
        const invalidConfirm = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: 'password456',
        );

        // Act
        final passwordValid = password.isValid;
        final validConfirmValid = validConfirm.isValid;
        final invalidConfirmValid = invalidConfirm.isValid;

        // Assert
        expect(passwordValid, isTrue);
        expect(validConfirmValid, isTrue);
        expect(invalidConfirmValid, isFalse);
      });

      test('reactive validation when password input changes', () {
        // Arrange
        const initialPassword = 'password123';
        const updatedPassword = 'newpassword456';

        var confirmInput = const ConfirmPasswordInputValidation.dirty(
          password: initialPassword,
          value: initialPassword,
        );

        // Act - password field changes
        confirmInput = confirmInput.updatePassword(updatedPassword);

        // Assert - should now be invalid
        expect(confirmInput.isValid, isFalse);
        expect(
          confirmInput.error,
          equals(ConfirmPasswordValidationError.mismatch),
        );
      });
    });

    group('comparison with password field', () {
      test('validates against trimmed password reference', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'password123',
          value: '  password123  ',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('does not trim password reference - only value', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: '  password123  ',
          value: 'password123',
        );

        // Assert - mismatch because password ref is not trimmed
        expect(input.isValid, isFalse);
        expect(input.error, equals(ConfirmPasswordValidationError.mismatch));
      });

      test('exact string comparison after value trim', () {
        // Arrange & Act
        const input = ConfirmPasswordInputValidation.dirty(
          password: 'test',
          value: '  test  ',
        );

        // Assert
        expect(input.isValid, isTrue);
      });
    });
  });
}
