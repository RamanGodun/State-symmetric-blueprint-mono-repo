import 'package:core/public_api/base_modules/overlays.dart';
import 'package:core/public_api/utils.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mock implementation of OverlayActivityWatcher for testing
class MockOverlayActivityWatcher implements OverlayActivityWatcher {
  final List<void Function({required bool active})> _listeners = [];

  @override
  void Function() subscribe(
    void Function({required bool active}) listener,
  ) {
    _listeners.add(listener);
    return () {
      _listeners.remove(listener);
    };
  }

  void notifyListeners({required bool active}) {
    for (final listener in _listeners) {
      listener(active: active);
    }
  }

  int get listenerCount => _listeners.length;
}

void main() {
  group('SubmitCompletionLockController', () {
    late MockOverlayActivityWatcher mockWatcher;
    late SubmitCompletionLockController controller;

    setUp(() {
      mockWatcher = MockOverlayActivityWatcher();
      controller = SubmitCompletionLockController(
        overlayWatcher: mockWatcher,
      );
    });

    tearDown(() {
      controller.dispose();
    });

    group('initialization', () {
      test('starts unlocked by default', () {
        // Assert
        expect(controller.isLocked, isFalse);
      });

      test('accepts custom fallback duration', () {
        // Arrange
        const customDuration = Duration(milliseconds: 500);

        // Act
        final customController = SubmitCompletionLockController(
          overlayWatcher: mockWatcher,
          fallback: customDuration,
        );

        // Assert
        expect(customController.fallback, equals(customDuration));

        // Cleanup
        customController.dispose();
      });

      test('uses default fallback duration when not specified', () {
        // Assert
        expect(controller.fallback, equals(AppDurations.ms180));
      });
    });

    group('arm', () {
      test('locks the controller when armed', () {
        // Act
        controller.arm();

        // Assert
        expect(controller.isLocked, isTrue);
      });

      test('subscribes to overlay watcher when armed', () {
        // Arrange
        expect(mockWatcher.listenerCount, equals(0));

        // Act
        controller.arm();

        // Assert
        expect(mockWatcher.listenerCount, equals(1));
      });

      test('does nothing if already locked', () {
        // Arrange
        controller.arm();
        expect(controller.isLocked, isTrue);
        final initialListenerCount = mockWatcher.listenerCount;

        // Act
        controller.arm();

        // Assert
        expect(controller.isLocked, isTrue);
        expect(
          mockWatcher.listenerCount,
          equals(initialListenerCount),
        ); // Should not add duplicate
      });

      test('replaces previous overlay subscription when armed again', () async {
        // Arrange
        controller.arm();
        await Future<void>.delayed(const Duration(milliseconds: 10));
        controller.dispose(); // Clean up first subscription

        controller =
            SubmitCompletionLockController(
                overlayWatcher: mockWatcher,
              )
              // Act
              ..arm();

        // Assert
        expect(mockWatcher.listenerCount, equals(1));
      });
    });

    group('unlock on overlay activation', () {
      test('unlocks when overlay becomes active', () {
        // Arrange
        controller.arm();
        expect(controller.isLocked, isTrue);

        // Act
        mockWatcher.notifyListeners(active: true);

        // Assert
        expect(controller.isLocked, isFalse);
      });

      test('does not unlock when overlay becomes inactive', () {
        // Arrange
        controller.arm();
        expect(controller.isLocked, isTrue);

        // Act
        mockWatcher.notifyListeners(active: false);

        // Assert
        expect(controller.isLocked, isTrue);
      });

      test('unsubscribes from overlay watcher after unlock', () {
        // Arrange
        controller.arm();
        expect(mockWatcher.listenerCount, equals(1));

        // Act
        mockWatcher.notifyListeners(active: true);

        // Assert
        expect(mockWatcher.listenerCount, equals(0));
      });

      test('handles multiple activation events gracefully', () {
        // Arrange
        controller.arm();

        // Act
        mockWatcher
          ..notifyListeners(active: true)
          ..notifyListeners(active: true)
          ..notifyListeners(active: true);

        // Assert - should not throw
        expect(controller.isLocked, isFalse);
      });
    });

    group('fallback timeout unlock', () {
      test(
        'unlocks after fallback duration if no overlay activation',
        () async {
          // Arrange
          const shortFallback = Duration(milliseconds: 50);
          final fastController =
              SubmitCompletionLockController(
                  overlayWatcher: mockWatcher,
                  fallback: shortFallback,
                )
                // Act
                ..arm();
          expect(fastController.isLocked, isTrue);

          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Assert
          expect(fastController.isLocked, isFalse);

          // Cleanup
          fastController.dispose();
        },
      );

      test('does not unlock before fallback duration', () async {
        // Arrange
        const longFallback = Duration(milliseconds: 200);
        final slowController =
            SubmitCompletionLockController(
                overlayWatcher: mockWatcher,
                fallback: longFallback,
              )
              // Act
              ..arm();
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(slowController.isLocked, isTrue);

        // Cleanup
        slowController.dispose();
      });

      test('unsubscribes from overlay after fallback timeout', () async {
        // Arrange
        const shortFallback = Duration(milliseconds: 50);
        final fastController = SubmitCompletionLockController(
          overlayWatcher: mockWatcher,
          fallback: shortFallback,
        )..arm();
        expect(mockWatcher.listenerCount, equals(1));

        // Act
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(mockWatcher.listenerCount, equals(0));

        // Cleanup
        fastController.dispose();
      });

      test('overlay activation takes precedence over fallback', () async {
        // Arrange
        const fallback = Duration(milliseconds: 200);
        final testController =
            SubmitCompletionLockController(
                overlayWatcher: mockWatcher,
                fallback: fallback,
              )
              // Act
              ..arm();
        await Future<void>.delayed(const Duration(milliseconds: 50));
        mockWatcher.notifyListeners(active: true);

        // Assert - unlocked immediately, not waiting for fallback
        expect(testController.isLocked, isFalse);

        // Cleanup
        testController.dispose();
      });
    });

    group('dispose', () {
      test('cancels overlay subscription', () {
        // Arrange
        controller.arm();
        expect(mockWatcher.listenerCount, equals(1));

        // Act
        controller.dispose();

        // Assert
        expect(mockWatcher.listenerCount, equals(0));
      });

      test('can be called multiple times safely', () {
        // Arrange
        controller.arm();

        // Act & Assert - should not throw
        expect(() {
          controller
            ..dispose()
            ..dispose()
            ..dispose();
        }, returnsNormally);
      });

      test('can be called when not armed', () {
        // Act & Assert - should not throw
        expect(() => controller.dispose(), returnsNormally);
      });

      test('prevents memory leaks by clearing subscription', () {
        // Arrange
        controller.arm();
        final listenerCountBeforeDispose = mockWatcher.listenerCount;
        expect(listenerCountBeforeDispose, equals(1));

        // Act
        controller.dispose();

        // Assert
        expect(mockWatcher.listenerCount, equals(0));
      });
    });

    group('edge cases', () {
      test('handles rapid arm-unlock cycles', () {
        // Act & Assert - should not throw
        expect(() {
          controller.arm();
          mockWatcher.notifyListeners(active: true);
          controller.arm();
          mockWatcher.notifyListeners(active: true);
          controller.arm();
          mockWatcher.notifyListeners(active: true);
        }, returnsNormally);

        expect(controller.isLocked, isFalse);
      });

      test('isLocked reflects current state accurately', () {
        // Initial state
        expect(controller.isLocked, isFalse);

        // After arm
        controller.arm();
        expect(controller.isLocked, isTrue);

        // After unlock
        mockWatcher.notifyListeners(active: true);
        expect(controller.isLocked, isFalse);
      });

      test('maintains state after overlay deactivation following unlock', () {
        // Arrange
        controller.arm();
        mockWatcher.notifyListeners(active: true);
        expect(controller.isLocked, isFalse);

        // Act
        mockWatcher.notifyListeners(active: false);

        // Assert - should remain unlocked
        expect(controller.isLocked, isFalse);
      });

      test('handles dispose during locked state', () {
        // Arrange
        controller.arm();
        expect(controller.isLocked, isTrue);

        // Act
        controller.dispose();

        // Assert - should not throw and cleanup properly
        expect(mockWatcher.listenerCount, equals(0));
      });

      test('zero fallback duration unlocks immediately', () async {
        // Arrange
        final instantController =
            SubmitCompletionLockController(
                overlayWatcher: mockWatcher,
                fallback: Duration.zero,
              )
              // Act
              ..arm();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(instantController.isLocked, isFalse);

        // Cleanup
        instantController.dispose();
      });

      test(
        'very long fallback duration keeps lock until overlay activation',
        () async {
          // Arrange
          const veryLongFallback = Duration(seconds: 10);
          final longController =
              SubmitCompletionLockController(
                  overlayWatcher: mockWatcher,
                  fallback: veryLongFallback,
                )
                // Act
                ..arm();
          await Future<void>.delayed(const Duration(milliseconds: 100));

          // Assert - still locked
          expect(longController.isLocked, isTrue);

          // Activate overlay
          mockWatcher.notifyListeners(active: true);

          // Assert - unlocked immediately
          expect(longController.isLocked, isFalse);

          // Cleanup
          longController.dispose();
        },
      );
    });

    group('integration scenarios', () {
      test('typical submit flow: arm, overlay shows, unlocks', () {
        // Arrange - simulate form submit starting

        // Act - arm lock after loading completes
        controller.arm();
        expect(controller.isLocked, isTrue);

        // Simulate overlay (success message) appears
        mockWatcher.notifyListeners(active: true);

        // Assert - lock released when overlay shows
        expect(controller.isLocked, isFalse);
      });

      test('fallback scenario: arm, no overlay, timeout unlocks', () async {
        // Arrange
        const shortFallback = Duration(milliseconds: 50);
        final testController =
            SubmitCompletionLockController(
                overlayWatcher: mockWatcher,
                fallback: shortFallback,
              )
              // Act - arm but overlay never activates
              ..arm();
        expect(testController.isLocked, isTrue);

        // Wait for fallback
        await Future<void>.delayed(const Duration(milliseconds: 100));

        // Assert - automatically unlocked
        expect(testController.isLocked, isFalse);

        // Cleanup
        testController.dispose();
      });

      test('cleanup scenario: dispose during active lock', () {
        // Arrange
        controller.arm();
        expect(controller.isLocked, isTrue);
        expect(mockWatcher.listenerCount, equals(1));

        // Act - cleanup (e.g., widget disposed)
        controller.dispose();

        // Assert - resources released
        expect(mockWatcher.listenerCount, equals(0));
      });
    });
  });
}
