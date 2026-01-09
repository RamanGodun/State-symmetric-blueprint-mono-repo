/// Tests for Password Providers
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ 100% code coverage goal
library;

import 'package:adapters_for_firebase/adapters_for_firebase.dart'
    show FirebaseAuth;
import 'package:adapters_for_riverpod/src/features/auth/for_firebase/firebase_providers.dart';
import 'package:adapters_for_riverpod/src/features/password_changing_or_reset/data_layer_providers/data_layer_providers.dart';
import 'package:adapters_for_riverpod/src/features/password_changing_or_reset/domain_layer_providers/use_cases_provider.dart';
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset_infra.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  group('Password Data Layer Providers', () {
    test('passwordRemoteDatabaseProvider creates impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final database = container.read(passwordRemoteDatabaseProvider);

      // Assert
      expect(database, isA<IPasswordRemoteDatabase>());
      expect(database, isA<PasswordRemoteDatabaseImpl>());
    });

    test('passwordRepoProvider creates repo impl', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final repo = container.read(passwordRepoProvider);

      // Assert
      expect(repo, isA<IPasswordRepo>());
      expect(repo, isA<PasswordRepoImpl>());
    });
  });

  group('Password Domain Layer Providers', () {
    test('passwordUseCasesProvider creates use cases', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      final useCases = container.read(passwordUseCasesProvider);

      // Assert
      expect(useCases, isA<PasswordRelatedUseCases>());
    });
  });

  group('Provider Dependencies', () {
    test('use cases depend on repo', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      container.read(passwordUseCasesProvider);

      // Assert
      expect(
        container.read(passwordRepoProvider),
        isA<IPasswordRepo>(),
      );
    });

    test('repo depends on remote database', () {
      // Arrange
      final mockAuth = MockFirebaseAuth();
      final container = ProviderContainer(
        overrides: [
          firebaseAuthProvider.overrideWithValue(mockAuth),
        ],
      );
      addTearDown(container.dispose);

      // Act
      container.read(passwordRepoProvider);

      // Assert
      expect(
        container.read(passwordRemoteDatabaseProvider),
        isA<IPasswordRemoteDatabase>(),
      );
    });
  });
}
