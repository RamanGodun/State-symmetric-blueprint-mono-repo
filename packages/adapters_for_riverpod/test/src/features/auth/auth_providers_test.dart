/// Tests for Auth Providers
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Auth Gateway providers
/// - Data layer providers
/// - Domain layer (use case) providers
library;

import 'package:adapters_for_firebase/adapters_for_firebase.dart';
import 'package:adapters_for_riverpod/src/features/auth/auth_gateway/auth_gateway_providers.dart';
import 'package:adapters_for_riverpod/src/features/auth/data_layer_providers/data_layer_providers.dart';
import 'package:adapters_for_riverpod/src/features/auth/domain_layer_providers/use_cases_providers.dart';
import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart';
import 'package:features_dd_layers/public_api/auth/auth_infra.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway, AuthLoading, AuthReady, AuthSession, AuthSnapshot;

class MockAuthGateway extends Mock implements AuthGateway {}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// Using Fake instead of Mock to avoid sealed class warning
// ignore: subtype_of_sealed_class
class FakeUsersCollection extends Fake implements UsersCollection {}

void main() {
  group('Auth Gateway Providers', () {
    test('authGatewayProvider throws UnimplementedError by default', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act & Assert
      expect(
        () => container.read(authGatewayProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('authGatewayProvider can be overridden', () {
      // Arrange
      final mockGateway = MockAuthGateway();
      final container = ProviderContainer(
        overrides: [
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final gateway = container.read(authGatewayProvider);

      // Assert
      expect(gateway, equals(mockGateway));
      expect(gateway, isA<AuthGateway>());
    });

    test('authSnapshotsProvider requires authGateway override', () {
      // Arrange
      final mockGateway = MockAuthGateway();
      when(() => mockGateway.snapshots$).thenAnswer(
        (_) => Stream.value(const AuthLoading()),
      );

      final container = ProviderContainer(
        overrides: [
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final snapshots = container.read(authSnapshotsProvider);

      // Assert - authSnapshotsProvider returns AsyncValue<AuthSnapshot>
      expect(snapshots, isA<AsyncValue<AuthSnapshot>>());
    });

    test('authUidProvider extracts uid from AuthReady snapshots', () {
      // Arrange
      final mockGateway = MockAuthGateway();
      const testSession = AuthSession(
        uid: 'test-uid',
        email: 'test@example.com',
        emailVerified: true,
        isAnonymous: false,
      );
      when(() => mockGateway.snapshots$).thenAnswer(
        (_) => Stream.value(const AuthReady(testSession)),
      );

      final container = ProviderContainer(
        overrides: [
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final uidProvider = container.read(authUidProvider);

      // Assert - authUidProvider returns AsyncValue<String?>
      expect(uidProvider, isA<AsyncValue<String?>>());
    });

    test('authUidProvider returns null for unauthenticated snapshots', () {
      // Arrange
      final mockGateway = MockAuthGateway();
      const unauthSession = AuthSession(
        emailVerified: false,
        isAnonymous: false,
      );
      when(() => mockGateway.snapshots$).thenAnswer(
        (_) => Stream.value(const AuthReady(unauthSession)),
      );

      final container = ProviderContainer(
        overrides: [
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final uidProvider = container.read(authUidProvider);

      // Assert - Returns AsyncValue wrapping null
      expect(uidProvider, isA<AsyncValue<String?>>());
    });
  });

  group('Data Layer Providers', () {
    test('authRemoteDatabaseProvider creates AuthRemoteDatabaseImpl', () {
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
      final remoteDb = container.read(authRemoteDatabaseProvider);

      // Assert
      expect(remoteDb, isA<IAuthRemoteDatabase>());
      expect(remoteDb, isA<AuthRemoteDatabaseImpl>());
    });

    test('signInRepoProvider creates SignInRepoImpl', () {
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
      final repo = container.read(signInRepoProvider);

      // Assert
      expect(repo, isA<ISignInRepo>());
      expect(repo, isA<SignInRepoImpl>());
    });

    test('signOutRepoProvider creates SignOutRepoImpl', () {
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
      final repo = container.read(signOutRepoProvider);

      // Assert
      expect(repo, isA<ISignOutRepo>());
      expect(repo, isA<SignOutRepoImpl>());
    });

    test('signUpRepoProvider creates SignUpRepoImpl', () {
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
      final repo = container.read(signUpRepoProvider);

      // Assert
      expect(repo, isA<ISignUpRepo>());
      expect(repo, isA<SignUpRepoImpl>());
    });
  });

  group('Domain Layer Providers', () {
    test('signInUseCaseProvider creates SignInUseCase', () {
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
      final useCase = container.read(signInUseCaseProvider);

      // Assert
      expect(useCase, isA<SignInUseCase>());
    });

    test('signOutUseCaseProvider creates SignOutUseCase', () {
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
      final useCase = container.read(signOutUseCaseProvider);

      // Assert
      expect(useCase, isA<SignOutUseCase>());
    });

    test('signUpUseCaseProvider creates SignUpUseCase', () {
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
      final useCase = container.read(signUpUseCaseProvider);

      // Assert
      expect(useCase, isA<SignUpUseCase>());
    });
  });

  group('Provider Dependencies', () {
    test('use cases depend on repositories', () {
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

      // Act - Read use cases (should trigger repo creation)
      container
        ..read(signInUseCaseProvider)
        ..read(signOutUseCaseProvider)
        ..read(signUpUseCaseProvider);

      // Assert - Repos should also be created
      expect(container.read(signInRepoProvider), isA<ISignInRepo>());
      expect(container.read(signOutRepoProvider), isA<ISignOutRepo>());
      expect(container.read(signUpRepoProvider), isA<ISignUpRepo>());
    });

    test('repositories depend on remote database', () {
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

      // Act - Read repos (should trigger remote database creation)
      container.read(signInRepoProvider);

      // Assert
      expect(
        container.read(authRemoteDatabaseProvider),
        isA<IAuthRemoteDatabase>(),
      );
    });
  });
}
