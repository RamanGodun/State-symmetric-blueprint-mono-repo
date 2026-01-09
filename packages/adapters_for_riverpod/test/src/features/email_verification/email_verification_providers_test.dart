/// Tests for Email Verification Providers
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
library;

import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth;
import 'package:adapters_for_riverpod/src/features/auth/auth_gateway/auth_gateway_providers.dart';
import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart';
import 'package:adapters_for_riverpod/src/features/email_verification/data_layer_providers/data_layer_providers.dart';
import 'package:adapters_for_riverpod/src/features/email_verification/domain_layer_providers/use_case_provider.dart';
import 'package:features_dd_layers/features_dd_layers.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_core_modules/public_api/core_contracts/auth.dart'
    show AuthGateway;

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

class MockAuthGateway extends Mock implements AuthGateway {}

void main() {
  group('Email Verification Data Layer Providers', () {
    test('userValidationRemoteDataSourceProvider creates impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final dataSource = container.read(userValidationRemoteDataSourceProvider);

      // Assert
      expect(dataSource, isA<IUserValidationRemoteDataSource>());
      expect(dataSource, isA<IUserValidationRemoteDataSourceImpl>());
    });

    test('emailVerificationRepoProvider creates repo impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final repo = container.read(emailVerificationRepoProvider);

      // Assert
      expect(repo, isA<IUserValidationRepo>());
      expect(repo, isA<IUserValidationRepoImpl>());
    });
  });

  group('Email Verification Domain Layer Providers', () {
    test('emailVerificationUseCaseProvider creates use case', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockGateway = MockAuthGateway();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCase = container.read(emailVerificationUseCaseProvider);

      // Assert
      expect(useCase, isA<EmailVerificationUseCase>());
    });
  });

  group('Provider Dependencies', () {
    test('use case depends on repo and gateway', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final mockGateway = MockAuthGateway();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
          authGatewayProvider.overrideWithValue(mockGateway),
        ],
      );
      addTearDown(container.dispose);

      // Act - Read use case (should trigger repo creation)
      container.read(emailVerificationUseCaseProvider);

      // Assert - Repo should also be created
      expect(
        container.read(emailVerificationRepoProvider),
        isA<IUserValidationRepo>(),
      );
    });

    test('repo depends on remote data source', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();

      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act - Read repo (should trigger data source creation)
      container.read(emailVerificationRepoProvider);

      // Assert
      expect(
        container.read(userValidationRemoteDataSourceProvider),
        isA<IUserValidationRemoteDataSource>(),
      );
    });
  });
}
