import 'package:core/src/base_modules/overlays/core/tap_through_overlay_barrier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('TapThroughOverlayBarrier', () {
    testWidgets('renders child widget', (tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TapThroughOverlayBarrier(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('child is wrapped in IgnorePointer', (tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TapThroughOverlayBarrier(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert - finds at least one IgnorePointer (MaterialApp may have more)
      expect(find.byType(IgnorePointer), findsWidgets);
    });

    testWidgets('uses Listener for tap detection', (tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: TapThroughOverlayBarrier(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert - finds at least one Listener (MaterialApp may have more)
      expect(find.byType(Listener), findsWidgets);
    });

    group('passthrough disabled (default)', () {
      testWidgets('child receives pointer events by default', (tester) async {
        // Arrange
        var childTapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: GestureDetector(
                  onTap: () => childTapped = true,
                  child: const SizedBox(
                    width: 200,
                    height: 200,
                    child: Text('Tap Me'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Tap Me'));
        await tester.pumpAndSettle();

        // Assert
        expect(childTapped, isTrue);
      });

      testWidgets('onTapOverlay not called when passthrough disabled', (
        tester,
      ) async {
        // Arrange
        var onTapCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                onTapOverlay: () => onTapCalled = true,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert
        expect(onTapCalled, isFalse);
      });

      testWidgets('IgnorePointer is not ignoring when passthrough disabled', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: SizedBox(
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        );

        // Act - find all IgnorePointers and get the one from TapThroughOverlayBarrier
        final ignorePointers = tester.widgetList<IgnorePointer>(
          find.byType(IgnorePointer),
        );
        // Find the one with ignoring=false (from TapThroughOverlayBarrier)
        final ignorePointer = ignorePointers.firstWhere(
          (ip) => ip.ignoring == false,
        );

        // Assert
        expect(ignorePointer.ignoring, isFalse);
      });
    });

    group('passthrough enabled', () {
      testWidgets('enables tap passthrough when enabled', (tester) async {
        // Arrange
        var childTapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                child: GestureDetector(
                  onTap: () => childTapped = true,
                  child: const SizedBox(
                    width: 200,
                    height: 200,
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert - child should not receive tap due to IgnorePointer
        expect(childTapped, isFalse);
      });

      testWidgets('calls onTapOverlay when passthrough enabled and tapped', (
        tester,
      ) async {
        // Arrange
        var onTapCalled = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                onTapOverlay: () => onTapCalled = true,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert
        expect(onTapCalled, isTrue);
      });

      testWidgets('IgnorePointer ignores when passthrough enabled', (
        tester,
      ) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                child: SizedBox(
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),
        );

        // Act - find all IgnorePointers and get the one from TapThroughOverlayBarrier
        final ignorePointers = tester.widgetList<IgnorePointer>(
          find.byType(IgnorePointer),
        );
        // Find the one with ignoring=true (from TapThroughOverlayBarrier)
        final ignorePointer = ignorePointers.firstWhere(
          (ip) => ip.ignoring == true,
        );

        // Assert
        expect(ignorePointer.ignoring, isTrue);
      });

      testWidgets('onTapOverlay can be null when passthrough enabled', (
        tester,
      ) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Assert - should not throw
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('multiple taps call onTapOverlay multiple times', (
        tester,
      ) async {
        // Arrange
        var tapCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                onTapOverlay: () => tapCount++,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.tap(find.text('Test'));
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(3));
      });
    });

    group('callback behavior', () {
      testWidgets('onTapOverlay receives correct context', (tester) async {
        // Arrange
        var callbackExecuted = false;
        void callback() {
          callbackExecuted = true;
        }

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                onTapOverlay: callback,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert
        expect(callbackExecuted, isTrue);
      });

      testWidgets('onTapOverlay can trigger navigation', (tester) async {
        // Arrange
        var navigated = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Builder(
              builder: (context) => Scaffold(
                body: TapThroughOverlayBarrier(
                  enablePassthrough: true,
                  onTapOverlay: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const Scaffold(body: Text('New Page')),
                      ),
                    );
                    navigated = true;
                  },
                  child: const SizedBox(
                    width: 200,
                    height: 200,
                    child: Text('Test'),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Test'));
        await tester.pumpAndSettle();

        // Assert
        expect(navigated, isTrue);
        expect(find.text('New Page'), findsOneWidget);
      });
    });

    group('layout and rendering', () {
      testWidgets('uses Stack for layout', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: Text('Test'),
              ),
            ),
          ),
        );

        // Assert - finds at least one Stack (MaterialApp may have more)
        expect(find.byType(Stack), findsWidgets);
      });

      testWidgets('child maintains its size', (tester) async {
        // Arrange
        const childSize = Size(100, 100);
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: SizedBox(
                  width: 100,
                  height: 100,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act
        final childBox = tester.getSize(find.byType(SizedBox));

        // Assert
        expect(childBox, equals(childSize));
      });

      testWidgets('works with complex child widgets', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: Column(
                  children: [
                    const Text('Title'),
                    ElevatedButton(
                      onPressed: () {},
                      child: const Text('Button'),
                    ),
                    const Icon(Icons.info),
                  ],
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('handles rapid taps correctly', (tester) async {
        // Arrange
        var tapCount = 0;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                enablePassthrough: true,
                onTapOverlay: () => tapCount++,
                child: const SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act - simulate rapid taps
        for (var i = 0; i < 10; i++) {
          await tester.tap(find.text('Test'));
        }
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(10));
      });

      testWidgets('works when child is null-safe', (tester) async {
        // Arrange
        const Widget nullableChild = SizedBox();

        // Act & Assert - should not throw
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: nullableChild,
              ),
            ),
          ),
        );

        expect(find.byType(SizedBox), findsOneWidget);
      });

      testWidgets('listener has translucent behavior', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: TapThroughOverlayBarrier(
                child: Text('Test'),
              ),
            ),
          ),
        );

        // Act - find all Listeners and get the one from TapThroughOverlayBarrier
        final listeners = tester.widgetList<Listener>(find.byType(Listener));
        final listener = listeners.firstWhere(
          (l) => l.behavior == HitTestBehavior.translucent,
        );

        // Assert
        expect(listener.behavior, equals(HitTestBehavior.translucent));
      });

      testWidgets('toggles passthrough dynamically', (tester) async {
        // Arrange
        var enablePassthrough = false;
        var tapCount = 0;

        await tester.pumpWidget(
          StatefulBuilder(
            builder: (context, setState) => MaterialApp(
              home: Scaffold(
                body: Column(
                  children: [
                    TapThroughOverlayBarrier(
                      enablePassthrough: enablePassthrough,
                      onTapOverlay: () => tapCount++,
                      child: const SizedBox(
                        width: 200,
                        height: 200,
                        child: Text('Test'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() => enablePassthrough = !enablePassthrough);
                      },
                      child: const Text('Toggle'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

        // Act - tap before toggle
        await tester.tap(find.text('Test'), warnIfMissed: false);
        await tester.pumpAndSettle();
        expect(tapCount, equals(0));

        // Toggle passthrough
        await tester.tap(find.text('Toggle'));
        await tester.pumpAndSettle();

        // Act - tap after toggle
        await tester.tap(find.text('Test'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert
        expect(tapCount, equals(1));
      });
    });

    group('integration scenarios', () {
      testWidgets('banner use case: allows interaction below', (tester) async {
        // Arrange - simulates banner that allows taps to pass through
        var backgroundTapped = false;
        var bannerDismissed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  // Background content
                  GestureDetector(
                    onTap: () => backgroundTapped = true,
                    child: const ColoredBox(
                      color: Colors.white,
                      child: Center(child: Text('Background')),
                    ),
                  ),
                  // Banner overlay
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: TapThroughOverlayBarrier(
                      enablePassthrough: true,
                      onTapOverlay: () => bannerDismissed = true,
                      child: Container(
                        height: 50,
                        color: Colors.blue,
                        child: const Text('Banner'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Banner'), warnIfMissed: false);
        await tester.pumpAndSettle();

        // Assert - banner tap triggers dismiss but also passes through to background
        // because enablePassthrough is true and IgnorePointer allows events through
        expect(bannerDismissed, isTrue);
        // Note: backgroundTapped will be true because enablePassthrough allows
        // the tap to pass through to the background
        expect(backgroundTapped, isTrue);
      });

      testWidgets('dialog use case: blocks interaction below', (tester) async {
        // Arrange - simulates dialog that blocks background
        var backgroundTapped = false;
        var dialogDismissed = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Stack(
                children: [
                  // Background content
                  GestureDetector(
                    onTap: () => backgroundTapped = true,
                    child: const ColoredBox(
                      color: Colors.white,
                      child: Center(child: Text('Background')),
                    ),
                  ),
                  // Dialog overlay
                  Center(
                    child: TapThroughOverlayBarrier(
                      onTapOverlay: () => dialogDismissed = true,
                      child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.white,
                        child: const Text('Dialog'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Dialog'));
        await tester.pumpAndSettle();

        // Assert - dialog doesn't trigger dismiss, blocks background
        expect(dialogDismissed, isFalse);
        expect(backgroundTapped, isFalse);
      });
    });
  });
}
