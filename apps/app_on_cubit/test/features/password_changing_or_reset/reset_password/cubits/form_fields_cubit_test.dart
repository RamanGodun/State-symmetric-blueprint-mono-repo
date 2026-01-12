/// Tests for ResetPasswordFormFieldsCubit
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
/// - State reset functionality
/// - Form validation
library;

import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/form_fields_cubit.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/forms.dart';

void main() {
  group('ResetPasswordFormFieldsCubit', () {
    test('initial state has default values', () {
      // Arrange & Act
      final cubit = ResetPasswordFormFieldsCubit();

      // Assert
      expect(cubit.state, isA<ResetPasswordFormState>());
      expect(cubit.state, equals(const ResetPasswordFormState()));

      cubit.close();
    });

    group('onEmailChanged', () {
      blocTest<ResetPasswordFormFieldsCubit, ResetPasswordFormState>(
        'updates email field',
        build: ResetPasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onEmailChanged('test@example.com'),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ResetPasswordFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );

      blocTest<ResetPasswordFormFieldsCubit, ResetPasswordFormState>(
        'trims and validates email',
        build: ResetPasswordFormFieldsCubit.new,
        act: (cubit) => cubit.onEmailChanged(' test@example.com '),
        wait: const Duration(milliseconds: 150),
        expect: () => [
          isA<ResetPasswordFormState>().having(
            (state) => state.email.value,
            'email value',
            'test@example.com',
          ),
        ],
      );

      blocTest<ResetPasswordFormFieldsCubit, ResetPasswordFormState>(
        'updates email multiple times with debounce',
        build: ResetPasswordFormFieldsCubit.new,
        act: (cubit) async {
          cubit.onEmailChanged('test1@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onEmailChanged('test2@example.com');
          await Future<void>.delayed(const Duration(milliseconds: 50));
          cubit.onEmailChanged('test3@example.com');
        },
        wait: const Duration(milliseconds: 200),
        expect: () => [
          isA<ResetPasswordFormState>().having(
            (state) => state.email.value,
            'email value',
            'test3@example.com',
          ),
        ],
      );
    });

    group('resetState', () {
      blocTest<ResetPasswordFormFieldsCubit, ResetPasswordFormState>(
        'resets form to initial state',
        build: ResetPasswordFormFieldsCubit.new,
        seed: () => const ResetPasswordFormState().updateState(
          email: 'test@example.com',
        ),
        act: (cubit) => cubit.resetState(),
        expect: () => [
          isA<ResetPasswordFormState>()
              .having((state) => state.email.value, 'email', '')
              .having((state) => state.epoch, 'epoch', 1),
        ],
      );

      blocTest<ResetPasswordFormFieldsCubit, ResetPasswordFormState>(
        'increments epoch on reset',
        build: ResetPasswordFormFieldsCubit.new,
        act: (cubit) {
          cubit
            ..resetState()
            ..resetState();
        },
        expect: () => [
          isA<ResetPasswordFormState>().having(
            (state) => state.epoch,
            'epoch',
            1,
          ),
          isA<ResetPasswordFormState>().having(
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
        final cubit = ResetPasswordFormFieldsCubit();

        // Act
        await cubit.close();

        // Assert
        expect(cubit.isClosed, isTrue);
      });
    });
  });
}
