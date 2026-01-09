import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('ChangePasswordFormState', () {
    group('construction', () {
      test('creates valid initial state with default values', () {
        // Arrange & Act
        const state = ChangePasswordFormState();

        // Assert
        expect(state.password, equals(const PasswordInputValidation.pure()));
        expect(
          state.confirmPassword,
          equals(const ConfirmPasswordInputValidation.pure()),
        );
        expect(state.isPasswordObscure, isTrue);
        expect(state.isConfirmPasswordObscure, isTrue);
        expect(state.isValid, isFalse);
        expect(state.epoch, equals(0));
      });

      test('creates state with custom values', () {
        // Arrange & Act
        const state = ChangePasswordFormState(
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state.password.value, equals('password123'));
        expect(state.confirmPassword.value, equals('password123'));
        expect(state.isPasswordObscure, isFalse);
        expect(state.isConfirmPasswordObscure, isFalse);
        expect(state.isValid, isTrue);
        expect(state.epoch, equals(5));
      });
    });

    group('updateState', () {
      test('updates password field', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword123',
        );

        // Assert
        expect(updatedState.password.value, equals('newPassword123'));
        expect(updatedState.password.isPure, isFalse);
      });

      test('updates confirmPassword field', () {
        // Arrange
        final initialState = const ChangePasswordFormState().updateState(
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

      test('updates both fields', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
        expect(updatedState.confirmPassword.value, equals('password123'));
      });

      test('updates isPasswordObscure flag', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          isPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isPasswordObscure, isFalse);
      });

      test('updates isConfirmPasswordObscure flag', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          isConfirmPasswordObscure: false,
        );

        // Assert
        expect(updatedState.isConfirmPasswordObscure, isFalse);
      });

      test('updates epoch', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 10);

        // Assert
        expect(updatedState.epoch, equals(10));
      });

      test('trims password input', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '  password123  ',
        );

        // Assert
        expect(updatedState.password.value, equals('password123'));
      });

      test('trims confirmPassword input', () {
        // Arrange
        final initialState = const ChangePasswordFormState().updateState(
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
        final initialState = const ChangePasswordFormState().updateState(
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
        final initialState = const ChangePasswordFormState().updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword456',
        );

        // Assert
        expect(updatedState.confirmPassword.isValid, isFalse);
        expect(
          updatedState.confirmPassword.error,
          equals(ConfirmPasswordValidationError.mismatch),
        );
      });
    });

    group('validation', () {
      test('sets isValid to true when both fields are valid', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });

      test('sets isValid to false when password is invalid', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'short',
          confirmPassword: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when passwords do not match', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password456',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when both fields are empty', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '',
          confirmPassword: '',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('revalidates form by default', () {
        // Arrange
        const initialState = ChangePasswordFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          password: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('skips revalidation when revalidate is false', () {
        // Arrange
        const initialState = ChangePasswordFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          password: 'short',
          revalidate: false,
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('immutability', () {
      test('updateState creates new instance', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'password123',
        );

        // Assert
        expect(identical(initialState, updatedState), isFalse);
      });

      test('original state unchanged after update', () {
        // Arrange
        final initialState = const ChangePasswordFormState()
          // Act
          ..updateState(
            password: 'password123',
            confirmPassword: 'password123',
          );

        // Assert
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
        const state1 = ChangePasswordFormState(
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );
        const state2 = ChangePasswordFormState(
          password: PasswordInputValidation.dirty('password123'),
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'password123',
            value: 'password123',
          ),
          isPasswordObscure: false,
          isConfirmPasswordObscure: false,
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state1, equals(state2));
      });

      test('two states with different passwords are not equal', () {
        // Arrange
        const state1 = ChangePasswordFormState(
          password: PasswordInputValidation.dirty('password1'),
        );
        const state2 = ChangePasswordFormState(
          password: PasswordInputValidation.dirty('password2'),
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different epochs are not equal', () {
        // Arrange
        const state1 = ChangePasswordFormState(epoch: 1);
        const state2 = ChangePasswordFormState(epoch: 2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('real-world scenarios', () {
      test('typical user password change flow', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act - User types new password
        final step1 = initialState.updateState(
          password: 'MyNewPassword123!',
        );

        // User confirms new password
        final step2 = step1.updateState(
          confirmPassword: 'MyNewPassword123!',
        );

        // Assert
        expect(step2.password.value, equals('MyNewPassword123!'));
        expect(step2.confirmPassword.value, equals('MyNewPassword123!'));
        expect(step2.isValid, isTrue);
      });

      test('user enters mismatched passwords then corrects', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final step1 = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password456',
        );

        final step2 = step1.updateState(confirmPassword: 'password123');

        // Assert
        expect(step1.isValid, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user changes password mid-form', () {
        // Arrange
        final initialState = const ChangePasswordFormState().updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword456',
        );

        // Assert
        expect(initialState.isValid, isTrue);
        expect(updatedState.isValid, isFalse);
      });

      test('user toggles password visibility', () {
        // Arrange
        final initialState = const ChangePasswordFormState().updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        // Act
        final step1 = initialState.updateState(isPasswordObscure: false);
        final step2 = step1.updateState(isConfirmPasswordObscure: false);

        // Assert
        expect(step2.isPasswordObscure, isFalse);
        expect(step2.isConfirmPasswordObscure, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user enters short password', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: 'short',
          confirmPassword: 'short',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
        expect(
          updatedState.password.error,
          equals(PasswordValidationError.tooShort),
        );
      });

      test('user submits empty form', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '',
          confirmPassword: '',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
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
      test('handles very long passwords', () {
        // Arrange
        final longPassword = 'p' * 1000;
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: longPassword,
          confirmPassword: longPassword,
        );

        // Assert
        expect(updatedState.password.value, equals(longPassword));
        expect(updatedState.confirmPassword.value, equals(longPassword));
        expect(updatedState.isValid, isTrue);
      });

      test('handles whitespace-only password', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: '   ',
          confirmPassword: '   ',
        );

        // Assert
        expect(updatedState.password.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });

      test('handles special characters in password', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          password: r'P@$$w0rd!#$%',
          confirmPassword: r'P@$$w0rd!#$%',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('formz integration', () {
      test('validates all inputs together', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final validState = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password123',
        );

        final invalidState = initialState.updateState(
          password: 'short',
          confirmPassword: 'different',
        );

        // Assert
        expect(validState.isValid, isTrue);
        expect(invalidState.isValid, isFalse);
      });

      test('form is invalid if any field is invalid', () {
        // Arrange
        const initialState = ChangePasswordFormState();

        // Act
        final state = initialState.updateState(
          password: 'password123',
          confirmPassword: 'password456',
        );

        // Assert
        expect(state.password.isValid, isTrue);
        expect(state.confirmPassword.isValid, isFalse);
        expect(state.isValid, isFalse);
      });
    });

    group('partial updates', () {
      test('updating only password preserves confirmPassword value', () {
        // Arrange
        const initialState = ChangePasswordFormState(
          confirmPassword: ConfirmPasswordInputValidation.dirty(
            password: 'old',
            value: 'existing',
          ),
        );

        // Act
        final updatedState = initialState.updateState(
          password: 'newPassword',
        );

        // Assert
        expect(updatedState.password.value, equals('newPassword'));
        expect(updatedState.confirmPassword.value, equals('existing'));
      });

      test('null values preserve existing fields', () {
        // Arrange
        const initialState = ChangePasswordFormState(
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
        const initialState = ChangePasswordFormState();

        // Act
        final step1 = initialState.updateState(isPasswordObscure: false);
        final step2 = step1.updateState(isConfirmPasswordObscure: false);

        // Assert
        expect(step1.isPasswordObscure, isFalse);
        expect(step1.isConfirmPasswordObscure, isTrue);
        expect(step2.isPasswordObscure, isFalse);
        expect(step2.isConfirmPasswordObscure, isFalse);
      });

      test('password visibility does not affect validation', () {
        // Arrange
        final initialState = const ChangePasswordFormState().updateState(
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
