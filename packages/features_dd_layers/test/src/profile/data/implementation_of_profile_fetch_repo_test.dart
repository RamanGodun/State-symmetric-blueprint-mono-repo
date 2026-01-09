/// Tests for ProfileRepoImpl
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Profile fetching with caching
/// - Profile refresh (cache bypass)
/// - Profile creation
/// - Cache management
/// - DTO mapping
/// - Error handling
library;

import 'package:features_dd_layers/src/profile/data/implementation_of_profile_fetch_repo.dart';
import 'package:features_dd_layers/src/profile/data/remote_database_contract.dart';
import 'package:features_dd_layers/src/profile/domain/repo_contract.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/base_modules/errors_management.dart';
import 'package:shared_layers/public_api/data_layer_shared.dart'
    show CacheStats;
import 'package:shared_layers/public_api/domain_layer_shared.dart';

import '../../../fixtures/test_constants.dart';

class MockProfileRemoteDatabase extends Mock
    implements IProfileRemoteDatabase {}

void main() {
  group('ProfileRepoImpl', () {
    late IProfileRemoteDatabase mockRemote;
    late IProfileRepo repo;

    setUp(() {
      mockRemote = MockProfileRemoteDatabase();
      repo = ProfileRepoImpl(mockRemote);
    });

    group('constructor', () {
      test('creates instance with provided remote database', () {
        // Arrange & Act
        final repo = ProfileRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<ProfileRepoImpl>());
        expect(repo, isA<IProfileRepo>());
      });

      test('creates instance with default cache manager', () {
        // Arrange & Act
        final repo = ProfileRepoImpl(mockRemote);

        // Assert
        expect(repo, isA<ProfileRepoImpl>());
        expect(repo.cacheStats, isA<CacheStats>());
      });
    });

    group('getProfile', () {
      group('successful profile fetch', () {
        test('calls remote fetchUserMap method', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          verify(
            () => mockRemote.fetchUserMap(TestConstants.testUserId),
          ).called(1);
        });

        test('returns Right with UserEntity on success', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          final result = await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, isA<UserEntity>());
        });

        test('maps DTO to entity correctly', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          final result = await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          expect(result.rightOrNull?.id, equals(TestConstants.testUserId));
          expect(
            result.rightOrNull?.name,
            equals(TestConstants.testUserEntity.name),
          );
          expect(
            result.rightOrNull?.email,
            equals(TestConstants.testUserEntity.email),
          );
        });

        test('uses cache on subsequent calls with same uid', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act - First call
          await repo.getProfile(uid: TestConstants.testUserId);
          // Act - Second call (should use cache)
          await repo.getProfile(uid: TestConstants.testUserId);

          // Assert - Remote should only be called once due to caching
          verify(
            () => mockRemote.fetchUserMap(TestConstants.testUserId),
          ).called(1);
        });

        test('fetches different profiles independently', () async {
          // Arrange
          const uid1 = 'user-1';
          const uid2 = 'user-2';
          when(
            () => mockRemote.fetchUserMap(uid1),
          ).thenAnswer((_) async => TestConstants.testUserMap);
          when(
            () => mockRemote.fetchUserMap(uid2),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          await repo.getProfile(uid: uid1);
          await repo.getProfile(uid: uid2);

          // Assert
          verify(() => mockRemote.fetchUserMap(uid1)).called(1);
          verify(() => mockRemote.fetchUserMap(uid2)).called(1);
        });
      });

      group('failed profile fetch', () {
        test('returns Left when user not found (null data)', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => null);

          // Act
          final result = await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
          expect(
            result.leftOrNull?.type,
            isA<UserNotFoundFirebaseFailureType>(),
          );
        });

        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenThrow(Exception('Connection timeout'));

          // Act
          final result = await repo.getProfile(uid: TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Connection timeout'));
        });
      });
    });

    group('refreshProfile', () {
      group('successful profile refresh', () {
        test('calls remote fetchUserMap even if cached', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act - First call to populate cache
          await repo.getProfile(uid: TestConstants.testUserId);
          // Act - Refresh should bypass cache
          await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );

          // Assert - Should be called twice (once for getProfile, once for refresh)
          verify(
            () => mockRemote.fetchUserMap(TestConstants.testUserId),
          ).called(2);
        });

        test('returns Right with updated UserEntity', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          final result = await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );

          // Assert
          expect(result.isRight, isTrue);
          expect(result.rightOrNull, isA<UserEntity>());
        });

        test('bypasses cache for each refresh call', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act
          await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );
          await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );
          await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );

          // Assert - Should call remote 3 times (no caching)
          verify(
            () => mockRemote.fetchUserMap(TestConstants.testUserId),
          ).called(3);
        });
      });

      group('failed profile refresh', () {
        test('returns Left when user not found', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => null);

          // Act
          final result = await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(
            result.leftOrNull?.type,
            isA<UserNotFoundFirebaseFailureType>(),
          );
        });

        test('returns Left when remote throws exception', () async {
          // Arrange
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenThrow(Exception('Network error'));

          // Act
          final result = await (repo as ProfileRepoImpl).refreshProfile(
            uid: TestConstants.testUserId,
          );

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
        });
      });
    });

    group('createUserProfile', () {
      group('successful profile creation', () {
        test('calls getCurrentUserAuthData from remote', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          verify(() => mockRemote.getCurrentUserAuthData()).called(1);
        });

        test('calls createUserMap with correct data', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          verify(
            () => mockRemote.createUserMap(
              TestConstants.testUserId,
              any(),
            ),
          ).called(1);
        });

        test('returns Right on successful creation', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenAnswer((_) async {});

          // Act
          final result = await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          expect(result.isRight, isTrue);
        });

        test('removes uid from cache after creation', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenAnswer((_) async {});
          when(
            () => mockRemote.fetchUserMap(any()),
          ).thenAnswer((_) async => TestConstants.testUserMap);

          // Act - Populate cache first
          await repo.getProfile(uid: TestConstants.testUserId);
          // Act - Create profile (should clear from cache)
          await repo.createUserProfile(TestConstants.testUserId);
          // Act - Fetch again (should call remote again)
          await repo.getProfile(uid: TestConstants.testUserId);

          // Assert - Should be called 2 times (once before create, once after)
          verify(
            () => mockRemote.fetchUserMap(TestConstants.testUserId),
          ).called(2);
        });
      });

      group('failed profile creation', () {
        test('returns Left when getCurrentUserAuthData returns null', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => null);

          // Act
          final result = await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull, isA<Failure>());
          expect(
            result.leftOrNull?.type,
            isA<UserMissingFirebaseFailureType>(),
          );
        });

        test('does not call createUserMap when auth data is null', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => null);

          // Act
          await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          verifyNever(() => mockRemote.createUserMap(any(), any()));
        });

        test('returns Left when createUserMap throws exception', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenThrow(Exception('Database error'));

          // Act
          final result = await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Database error'));
        });

        test('captures exception message in Failure', () async {
          // Arrange
          when(
            () => mockRemote.getCurrentUserAuthData(),
          ).thenAnswer((_) async => TestConstants.testAuthData);
          when(
            () => mockRemote.createUserMap(any(), any()),
          ).thenThrow(Exception('Permission denied'));

          // Act
          final result = await repo.createUserProfile(TestConstants.testUserId);

          // Assert
          expect(result.isLeft, isTrue);
          expect(result.leftOrNull?.message, contains('Permission denied'));
        });
      });
    });

    group('clearCache', () {
      test('clears cache for all users', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act - Populate cache with 2 users
        await repo.getProfile(uid: 'user1');
        await repo.getProfile(uid: 'user2');

        // Act - Clear cache
        repo.clearCache();

        // Act - Fetch again (should call remote again)
        await repo.getProfile(uid: 'user1');
        await repo.getProfile(uid: 'user2');

        // Assert - Each user should be fetched twice (before and after clear)
        verify(() => mockRemote.fetchUserMap('user1')).called(2);
        verify(() => mockRemote.fetchUserMap('user2')).called(2);
      });

      test('cache stats available after clear', () {
        // Arrange & Act
        repo.clearCache();

        // Assert
        expect((repo as ProfileRepoImpl).cacheStats, isA<CacheStats>());
      });
    });

    group('cacheStats', () {
      test('returns cache statistics', () {
        // Arrange & Act
        final stats = (repo as ProfileRepoImpl).cacheStats;

        // Assert
        expect(stats, isA<CacheStats>());
      });
    });

    group('real-world scenarios', () {
      test('simulates complete user profile flow', () async {
        // Arrange
        when(
          () => mockRemote.getCurrentUserAuthData(),
        ).thenAnswer((_) async => TestConstants.testAuthData);
        when(
          () => mockRemote.createUserMap(any(), any()),
        ).thenAnswer((_) async {});
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act - Create profile
        final createResult = await repo.createUserProfile(
          TestConstants.testUserId,
        );

        // Act - Fetch profile
        final fetchResult = await repo.getProfile(
          uid: TestConstants.testUserId,
        );

        // Assert
        expect(createResult.isRight, isTrue);
        expect(fetchResult.isRight, isTrue);
        expect(fetchResult.rightOrNull, isA<UserEntity>());
      });

      test('simulates profile fetch then refresh', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act
        final initialResult = await repo.getProfile(
          uid: TestConstants.testUserId,
        );
        final refreshResult = await (repo as ProfileRepoImpl).refreshProfile(
          uid: TestConstants.testUserId,
        );

        // Assert
        expect(initialResult.isRight, isTrue);
        expect(refreshResult.isRight, isTrue);
        verify(
          () => mockRemote.fetchUserMap(TestConstants.testUserId),
        ).called(2);
      });

      test('simulates cached access pattern', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act - Multiple reads should use cache
        await repo.getProfile(uid: TestConstants.testUserId);
        await repo.getProfile(uid: TestConstants.testUserId);
        await repo.getProfile(uid: TestConstants.testUserId);

        // Assert - Remote called only once due to caching
        verify(
          () => mockRemote.fetchUserMap(TestConstants.testUserId),
        ).called(1);
      });

      test('simulates cache clear and refetch', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act
        await repo.getProfile(uid: TestConstants.testUserId);
        repo.clearCache();
        await repo.getProfile(uid: TestConstants.testUserId);

        // Assert
        verify(
          () => mockRemote.fetchUserMap(TestConstants.testUserId),
        ).called(2);
      });

      test('handles user not found gracefully', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => null);

        // Act
        final result = await repo.getProfile(uid: 'nonexistent-user');

        // Assert
        expect(result.isLeft, isTrue);
        expect(
          result.leftOrNull?.type,
          isA<UserNotFoundFirebaseFailureType>(),
        );
      });
    });

    group('edge cases', () {
      test('handles empty uid', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act
        await repo.getProfile(uid: '');

        // Assert
        verify(() => mockRemote.fetchUserMap('')).called(1);
      });

      test('handles very long uid', () async {
        // Arrange
        final longUid = 'uid' * 1000;
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act
        await repo.getProfile(uid: longUid);

        // Assert
        verify(() => mockRemote.fetchUserMap(longUid)).called(1);
      });

      test('handles multiple concurrent fetches for same uid', () async {
        // Arrange
        when(
          () => mockRemote.fetchUserMap(any()),
        ).thenAnswer((_) async => TestConstants.testUserMap);

        // Act - Concurrent fetches
        await Future.wait([
          repo.getProfile(uid: TestConstants.testUserId),
          repo.getProfile(uid: TestConstants.testUserId),
          repo.getProfile(uid: TestConstants.testUserId),
        ]);

        // Assert - Should only call remote once due to in-flight caching
        verify(
          () => mockRemote.fetchUserMap(TestConstants.testUserId),
        ).called(1);
      });

      test('handles generic errors', () async {
        // Arrange
        when(() => mockRemote.fetchUserMap(any())).thenThrow('String error');

        // Act
        final result = await repo.getProfile(uid: TestConstants.testUserId);

        // Assert
        expect(result.isLeft, isTrue);
        expect(result.leftOrNull, isA<Failure>());
      });
    });
  });
}
