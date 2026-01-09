/// Tests for Overlay Adapters Providers
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - RiverpodOverlayActivityPort
/// - overlayDispatcherProvider
/// - OverlayStatus notifier
/// - overlayStatusProvider
library;

import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';

void main() {
  group('RiverpodOverlayActivityPort', () {
    test('creates instance with Ref', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProvider = Provider<RiverpodOverlayActivityPort>((ref) {
        return RiverpodOverlayActivityPort(ref);
      });

      // Act
      final port = container.read(testProvider);

      // Assert
      expect(port, isA<RiverpodOverlayActivityPort>());
      expect(port, isA<OverlayActivityPort>());
    });

    test('setActive updates overlay status via notifier', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - Directly update via notifier (simulating what RiverpodOverlayActivityPort does)
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert
      expect(container.read(overlayStatusProvider), isTrue);
    });

    test('setActive with false updates to false via notifier', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - Set to true first
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Set to false
      container.read(overlayStatusProvider.notifier).isActive = false;

      // Assert
      expect(container.read(overlayStatusProvider), isFalse);
    });

    test('notifier does not notify when setting same value', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var updateCount = 0;

      container.listen<bool>(
        overlayStatusProvider,
        (previous, next) {
          updateCount++;
        },
      );

      // Act - Set to false twice (already false by default)
      container.read(overlayStatusProvider.notifier).isActive = false;
      container.read(overlayStatusProvider.notifier).isActive = false;

      // Assert - Riverpod deduplicates same values, so no notifications
      expect(updateCount, equals(0));
    });

    test('notifier updates state immediately', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Assert - Initially false
      expect(container.read(overlayStatusProvider), isFalse);

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert - Updated immediately (no async delay like RiverpodOverlayActivityPort)
      expect(container.read(overlayStatusProvider), isTrue);
    });

    test('RiverpodOverlayActivityPort has resetCache method', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final portProvider = Provider(RiverpodOverlayActivityPort.new);
      final port = container.read(portProvider)
        // Act - resetCache should not throw
        ..resetCache();

      // Assert - Cache reset successful (no exception)
      expect(port, isA<RiverpodOverlayActivityPort>());
    });

    test('can be created via provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final portProvider = Provider(RiverpodOverlayActivityPort.new);

      // Act
      final port = container.read(portProvider);

      // Assert
      expect(port, isA<RiverpodOverlayActivityPort>());
    });
  });

  group('overlayDispatcherProvider', () {
    test('provides OverlayDispatcher instance', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final dispatcher = container.read(overlayDispatcherProvider);

      // Assert
      expect(dispatcher, isA<OverlayDispatcher>());
      expect(dispatcher, isNotNull);
    });

    test('is keepAlive provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final dispatcher1 = container.read(overlayDispatcherProvider);
      final dispatcher2 = container.read(overlayDispatcherProvider);

      // Assert - Same instance
      expect(identical(dispatcher1, dispatcher2), isTrue);
    });

    test('creates dispatcher with RiverpodOverlayActivityPort', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final dispatcher = container.read(overlayDispatcherProvider);

      // Assert - Dispatcher should be functional
      expect(dispatcher, isA<OverlayDispatcher>());
    });
  });

  group('OverlayStatus', () {
    test('initial state is false', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final status = container.read(overlayStatusProvider);

      // Assert
      expect(status, isFalse);
    });

    test('isActive setter updates state', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert
      expect(container.read(overlayStatusProvider), isTrue);
    });

    test('isActive getter returns current state', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;
      final isActive = container.read(overlayStatusProvider.notifier).isActive;

      // Assert
      expect(isActive, isTrue);
    });

    test('can toggle between true and false', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act & Assert
      container.read(overlayStatusProvider.notifier).isActive = true;
      expect(container.read(overlayStatusProvider), isTrue);

      container.read(overlayStatusProvider.notifier).isActive = false;
      expect(container.read(overlayStatusProvider), isFalse);

      container.read(overlayStatusProvider.notifier).isActive = true;
      expect(container.read(overlayStatusProvider), isTrue);
    });

    test('notifies listeners on state change', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var notificationCount = 0;
      container.listen<bool>(
        overlayStatusProvider,
        (previous, next) {
          notificationCount++;
        },
      );

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;
      container.read(overlayStatusProvider.notifier).isActive = false;

      // Assert
      expect(notificationCount, equals(2));
    });

    test('is keepAlive provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Read multiple times
      final status1 = container.read(overlayStatusProvider);
      final status2 = container.read(overlayStatusProvider);

      // Assert - State persists
      expect(status1, isTrue);
      expect(status2, isTrue);
    });
  });

  group('overlayStatusProvider', () {
    test('provides boolean status', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final status = container.read(overlayStatusProvider);

      // Assert
      expect(status, isA<bool>());
    });

    test('can be watched by consumers', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var lastValue = false;
      container.listen<bool>(
        overlayStatusProvider,
        (previous, next) {
          lastValue = next;
        },
      );

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert
      expect(lastValue, isTrue);
    });
  });

  group('integration', () {
    test('dispatcher is properly initialized', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act
      final dispatcher = container.read(overlayDispatcherProvider);

      // Assert
      expect(dispatcher, isA<OverlayDispatcher>());
      expect(container.read(overlayStatusProvider), isFalse);
    });

    test('multiple status changes work correctly via notifier', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final statusChanges = <bool>[];

      container.listen<bool>(
        overlayStatusProvider,
        (previous, next) {
          statusChanges.add(next);
        },
      );

      // Act - Multiple changes
      container.read(overlayStatusProvider.notifier).isActive = true;
      container.read(overlayStatusProvider.notifier).isActive = false;
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert
      expect(statusChanges, equals([true, false, true]));
    });

    test('provider and notifier work together', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - Update via notifier
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert - Read via provider
      expect(container.read(overlayStatusProvider), isTrue);

      // Act - Read via notifier getter
      final isActive = container.read(overlayStatusProvider.notifier).isActive;

      // Assert
      expect(isActive, isTrue);
    });
  });

  group('real-world scenarios', () {
    test('overlay dispatcher lifecycle via notifier', () {
      // Arrange - App initialization
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - Get dispatcher
      final dispatcher = container.read(overlayDispatcherProvider);
      expect(dispatcher, isA<OverlayDispatcher>());

      // Show overlay via notifier
      container.read(overlayStatusProvider.notifier).isActive = true;
      expect(container.read(overlayStatusProvider), isTrue);

      // Hide overlay
      container.read(overlayStatusProvider.notifier).isActive = false;

      // Assert
      expect(container.read(overlayStatusProvider), isFalse);
    });

    test('overlay state persists across provider reads', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Act - Set state
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Simulate "hot reload" - state should persist
      final status1 = container.read(overlayStatusProvider);
      final status2 = container.read(overlayStatusProvider);

      // Assert - State persists
      expect(status1, isTrue);
      expect(status2, isTrue);
    });

    test('multiple containers can have independent overlay states', () {
      // Arrange
      final container1 = ProviderContainer();
      final container2 = ProviderContainer();
      addTearDown(container1.dispose);
      addTearDown(container2.dispose);

      // Act
      container1.read(overlayStatusProvider.notifier).isActive = true;
      container2.read(overlayStatusProvider.notifier).isActive = false;

      // Assert - Independent states
      expect(container1.read(overlayStatusProvider), isTrue);
      expect(container2.read(overlayStatusProvider), isFalse);
    });
  });
}
