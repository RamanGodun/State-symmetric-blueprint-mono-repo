/// Tests for GlobalDIContainer
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Singleton initialization
/// - isInitialized getter
/// - instance getter
/// - initialize method
/// - reset method
/// - dispose method
/// - Error cases
library;

import 'package:adapters_for_riverpod/src/app_bootstrap/di/global_di_container.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GlobalDIContainer', () {
    // Clean up after each test
    tearDown(GlobalDIContainer.reset);

    group('isInitialized', () {
      test('returns false when not initialized', () {
        // Arrange - Ensure clean state
        GlobalDIContainer.reset();

        // Act
        final isInit = GlobalDIContainer.isInitialized;

        // Assert
        expect(isInit, isFalse);
      });

      test('returns true after initialization', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        final isInit = GlobalDIContainer.isInitialized;

        // Assert
        expect(isInit, isTrue);
      });

      test('returns false after reset', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        GlobalDIContainer.reset();
        final isInit = GlobalDIContainer.isInitialized;

        // Assert
        expect(isInit, isFalse);
      });
    });

    group('instance', () {
      test('throws StateError when accessed before initialization', () {
        // Arrange - Ensure not initialized
        GlobalDIContainer.reset();

        // Act & Assert
        expect(
          () => GlobalDIContainer.instance,
          throwsA(isA<StateError>()),
        );
      });

      test('returns container after initialization', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        final instance = GlobalDIContainer.instance;

        // Assert
        expect(instance, isNotNull);
        expect(instance, equals(container));
        expect(instance, isA<ProviderContainer>());
      });

      test('returns same instance on multiple accesses', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        final instance1 = GlobalDIContainer.instance;
        final instance2 = GlobalDIContainer.instance;

        // Assert
        expect(identical(instance1, instance2), isTrue);
      });
    });

    group('initialize', () {
      test('initializes container successfully', () {
        // Arrange
        final container = ProviderContainer();

        // Act
        GlobalDIContainer.initialize(container);

        // Assert
        expect(GlobalDIContainer.isInitialized, isTrue);
        expect(GlobalDIContainer.instance, equals(container));
      });

      test('throws StateError when called twice', () {
        // Arrange
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();
        GlobalDIContainer.initialize(container1);

        // Act & Assert
        expect(
          () => GlobalDIContainer.initialize(container2),
          throwsA(isA<StateError>()),
        );
      });

      test('can be called again after reset', () {
        // Arrange
        final container1 = ProviderContainer();
        GlobalDIContainer.initialize(container1);
        GlobalDIContainer.reset();

        final container2 = ProviderContainer();

        // Act
        GlobalDIContainer.initialize(container2);

        // Assert
        expect(GlobalDIContainer.isInitialized, isTrue);
        expect(GlobalDIContainer.instance, equals(container2));
      });
    });

    group('reset', () {
      test('clears the instance', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);
        expect(GlobalDIContainer.isInitialized, isTrue);

        // Act
        GlobalDIContainer.reset();

        // Assert
        expect(GlobalDIContainer.isInitialized, isFalse);
        expect(() => GlobalDIContainer.instance, throwsA(isA<StateError>()));
      });

      test('can be called multiple times safely', () {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        GlobalDIContainer.reset();
        GlobalDIContainer.reset();
        GlobalDIContainer.reset();

        // Assert
        expect(GlobalDIContainer.isInitialized, isFalse);
      });

      test('can be called when not initialized', () {
        // Arrange - Ensure clean state
        GlobalDIContainer.reset();

        // Act & Assert - Should not throw
        expect(GlobalDIContainer.reset, returnsNormally);
        expect(GlobalDIContainer.isInitialized, isFalse);
      });
    });

    group('dispose', () {
      test('disposes and clears the instance', () async {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        await GlobalDIContainer.dispose();

        // Assert
        expect(GlobalDIContainer.isInitialized, isFalse);
      });

      test('can be called when not initialized', () async {
        // Arrange
        GlobalDIContainer.reset();

        // Act & Assert - Should not throw
        await expectLater(
          GlobalDIContainer.dispose(),
          completes,
        );
      });

      test('can be called multiple times', () async {
        // Arrange
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act & Assert
        await GlobalDIContainer.dispose();
        await GlobalDIContainer.dispose();
        await GlobalDIContainer.dispose();

        expect(GlobalDIContainer.isInitialized, isFalse);
      });
    });

    group('real-world scenarios', () {
      test('typical app initialization flow', () async {
        // Arrange
        final container = ProviderContainer();

        // Act - App startup
        expect(GlobalDIContainer.isInitialized, isFalse);
        GlobalDIContainer.initialize(container);
        expect(GlobalDIContainer.isInitialized, isTrue);

        // Use container
        final instance = GlobalDIContainer.instance;
        expect(instance, isNotNull);

        // App shutdown
        await GlobalDIContainer.dispose();
        expect(GlobalDIContainer.isInitialized, isFalse);
      });

      test('test isolation pattern', () async {
        // Arrange - Simulate test 1
        final container1 = ProviderContainer();
        GlobalDIContainer.initialize(container1);
        await GlobalDIContainer.dispose();

        // Simulate test 2 - clean state
        expect(GlobalDIContainer.isInitialized, isFalse);

        final container2 = ProviderContainer();
        GlobalDIContainer.initialize(container2);

        // Assert - Test 2 has its own container
        expect(GlobalDIContainer.instance, equals(container2));
        expect(GlobalDIContainer.instance, isNot(equals(container1)));

        await GlobalDIContainer.dispose();
      });

      test('reading providers from global container', () {
        // Arrange
        final testProvider = Provider<String>((ref) => 'test value');
        final container = ProviderContainer();
        GlobalDIContainer.initialize(container);

        // Act
        final value = GlobalDIContainer.instance.read(testProvider);

        // Assert
        expect(value, equals('test value'));
      });

      test('prevents accidental double initialization', () {
        // Arrange
        final container1 = ProviderContainer();
        final container2 = ProviderContainer();

        // Act
        GlobalDIContainer.initialize(container1);

        // Assert - Second initialization should fail
        expect(
          () => GlobalDIContainer.initialize(container2),
          throwsA(
            predicate<StateError>(
              (e) => e.message.contains('already initialized'),
            ),
          ),
        );
      });

      test('reset allows re-initialization for testing', () {
        // Arrange - First test
        final container1 = ProviderContainer();
        GlobalDIContainer.initialize(container1);

        // Act - Clean up for next test
        GlobalDIContainer.reset();

        // Second test
        final container2 = ProviderContainer();
        GlobalDIContainer.initialize(container2);

        // Assert
        expect(GlobalDIContainer.instance, equals(container2));
      });
    });
  });
}
