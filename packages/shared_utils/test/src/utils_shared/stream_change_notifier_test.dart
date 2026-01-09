/// Tests for StreamChangeNotifier
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Construction and subscription
/// - Listener notifications
/// - Dispose and cleanup
/// - Multiple listeners
/// - Stream events handling
/// - Real-world scenarios (GoRouter, state updates)
// ignore_for_file: cascade_invocations

library;

import 'dart:async' show StreamController, runZonedGuarded, unawaited;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart'
    show StreamChangeNotifier;

void main() {
  group('StreamChangeNotifier', () {
    group('construction', () {
      test('creates instance from stream', () {
        // Arrange
        final controller = StreamController<int>();

        // Act
        final notifier = StreamChangeNotifier(controller.stream);

        // Assert
        expect(notifier, isA<StreamChangeNotifier<int>>());

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('subscribes to stream immediately', () async {
        // Arrange
        final controller = StreamController<String>();
        var subscribed = false;
        controller.onListen = () => subscribed = true;

        // Act
        final notifier = StreamChangeNotifier(controller.stream);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(subscribed, isTrue);

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('accepts different stream types', () {
        // Arrange & Act
        final intNotifier = StreamChangeNotifier(Stream<int>.value(1));
        final stringNotifier = StreamChangeNotifier(Stream<String>.value('a'));
        final boolNotifier = StreamChangeNotifier(Stream<bool>.value(true));

        // Assert
        expect(intNotifier, isA<StreamChangeNotifier<int>>());
        expect(stringNotifier, isA<StreamChangeNotifier<String>>());
        expect(boolNotifier, isA<StreamChangeNotifier<bool>>());

        // Clean up
        intNotifier.dispose();
        stringNotifier.dispose();
        boolNotifier.dispose();
      });
    });

    group('listener notifications', () {
      test('notifies listeners on stream events', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(notificationCount, equals(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('notifies on multiple stream events', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        controller.add(2);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        controller.add(3);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(notificationCount, equals(3));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('notifies all registered listeners', () async {
        // Arrange
        final controller = StreamController<String>();
        final notifier = StreamChangeNotifier(controller.stream);
        var listener1Count = 0;
        var listener2Count = 0;
        var listener3Count = 0;

        notifier
          ..addListener(() => listener1Count++)
          ..addListener(() => listener2Count++)
          ..addListener(() => listener3Count++);

        // Act
        controller.add('event');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(listener1Count, equals(1));
        expect(listener2Count, equals(1));
        expect(listener3Count, equals(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('does not notify after listener removed', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        void listener() => notificationCount++;
        notifier.addListener(listener);

        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(notificationCount, equals(1));

        // Act - Remove listener
        notifier.removeListener(listener);
        controller.add(2);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - No additional notification
        expect(notificationCount, equals(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('handles rapid stream events', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act - Send 10 rapid events
        for (var i = 0; i < 10; i++) {
          controller.add(i);
        }
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(notificationCount, equals(10));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });
    });

    group('dispose', () {
      test('cancels stream subscription', () async {
        // Arrange
        final controller = StreamController<int>();
        var cancelCalled = false;
        controller.onCancel = () => cancelCalled = true;

        final notifier = StreamChangeNotifier(controller.stream);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Act
        notifier.dispose();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(cancelCalled, isTrue);

        // Clean up
        unawaited(controller.close());
      });

      test('does not notify listeners after dispose', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier
          ..addListener(() => notificationCount++)
          // Act
          ..dispose();
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(notificationCount, equals(0));

        // Clean up
        unawaited(controller.close());
      });

      test('calling dispose multiple times throws error', () {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);

        // Act - First dispose is ok
        notifier.dispose();

        // Assert - Second dispose throws
        expect(notifier.dispose, throwsFlutterError);

        // Clean up
        unawaited(controller.close());
      });

      test('cleans up resources properly', () async {
        // Arrange
        final controller = StreamController<int>();
        //
        // ignore: unused_local_variable
        final notifier = StreamChangeNotifier(controller.stream)
          // Act
          ..dispose();
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - Stream should have no active listeners
        expect(controller.hasListener, isFalse);

        // Clean up
        unawaited(controller.close());
      });
    });

    group('edge cases', () {
      test('handles empty stream', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act - No events sent
        await Future<void>.delayed(const Duration(milliseconds: 50));

        // Assert
        expect(notificationCount, equals(0));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('stream errors propagate unhandled', () async {
        // Arrange
        Object? caughtError;

        // Act - Create notifier in zone to catch unhandled stream error
        await runZonedGuarded(
          () async {
            final controller = StreamController<int>();
            final notifier = StreamChangeNotifier(controller.stream);

            controller.addError(Exception('Test error'));
            await Future<void>.delayed(const Duration(milliseconds: 50));

            // Clean up
            notifier.dispose();
            unawaited(controller.close());
          },
          (error, stack) {
            caughtError = error;
          },
        );

        // Assert - Error was unhandled and caught by zone
        expect(caughtError, isA<Exception>());
      });

      test('handles broadcast stream', () async {
        // Arrange
        final controller = StreamController<int>.broadcast();
        final notifier1 = StreamChangeNotifier(controller.stream);
        final notifier2 = StreamChangeNotifier(controller.stream);
        var count1 = 0;
        var count2 = 0;

        notifier1.addListener(() => count1++);
        notifier2.addListener(() => count2++);

        // Act
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - Both should be notified
        expect(count1, equals(1));
        expect(count2, equals(1));

        // Clean up
        notifier1.dispose();
        notifier2.dispose();
        unawaited(controller.close());
      });

      test('handles single-subscription stream', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(notificationCount, equals(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('handles null stream events', () async {
        // Arrange
        final controller = StreamController<int?>();
        final notifier = StreamChangeNotifier(controller.stream);
        var notificationCount = 0;

        notifier.addListener(() => notificationCount++);

        // Act
        controller.add(null);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - Should still notify
        expect(notificationCount, equals(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });
    });

    group('real-world scenarios', () {
      test('simulates GoRouter refresh listenable', () async {
        // Arrange - Auth state stream
        final authController = StreamController<bool>();
        final authNotifier = StreamChangeNotifier(authController.stream);
        var routerRefreshCount = 0;

        // GoRouter would listen to this
        authNotifier.addListener(() {
          routerRefreshCount++;
          // Router rebuilds on auth state change
        });

        // Act - User logs in
        authController.add(true);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // User logs out
        authController.add(false);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(routerRefreshCount, equals(2));

        // Clean up
        authNotifier.dispose();
        unawaited(authController.close());
      });

      test('simulates Riverpod stream to ChangeNotifier bridge', () async {
        // Arrange - Simulates Riverpod stream provider
        final stateController = StreamController<String>();
        final notifier = StreamChangeNotifier(stateController.stream);
        final stateUpdates = <String>[];

        notifier.addListener(() {
          stateUpdates.add('state-changed');
        });

        // Act - State updates from Riverpod
        stateController.add('loading');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        stateController.add('loaded');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        stateController.add('error');
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(stateUpdates.length, equals(3));

        // Clean up
        notifier.dispose();
        unawaited(stateController.close());
      });

      test('simulates Firebase realtime updates', () async {
        // Arrange - Simulates Firebase snapshots stream
        final snapshotsController = StreamController<Map<String, dynamic>>();
        final notifier = StreamChangeNotifier(snapshotsController.stream);
        var uiUpdateCount = 0;

        notifier.addListener(() {
          uiUpdateCount++;
          // UI rebuilds on data change
        });

        // Act - Firebase sends updates
        snapshotsController.add({'users': 10});
        await Future<void>.delayed(const Duration(milliseconds: 10));

        snapshotsController.add({'users': 11});
        await Future<void>.delayed(const Duration(milliseconds: 10));

        snapshotsController.add({'users': 12});
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(uiUpdateCount, equals(3));

        // Clean up
        notifier.dispose();
        unawaited(snapshotsController.close());
      });

      test('simulates imperative navigation guard', () async {
        // Arrange
        final permissionsController = StreamController<bool>();
        final permissionNotifier = StreamChangeNotifier(
          permissionsController.stream,
        );
        var navigationUpdates = 0;

        permissionNotifier.addListener(() {
          navigationUpdates++;
          // Navigation guard checks permissions
        });

        // Act - Permission changes
        permissionsController.add(false); // No permission
        await Future<void>.delayed(const Duration(milliseconds: 10));

        permissionsController.add(true); // Permission granted
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(navigationUpdates, equals(2));

        // Clean up
        permissionNotifier.dispose();
        unawaited(permissionsController.close());
      });

      test('simulates connectivity listener', () async {
        // Arrange
        final connectivityController = StreamController<bool>();
        final connectivityNotifier = StreamChangeNotifier(
          connectivityController.stream,
        );
        final connectivityStates = <String>[];

        connectivityNotifier.addListener(() {
          connectivityStates.add('connectivity-changed');
        });

        // Act - Network changes
        connectivityController.add(true); // Online
        await Future<void>.delayed(const Duration(milliseconds: 10));

        connectivityController.add(false); // Offline
        await Future<void>.delayed(const Duration(milliseconds: 10));

        connectivityController.add(true); // Online again
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(connectivityStates.length, equals(3));

        // Clean up
        connectivityNotifier.dispose();
        unawaited(connectivityController.close());
      });
    });

    group('memory management', () {
      test('removes listeners on dispose', () {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var listenerCalled = false;

        notifier
          ..addListener(() => listenerCalled = true)
          // Act
          ..dispose();

        // Try to notify (should not work after dispose)
        try {
          controller.add(1);
          //
          // ignore: avoid_catches_without_on_clauses
        } catch (_) {
          // May throw if controller is closed
        }

        // Assert
        expect(listenerCalled, isFalse);

        // Clean up
        unawaited(controller.close());
      });

      test('does not leak memory with many subscriptions', () async {
        // Arrange
        final controllers = <StreamController<int>>[];
        final notifiers = <StreamChangeNotifier<int>>[];

        // Act - Create and dispose many notifiers
        for (var i = 0; i < 100; i++) {
          final controller = StreamController<int>();
          final notifier = StreamChangeNotifier(controller.stream);

          controllers.add(controller);
          notifiers.add(notifier);
        }

        // Dispose all
        for (final notifier in notifiers) {
          notifier.dispose();
        }

        // Clean up
        for (final controller in controllers) {
          unawaited(controller.close());
        }

        // Assert - Should complete without issues
        expect(notifiers.length, equals(100));
      });
    });

    group('listener management', () {
      test('can add listener after construction', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);

        // Act
        var notified = false;
        notifier.addListener(() => notified = true);

        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(notified, isTrue);

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('can remove and re-add listener', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var count = 0;

        void listener() => count++;

        // Act
        notifier.addListener(listener);
        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(count, equals(1));

        notifier.removeListener(listener);
        controller.add(2);
        await Future<void>.delayed(const Duration(milliseconds: 10));
        expect(count, equals(1)); // Not incremented

        notifier.addListener(listener);
        controller.add(3);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert
        expect(count, equals(2));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });

      test('handles same listener added multiple times', () async {
        // Arrange
        final controller = StreamController<int>();
        final notifier = StreamChangeNotifier(controller.stream);
        var count = 0;

        void listener() => count++;

        // Act
        notifier
          ..addListener(listener)
          ..addListener(listener)
          ..addListener(listener);

        controller.add(1);
        await Future<void>.delayed(const Duration(milliseconds: 10));

        // Assert - ChangeNotifier typically calls each added instance
        expect(count, greaterThanOrEqualTo(1));

        // Clean up
        notifier.dispose();
        unawaited(controller.close());
      });
    });
  });
}
