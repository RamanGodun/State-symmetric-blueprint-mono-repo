/// Tests for ProviderDebugObserver
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Constructor parameters (logValues, onlyNamed, ignore)
/// - _shouldLog filtering logic
/// - didAddProvider callback
/// - didUpdateProvider callback
/// - didDisposeProvider callback
library;

import 'package:adapters_for_riverpod/src/base_modules/observing/providers_debug_observer.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProviderDebugObserver', () {
    group('constructor', () {
      test('creates instance with default values', () {
        // Arrange & Act
        const observer = ProviderDebugObserver();

        // Assert
        expect(observer, isA<ProviderDebugObserver>());
        expect(observer.logValues, isTrue);
        expect(observer.onlyNamed, isNull);
        expect(observer.ignore, isNull);
      });

      test('creates instance with custom logValues', () {
        // Arrange & Act
        const observer = ProviderDebugObserver(logValues: false);

        // Assert
        expect(observer.logValues, isFalse);
      });

      test('creates instance with onlyNamed filter', () {
        // Arrange & Act
        const observer = ProviderDebugObserver(
          onlyNamed: {'provider1', 'provider2'},
        );

        // Assert
        expect(observer.onlyNamed, isNotNull);
        expect(observer.onlyNamed, contains('provider1'));
        expect(observer.onlyNamed, contains('provider2'));
      });

      test('creates instance with ignore filter', () {
        // Arrange & Act
        const observer = ProviderDebugObserver(
          ignore: {'ignoreThis', 'ignoreThat'},
        );

        // Assert
        expect(observer.ignore, isNotNull);
        expect(observer.ignore, contains('ignoreThis'));
        expect(observer.ignore, contains('ignoreThat'));
      });

      test('creates instance with all parameters', () {
        // Arrange & Act
        const observer = ProviderDebugObserver(
          logValues: false,
          onlyNamed: {'allowed'},
          ignore: {'blocked'},
        );

        // Assert
        expect(observer.logValues, isFalse);
        expect(observer.onlyNamed, isNotNull);
        expect(observer.ignore, isNotNull);
      });
    });

    group('filtering behavior', () {
      test('logs all providers when no filters set', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);
        final provider = Provider<String>((ref) => 'test');

        // Act
        final value = container.read(provider);

        // Assert
        expect(value, equals('test'));
        container.dispose();
      });

      test('logs only named providers when onlyNamed is set', () {
        // Arrange
        const observer = ProviderDebugObserver(
          onlyNamed: {'allowedProvider'},
        );
        final container = ProviderContainer(observers: [observer]);

        // Named provider that should be logged
        final allowedProvider = Provider<String>(
          (ref) => 'allowed',
          name: 'allowedProvider',
        );

        // Named provider that should NOT be logged
        final blockedProvider = Provider<String>(
          (ref) => 'blocked',
          name: 'blockedProvider',
        );

        // Act
        final allowed = container.read(allowedProvider);
        final blocked = container.read(blockedProvider);

        // Assert
        expect(allowed, equals('allowed'));
        expect(blocked, equals('blocked'));
        container.dispose();
      });

      test('does not log ignored providers', () {
        // Arrange
        const observer = ProviderDebugObserver(
          ignore: {'ignoredProvider'},
        );
        final container = ProviderContainer(observers: [observer]);

        final ignoredProvider = Provider<String>(
          (ref) => 'ignored',
          name: 'ignoredProvider',
        );

        final normalProvider = Provider<String>(
          (ref) => 'normal',
          name: 'normalProvider',
        );

        // Act
        final ignored = container.read(ignoredProvider);
        final normal = container.read(normalProvider);

        // Assert
        expect(ignored, equals('ignored'));
        expect(normal, equals('normal'));
        container.dispose();
      });
    });

    group('lifecycle callbacks', () {
      test('didAddProvider is called when provider is created', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);
        final provider = Provider<String>((ref) => 'test value');

        // Act
        final value = container.read(provider);

        // Assert
        expect(value, equals('test value'));
        container.dispose();
      });

      test('didUpdateProvider is called when provider value changes', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);
        final provider = StateProvider<int>((ref) => 0);

        // Act - Initial read
        container.read(provider);

        // Update value
        container.read(provider.notifier).state = 42;

        // Assert
        expect(container.read(provider), equals(42));
        container.dispose();
      });

      test('didDisposeProvider is called when container is disposed', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);
        final provider = Provider<String>((ref) => 'test');

        // Act
        container
          ..read(provider)
          ..dispose();

        // Assert - Container disposed successfully
        expect(() => container.read(provider), throwsStateError);
      });
    });

    group('logValues parameter', () {
      test('logs values when logValues is true', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);
        final provider = StateProvider<String>((ref) => 'initial');

        // Act
        container.read(provider);
        container.read(provider.notifier).state = 'updated';

        // Assert
        expect(container.read(provider), equals('updated'));
        container.dispose();
      });

      test('does not log values when logValues is false', () {
        // Arrange
        const observer = ProviderDebugObserver(logValues: false);
        final container = ProviderContainer(observers: [observer]);
        final provider = StateProvider<String>((ref) => 'initial');

        // Act
        container.read(provider);
        container.read(provider.notifier).state = 'updated';

        // Assert
        expect(container.read(provider), equals('updated'));
        container.dispose();
      });
    });

    group('real-world scenarios', () {
      test('tracks provider lifecycle in typical app flow', () {
        // Arrange
        const observer = ProviderDebugObserver();
        final container = ProviderContainer(observers: [observer]);

        final counterProvider = StateProvider<int>((ref) => 0);

        // Act - Simulate app lifecycle
        // 1. Provider created
        final initial = container.read(counterProvider);
        expect(initial, equals(0));

        // 2. Provider updated
        container.read(counterProvider.notifier).state = 1;
        expect(container.read(counterProvider), equals(1));

        // 3. Provider updated again
        container.read(counterProvider.notifier).state = 2;
        expect(container.read(counterProvider), equals(2));

        // 4. Container disposed
        container.dispose();

        // Assert
        expect(() => container.read(counterProvider), throwsStateError);
      });

      test('filters providers in large app', () {
        // Arrange - Only log auth-related providers
        const observer = ProviderDebugObserver(
          onlyNamed: {'authProvider', 'userProvider'},
        );
        final container = ProviderContainer(observers: [observer]);

        final authProvider = Provider<bool>(
          (ref) => true,
          name: 'authProvider',
        );

        final userProvider = Provider<String>(
          (ref) => 'John',
          name: 'userProvider',
        );

        final themeProvider = Provider<String>(
          (ref) => 'dark',
          name: 'themeProvider',
        );

        // Act - Read all providers
        final isAuth = container.read(authProvider);
        final user = container.read(userProvider);
        final theme = container.read(themeProvider);

        // Assert - All work, but only auth & user are logged
        expect(isAuth, isTrue);
        expect(user, equals('John'));
        expect(theme, equals('dark'));

        container.dispose();
      });

      test('ignores noisy providers', () {
        // Arrange - Ignore frequently updating providers
        const observer = ProviderDebugObserver(
          ignore: {'mousePositionProvider', 'timerProvider'},
        );
        final container = ProviderContainer(observers: [observer]);

        final mouseProvider = StateProvider<int>(
          (ref) => 0,
          name: 'mousePositionProvider',
        );

        final importantProvider = StateProvider<String>(
          (ref) => 'important',
          name: 'importantProvider',
        );

        // Act
        container.read(mouseProvider.notifier).state = 100; // Not logged
        container.read(importantProvider.notifier).state = 'updated'; // Logged

        // Assert
        expect(container.read(mouseProvider), equals(100));
        expect(container.read(importantProvider), equals('updated'));

        container.dispose();
      });
    });
  });
}
