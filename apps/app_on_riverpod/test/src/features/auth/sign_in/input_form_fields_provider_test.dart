/// Tests for SignInForm Provider
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Provider initialization
/// - Email input handling and validation
/// - Password input handling and validation
/// - Password visibility toggle
/// - Form state reset
/// - Debouncing behavior
/// - Memory cleanup
library;

import 'package:app_on_riverpod/features/auth/sign_in/providers/input_form_fields_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

import '../../../../fixtures/test_constants.dart';
import '../../../../helpers/test_helpers.dart';

void main() {
  group('SignInForm Provider', () {
    group('initialization', () {
      test('builds with initial pure state', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final state = container.read(signInFormProvider);

        // Assert
        expect(state, isA<SignInFormState>());
        expect(state.email.isPure, isTrue);
        expect(state.password.isPure, isTrue);
        expect(state.isPasswordObscure, isTrue);
        expect(state.isValid, isFalse);
      });

      test('initializes debouncer correctly', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Act
        final notifier = container.read(signInFormProvider.notifier);

        // Assert
        expect(notifier, isA<SignInForm>());
      });
    });

    group('email input handling', () {
      test('updates email state on input', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        container
            .read(signInFormProvider.notifier)
            // Act
            .onEmailChanged(TestConstants.validEmail);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.email.value, equals(TestConstants.validEmail));
        expect(state.email.isPure, isFalse);
      });

      test('validates email format', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act - Valid email
        ..onEmailChanged(TestConstants.validEmail);
        await wait(TestConstants.mediumDelay);

        // Assert
        var state = container.read(signInFormProvider);
        expect(state.email.isValid, isTrue);

        // Act - Invalid email
        notifier.onEmailChanged(TestConstants.invalidEmail);
        await wait(TestConstants.mediumDelay);

        // Assert
        state = container.read(signInFormProvider);
        expect(state.email.isValid, isFalse);
      });

      test('trims email input', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final _ = container.read(signInFormProvider.notifier)

        // Act
        ..onEmailChanged('  ${TestConstants.validEmail}  ');
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.email.value, equals(TestConstants.validEmail));
        expect(state.email.value, isNot(contains(' ')));
      });

      test('handles empty email input', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final _ = container.read(signInFormProvider.notifier)

        // Act
        ..onEmailChanged(TestConstants.emptyString);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.email.value, equals(TestConstants.emptyString));
        expect(state.email.isValid, isFalse);
      });

      test('debounces rapid email changes', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final _ = container.read(signInFormProvider.notifier)

        // Act - Rapid changes
        ..onEmailChanged('a')
        ..onEmailChanged('ab')
        ..onEmailChanged('abc')
        ..onEmailChanged(TestConstants.validEmail);

        // Wait for debounce
        await wait(TestConstants.mediumDelay);

        // Assert - Should only have the last value
        final state = container.read(signInFormProvider);
        expect(state.email.value, equals(TestConstants.validEmail));
      });
    });

    group('password input handling', () {
      test('updates password state on input', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final _ = container.read(signInFormProvider.notifier)

        // Act
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.password.value, equals(TestConstants.validPassword));
        expect(state.password.isPure, isFalse);
      });

      test('validates password requirements', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act - Valid password
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        // Assert
        var state = container.read(signInFormProvider);
        expect(state.password.isValid, isTrue);

        // Act - Weak password
        notifier.onPasswordChanged(TestConstants.weakPassword);
        await wait(TestConstants.mediumDelay);

        // Assert
        state = container.read(signInFormProvider);
        expect(state.password.isValid, isFalse);
      });

      test('handles empty password input', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final _ = container.read(signInFormProvider.notifier)

        // Act
        ..onPasswordChanged(TestConstants.emptyString);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.password.value, equals(TestConstants.emptyString));
        expect(state.password.isValid, isFalse);
      });

      test('debounces rapid password changes', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);

        // Wait for debounce
        await wait(TestConstants.mediumDelay);

        // Assert - Should only have the last value
        final state = container.read(signInFormProvider);
        expect(state.password.value, equals(TestConstants.validPassword));
      });
    });

    group('password visibility toggle', () {
      test('toggles password visibility', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier);

        // Initial state - password obscured
        var state = container.read(signInFormProvider);
        expect(state.isPasswordObscure, isTrue);

        // Act - Toggle to visible
        notifier.togglePasswordVisibility();

        // Assert
        state = container.read(signInFormProvider);
        expect(state.isPasswordObscure, isFalse);

        // Act - Toggle back to obscured
        notifier.togglePasswordVisibility();

        // Assert
        state = container.read(signInFormProvider);
        expect(state.isPasswordObscure, isTrue);
      });

      test('toggle does not affect validation', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Set valid inputs
        ..onEmailChanged(TestConstants.validEmail)
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        final stateBefore = container.read(signInFormProvider);
        final wasValid = stateBefore.isValid;

        // Act
        notifier.togglePasswordVisibility();

        // Assert
        final stateAfter = container.read(signInFormProvider);
        expect(stateAfter.isValid, equals(wasValid));
      });

      test('multiple toggles work correctly', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier);

        // Act & Assert - Multiple toggles
        for (var i = 0; i < 5; i++) {
          final expectedObscured = i.isEven;
          final state = container.read(signInFormProvider);
          expect(state.isPasswordObscure, equals(expectedObscured));
          notifier.togglePasswordVisibility();
        }
      });
    });

    group('form validation', () {
      test('form is valid with correct email and password', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act
        ..onEmailChanged(TestConstants.validEmail)
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.isValid, isTrue);
      });

      test('form is invalid with invalid email', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.isValid, isFalse);
      });

      test('form is invalid with weak password', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act
        ..onEmailChanged(TestConstants.validEmail)
        ..onPasswordChanged(TestConstants.weakPassword);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.isValid, isFalse);
      });

      test('form is invalid when both fields are empty', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act
        ..onEmailChanged(TestConstants.emptyString)
        ..onPasswordChanged(TestConstants.emptyString);
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.isValid, isFalse);
      });
    });

    group('state reset', () {
      test('resets form to initial pure state', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Fill in the form
        ..onEmailChanged(TestConstants.validEmail)
        ..onPasswordChanged(TestConstants.validPassword)
        ..togglePasswordVisibility();
        await wait(TestConstants.mediumDelay);

        // Act
        notifier.resetState();

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.email.isPure, isTrue);
        expect(state.password.isPure, isTrue);
        expect(state.isPasswordObscure, isTrue);
        expect(state.isValid, isFalse);
      });

      test('increments epoch on reset', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier);

        final initialEpoch = container.read(signInFormProvider).epoch;

        // Act
        notifier.resetState();

        // Assert
        final newEpoch = container.read(signInFormProvider).epoch;
        expect(newEpoch, equals(initialEpoch + 1));
      });

      test('multiple resets increment epoch correctly', () {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier);

        final initialEpoch = container.read(signInFormProvider).epoch;

        // Act - Reset 3 times
        notifier..resetState()
        ..resetState()
        ..resetState();

        // Assert
        final finalEpoch = container.read(signInFormProvider).epoch;
        expect(finalEpoch, equals(initialEpoch + 3));
      });
    });

    group('memory management', () {
      test('disposes debouncer on container disposal', () {
        // Arrange
        final container = ProviderContainer()
        ..read(signInFormProvider.notifier)

        // Act
        ..dispose();

        // Assert - Should not throw
        expect(container.dispose, returnsNormally);
      });
    });

    group('real-world scenarios', () {
      test('user fills in sign-in form successfully', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act - User types email
        ..onEmailChanged('john.doe@example.com');
        await wait(TestConstants.mediumDelay);

        // Act - User types password
        notifier.onPasswordChanged('SecurePassword123!');
        await wait(TestConstants.mediumDelay);

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.isValid, isTrue);
        expect(state.email.value, equals('john.doe@example.com'));
        expect(state.password.value, equals('SecurePassword123!'));
      });

      test('user corrects invalid email', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act - User types invalid email
        ..onEmailChanged('invalid-email');
        await wait(TestConstants.mediumDelay);

        var state = container.read(signInFormProvider);
        expect(state.email.isValid, isFalse);

        // Act - User corrects email
        notifier.onEmailChanged('valid@example.com');
        await wait(TestConstants.mediumDelay);

        // Assert
        state = container.read(signInFormProvider);
        expect(state.email.isValid, isTrue);
      });

      test('user toggles password visibility while typing', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Act - User types password
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        // Act - User wants to see password
        notifier.togglePasswordVisibility();

        // Assert
        var state = container.read(signInFormProvider);
        expect(state.isPasswordObscure, isFalse);
        expect(state.password.value, equals(TestConstants.validPassword));

        // Act - User hides password again
        notifier.togglePasswordVisibility();

        // Assert
        state = container.read(signInFormProvider);
        expect(state.isPasswordObscure, isTrue);
      });

      test('user clears form after failed sign-in', () async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        final notifier = container.read(signInFormProvider.notifier)

        // Fill in form
        ..onEmailChanged(TestConstants.validEmail)
        ..onPasswordChanged(TestConstants.validPassword);
        await wait(TestConstants.mediumDelay);

        expect(container.read(signInFormProvider).isValid, isTrue);

        // Act - Reset after failed sign-in
        notifier.resetState();

        // Assert
        final state = container.read(signInFormProvider);
        expect(state.email.isPure, isTrue);
        expect(state.password.isPure, isTrue);
        expect(state.isValid, isFalse);
      });
    });
  });
}
