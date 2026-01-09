import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('SignUpFormState', () {
    group('construction', () {
      test('creates valid initial state with default values', () {
        // Arrange & Act
        const state = SignUpFormState();

        // Assert
        expect(state.name, equals(const NameInputValidation.pure()));
        expect(state.email, equals(const EmailInputValidation.pure()));
        expect(state.password, equals(const PasswordInputValidation.pure()));
        expect(
          state.confirmPassword,
          equals(const ConfirmPasswordInputValidation.pure()),
        );
        expect(state.isValid, isFalse);
        expect(state.isPasswordObscure, isTrue);
        expect(state.isConfirmPasswordObscure, isTrue);
        expect(state.epoch, equals(0));
      });

      test('creates state with custom values', () {
        // Arrange & Act
        const state = SignUpFormState(
          name: NameInputValidation.dirty('John Doe'),
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isValid: true,
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          epoch: 5,
        );

        // Assert
        expect(state.name.value, equals('John Doe'));
        expect(state.email.value, equals('test@example.com'));
        expect(state.password.value, equals('password123'));
        expect(state.confirmPassword.value, equals('password123'));
        expect(state.isValid, isTrue);
        expect(state.isPasswordObscure, isFalse);
        expect(state.isConfirmPasswordObscure, isFalse);
        expect(state.epoch, equals(5));
      });

      test('creates state with pure inputs by default', () {
        // Arrange & Act
        const state = SignUpFormState();

        // Assert
        expect(state.name.isPure, isTrue);
        expect(state.email.isPure, isTrue);
        expect(state.password.isPure, isTrue);
        expect(state.confirmPassword.isPure, isTrue);
      });
    });

    group('updateState', () {
      test('updates name field', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(name: 'John Doe');

        // Assert
        expect(updatedState.name.value, equals('John Doe'));
        expect(updatedState.name.isPure, isFalse);
      });

      test('updates email field', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.email.isPure, isFalse);
      });

      test('updates password field', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
        expect(updatedState.password.isPure, isFalse);
      });

      test('updates confirmPassword field', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          password: 'password123',
        );

        // Act
        final updatedState = initialState.updateState(
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.confirmPassword.value, equals('password123'));
        expect(updatedState.confirmPassword.isPure, isFalse);
      });

      test('updates all fields', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.name.value, equals('John Doe'));
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.password.value, equals('password123'));
        expect(updatedState.confirmPassword.value, equals('password123'));
      });

      test('updates isPasswordObscure flag', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isPasswordObscure, isFalse);
      });

      test('updates isConfirmPasswordObscure flag', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          isConfirmPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isConfirmPasswordObscure, isFalse);
      });

      test('updates epoch', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 10);

        // Assert
        expect(updatedState.epoch, equals(10));
      });

      test('trims name input', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: '  John Doe  ',
        );

        // Assert
        expect(updatedState.name.value, equals('John Doe'));
      });

      test('trims email input', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '  test@example.com  ',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
      });

      test('trims password input', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '  password123  ',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
      });

      test('trims confirmPassword input', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          password: 'password123',
        );

        // Act
        final updatedState = initialState.updateState(
          confirmPassword: '  password123  ',
        );

        // Assert
        expect(updatedState.confirmPassword.value, equals('password123'));
      });
    });

    group('password synchronization', () {
      test('updates confirmPassword reference when password changes', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          password: 'oldPassword',
          confirmPassword: 'oldPassword',
        );

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword',
        );

        // Assert
        expect(updatedState.confirmPassword.password, equals('newPassword'));
      });

      test('confirmPassword validates against new password', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act - Change password without updating confirmPassword
        final updatedState = initialState.updateState(
          password: 'newPassword456',
        );

        // Assert - confirmPassword should now be invalid (mismatch)
        expect(updatedState.confirmPassword.isValid, isFalse);
        expect(
          updatedState.confirmPassword.error,
          equals(ConfirmPasswordValidationError.mismatch),
        );
      });

      test('sets confirmPassword password reference correctly', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.confirmPassword.password, equals('password123'));
        expect(updatedState.confirmPassword.value, equals('password123'));
      });
    });

    group('validation', () {
      test('sets isValid to true when all fields are valid', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });

      test('sets isValid to false when name is invalid', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'Jo',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when email is invalid', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: 'invalid-email',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when password is invalid', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'short',
          confirmPassword: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when confirmPassword does not match', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password456',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('revalidates form by default', () {
        // Arrange
        const initialState = SignUpFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('skips revalidation when revalidate is false', () {
        // Arrange
        const initialState = SignUpFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
          revalidate: false,
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('immutability', () {
      test('updateState creates new instance', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
        );

        // Assert
        expect(identical(initialState, updatedState), isFalse);
      });

      test('original state unchanged after update', () {
        // Arrange
        final initialState = const SignUpFormState()
          // Act
          ..updateState(
            name: 'John Doe',
            email: 'test@example.com',
            password: 'password123',
            confirmPassword: 'password123',
          );

        // Assert
        expect(initialState.name, equals(const NameInputValidation.pure()));
        expect(initialState.email, equals(const EmailInputValidation.pure()));
        expect(
          initialState.password,
          equals(const PasswordInputValidation.pure()),
        );
        expect(
          initialState.confirmPassword,
          equals(const ConfirmPasswordInputValidation.pure()),
        );
      });
    });

    group('equatable', () {
      test('two states with same values are equal', () {
        // Arrange
        const state1 = SignUpFormState(
          name: NameInputValidation.dirty('John'),
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isValid: true,
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          epoch: 5,
        );
        const state2 = SignUpFormState(
          name: NameInputValidation.dirty('John'),
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isValid: true,
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          epoch: 5,
        );

        // Assert
        expect(state1, equals(state2));
      });

      test('two states with different names are not equal', () {
        // Arrange
        const state1 = SignUpFormState(
          name: NameInputValidation.dirty('John'),
        );
        const state2 = SignUpFormState(
          name: NameInputValidation.dirty('Jane'),
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test(
        'two states with different isConfirmPasswordObscure are not equal',
        () {
          // Arrange
          const state1 = SignUpFormState();
          const state2 = SignUpFormState(isConfirmPasswordObscure: false);

          // Assert
          expect(state1, isNot(equals(state2)));
        },
      );
    });

    group('real-world scenarios', () {
      test('typical user registration flow', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act - User types name
        final step1 = initialState.updateState(name: 'John Doe');

        // User types email
        final step2 = step1.updateState(email: 'john.doe@example.com');

        // User types password
        final step3 = step2.updateState(password: 'MyPassword123!');

        // User confirms password
        final step4 = step3.updateState(confirmPassword: 'MyPassword123!');

        // Assert
        expect(step4.name.value, equals('John Doe'));
        expect(step4.email.value, equals('john.doe@example.com'));
        expect(step4.password.value, equals('MyPassword123!'));
        expect(step4.confirmPassword.value, equals('MyPassword123!'));
        expect(step4.isValid, isTrue);
      });

      test('user enters mismatched passwords then corrects', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act - Fill form with mismatched passwords
        final step1 = initialState.updateState(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          confirmPassword: 'password456',
        );

        // User corrects confirm password
        final step2 = step1.updateState(confirmPassword: 'password123');

        // Assert
        expect(step1.isValid, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user changes password and confirmPassword becomes invalid', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act - User changes password
        final updatedState = initialState.updateState(
          password: 'newPassword456',
        );

        // Assert
        expect(initialState.isValid, isTrue);
        expect(updatedState.isValid, isFalse);
        expect(
          updatedState.confirmPassword.error,
          equals(ConfirmPasswordValidationError.mismatch),
        );
      });

      test('user toggles password visibility during registration', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          name: 'John Doe',
          email: 'john@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act - Toggle password visibility
        final step1 = initialState.updateState(isPasswordObscure: false);

        // Toggle confirm password visibility
        final step2 = step1.updateState(isConfirmPasswordObscure: false);

        // Assert
        expect(step2.isPasswordObscure, isFalse);
        expect(step2.isConfirmPasswordObscure, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user enters name too short then corrects', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act - User types short name
        final step1 = initialState.updateState(
          name: 'Jo',
          email: 'john@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // User corrects name
        final step2 = step1.updateState(name: 'John Doe');

        // Assert
        expect(step1.isValid, isFalse);
        expect(step1.name.error, equals(NameValidationError.tooShort));
        expect(step2.isValid, isTrue);
      });

      test('user copies email with extra whitespace', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: 'John Doe',
          email: '  user@example.com  ',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.email.value, equals('user@example.com'));
        expect(updatedState.isValid, isTrue);
      });

      test('user submits empty form', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(
          name: '',
          email: '',
          password: '',
          confirmPassword: '',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
        expect(updatedState.name.error, equals(NameValidationError.empty));
        expect(updatedState.email.error, equals(EmailValidationError.empty));
        expect(
          updatedState.password.error,
          equals(PasswordValidationError.empty),
        );
        expect(
          updatedState.confirmPassword.error,
          equals(ConfirmPasswordValidationError.empty),
        );
      });
    });

    group('edge cases', () {
      test('handles very long name', () {
        // Arrange
        final longName = 'A' * 100;
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(name: longName);

        // Assert
        expect(updatedState.name.value, equals(longName));
      });

      test('handles whitespace-only name', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(name: '   ');

        // Assert
        expect(updatedState.name.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });

      test('handles special characters in name', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(name: "O'Connor");

        // Assert
        expect(updatedState.name.value, equals("O'Connor"));
      });

      test('handles unicode characters in name', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final updatedState = initialState.updateState(name: 'Roman Godun');

        // Assert
        expect(updatedState.name.value, equals('Roman Godun'));
      });
    });

    group('formz integration', () {
      test('validates all inputs together', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final validState = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        final invalidState = initialState.updateState(
          name: 'Jo',
          email: 'invalid',
          password: 'short',
          confirmPassword: 'different',
        );

        // Assert
        expect(validState.isValid, isTrue);
        expect(invalidState.isValid, isFalse);
      });

      test('form is invalid if any field is invalid', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final state = initialState.updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password456',
        );

        // Assert
        expect(state.name.isValid, isTrue);
        expect(state.email.isValid, isTrue);
        expect(state.password.isValid, isTrue);
        expect(state.confirmPassword.isValid, isFalse);
        expect(state.isValid, isFalse);
      });
    });

    group('partial updates', () {
      test('updating only name preserves other fields', () {
        // Arrange
        const initialState = SignUpFormState(
          email: EmailInputValidation.dirty('existing@example.com'),
          password: PasswordInputValidation.dirty('existingPassword'),
        );

        // Act
        final updatedState = initialState.updateState(name: 'John Doe');

        // Assert
        expect(updatedState.name.value, equals('John Doe'));
        expect(updatedState.email.value, equals('existing@example.com'));
        expect(updatedState.password.value, equals('existingPassword'));
      });

      test('null values preserve existing fields', () {
        // Arrange
        const initialState = SignUpFormState(
          name: NameInputValidation.dirty('John Doe'),
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          epoch: 5,
        );

        // Act
        final updatedState = initialState.updateState();

        // Assert
        expect(updatedState.name, equals(initialState.name));
        expect(updatedState.email, equals(initialState.email));
        expect(updatedState.password, equals(initialState.password));
        expect(
          updatedState.isPasswordObscure,
          equals(initialState.isPasswordObscure),
        );
        expect(
          updatedState.isConfirmPasswordObscure,
          equals(initialState.isConfirmPasswordObscure),
        );
        expect(updatedState.epoch, equals(initialState.epoch));
      });
    });

    group('password visibility', () {
      test('both passwords can be visible independently', () {
        // Arrange
        const initialState = SignUpFormState();

        // Act
        final step1 = initialState.updateState(isPasswordObscure: false);
        final step2 = step1.updateState(isConfirmPasswordObscure: false);

        // Assert
        expect(initialState.isPasswordObscure, isTrue);
        expect(initialState.isConfirmPasswordObscure, isTrue);
        expect(step1.isPasswordObscure, isFalse);
        expect(step1.isConfirmPasswordObscure, isTrue);
        expect(step2.isPasswordObscure, isFalse);
        expect(step2.isConfirmPasswordObscure, isFalse);
      });

      test('password visibility does not affect validation', () {
        // Arrange
        final initialState = const SignUpFormState().updateState(
          name: 'John Doe',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });
  });
}
