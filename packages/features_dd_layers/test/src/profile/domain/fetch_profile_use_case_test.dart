/// Tests for FetchProfileUseCase
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Profile fetching (happy path)
/// - Profile creation when not found
/// - Error handling
/// - Retry logic after creation
library;

import 'package:features_dd_layers/src/profile/domain/fetch_profile_use_case.dart';
import 'package:features_dd_layers/src/profile/domain/repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';

import '../../../fixtures/test_constants.dart' show TestConstants;
import '../../../helpers/test_helpers.dart'
    show FutureListX, TestFailureX, wait;

class MockProfileRepo extends Mock implements IProfileRepo {}

void main() {
  group('FetchProfileUseCase', () {
    late IProfileRepo mockRepo;
    late FetchProfileUseCase useCase;

    setUp(() {
      mockRepo = MockProfileRepo();
      useCase = FetchProfileUseCase(mockRepo);
    });

    group('constructor', () {
      test('creates instance with provided repository', () {
        // Arrange & Act
        final useCase = FetchProfileUseCase(mockRepo);

        // Assert
        expect(useCase, isA<FetchProfileUseCase>());
      });
    });

    group('call', () {
      group('profile exists', () {
        test('returns profile when found', () async {
          // Arrange
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

          // Act
          final result = await useCase(TestConstants.testUserId);

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, equals(TestConstants.testUserEntity));
          verify(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).called(1);
          verifyNever(() => mockRepo.createUserProfile(any()));
        });

        test('calls repository with correct uid', () async {
          // Arrange
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

          // Act
          await useCase(TestConstants.testUserId);

          // Assert
          verify(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).called(1);
        });

        test('returns different profiles for different uids', () async {
          // Arrange
          when(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));
          when(
            () => mockRepo.getProfile(uid: TestConstants.testUserId2),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity2));

          // Act
          final result1 = await useCase(TestConstants.testUserId);
          final result2 = await useCase(TestConstants.testUserId2);

          // Assert
          expect(result1.rightOrNull?.id, equals(TestConstants.testUserId));
          expect(result2.rightOrNull?.id, equals(TestConstants.testUserId2));
        });
      });

      group('profile does not exist', () {
        test('creates profile and retries when not found', () async {
          // Arrange
          final notFoundFailure = 'User not found'.toFailure();
          var callCount = 0;
          when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer((
            _,
          ) async {
            callCount++;
            return callCount == 1
                ? Left(notFoundFailure)
                : const Right(TestConstants.testUserEntity);
          });
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(TestConstants.testUserId);

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, equals(TestConstants.testUserEntity));
          verify(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).called(2);
          verify(
            () => mockRepo.createUserProfile(TestConstants.testUserId),
          ).called(1);
        });

        test('calls getProfile twice when profile not found', () async {
          // Arrange
          final notFoundFailure = 'User not found'.toFailure();
          var callCount = 0;
          when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer((
            _,
          ) async {
            callCount++;
            return callCount == 1
                ? Left(notFoundFailure)
                : const Right(TestConstants.testUserEntity);
          });
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(TestConstants.testUserId);

          // Assert
          verify(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).called(2); // Once initially, once after creation
        });

        test('creates profile with correct uid', () async {
          // Arrange
          final notFoundFailure = 'User not found'.toFailure();
          var callCount = 0;
          when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer((
            _,
          ) async {
            callCount++;
            return callCount == 1
                ? Left(notFoundFailure)
                : const Right(TestConstants.testUserEntity);
          });
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          await useCase(TestConstants.testUserId);

          // Assert
          verify(
            () => mockRepo.createUserProfile(TestConstants.testUserId),
          ).called(1);
        });
      });

      group('error handling', () {
        test('returns failure when profile creation fails', () async {
          // Arrange
          final notFoundFailure = 'User not found'.toFailure();
          final creationFailure = 'Creation failed'.toFailure();
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => Left(notFoundFailure));
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => Left(creationFailure));

          // Act
          final result = await useCase(TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          // The second getProfile call will still happen but return Left
        });

        test(
          'returns failure when second fetch fails after creation',
          () async {
            // Arrange
            final notFoundFailure = 'User not found'.toFailure();
            when(
              () => mockRepo.getProfile(uid: any(named: 'uid')),
            ).thenAnswer((_) async => Left(notFoundFailure));
            when(
              () => mockRepo.createUserProfile(any()),
            ).thenAnswer((_) async => const Right(null));

            // Act
            final result = await useCase(TestConstants.testUserId);

            // Assert
            expect(result.isLeft, isTrue);
            expect(result.leftOrNull, equals(notFoundFailure));
          },
        );

        test('propagates network errors', () async {
          // Arrange
          final networkFailure = 'Network error'.toFailure();
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => Left(networkFailure));
          when(
            () => mockRepo.createUserProfile(any()),
          ).thenAnswer((_) async => const Right(null));

          // Act
          final result = await useCase(TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Network'));
        });
      });

      group('edge cases', () {
        test('handles empty uid', () async {
          // Arrange
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

          // Act
          await useCase(TestConstants.emptyString);

          // Assert
          verify(
            () => mockRepo.getProfile(uid: TestConstants.emptyString),
          ).called(1);
        });

        test('handles very long uid', () async {
          // Arrange
          final longUid = 'x' * 1000;
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

          // Act
          await useCase(longUid);

          // Assert
          verify(() => mockRepo.getProfile(uid: longUid)).called(1);
        });

        test('handles multiple sequential calls', () async {
          // Arrange
          when(
            () => mockRepo.getProfile(uid: any(named: 'uid')),
          ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

          // Act
          await useCase(TestConstants.testUserId);
          await useCase(TestConstants.testUserId);
          await useCase(TestConstants.testUserId);

          // Assert
          verify(
            () => mockRepo.getProfile(uid: TestConstants.testUserId),
          ).called(3);
        });

        test('handles concurrent calls', () async {
          // Arrange
          when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer(
            (_) async {
              await wait(TestConstants.shortDelayMs);
              return const Right(TestConstants.testUserEntity);
            },
          );

          // Act
          final futures = [
            useCase(TestConstants.testUserId),
            useCase(TestConstants.testUserId),
            useCase(TestConstants.testUserId),
          ];
          final results = await futures.awaitAll();

          // Assert
          expect(results.length, equals(3));
          for (final result in results) {
            expect(result.isRight, isTrue);
          }
        });
      });
    });

    group('real-world scenarios', () {
      test('simulates first-time user login', () async {
        // Arrange - User doesn't exist, needs to be created
        final notFoundFailure = 'User not found'.toFailure();
        var callCount = 0;
        when(() => mockRepo.getProfile(uid: any(named: 'uid'))).thenAnswer((
          _,
        ) async {
          callCount++;
          return callCount == 1
              ? Left(notFoundFailure)
              : const Right(TestConstants.testUserEntity);
        });
        when(
          () => mockRepo.createUserProfile(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(TestConstants.testUserId);

        // Assert
        expect(result.isRight, isTrue);
        expect(result.rightOrNull?.id, equals(TestConstants.testUserId));
        verify(
          () => mockRepo.createUserProfile(TestConstants.testUserId),
        ).called(1);
      });

      test('simulates returning user login', () async {
        // Arrange - User already exists
        when(
          () => mockRepo.getProfile(uid: any(named: 'uid')),
        ).thenAnswer((_) async => const Right(TestConstants.testUserEntity));

        // Act
        final result = await useCase(TestConstants.testUserId);

        // Assert
        expect(result.isRight, isTrue);
        expect(result.rightOrNull, equals(TestConstants.testUserEntity));
        verifyNever(() => mockRepo.createUserProfile(any()));
      });

      test('simulates profile fetch with network interruption', () async {
        // Arrange
        final networkFailure = 'Network connection lost'.toFailure();
        when(
          () => mockRepo.getProfile(uid: any(named: 'uid')),
        ).thenAnswer((_) async => Left(networkFailure));
        when(
          () => mockRepo.createUserProfile(any()),
        ).thenAnswer((_) async => const Right(null));

        // Act
        final result = await useCase(TestConstants.testUserId);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull?.message, contains('Network'));
      });

      test('simulates profile creation failure due to auth issue', () async {
        // Arrange
        final notFoundFailure = 'User not found'.toFailure();
        final authFailure = 'Unauthorized'.toFailure();
        when(
          () => mockRepo.getProfile(uid: any(named: 'uid')),
        ).thenAnswer((_) async => Left(notFoundFailure));
        when(
          () => mockRepo.createUserProfile(any()),
        ).thenAnswer((_) async => Left(authFailure));

        // Act
        final result = await useCase(TestConstants.testUserId);

        // Assert
        expect(result.isLeft, isTrue);
        verify(
          () => mockRepo.createUserProfile(TestConstants.testUserId),
        ).called(1);
      });
    });
  });
}
