import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('SignInFormState', () {
    group('construction', () {
      test('creates valid initial state with default values', () {
        // Arrange & Act
        const state = SignInFormState();

        // Assert
        expect(state.email, equals(const EmailInputValidation.pure()));
        expect(state.password, equals(const PasswordInputValidation.pure()));
        expect(state.isPasswordObscure, isTrue);
        expect(state.isValid, isFalse);
        expect(state.epoch, equals(0));
      });

      test('creates state with custom values', () {
        // Arrange & Act
        const state = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state.email.value, equals('test@example.com'));
        expect(state.password.value, equals('password123'));
        expect(state.isPasswordObscure, isFalse);
        expect(state.isValid, isTrue);
        expect(state.epoch, equals(5));
      });

      test('creates state with pure inputs by default', () {
        // Arrange & Act
        const state = SignInFormState();

        // Assert
        expect(state.email.isPure, isTrue);
        expect(state.password.isPure, isTrue);
      });
    });

    group('updateState', () {
      test('updates email field', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.email.isPure, isFalse);
        expect(updatedState.password, equals(initialState.password));
      });

      test('updates password field', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
        expect(updatedState.password.isPure, isFalse);
        expect(updatedState.email, equals(initialState.email));
      });

      test('updates both email and password', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.password.value, equals('password123'));
      });

      test('updates isPasswordObscure flag', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isPasswordObscure, isFalse);
      });

      test('updates epoch', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 10);

        // Assert
        expect(updatedState.epoch, equals(10));
      });

      test('trims email input', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '  test@example.com  ',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
      });

      test('trims password input', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '  password123  ',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
      });
    });

    group('validation', () {
      test('sets isValid to true when all fields are valid', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });

      test('sets isValid to false when email is invalid', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid-email',
          password: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when password is invalid', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          password: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when both fields are invalid', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
          password: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when email is empty', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '',
          password: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when password is empty', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          password: '',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('revalidates form by default', () {
        // Arrange
        const initialState = SignInFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('skips revalidation when revalidate is false', () {
        // Arrange
        const initialState = SignInFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
          revalidate: false,
        );

        // Assert - should keep old isValid value
        expect(updatedState.isValid, isTrue);
      });
    });

    group('immutability', () {
      test('updateState creates new instance', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(identical(initialState, updatedState), isFalse);
      });

      test('original state unchanged after update', () {
        // Arrange
        final initialState = const SignInFormState()
          // Act
          ..updateState(
            email: 'test@example.com',
            password: 'password123',
          );

        // Assert
        expect(initialState.email, equals(const EmailInputValidation.pure()));
        expect(
          initialState.password,
          equals(const PasswordInputValidation.pure()),
        );
      });

      test('updating without changes preserves field references', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(updatedState.email, equals(initialState.email));
        expect(updatedState.password, equals(initialState.password));
      });
    });

    group('equatable', () {
      test('two states with same values are equal', () {
        // Arrange
        const state1 = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );
        const state2 = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state1, equals(state2));
      });

      test('two states with different emails are not equal', () {
        // Arrange
        const state1 = SignInFormState(
          email: EmailInputValidation.dirty('test1@example.com'),
        );
        const state2 = SignInFormState(
          email: EmailInputValidation.dirty('test2@example.com'),
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different passwords are not equal', () {
        // Arrange
        const state1 = SignInFormState(
          password: PasswordInputValidation.dirty('password1'),
        );
        const state2 = SignInFormState(
          password: PasswordInputValidation.dirty('password2'),
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different isPasswordObscure are not equal', () {
        // Arrange
        const state1 = SignInFormState();
        const state2 = SignInFormState(isPasswordObscure: false);

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different isValid are not equal', () {
        // Arrange
        const state1 = SignInFormState(isValid: true);
        const state2 = SignInFormState();

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different epoch are not equal', () {
        // Arrange
        const state1 = SignInFormState(epoch: 1);
        const state2 = SignInFormState(epoch: 2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('state transitions', () {
      test('pure to dirty email', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(initialState.email.isPure, isTrue);
        expect(updatedState.email.isPure, isFalse);
      });

      test('pure to dirty password', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
        );

        // Assert
        expect(initialState.password.isPure, isTrue);
        expect(updatedState.password.isPure, isFalse);
      });

      test('invalid to valid form', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          password: 'password123',
        );

        // Assert
        expect(initialState.isValid, isFalse);
        expect(updatedState.isValid, isTrue);
      });

      test('valid to invalid form', () {
        // Arrange
        const initialState = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isValid: true,
        );

        // Act
        final updatedState = initialState.updateState(
          password: '',
        );

        // Assert
        expect(initialState.isValid, isTrue);
        expect(updatedState.isValid, isFalse);
      });
    });

    group('password visibility', () {
      test('toggles password visibility', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(initialState.isPasswordObscure, isTrue);
        expect(updatedState.isPasswordObscure, isFalse);
      });

      test('password visibility does not affect validation', () {
        // Arrange
        const initialState = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isValid: true,
        );

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('epoch tracking', () {
      test('increments epoch on update', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 1);

        // Assert
        expect(updatedState.epoch, equals(1));
      });

      test('maintains epoch when not specified', () {
        // Arrange
        const initialState = SignInFormState(epoch: 5);

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(updatedState.epoch, equals(5));
      });
    });

    group('edge cases', () {
      test('handles very long email', () {
        // Arrange
        final longEmail = '${'a' * 100}@example.com';
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(email: longEmail);

        // Assert
        expect(updatedState.email.value, equals(longEmail));
      });

      test('handles very long password', () {
        // Arrange
        final longPassword = 'p' * 1000;
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(password: longPassword);

        // Assert
        expect(updatedState.password.value, equals(longPassword));
      });

      test('handles whitespace-only email', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(email: '   ');

        // Assert
        expect(updatedState.email.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });

      test('handles whitespace-only password', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(password: '   ');

        // Assert
        expect(updatedState.password.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });

      test('handles special characters in email', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'user+tag@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('user+tag@example.com'));
      });

      test('handles special characters in password', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          password: r'P@$$w0rd!#$%',
        );

        // Assert
        expect(updatedState.password.value, equals(r'P@$$w0rd!#$%'));
      });
    });

    group('real-world scenarios', () {
      test('typical user login flow', () {
        // Arrange
        const initialState = SignInFormState();

        // Act - User types email
        final step1 = initialState.updateState(
          email: 'john.doe@example.com',
        );

        // User types password
        final step2 = step1.updateState(
          password: 'MyPassword123!',
        );

        // User toggles password visibility
        final step3 = step2.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(step3.email.value, equals('john.doe@example.com'));
        expect(step3.password.value, equals('MyPassword123!'));
        expect(step3.isPasswordObscure, isFalse);
        expect(step3.isValid, isTrue);
      });

      test('user enters invalid email then corrects it', () {
        // Arrange
        const initialState = SignInFormState();

        // Act - User types invalid email
        final step1 = initialState.updateState(
          email: 'invalid-email',
          password: 'password123',
        );

        // User corrects email
        final step2 = step1.updateState(
          email: 'valid@example.com',
        );

        // Assert
        expect(step1.isValid, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user enters short password then corrects it', () {
        // Arrange
        const initialState = SignInFormState();

        // Act - User types short password
        final step1 = initialState.updateState(
          email: 'user@example.com',
          password: 'short',
        );

        // User corrects password
        final step2 = step1.updateState(
          password: 'ValidPassword123',
        );

        // Assert
        expect(step1.isValid, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user copies email with extra spaces', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '  user@example.com  ',
          password: 'password123',
        );

        // Assert
        expect(updatedState.email.value, equals('user@example.com'));
        expect(updatedState.isValid, isTrue);
      });

      test('user submits empty form', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '',
          password: '',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
        expect(updatedState.email.error, equals(EmailValidationError.empty));
        expect(
          updatedState.password.error,
          equals(PasswordValidationError.empty),
        );
      });
    });

    group('formz integration', () {
      test('validates all inputs together', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final validState = initialState.updateState(
          email: 'test@example.com',
          password: 'password123',
        );

        final invalidState = initialState.updateState(
          email: 'invalid',
          password: 'short',
        );

        // Assert
        expect(validState.isValid, isTrue);
        expect(invalidState.isValid, isFalse);
      });

      test('form is invalid if any field is invalid', () {
        // Arrange
        const initialState = SignInFormState();

        // Act
        final state = initialState.updateState(
          email: 'test@example.com',
          password: 'short',
        );

        // Assert
        expect(state.email.isValid, isTrue);
        expect(state.password.isValid, isFalse);
        expect(state.isValid, isFalse);
      });
    });

    group('partial updates', () {
      test('updating only email preserves password', () {
        // Arrange
        const initialState = SignInFormState(
          password: PasswordInputValidation.dirty('existingPassword'),
        );

        // Act
        final updatedState = initialState.updateState(
          email: 'new@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('new@example.com'));
        expect(updatedState.password.value, equals('existingPassword'));
      });

      test('updating only password preserves email', () {
        // Arrange
        const initialState = SignInFormState(
          email: EmailInputValidation.dirty('existing@example.com'),
        );

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword',
        );

        // Assert
        expect(updatedState.email.value, equals('existing@example.com'));
        expect(updatedState.password.value, equals('newPassword'));
      });

      test('null values preserve existing fields', () {
        // Arrange
        const initialState = SignInFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          password: PasswordInputValidation.dirty('password123'),
          isPasswordObscure: false,
          epoch: 5,
        );

        // Act
        final updatedState = initialState.updateState();

        // Assert
        expect(updatedState.email, equals(initialState.email));
        expect(updatedState.password, equals(initialState.password));
        expect(
          updatedState.isPasswordObscure,
          equals(initialState.isPasswordObscure),
        );
        expect(updatedState.epoch, equals(initialState.epoch));
      });
    });
  });
}
