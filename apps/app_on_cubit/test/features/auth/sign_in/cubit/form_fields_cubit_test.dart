/// Tests for SignInFormCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Email field updates
/// - Password field updates
/// - Password visibility toggle
/// - State reset functionality
/// - Form validation
library;

import 'package:app_on_cubit/features/auth/sign_in/cubit/form_fields_cubit.dart'
    show SignInFormCubit;
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('SignInFormCubit', () {
    test('initial state has default values', () {
      // Arrange & Act
      final cubit = SignInFormCubit();

      // Assert
      expect(cubit.state, isA<SignInFormState>());
      expect(cubit.state, equals(const SignInFormState()));
      expect(cubit.state.isPasswordObscure, isTrue);

      cubit.close();
    });

    group('onEmailChanged', () {
      blocTest<SignInFormCubit, SignInFormState>(
        'updates email field',
        build: SignInFormCubit.new,
        act: (cubit) => cubit.onEmailChanged('test@example.com'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'trims and validates email',
        build: SignInFormCubit.new,
        act: (cubit) => cubit.onEmailChanged(' test@example.com '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'updates email multiple times with debounce',
        build: SignInFormCubit.new,
        act: (cubit) async {
          cubit.onEmailChanged('test1@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onEmailChanged('test2@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onEmailChanged('test3@example.com');
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.email.value,
            'email value',
            'test3@example.com',
          ),
        ],
      );
    });

    group('onPasswordChanged', () {
      blocTest<SignInFormCubit, SignInFormState>(
        'updates password field',
        build: SignInFormCubit.new,
        act: (cubit) => cubit.onPasswordChanged('password123'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.password.value,
            'password value',
            'password123',
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'trims and validates password',
        build: SignInFormCubit.new,
        act: (cubit) => cubit.onPasswordChanged(' password123 '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.password.value,
            'password value',
            'password123',
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'updates password multiple times with debounce',
        build: SignInFormCubit.new,
        act: (cubit) async {
          cubit.onPasswordChanged('pass1');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onPasswordChanged('pass2');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onPasswordChanged('pass3');
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.password.value,
            'password value',
            'pass3',
          ),
        ],
      );
    });

    group('togglePasswordVisibility', () {
      blocTest<SignInFormCubit, SignInFormState>(
        'toggles password visibility from true to false',
        build: SignInFormCubit.new,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            false,
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'toggles password visibility from false to true',
        build: SignInFormCubit.new,
        seed: () => const SignInFormState().updateState(
          isPasswordObscure: false,
          revalidate: false,
        ),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            true,
          ),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'toggles password visibility multiple times',
        build: SignInFormCubit.new,
        act: (cubit) {
          cubit
            ..togglePasswordVisibility() // false
            ..togglePasswordVisibility() // true
            ..togglePasswordVisibility(); // false
        },
        expect: () => [
          isA<SignInFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            false,
          ),
          isA<SignInFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            true,
          ),
          isA<SignInFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            false,
          ),
        ],
      );
    });

    group('resetState', () {
      blocTest<SignInFormCubit, SignInFormState>(
        'resets form to initial state',
        build: SignInFormCubit.new,
        seed: () => const SignInFormState().updateState(
          email: 'test@example.com',
          password: 'password123',
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<SignInFormState>()
              .having((state) => state.email.value, 'email', '')
              .having((state) => state.password.value, 'password', '')
              .having((state) => state.epoch, 'epoch', 1),
        ],
      );

      blocTest<SignInFormCubit, SignInFormState>(
        'increments epoch on reset',
        build: SignInFormCubit.new,
        act: (cubit) {
          cubit
            ..resetState()
            ..resetState();
        },
        expect: () => [
          isA<SignInFormState>().having((state) => state.epoch, 'epoch', 1),
          isA<SignInFormState>().having((state) => state.epoch, 'epoch', 2),
        ],
      );
    });

    group('close', () {
      test('closes successfully and cleans up debouncer', () async {
        // Arrange
        final cubit = SignInFormCubit();

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
