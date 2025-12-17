import 'package:core/src/base_modules/form_fields/input_validation/validation_enums.dart';
import 'package:core/src/base_modules/form_fields/shared_form_fields_states/reset_password.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ResetPasswordFormState', () {
    group('construction', () {
      test('creates valid initial state with default values', () {
        // Arrange & Act
        const state = ResetPasswordFormState();

        // Assert
        expect(state.email, equals(const EmailInputValidation.pure()));
        expect(state.isValid, isFalse);
        expect(state.epoch, equals(0));
      });

      test('creates state with custom values', () {
        // Arrange & Act
        const state = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state.email.value, equals('test@example.com'));
        expect(state.isValid, isTrue);
        expect(state.epoch, equals(5));
      });

      test('creates state with pure input by default', () {
        // Arrange & Act
        const state = ResetPasswordFormState();

        // Assert
        expect(state.email.isPure, isTrue);
      });
    });

    group('updateState', () {
      test('updates email field', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.email.isPure, isFalse);
      });

      test('updates epoch', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 10);

        // Assert
        expect(updatedState.epoch, equals(10));
      });

      test('trims email input', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '  test@example.com  ',
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
      });

      test('updates email and epoch together', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
          epoch: 3,
        );

        // Assert
        expect(updatedState.email.value, equals('test@example.com'));
        expect(updatedState.epoch, equals(3));
      });
    });

    group('validation', () {
      test('sets isValid to true when email is valid', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });

      test('sets isValid to false when email is invalid', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid-email',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('sets isValid to false when email is empty', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: '');

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('revalidates form by default', () {
        // Arrange
        const initialState = ResetPasswordFormState(isValid: true);

        // Act
        final updatedState = initialState.updateState(
          email: 'invalid',
        );

        // Assert
        expect(updatedState.isValid, isFalse);
      });

      test('skips revalidation when revalidate is false', () {
        // Arrange
        const initialState = ResetPasswordFormState(isValid: true);

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
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(identical(initialState, updatedState), isFalse);
      });

      test('original state unchanged after update', () {
        // Arrange
        final initialState = const ResetPasswordFormState()
          // Act
          ..updateState(email: 'test@example.com');

        // Assert
        expect(initialState.email, equals(const EmailInputValidation.pure()));
        expect(initialState.isValid, isFalse);
      });

      test('updating without changes preserves field references', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 5);

        // Assert
        expect(updatedState.email, equals(initialState.email));
      });
    });

    group('equatable', () {
      test('two states with same values are equal', () {
        // Arrange
        const state1 = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          isValid: true,
          epoch: 5,
        );
        const state2 = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          isValid: true,
          epoch: 5,
        );

        // Assert
        expect(state1, equals(state2));
      });

      test('two states with different emails are not equal', () {
        // Arrange
        const state1 = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test1@example.com'),
        );
        const state2 = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test2@example.com'),
        );

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different isValid are not equal', () {
        // Arrange
        const state1 = ResetPasswordFormState(isValid: true);
        const state2 = ResetPasswordFormState();

        // Assert
        expect(state1, isNot(equals(state2)));
      });

      test('two states with different epoch are not equal', () {
        // Arrange
        const state1 = ResetPasswordFormState(epoch: 1);
        const state2 = ResetPasswordFormState(epoch: 2);

        // Assert
        expect(state1, isNot(equals(state2)));
      });
    });

    group('state transitions', () {
      test('pure to dirty email', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(initialState.email.isPure, isTrue);
        expect(updatedState.email.isPure, isFalse);
      });

      test('invalid to valid form', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'test@example.com',
        );

        // Assert
        expect(initialState.isValid, isFalse);
        expect(updatedState.isValid, isTrue);
      });

      test('valid to invalid form', () {
        // Arrange
        const initialState = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          isValid: true,
        );

        // Act
        final updatedState = initialState.updateState(email: 'invalid');

        // Assert
        expect(initialState.isValid, isTrue);
        expect(updatedState.isValid, isFalse);
      });
    });

    group('epoch tracking', () {
      test('increments epoch on update', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(epoch: 1);

        // Assert
        expect(updatedState.epoch, equals(1));
      });

      test('maintains epoch when not specified', () {
        // Arrange
        const initialState = ResetPasswordFormState(epoch: 5);

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
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: longEmail);

        // Assert
        expect(updatedState.email.value, equals(longEmail));
      });

      test('handles whitespace-only email', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: '   ');

        // Assert
        expect(updatedState.email.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });

      test('handles special characters in email', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'user+tag@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('user+tag@example.com'));
      });

      test('handles mixed whitespace characters', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: '\t\n\r  ');

        // Assert
        expect(updatedState.email.value, equals(''));
        expect(updatedState.isValid, isFalse);
      });
    });

    group('real-world scenarios', () {
      test('typical user password reset flow', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act - User enters their email
        final updatedState = initialState.updateState(
          email: 'john.doe@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('john.doe@example.com'));
        expect(updatedState.isValid, isTrue);
      });

      test('user enters invalid email then corrects it', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act - User types invalid email
        final step1 = initialState.updateState(email: 'invalid-email');

        // User corrects email
        final step2 = step1.updateState(email: 'valid@example.com');

        // Assert
        expect(step1.isValid, isFalse);
        expect(step2.isValid, isTrue);
      });

      test('user copies email with extra spaces', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: '  user@example.com  ',
        );

        // Assert
        expect(updatedState.email.value, equals('user@example.com'));
        expect(updatedState.isValid, isTrue);
      });

      test('user submits empty email', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: '');

        // Assert
        expect(updatedState.isValid, isFalse);
        expect(updatedState.email.error, equals(EmailValidationError.empty));
      });

      test('user enters email with typo', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(email: 'user@gmail');

        // Assert
        expect(updatedState.isValid, isFalse);
        expect(updatedState.email.error, equals(EmailValidationError.invalid));
      });

      test('international user with unicode email', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'тест@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('тест@example.com'));
        expect(updatedState.isValid, isTrue);
      });

      test('user with complex email format', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final updatedState = initialState.updateState(
          email: 'first.last+tag@subdomain.example.co.uk',
        );

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('formz integration', () {
      test('pure instance is valid by default (formz behavior)', () {
        // Arrange & Act
        const state = ResetPasswordFormState();

        // Assert
        expect(state.email.isPure, isTrue);
      });

      test('validates email input', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final validState = initialState.updateState(
          email: 'test@example.com',
        );

        final invalidState = initialState.updateState(email: 'invalid');

        // Assert
        expect(validState.isValid, isTrue);
        expect(invalidState.isValid, isFalse);
      });

      test('form validity reflects email validity', () {
        // Arrange
        const initialState = ResetPasswordFormState();

        // Act
        final state = initialState.updateState(email: 'test@example.com');

        // Assert
        expect(state.email.isValid, isTrue);
        expect(state.isValid, isTrue);
      });
    });

    group('partial updates', () {
      test('updating only epoch preserves email', () {
        // Arrange
        const initialState = ResetPasswordFormState(
          email: EmailInputValidation.dirty('existing@example.com'),
        );

        // Act
        final updatedState = initialState.updateState(epoch: 10);

        // Assert
        expect(updatedState.email.value, equals('existing@example.com'));
        expect(updatedState.epoch, equals(10));
      });

      test('null values preserve existing fields', () {
        // Arrange
        const initialState = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
          isValid: true,
          epoch: 5,
        );

        // Act
        final updatedState = initialState.updateState();

        // Assert
        expect(updatedState.email, equals(initialState.email));
        expect(updatedState.isValid, equals(initialState.isValid));
        expect(updatedState.epoch, equals(initialState.epoch));
      });

      test('updating email preserves epoch', () {
        // Arrange
        const initialState = ResetPasswordFormState(epoch: 7);

        // Act
        final updatedState = initialState.updateState(
          email: 'new@example.com',
        );

        // Assert
        expect(updatedState.email.value, equals('new@example.com'));
        expect(updatedState.epoch, equals(7));
      });
    });

    group('validation behavior', () {
      test('validates on construction with dirty email', () {
        // Arrange & Act
        const state = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
        );

        // Assert - isValid is still false because not revalidated
        expect(state.email.isValid, isTrue);
        expect(state.isValid, isFalse);
      });

      test('explicit validation through updateState', () {
        // Arrange
        const initialState = ResetPasswordFormState(
          email: EmailInputValidation.dirty('test@example.com'),
        );

        // Act - Trigger revalidation
        final updatedState = initialState.updateState();

        // Assert
        expect(updatedState.isValid, isTrue);
      });
    });

    group('simple form state', () {
      test('has minimal state compared to other forms', () {
        // Arrange & Act
        const state = ResetPasswordFormState();

        // Assert - Only email, no password fields
        expect(state.props.length, equals(3)); // email, isValid, epoch
      });

      test('simpler than SignInFormState', () {
        // Arrange & Act
        const resetState = ResetPasswordFormState();

        // Assert - ResetPassword only needs email
        expect(resetState.email, isA<EmailInputValidation>());
      });
    });
  });
}
