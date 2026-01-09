/// Tests for SignOutUseCase
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-out
/// - Repository error handling
/// - Multiple sequential calls
library;

import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:features_dd_layers/src/auth/domain/use_cases/sign_out.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../../fixtures/test_constants.dart';
import '../../../../helpers/test_helpers.dart';

class MockSignOutRepo extends Mock implements ISignOutRepo {}

void main() {
  group('SignOutUseCase', () {
    late ISignOutRepo mockRepo;
    late SignOutUseCase useCase;

    setUp(() {
      mockRepo = MockSignOutRepo();
      useCase = SignOutUseCase(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided repository', () {
        // Arrange & Act
        final useCase = SignOutUseCase(mockRepo);

        // Assert
        expect(useCase, isA<SignOutUseCase>());
        expect(useCase.repo, equals(mockRepo));
      });
    });

    group('call', () {
      group('successful sign-out', () {
        test('calls repository signOut method', () async {
          // Arrange
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase();

          // Assert
          verify(() => mockRepo.signOut()).called(1);
        });

        test('returns Right on successful sign-out', () async {
          // Arrange
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isRight, isTrue);
          // Right returns void
        });

        test('completes without throwing', () async {
          // Arrange
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Right(null));

          // Act & Assert
          await expectLater(useCase(), completes);
        });
      });

      group('failed sign-out', () {
        test('returns Left when repository fails', () async {
          // Arrange
          final failure = 'Sign-out failed'.toFailure();
          when(() => mockRepo.signOut()).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, equals(failure));
        });

        test('propagates repository error', () async {
          // Arrange
          final failure = 'Network error during sign-out'.toFailure();
          when(() => mockRepo.signOut()).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network error'));
        });

        test('handles authentication errors', () async {
          // Arrange
          final failure = 'No user currently signed in'.toFailure();
          when(() => mockRepo.signOut()).thenAnswer((_) async => Left(failure));

          // Act
          final result = await useCase();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('No user'));
        });
      });

      group('edge cases', () {
        test('handles multiple sequential calls', () async {
          // Arrange
          when(
            () => mockRepo.signOut(),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase();
          await useCase();
          await useCase();

          // Assert
          verify(() => mockRepo.signOut()).called(3);
        });

        test('handles concurrent calls', () async {
          // Arrange
          when(() => mockRepo.signOut()).thenAnswer(
            (_) async {
              await wait(TestConstants.shortDelayMs);
              return const Right(null);
            },
          );

          // Act
          final futures = [
            useCase(),
            useCase(),
            useCase(),
          ];
          final results = await futures.awaitAll();

          // Assert
          expect(results.length, equals(3));
          for (final result in results) {
            expect(result.isRight, isTrue);
          }
          verify(() => mockRepo.signOut()).called(3);
        });

        test('handles alternating success and failure', () async {
          // Arrange
          var callCount = 0;
          when(() => mockRepo.signOut()).thenAnswer((_) async {
            callCount++;
            if (callCount.isEven) {
              return Left('Error'.toFailure());
            }
            return const Right(null);
          });

          // Act
          final result1 = await useCase(); // Success (odd)
          final result2 = await useCase(); // Failure (even)
          final result3 = await useCase(); // Success (odd)

          // Assert
          expect(result1.isRight, isTrue);
          expect(result2.isLeft, isTrue);
          expect(result3.isRight, isTrue);
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates normal logout flow', () async {
        // Arrange
        when(
          () => mockRepo.signOut(),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isRight, isTrue);
        verify(() => mockRepo.signOut()).called(1);
      });

      test('simulates logout when already logged out', () async {
        // Arrange
        final failure = 'No authenticated user'.toFailure();
        when(() => mockRepo.signOut()).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('No authenticated user'));
      });

      test('simulates logout with network issue', () async {
        // Arrange
        final failure = 'Failed to sign out due to network error'.toFailure();
        when(() => mockRepo.signOut()).thenAnswer((_) async => Left(failure));

        // Act
        final result = await useCase();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('network error'));
      });

      test('simulates retry after failed logout', () async {
        // Arrange
        var firstCall = true;
        when(() => mockRepo.signOut()).thenAnswer((_) async {
          if (firstCall) {
            firstCall = false;
            return Left('Network error'.toFailure());
          }
          return const Right(null);
        });

        // Act
        final result1 = await useCase(); // First attempt fails
        final result2 = await useCase(); // Retry succeeds

        // Assert
        expect(result1.isLeft, isTrue);
        expect(result2.isRight, isTrue);
        verify(() => mockRepo.signOut()).called(2);
      });
    });
  });
}
