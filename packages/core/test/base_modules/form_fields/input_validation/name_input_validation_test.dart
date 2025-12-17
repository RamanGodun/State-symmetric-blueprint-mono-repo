import 'package:core/src/base_modules/form_fields/input_validation/validation_enums.dart';
import 'package:core/src/base_modules/localization/generated/locale_keys.g.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('NameInputValidation', () {
    group('construction', () {
      test('creates valid pure instance with empty value', () {
        // Arrange & Act
        const input = NameInputValidation.pure();

        // Assert
        expect(input.value, equals(''));
        expect(input.isPure, isTrue);
        expect(input.isValid, isFalse); // Pure empty inputs are invalid
      });

      test('creates dirty instance with provided value', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe');

        // Assert
        expect(input.value, equals('John Doe'));
        expect(input.isPure, isFalse);
        expect(input.isValid, isTrue);
      });

      test('creates dirty instance with default empty value', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.value, equals(''));
        expect(input.isPure, isFalse);
      });
    });

    group('validation', () {
      test('returns null for valid name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('returns empty error when value is empty', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.error, equals(NameValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns empty error when value is only whitespace', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('   ');

        // Assert
        expect(input.error, equals(NameValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns empty error when value is tabs and spaces', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('\t  \n  ');

        // Assert
        expect(input.error, equals(NameValidationError.empty));
        expect(input.isValid, isFalse);
      });

      test('returns tooShort error when name is less than 3 characters', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Jo');

        // Assert
        expect(input.error, equals(NameValidationError.tooShort));
        expect(input.isValid, isFalse);
      });

      test('returns tooShort error for single character', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('J');

        // Assert
        expect(input.error, equals(NameValidationError.tooShort));
        expect(input.isValid, isFalse);
      });

      test('accepts name with exactly 3 characters', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Jon');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims leading whitespace before validation', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('   John Doe');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims trailing whitespace before validation', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe   ');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('trims both leading and trailing whitespace', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('  John Doe  ');

        // Assert
        expect(input.error, isNull);
        expect(input.isValid, isTrue);
      });

      test('fails when trimmed value is too short', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('  Jo  ');

        // Assert
        expect(input.error, equals(NameValidationError.tooShort));
        expect(input.isValid, isFalse);
      });
    });

    group('valid name formats', () {
      test('accepts simple first and last name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts name with middle initial', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John M. Doe');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts name with hyphen', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Mary-Jane Smith');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts name with apostrophe', () {
        // Arrange & Act
        const input = NameInputValidation.dirty("O'Brien");

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts single word name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Madonna');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts very long name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty(
          'Christopher Alexander Montgomery-Smythe III',
        );

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts name with numbers', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe 3rd');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts unicode characters', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('José García');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('accepts non-Latin characters', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('李小明');

        // Assert
        expect(input.isValid, isTrue);
      });
    });

    group('errorKey', () {
      test('returns empty key when error is empty', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.errorKey, equals(LocaleKeys.form_name_is_empty));
      });

      test('returns tooShort key when name is too short', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Jo');

        // Assert
        expect(input.errorKey, equals(LocaleKeys.form_name_is_too_short));
      });

      test('returns null when name is valid', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John');

        // Assert
        expect(input.errorKey, isNull);
      });
    });

    group('uiErrorKey', () {
      test('returns null when input is pure', () {
        // Arrange & Act
        const input = NameInputValidation.pure();

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns null when input is valid', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe');

        // Assert
        expect(input.uiErrorKey, isNull);
      });

      test('returns error key when dirty and invalid', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.uiErrorKey, equals(LocaleKeys.form_name_is_empty));
      });

      test('returns error key when dirty and too short', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Jo');

        // Assert
        expect(input.uiErrorKey, equals(LocaleKeys.form_name_is_too_short));
      });
    });

    group('state transitions', () {
      test('pure to dirty maintains same value', () {
        // Arrange
        const pureInput = NameInputValidation.pure();

        // Act
        const dirtyInput = NameInputValidation.dirty();

        // Assert
        expect(pureInput.value, equals(dirtyInput.value));
      });

      test('changing value creates new instance', () {
        // Arrange
        const input1 = NameInputValidation.dirty('John');

        // Act
        const input2 = NameInputValidation.dirty('Jane');

        // Assert
        expect(input1.value, isNot(equals(input2.value)));
      });
    });

    group('isPure and isValid', () {
      test('isPure returns true for pure instance', () {
        // Arrange & Act
        const input = NameInputValidation.pure();

        // Assert
        expect(input.isPure, isTrue);
      });

      test('isPure returns false for dirty instance', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John');

        // Assert
        expect(input.isPure, isFalse);
      });

      test('isValid returns true when no error', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John Doe');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('isValid returns false when error exists', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.isValid, isFalse);
      });
    });

    group('edge cases', () {
      test('handles very long name', () {
        // Arrange
        final longName = 'A' * 1000;

        // Act
        final input = NameInputValidation.dirty(longName);

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles name with only spaces after trim results in empty', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('     ');

        // Assert
        expect(input.error, equals(NameValidationError.empty));
      });

      test('handles mixed whitespace characters', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('\t\n\r  ');

        // Assert
        expect(input.error, equals(NameValidationError.empty));
      });

      test('handles special characters in name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty(r'John @#$ Doe');

        // Assert
        expect(input.isValid, isTrue);
      });

      test('handles emojis in name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('John 😊 Doe');

        // Assert
        expect(input.isValid, isTrue);
      });
    });

    group('real-world scenarios', () {
      test('typical user signup with full name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Robert Johnson');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
        expect(input.uiErrorKey, isNull);
      });

      test('user submits empty form field', () {
        // Arrange & Act
        const input = NameInputValidation.dirty();

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(NameValidationError.empty));
        expect(input.uiErrorKey, equals(LocaleKeys.form_name_is_empty));
      });

      test('user enters incomplete name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('Jo');

        // Assert
        expect(input.isValid, isFalse);
        expect(input.error, equals(NameValidationError.tooShort));
        expect(input.uiErrorKey, equals(LocaleKeys.form_name_is_too_short));
      });

      test('user enters name with leading/trailing spaces', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('  Sarah Connor  ');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });

      test('international user with non-ASCII name', () {
        // Arrange & Act
        const input = NameInputValidation.dirty('François Müller');

        // Assert
        expect(input.isValid, isTrue);
        expect(input.error, isNull);
      });
    });

    group('formz integration', () {
      test('pure instance is invalid when empty', () {
        // Arrange & Act
        const input = NameInputValidation.pure();

        // Assert
        expect(input.isValid, isFalse);
        expect(input.isPure, isTrue);
      });

      test('can be used in form validation', () {
        // Arrange
        const validName = NameInputValidation.dirty('John Doe');
        const invalidName = NameInputValidation.dirty();

        // Act
        final allValid = [validName].every((input) => input.isValid);
        final hasInvalid = [invalidName].any((input) => !input.isValid);

        // Assert
        expect(allValid, isTrue);
        expect(hasInvalid, isTrue);
      });
    });
  });
}
