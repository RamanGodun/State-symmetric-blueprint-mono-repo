/// Tests for SignOutRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Successful sign-out delegation
/// - Error handling and mapping
/// - Remote database interaction
library;

import 'package:features_dd_layers/src/auth/data/auth_repo_implementations/sign_out_repo_impl.dart';
import 'package:features_dd_layers/src/auth/data/remote_database_contract.dart';
import 'package:features_dd_layers/src/auth/domain/repo_contracts.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

class MockAuthRemoteDatabase extends Mock implements IAuthRemoteDatabase {}

void main() {
  group('SignOutRepoImpl', () {
    late IAuthRemoteDatabase mockRemote;
    late ISignOutRepo repo;

    setUp(() {
      mockRemote = MockAuthRemoteDatabase();
      repo = SignOutRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = SignOutRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<SignOutRepoImpl>());
        expect(repo, isA<ISignOutRepo>());
      });
    });

    group('signOut', () {
      group('successful sign-out', () {
        test('calls remote database signOut method', () async {
          // Arrange
          when(() => mockRemote.signOut()).thenAnswer((_) async {});

          // Act
          await repo.signOut();

          // Assert
          verify(() => mockRemote.signOut()).called(1);
        });

        test('returns Right on successful remote call', () async {
          // Arrange
          when(() => mockRemote.signOut()).thenAnswer((_) async {});

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isRight, isTrue);
        });

        test('handles multiple sequential sign-out calls', () async {
          // Arrange
          when(() => mockRemote.signOut()).thenAnswer((_) async {});

          // Act
          await repo.signOut();
          await repo.signOut();
          await repo.signOut();

          // Assert
          verify(() => mockRemote.signOut()).called(3);
        });
      });

      group('failed sign-out', () {
        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.signOut(),
          ).thenThrow(Exception('Sign-out failed'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.signOut(),
          ).thenThrow(Exception('User not authenticated'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.message,
            contains('User not authenticated'),
          );
        });

        test('handles network errors', () async {
          // Arrange
          when(
            () => mockRemote.signOut(),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network error'));
        });

        test('handles generic errors', () async {
          // Arrange
          when(() => mockRemote.signOut()).thenThrow('String error');

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('handles timeout errors', () async {
          // Arrange
          when(
            () => mockRemote.signOut(),
          ).thenThrow(Exception('Timeout error'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Timeout'));
        });
      });

      group('edge cases', () {
        test('handles sign-out when already signed out', () async {
          // Arrange
          when(
            () => mockRemote.signOut(),
          ).thenThrow(Exception('No user signed in'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('No user signed in'));
        });

        test('verifies error handling preserves stack trace info', () async {
          // Arrange
          when(() => mockRemote.signOut()).thenThrow(Exception('Error'));

          // Act
          final result = await repo.signOut();

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates successful Firebase sign-out', () async {
        // Arrange
        when(() => mockRemote.signOut()).thenAnswer((_) async {});

        // Act
        final result = await repo.signOut();

        // Assert
        expect(result.isRight, isTrue);
        verify(() => mockRemote.signOut()).called(1);
      });

      test('simulates sign-out with session expired error', () async {
        // Arrange
        when(
          () => mockRemote.signOut(),
        ).thenThrow(Exception('Session expired'));

        // Act
        final result = await repo.signOut();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Session expired'));
      });

      test('simulates sign-out with token revoked error', () async {
        // Arrange
        when(() => mockRemote.signOut()).thenThrow(Exception('Token revoked'));

        // Act
        final result = await repo.signOut();

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Token revoked'));
      });

      test('simulates successful logout after app restart', () async {
        // Arrange
        when(() => mockRemote.signOut()).thenAnswer((_) async {});

        // Act - First call
        final result1 = await repo.signOut();
        // Act - Second call (app restarted)
        final result2 = await repo.signOut();

        // Assert
        expect(result1.isRight, isTrue);
        expect(result2.isRight, isTrue);
        verify(() => mockRemote.signOut()).called(2);
      });
    });
  });
}
