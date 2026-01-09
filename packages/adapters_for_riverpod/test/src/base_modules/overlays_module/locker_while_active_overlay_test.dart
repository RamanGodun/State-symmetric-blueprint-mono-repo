/// Tests for RiverpodOverlayWatcher
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - RiverpodOverlayWatcher initialization
/// - subscribe method functionality
/// - Integration with overlayStatusProvider
/// - Cancel subscription mechanism
library;

import 'package:adapters_for_riverpod/src/base_modules/overlays_module/locker_while_active_overlay.dart';
import 'package:adapters_for_riverpod/src/base_modules/overlays_module/overlay_adapters_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RiverpodOverlayWatcher', () {
    testWidgets('creates instance with WidgetRef', (tester) async {
      // Arrange
      RiverpodOverlayWatcher? watcher;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                watcher = RiverpodOverlayWatcher(ref);
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Assert
      expect(watcher, isNotNull);
      expect(watcher, isA<RiverpodOverlayWatcher>());
    });

    testWidgets('subscribe calls onChange when overlay status changes', (
      tester,
    ) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      var callCount = 0;
      bool? lastValue;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                RiverpodOverlayWatcher(ref)
                // Subscribe to changes
                .subscribe(({required bool active}) {
                  callCount++;
                  lastValue = active;
                });

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Act - Change overlay status
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert
      expect(callCount, equals(1));
      expect(lastValue, isTrue);
    });

    testWidgets(
      'subscribe with fireImmediately false does not call onChange initially',
      (tester) async {
        // Arrange
        final container = ProviderContainer();
        addTearDown(container.dispose);
        var callCount = 0;

        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: MaterialApp(
              home: Consumer(
                builder: (context, ref, _) {
                  RiverpodOverlayWatcher(ref).subscribe(({
                    required bool active,
                  }) {
                    callCount++;
                  });

                  return const SizedBox.shrink();
                },
              ),
            ),
          ),
        );

        // Assert - Should not have been called immediately
        expect(callCount, equals(0));
      },
    );

    testWidgets('subscribe returns cancel function', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                final watcher = RiverpodOverlayWatcher(ref);

                final cancel = watcher.subscribe(({required bool active}) {});

                // Assert
                expect(cancel, isA<void Function()>());

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('cancel stops receiving updates', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      var callCount = 0;
      void Function()? cancel;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                final watcher = RiverpodOverlayWatcher(ref);

                cancel = watcher.subscribe(({required bool active}) {
                  callCount++;
                });

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Act - First change
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      expect(callCount, equals(1));

      // Cancel subscription
      cancel?.call();

      // Act - Second change (should not trigger callback)
      container.read(overlayStatusProvider.notifier).isActive = false;
      await tester.pump();

      // Assert - Count should not increase after cancel
      expect(callCount, equals(1));
    });

    testWidgets('multiple subscriptions can coexist', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      var callCount1 = 0;
      var callCount2 = 0;

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                RiverpodOverlayWatcher(ref)
                  ..subscribe(({required bool active}) {
                    callCount1++;
                  })
                  ..subscribe(({required bool active}) {
                    callCount2++;
                  });

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Act
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert - Both callbacks should be called
      expect(callCount1, equals(1));
      expect(callCount2, equals(1));
    });

    testWidgets('onChange receives correct active values', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);
      final receivedValues = <bool>[];

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                RiverpodOverlayWatcher(ref).subscribe(({required bool active}) {
                  receivedValues.add(active);
                });

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      // Act - Multiple changes
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      container.read(overlayStatusProvider.notifier).isActive = false;
      await tester.pump();

      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert
      expect(receivedValues, equals([true, false, true]));
    });

    testWidgets('works with SubmitCompletionLockController pattern', (
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
                // Watch overlay status to rebuild when it changes
                final isLocked = ref.watch(overlayStatusProvider);

                return Text('Locked: $isLocked');
              },
            ),
          ),
        ),
      );

      // Assert - Initially unlocked
      expect(find.text('Locked: false'), findsOneWidget);

      // Act - Activate overlay (lock)
      container.read(overlayStatusProvider.notifier).isActive = true;
      await tester.pump();

      // Assert - Now locked
      expect(find.text('Locked: true'), findsOneWidget);
    });

    testWidgets('can create multiple watchers', (tester) async {
      // Arrange
      final container = ProviderContainer();
      addTearDown(container.dispose);

      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                final watcher1 = RiverpodOverlayWatcher(ref);
                final watcher2 = RiverpodOverlayWatcher(ref);

                // Assert - Different instances
                expect(identical(watcher1, watcher2), isFalse);
                expect(watcher1, isA<RiverpodOverlayWatcher>());
                expect(watcher2, isA<RiverpodOverlayWatcher>());

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });

    testWidgets('ref is accessible', (tester) async {
      // Arrange
      WidgetRef? capturedRef;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Consumer(
              builder: (context, ref, _) {
                capturedRef = ref;
                final watcher = RiverpodOverlayWatcher(ref);

                // Assert
                expect(watcher.ref, equals(capturedRef));

                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );
    });
  });
}
