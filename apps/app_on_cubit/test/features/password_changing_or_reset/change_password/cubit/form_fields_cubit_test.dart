/// Tests for ChangePasswordFormFieldsCubit
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ BLoC testing with bloc_test
///
/// Coverage:
/// - Initial state
/// - Password field updates
/// - Confirm password field updates
/// - Password visibility toggles
/// - State reset functionality
library;

import 'package:app_on_cubit/features/password_changing_or_reset/change_password/cubit/form_fields_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('ChangePasswordFormFieldsCubit', () {
    test('initial state has default values', () {
      // Arrange & Act
      final cubit = ChangePasswordFormFieldsCubit();

      // Assert
      expect(cubit.state, isA<ChangePasswordFormState>());
      expect(cubit.state, equals(const ChangePasswordFormState()));
      expect(cubit.state.isPasswordObscure, isTrue);
      expect(cubit.state.isConfirmPasswordObscure, isTrue);

      cubit.close();
    });

    group('onPasswordChanged', () {
      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'updates password field',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onPasswordChanged('newPassword123'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.password.value,
            'password value',
            'newPassword123',
          ),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'trims password input',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onPasswordChanged(' newPassword123 '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.password.value,
            'password value',
            'newPassword123',
          ),
        ],
      );
    });

    group('onConfirmPasswordChanged', () {
      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'updates confirm password field',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onConfirmPasswordChanged('newPassword123'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.confirmPassword.value,
            'confirm password value',
            'newPassword123',
          ),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'trims confirm password input',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onConfirmPasswordChanged(' newPassword123 '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.confirmPassword.value,
            'confirm password value',
            'newPassword123',
          ),
        ],
      );
    });

    group('togglePasswordVisibility', () {
      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'toggles password visibility from true to false',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            false,
          ),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'toggles password visibility from false to true',
        build: ChangePasswordFormFieldsCubit.new,
        seed: () => const ChangePasswordFormState().updateState(
          isPasswordObscure: false,
          revalidate: false,
        ),
        act: (cubit) => cubit.togglePasswordVisibility(),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.isPasswordObscure,
            'password obscured',
            true,
          ),
        ],
      );
    });

    group('toggleConfirmPasswordVisibility', () {
      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'toggles confirm password visibility from true to false',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.isConfirmPasswordObscure,
            'confirm password obscured',
            false,
          ),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'toggles confirm password visibility from false to true',
        build: ChangePasswordFormFieldsCubit.new,
        seed: () => const ChangePasswordFormState().updateState(
          isConfirmPasswordObscure: false,
          revalidate: false,
        ),
        act: (cubit) => cubit.toggleConfirmPasswordVisibility(),
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.isConfirmPasswordObscure,
            'confirm password obscured',
            true,
          ),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'password and confirm password visibility are independent',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) {
          cubit
            ..togglePasswordVisibility()
            ..toggleConfirmPasswordVisibility();
        },
        expect: () => [
          isA<ChangePasswordFormState>()
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
          isA<ChangePasswordFormState>()
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
      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'resets form to initial state',
        build: ChangePasswordFormFieldsCubit.new,
        seed: () => const ChangePasswordFormState().updateState(
          password: 'password123',
          confirmPassword: 'password123',
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<ChangePasswordFormState>()
              .having((state) => state.password.value, 'password', '')
              .having(
                (state) => state.confirmPassword.value,
                'confirm password',
                '',
              )
              .having((state) => state.epoch, 'epoch', 1),
        ],
      );

      blocTest<ChangePasswordFormFieldsCubit, ChangePasswordFormState>(
        'increments epoch on reset',
        build: ChangePasswordFormFieldsCubit.new,
        act: (cubit) {
          cubit
            ..resetState()
            ..resetState();
        },
        expect: () => [
          isA<ChangePasswordFormState>().having(
            (state) => state.epoch,
            'epoch',
            1,
          ),
          isA<ChangePasswordFormState>().having(
            (state) => state.epoch,
            'epoch',
            2,
          ),
        ],
      );
    });

    group('close', () {
      test('closes successfully and cleans up debouncer', () async {
        // Arrange
        final cubit = ChangePasswordFormFieldsCubit();

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
