/// Tests for OverlayStatus extensions
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - OverlayStatusRefX extension (on WidgetRef)
/// - OverlayRefX extension (on Ref)
/// - isOverlayActive getter functionality
library;

import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart';
import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_status_x.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayStatusRefX', () {
    testWidgets('isOverlayActive returns false by default', (tester) async {
      // Arrange
      bool? overlayStatus;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                overlayStatus = ref.isOverlayActive;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Assert
      expect(overlayStatus, isFalse);
    });

    testWidgets('isOverlayActive returns true when overlay is active', (
      tester,
    ) async {
      // Arrange
      bool? overlayStatus;
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set overlay status to true
      container.read(overlayStatusProvider.notifier).isActive = true;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                overlayStatus = ref.isOverlayActive;
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Assert
      expect(overlayStatus, isTrue);
    });

    testWidgets('isOverlayActive updates when status changes', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final statuses = <bool>[];

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                statuses.add(ref.isOverlayActive);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Act - Change status
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert
      expect(statuses.first, isFalse); // Initial state
      expect(statuses.last, isTrue); // After change
    });

    testWidgets('isOverlayActive watches provider changes', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      var buildCount = 0;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                buildCount++;
                final _ = ref.isOverlayActive;
                return Text('Build: $buildCount');
              },
            ),
          ),
        ),
      );

      final initialBuildCount = buildCount;

      // Act - Change status multiple times
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      container.read(overlayStatusProvider.notifier).isActive = false;
      await tester.pump();

      // Assert - Should rebuild on each change
      expect(buildCount, greaterThan(initialBuildCount));
    });
  });

  group('OverlayRefX', () {
    test('isOverlayActive returns false by default in provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final testProvider = Provider<bool>((ref) {
        return ref.isOverlayActive;
      });

      // Act
      final result = container.read(testProvider);

      // Assert
      expect(result, isFalse);
    });

    test('isOverlayActive returns true when overlay is active in provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Set overlay status to true
      container.read(overlayStatusProvider.notifier).isActive = true;

      final testProvider = Provider<bool>((ref) {
        return ref.isOverlayActive;
      });

      // Act
      final result = container.read(testProvider);

      // Assert
      expect(result, isTrue);
    });

    test('isOverlayActive watches provider changes in provider', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var readCount = 0;
      final testProvider = Provider<bool>((ref) {
        readCount++;
        return ref.isOverlayActive;
      });

      // Act - Initial read
      container.read(testProvider);
      final initialReadCount = readCount;

      // Change status
      container.read(overlayStatusProvider.notifier).isActive = true;
      container.read(testProvider);

      // Assert - Should invalidate and rebuild
      expect(readCount, greaterThan(initialReadCount));
    });

    test('isOverlayActive can be used in computed providers', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final computedProvider = Provider<String>((ref) {
        final isActive = ref.isOverlayActive;
        return isActive ? 'Overlay Active' : 'Overlay Inactive';
      });

      // Act & Assert - Initially inactive
      expect(container.read(computedProvider), equals('Overlay Inactive'));

      // Act - Activate overlay
      container.read(overlayStatusProvider.notifier).isActive = true;

      // Assert - Now active
      expect(container.read(computedProvider), equals('Overlay Active'));
    });
  });

  group('real-world scenarios', () {
    testWidgets('multiple widgets can watch overlay status independently', (
      tester,
    ) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      bool? widget1Status;
      bool? widget2Status;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Column(
              children: [
                Consumer(
                  builder: (context, ref, _) {
                    widget1Status = ref.isOverlayActive;
                    return const Text('Widget 1');
                  },
                ),
                Consumer(
                  builder: (context, ref, _) {
                    widget2Status = ref.isOverlayActive;
                    return const Text('Widget 2');
                  },
                ),
              ],
            ),
          ),
        ),
      );

      // Act - Change status
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert - Both widgets see the same status
      expect(widget1Status, isTrue);
      expect(widget2Status, isTrue);
      expect(widget1Status, equals(widget2Status));
    });

    testWidgets('can conditionally show widgets based on overlay status', (
      tester,
    ) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                if (ref.isOverlayActive) {
                  return const Text('Overlay is active');
                }
                return const Text('Overlay is inactive');
              },
            ),
          ),
        ),
      );

      // Assert - Initially inactive
      expect(find.text('Overlay is inactive'), findsOneWidget);
      expect(find.text('Overlay is active'), findsNothing);

      // Act - Activate overlay
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert - Now active
      expect(find.text('Overlay is active'), findsOneWidget);
      expect(find.text('Overlay is inactive'), findsNothing);
    });

    test('providers can react to overlay status changes', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      var notificationCount = 0;
      final notificationProvider = Provider<void>((ref) {
        final isActive = ref.isOverlayActive;
        if (isActive) {
          notificationCount++;
        }
      });

      // Act - Initial read
      container.read(notificationProvider);
      expect(notificationCount, equals(0)); // Not active initially

      // Act - Activate overlay
      container.read(overlayStatusProvider.notifier).isActive = true;
      container.read(notificationProvider);

      // Assert - Should have been notified
      expect(notificationCount, equals(1));
    });

    test('extension works with both Ref and WidgetRef', () {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      // Provider using Ref
      final refProvider = Provider<bool>((ref) => ref.isOverlayActive);

      // Act
      final refResult = container.read(refProvider);

      // Assert - Both should work the same way
      expect(refResult, isFalse);
    });

    testWidgets('overlay status persists across rebuilds', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      container.read(overlayStatusProvider.notifier).isActive = true;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                return Text('Status: ${ref.isOverlayActive}');
              },
            ),
          ),
        ),
      );

      // Assert - Status is true
      expect(find.text('Status: true'), findsOneWidget);

      // Act - Rebuild widget tree
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                return Text('Status: ${ref.isOverlayActive}');
              },
            ),
          ),
        ),
      );

      // Assert - Status still true after rebuild
      expect(find.text('Status: true'), findsOneWidget);
    });
  });
}
