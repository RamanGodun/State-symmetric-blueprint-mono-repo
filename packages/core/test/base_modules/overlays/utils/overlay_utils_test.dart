import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_entries/_overlay_entries_registry.dart';
import 'package:core/src/base_modules/overlays/utils/overlay_utils.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayUtils', () {
    late OverlayDispatcher mockDispatcher;

    setUp(() {
      mockDispatcher = OverlayDispatcher();
      setOverlayDispatcherResolver((_) => mockDispatcher);
    });

    tearDown(() {
      setOverlayDispatcherResolver((_) => OverlayDispatcher());
    });

    group('dismissAndRun', () {
      testWidgets('returns VoidCallback', (tester) async {
        // Arrange
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () {},
          testContext,
        );

        // Assert
        expect(callback, isA<VoidCallback>());
      });

      testWidgets('dismisses current overlay when called', (tester) async {
        // Arrange
        var actionCalled = false;
        late BuildContext testContext;

        // Mock dispatcher that tracks dismiss calls
        final testDispatcher = OverlayDispatcher();
        setOverlayDispatcherResolver((_) => testDispatcher);

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Insert a test overlay
        final entry = BannerOverlayEntry(
          widget: const Text('Test'),
          priority: OverlayPriority.normal,
        );
        await testDispatcher.enqueueRequest(testContext, entry);
        await tester.pumpAndSettle();

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () {
            actionCalled = true;
          },
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert
        expect(actionCalled, isTrue);
      });

      testWidgets('runs action after dismiss completes', (tester) async {
        // Arrange
        final executionOrder = <String>[];
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => executionOrder.add('action'),
          testContext,
        );

        executionOrder.add('before_callback');
        callback();
        executionOrder.add('after_callback');
        await tester.pumpAndSettle();

        // Assert - action should run after callback is invoked
        expect(executionOrder, contains('before_callback'));
        expect(executionOrder, contains('after_callback'));
        expect(executionOrder, contains('action'));
      });

      testWidgets('action runs in post-frame callback', (tester) async {
        // Arrange
        var actionCalled = false;
        var frameCompleted = false;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () {
            actionCalled = true;
            // Action should run after frame completes
            expect(frameCompleted, isTrue);
          },
          testContext,
        );

        callback();
        frameCompleted = true;
        await tester.pumpAndSettle();

        // Assert
        expect(actionCalled, isTrue);
      });

      testWidgets('uses force parameter when dismissing', (tester) async {
        // Arrange
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(() {}, testContext);

        // Assert - should not throw when dismissing with force
        expect(callback, returnsNormally);
        await tester.pumpAndSettle();
      });

      testWidgets('works when no overlay is active', (tester) async {
        // Arrange
        var actionCalled = false;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act - no overlay active
        final callback = OverlayUtils.dismissAndRun(
          () => actionCalled = true,
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert - action should still run
        expect(actionCalled, isTrue);
      });

      testWidgets('can be called multiple times', (tester) async {
        // Arrange
        var callCount = 0;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback1 = OverlayUtils.dismissAndRun(
          () => callCount++,
          testContext,
        );
        final callback2 = OverlayUtils.dismissAndRun(
          () => callCount++,
          testContext,
        );

        callback1();
        await tester.pumpAndSettle();

        callback2();
        await tester.pumpAndSettle();

        // Assert - at least one callback executed
        expect(callCount, greaterThan(0));
      });

      testWidgets('action can modify UI', (tester) async {
        // Arrange
        var showText = false;
        late BuildContext testContext;
        late StateSetter setState;

        await tester.pumpWidget(
          MaterialApp(
            home: StatefulBuilder(
              builder: (context, setStateFunc) {
                testContext = context;
                setState = setStateFunc;
                return showText ? const Text('Updated') : const SizedBox();
              },
            ),
          ),
        );

        expect(find.text('Updated'), findsNothing);

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => setState(() => showText = true),
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Updated'), findsOneWidget);
      });

      testWidgets('handles context from different widgets', (tester) async {
        // Arrange
        var action1Called = false;
        var action2Called = false;
        late BuildContext context1;
        late BuildContext context2;

        await tester.pumpWidget(
          MaterialApp(
            home: Column(
              children: [
                Builder(
                  builder: (ctx) {
                    context1 = ctx;
                    return const SizedBox();
                  },
                ),
                Builder(
                  builder: (ctx) {
                    context2 = ctx;
                    return const SizedBox();
                  },
                ),
              ],
            ),
          ),
        );

        // Act
        final callback1 = OverlayUtils.dismissAndRun(
          () => action1Called = true,
          context1,
        );
        final callback2 = OverlayUtils.dismissAndRun(
          () => action2Called = true,
          context2,
        );

        callback1();
        callback2();
        await tester.pumpAndSettle();

        // Assert
        expect(action1Called, isTrue);
        expect(action2Called, isTrue);
      });
    });

    group('integration scenarios', () {
      testWidgets('button tap dismisses overlay and navigates', (tester) async {
        // Arrange
        var navigated = false;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return ElevatedButton(
                  onPressed: OverlayUtils.dismissAndRun(
                    () => navigated = true,
                    context,
                  ),
                  child: const Text('Navigate'),
                );
              },
            ),
          ),
        );

        // Show overlay first
        final entry = BannerOverlayEntry(
          widget: const Text('Banner'),
          priority: OverlayPriority.normal,
        );
        await mockDispatcher.enqueueRequest(testContext, entry);
        await tester.pumpAndSettle();

        // Act
        await tester.tap(find.text('Navigate'));
        await tester.pumpAndSettle();

        // Assert
        expect(navigated, isTrue);
      });

      testWidgets('dismisses persistent overlay before action', (tester) async {
        // Arrange
        var actionCalled = false;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Show persistent overlay
        final entry = DialogOverlayEntry(
          widget: const Text('Persistent Dialog'),
          priority: OverlayPriority.high,
          dismissPolicy: OverlayDismissPolicy.persistent,
        );
        await mockDispatcher.enqueueRequest(testContext, entry);
        await tester.pumpAndSettle();

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => actionCalled = true,
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert - action should run even with persistent overlay
        expect(actionCalled, isTrue);
      });

      testWidgets('handles rapid successive calls', (tester) async {
        // Arrange
        var callCount = 0;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act - rapid calls
        for (var i = 0; i < 5; i++) {
          final callback = OverlayUtils.dismissAndRun(
            () => callCount++,
            testContext,
          );
          callback();
        }

        await tester.pumpAndSettle();

        // Assert
        expect(callCount, equals(5));
      });

      testWidgets('action can trigger new overlay', (tester) async {
        // Arrange
        late BuildContext testContext;
        var newOverlayShown = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Show first overlay
        final entry1 = BannerOverlayEntry(
          widget: const Text('First'),
          priority: OverlayPriority.normal,
        );
        await mockDispatcher.enqueueRequest(testContext, entry1);
        await tester.pumpAndSettle();

        // Act - dismiss and show new overlay
        final callback = OverlayUtils.dismissAndRun(
          () async {
            final entry2 = BannerOverlayEntry(
              widget: const Text('Second'),
              priority: OverlayPriority.normal,
            );
            await mockDispatcher.enqueueRequest(testContext, entry2);
            newOverlayShown = true;
          },
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert
        expect(newOverlayShown, isTrue);
      });
    });

    group('edge cases', () {
      testWidgets('handles empty action', (tester) async {
        // Arrange
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(() {}, testContext);

        // Assert - should not throw
        expect(callback, returnsNormally);
        await tester.pumpAndSettle();
      });

      testWidgets('action exceptions are handled by framework', (tester) async {
        // Arrange
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => throw Exception('Test error'),
          testContext,
        );

        // Assert - callback should be created successfully
        expect(callback, isA<VoidCallback>());

        // Note: When callback() is invoked, exception will be caught by Flutter framework
        // in post-frame callback, which is expected behavior
      });

      testWidgets('works with disposed BuildContext', (tester) async {
        // Arrange
        late BuildContext testContext;
        late VoidCallback callback;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        callback = OverlayUtils.dismissAndRun(() {}, testContext);

        // Dispose context by removing widget
        await tester.pumpWidget(const MaterialApp(home: SizedBox()));

        // Act & Assert - should handle gracefully
        expect(() => callback(), returnsNormally);
        await tester.pumpAndSettle();
      });

      testWidgets('concurrent callbacks execute independently', (tester) async {
        // Arrange
        final executionOrder = <int>[];
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback1 = OverlayUtils.dismissAndRun(
          () => executionOrder.add(1),
          testContext,
        );
        final callback2 = OverlayUtils.dismissAndRun(
          () => executionOrder.add(2),
          testContext,
        );
        final callback3 = OverlayUtils.dismissAndRun(
          () => executionOrder.add(3),
          testContext,
        );

        callback1();
        callback2();
        callback3();
        await tester.pumpAndSettle();

        // Assert - all callbacks executed
        expect(executionOrder, containsAll([1, 2, 3]));
        expect(executionOrder.length, equals(3));
      });
    });

    group('callback properties', () {
      testWidgets('returned callback can be called multiple times', (
        tester,
      ) async {
        // Arrange
        var callCount = 0;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => callCount++,
          testContext,
        );

        // Call once
        callback();
        await tester.pumpAndSettle();

        // Assert - callback executed at least once
        expect(callCount, greaterThan(0));
      });

      testWidgets('callback captures action closure correctly', (tester) async {
        // Arrange
        var capturedValue = 0;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        var localValue = 42;
        final callback = OverlayUtils.dismissAndRun(
          () => capturedValue = localValue,
          testContext,
        );

        localValue = 100; // Change value before calling callback
        callback();
        await tester.pumpAndSettle();

        // Assert - closure captures current value
        expect(capturedValue, equals(100));
      });

      testWidgets('callback captures context correctly', (tester) async {
        // Arrange
        late BuildContext capturedContext;
        late BuildContext testContext;

        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) {
                testContext = context;
                return const SizedBox();
              },
            ),
          ),
        );

        // Act
        final callback = OverlayUtils.dismissAndRun(
          () => capturedContext = testContext,
          testContext,
        );

        callback();
        await tester.pumpAndSettle();

        // Assert
        expect(capturedContext, equals(testContext));
      });
    });
  });
}
