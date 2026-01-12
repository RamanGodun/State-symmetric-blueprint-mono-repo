/// Tests for SignUpFormFieldCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Name field updates
/// - Email field updates
/// - Password field updates
/// - Confirm password field updates
/// - Password visibility toggles
/// - State reset functionality
library;

import 'package:app_on_cubit/features/auth/sign_up/cubit/form_fields_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('SignUpFormFieldCubit', () {
    test('initial state has default values', () {
      // Arrange & Act
      final cubit = SignUpFormFieldCubit();

      // Assert
      expect(cubit.state, isA<SignUpFormState>());
      expect(cubit.state, equals(const SignUpFormState()));
      expect(cubit.state.isPasswordObscure, isTrue);
      expect(cubit.state.isConfirmPasswordObscure, isTrue);

      cubit.close();
    });

    group('onNameChanged', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'updates name field',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onNameChanged('Test User'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.name.value,
            'name value',
            'Test User',
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'trims name input',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onNameChanged(' Test User '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.name.value,
            'name value',
            'Test User',
          ),
        ],
      );
    });

    group('onEmailChanged', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'updates email field',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onEmailChanged('test@example.com'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'trims email input',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onEmailChanged(' test@example.com '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );
    });

    group('onPasswordChanged', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'updates password field',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onPasswordChanged('password123'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.password.value,
            'password value',
            'password123',
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'trims password input',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onPasswordChanged(' password123 '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.password.value,
            'password value',
            'password123',
          ),
        ],
      );
    });

    group('onConfirmPasswordChanged', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'updates confirm password field',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onConfirmPasswordChanged('password123'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.confirmPassword.value,
            'confirm password value',
            'password123',
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'trims confirm password input',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.onConfirmPasswordChanged(' password123 '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.confirmPassword.value,
            'confirm password value',
            'password123',
          ),
        ],
      );
    });

    group('togglePasswordVisibility', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'toggles password visibility from true to false',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            false,
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'toggles password visibility from false to true',
        build: SignUpFormFieldCubit.new,
        seed: () => const SignUpFormState().updateState(
          isPasswordObscure: false,
          revalidate: false,
        ),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            true,
          ),
        ],
      );
    });

    group('toggleConfirmPasswordVisibility', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'toggles confirm password visibility from true to false',
        build: SignUpFormFieldCubit.new,
        act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.isConfirmPasswordObscure,
            'confirm password obscured',
            false,
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'toggles confirm password visibility from false to true',
        build: SignUpFormFieldCubit.new,
        seed: () => const SignUpFormState().updateState(
          isConfirmPasswordObscure: false,
          revalidate: false,
        ),
        act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
        expect: () => [
          isA<SignUpFormState>().having(
            (state) => state.isConfirmPasswordObscure,
            'confirm password obscured',
            true,
          ),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'password and confirm password visibility are independent',
        build: SignUpFormFieldCubit.new,
        act: (cubit) {
          cubit
            ..togglePasswordVisibility()
            ..toggleConfirmPasswordVisibility();
        },
        expect: () => [
          isA<SignUpFormState>()
              .having(
                (state) => state.isPasswordObscure,
                'password obscured',
                false,
              )
              .having(
                (state) => state.isConfirmPasswordObscure,
                'confirm password obscured',
                true,
              ),
          isA<SignUpFormState>()
              .having(
                (state) => state.isPasswordObscure,
                'password obscured',
                false,
              )
              .having(
                (state) => state.isConfirmPasswordObscure,
                'confirm password obscured',
                false,
              ),
        ],
      );
    });

    group('resetState', () {
      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'resets form to initial state',
        build: SignUpFormFieldCubit.new,
        seed: () => const SignUpFormState().updateState(
          name: 'Test User',
          email: 'test@example.com',
          password: 'password123',
          confirmPassword: 'password123',
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SignUpFormState>()
              .having((state) => state.name.value, 'name', '')
              .having((state) => state.email.value, 'email', '')
              .having((state) => state.password.value, 'password', '')
              .having(
                (state) => state.confirmPassword.value,
                'confirm password',
                '',
              )
              .having((state) => state.epoch, 'epoch', 1),
        ],
      );

      blocTest<SignUpFormFieldCubit, SignUpFormState>(
        'increments epoch on reset',
        build: SignUpFormFieldCubit.new,
        act: (cubit) {
          cubit
            ..resetState()
            ..resetState();
        },
        expect: () => [
          isA<SignUpFormState>().having((state) => state.epoch, 'epoch', 1),
          isA<SignUpFormState>().having((state) => state.epoch, 'epoch', 2),
        ],
      );
    });

    group('close', () {
      test('closes successfully and cleans up debouncer', () async {
        // Arrange
        final cubit = SignUpFormFieldCubit();

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
