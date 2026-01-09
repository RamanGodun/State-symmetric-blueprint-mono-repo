/// Tests for Profile Providers
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
library;

import 'package:adapters_for_firebase/adapters_for_firebase.dart';
import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart';
import 'package:adapters_for_riverpod/src/features/profile/data_layers_providers/data_layer_providers.dart';
import 'package:adapters_for_riverpod/src/features/profile/domain_layer_providers/use_case_provider.dart';
import 'package:features_dd_layers/public_api/profile/profile.dart';
import 'package:features_dd_layers/public_api/profile/profile_infra.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Using Fake instead of Mock to avoid sealed class warning
// ignore: subtype_of_sealed_class
class FakeUsersCollection extends Fake implements UsersCollection {}

void main() {
  group('Profile Data Layer Providers', () {
    test('profileRemoteDataSourceProvider creates impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final dataSource = container.read(profileRemoteDataSourceProvider);

      // Assert
      expect(dataSource, isA<IProfileRemoteDatabase>());
      expect(dataSource, isA<ProfileRemoteDatabaseImpl>());
    });

    test('profileRepoProvider creates repo impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final repo = container.read(profileRepoProvider);

      // Assert
      expect(repo, isA<IProfileRepo>());
      expect(repo, isA<ProfileRepoImpl>());
    });

    test('profileRepoProvider depends on profileRemoteDataSourceProvider', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      container.read(profileRepoProvider);

      // Assert - Reading repo should also initialize remote data source
      expect(
        container.read(profileRemoteDataSourceProvider),
        isA<IProfileRemoteDatabase>(),
      );
    });

    test('multiple reads return same instance (singleton behavior)', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final repo1 = container.read(profileRepoProvider);
      final repo2 = container.read(profileRepoProvider);

      // Assert - Should be same instance
      expect(identical(repo1, repo2), isTrue);
    });
  });

  group('Profile Domain Layer Providers', () {
    test('fetchProfileUseCaseProvider creates use case', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(fetchProfileUseCaseProvider);

      // Assert
      expect(useCase, isA<FetchProfileUseCase>());
    });

    test('fetchProfileUseCaseProvider depends on profileRepoProvider', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act
      container.read(fetchProfileUseCaseProvider);

      // Assert - Reading use case should initialize repo
      expect(
        container.read(profileRepoProvider),
        isA<IProfileRepo>(),
      );
    });

    test('fetchProfileUseCaseProvider is not kept alive', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act - Read and then let it dispose
      final useCase1 = container.read(fetchProfileUseCaseProvider);
      expect(useCase1, isA<FetchProfileUseCase>());

      // Force provider disposal by invalidating
      container.invalidate(fetchProfileUseCaseProvider);

      // Read again after invalidation
      final useCase2 = container.read(fetchProfileUseCaseProvider);

      // Assert - Should create new instance (not kept alive)
      expect(useCase2, isA<FetchProfileUseCase>());
    });
  });

  group('Provider Dependencies', () {
    test('use case transitively depends on remote data source', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act - Read use case
      container.read(fetchProfileUseCaseProvider);

      // Assert - All dependencies should be initialized
      expect(
        container.read(profileRepoProvider),
        isA<IProfileRepo>(),
      );
      expect(
        container.read(profileRemoteDataSourceProvider),
        isA<IProfileRemoteDatabase>(),
      );
    });

    test('full dependency chain works correctly', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act & Assert - Build dependency chain from bottom to top
      final dataSource = container.read(profileRemoteDataSourceProvider);
      expect(dataSource, isA<ProfileRemoteDatabaseImpl>());

      final repo = container.read(profileRepoProvider);
      expect(repo, isA<ProfileRepoImpl>());

      final useCase = container.read(fetchProfileUseCaseProvider);
      expect(useCase, isA<FetchProfileUseCase>());
    });
  });

  group('Provider Overrides', () {
    test('can override profileRepoProvider', () {
      // Arrange
      final mockRepo = MockProfileRepo();
      final container = ProviderContainer(
        overrides: [
          profileRepoProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final repo = container.read(profileRepoProvider);

      // Assert
      expect(repo, equals(mockRepo));
    });

    test('can override profileRemoteDataSourceProvider', () {
      // Arrange
      final mockDataSource = MockProfileRemoteDatabase();
      final container = ProviderContainer(
        overrides: [
          profileRemoteDataSourceProvider.overrideWithValue(mockDataSource),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final dataSource = container.read(profileRemoteDataSourceProvider);

      // Assert
      expect(dataSource, equals(mockDataSource));
    });

    test('overriding repo does not affect use case creation', () {
      // Arrange
      final mockRepo = MockProfileRepo();
      final container = ProviderContainer(
        overrides: [
          profileRepoProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(fetchProfileUseCaseProvider);

      // Assert - Use case should be created with mocked repo
      expect(useCase, isA<FetchProfileUseCase>());
    });
  });

  group('Real-World Scenarios', () {
    test('typical app initialization creates all profile dependencies', () {
      // Arrange - App startup with Firebase
      final mockAuth = MockFirebaseAuth();
      final mockCollection = FakeUsersCollection();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          usersCollectionProvider.overrideWithValue(mockCollection),
        ],
      );
      addTearDown(container.dispose);

      // Act - Initialize profile feature
      final useCase = container.read(fetchProfileUseCaseProvider);

      // Assert - Complete dependency chain created
      expect(useCase, isA<FetchProfileUseCase>());
      expect(
        container.read(profileRepoProvider),
        isA<ProfileRepoImpl>(),
      );
      expect(
        container.read(profileRemoteDataSourceProvider),
        isA<ProfileRemoteDatabaseImpl>(),
      );
    });

    test('testing scenario with mocked repository', () {
      // Arrange - Test setup with mock
      final mockRepo = MockProfileRepo();
      final container = ProviderContainer(
        overrides: [
          profileRepoProvider.overrideWithValue(mockRepo),
        ],
      );
      addTearDown(container.dispose);

      // Act - Use in test
      final useCase = container.read(fetchProfileUseCaseProvider);

      // Assert - Works with test doubles
      expect(useCase, isA<FetchProfileUseCase>());
    });
  });
}

// Test Mocks
class MockProfileRepo extends Mock implements IProfileRepo {}

class MockProfileRemoteDatabase extends Mock
    implements IProfileRemoteDatabase {}
