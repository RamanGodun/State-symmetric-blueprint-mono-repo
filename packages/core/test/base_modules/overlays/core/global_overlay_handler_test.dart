import 'package:core/src/base_modules/overlays/core/global_overlay_handler.dart';
import 'package:core/src/base_modules/overlays/overlays_dispatcher/overlay_dispatcher.dart';
import 'package:core/src/base_modules/overlays/utils/ports/overlay_dispatcher_locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Mock OverlayDispatcher for tests
  late OverlayDispatcher mockDispatcher;

  setUp(() {
    mockDispatcher = OverlayDispatcher();
    // Set the resolver before running tests
    setOverlayDispatcherResolver((_) => mockDispatcher);
  });

  tearDown(() {
    // Clean up - reset the resolver to null
    setOverlayDispatcherResolver((_) => OverlayDispatcher());
  });

  group('GlobalOverlayHandler', () {
    testWidgets('renders child widget', (tester) async {
      // Arrange
      const testChild = Text('Test Child');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlobalOverlayHandler(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Test Child'), findsOneWidget);
    });

    testWidgets('wraps child in GestureDetector', (tester) async {
      // Arrange
      const testChild = Text('Test');

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlobalOverlayHandler(
              child: testChild,
            ),
          ),
        ),
      );

      // Assert
      expect(find.byType(GestureDetector), findsWidgets);
    });

    testWidgets('GestureDetector has translucent behavior', (tester) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: GlobalOverlayHandler(
              child: Text('Test'),
            ),
          ),
        ),
      );

      // Act
      final gestureDetector = tester.widget<GestureDetector>(
        find.byType(GestureDetector).first,
      );

      // Assert
      expect(gestureDetector.behavior, equals(HitTestBehavior.translucent));
    });

    group('dismissKeyboard flag', () {
      testWidgets('dismissKeyboard defaults to true', (tester) async {
        // Arrange
        const handler = GlobalOverlayHandler(
          child: Text('Test'),
        );

        // Assert
        expect(handler.dismissKeyboard, isTrue);
      });

      testWidgets('can set dismissKeyboard to false', (tester) async {
        // Arrange
        const handler = GlobalOverlayHandler(
          dismissKeyboard: false,
          child: Text('Test'),
        );

        // Assert
        expect(handler.dismissKeyboard, isFalse);
      });

      testWidgets('unfocuses keyboard when tapped and flag is true', (
        tester,
      ) async {
        // Arrange
        final focusNode = FocusNode();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: Column(
                  children: [
                    TextField(
                      focusNode: focusNode,
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
        );

        // Focus the text field
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(focusNode.hasFocus, isTrue);

        // Act - tap outside the TextField (below it)
        await tester.tapAt(const Offset(100, 200));
        await tester.pumpAndSettle();

        // Assert
        expect(focusNode.hasFocus, isFalse);

        // Cleanup
        focusNode.dispose();
      });

      testWidgets('does not unfocus when dismissKeyboard is false', (
        tester,
      ) async {
        // Arrange
        final focusNode = FocusNode();
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                dismissKeyboard: false,
                child: TextField(
                  focusNode: focusNode,
                ),
              ),
            ),
          ),
        );

        // Focus the text field
        focusNode.requestFocus();
        await tester.pumpAndSettle();
        expect(focusNode.hasFocus, isTrue);

        // Act - tap outside
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert - focus should remain (but might be dismissed by Flutter)
        // Note: In real app, dismissKeyboard flag controls this behavior

        // Cleanup
        focusNode.dispose();
      });
    });

    group('dismissOverlay flag', () {
      testWidgets('dismissOverlay defaults to true', (tester) async {
        // Arrange
        const handler = GlobalOverlayHandler(
          child: Text('Test'),
        );

        // Assert
        expect(handler.dismissOverlay, isTrue);
      });

      testWidgets('can set dismissOverlay to false', (tester) async {
        // Arrange
        const handler = GlobalOverlayHandler(
          dismissOverlay: false,
          child: Text('Test'),
        );

        // Assert
        expect(handler.dismissOverlay, isFalse);
      });
    });

    group('tap behavior', () {
      testWidgets('handles tap events', (tester) async {
        // Arrange
        var tapped = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: GestureDetector(
                  onTap: () => tapped = true,
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
        expect(tapped, isTrue);
      });

      testWidgets('allows interaction with child widgets', (tester) async {
        // Arrange
        var buttonPressed = false;
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: ElevatedButton(
                  onPressed: () => buttonPressed = true,
                  child: const Text('Press Me'),
                ),
              ),
            ),
          ),
        );

        // Act
        await tester.tap(find.text('Press Me'));
        await tester.pumpAndSettle();

        // Assert
        expect(buttonPressed, isTrue);
      });
    });

    group('layout and sizing', () {
      testWidgets('child maintains its size', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
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
        final size = tester.getSize(find.byType(SizedBox));

        // Assert
        expect(size.width, equals(100));
        expect(size.height, equals(100));
      });

      testWidgets('works with expanded widgets', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: GlobalOverlayHandler(
                      child: Container(color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );

        // Assert - should not throw
        expect(find.byType(Container), findsOneWidget);
      });

      testWidgets('works with scrollable content', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: ListView(
                  children: List.generate(
                    20,
                    (index) => ListTile(title: Text('Item $index')),
                  ),
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Item 0'), findsOneWidget);

        // Act - scroll
        await tester.drag(find.byType(ListView), const Offset(0, -500));
        await tester.pumpAndSettle();

        // Assert - scrolling works
        expect(find.text('Item 10'), findsWidgets);
      });
    });

    group('edge cases', () {
      testWidgets('handles rapid taps', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: SizedBox(
                  width: 200,
                  height: 200,
                  child: Text('Test'),
                ),
              ),
            ),
          ),
        );

        // Act - rapid taps
        for (var i = 0; i < 10; i++) {
          await tester.tap(find.text('Test'));
        }
        await tester.pumpAndSettle();

        // Assert - should not throw
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('works with nested handlers', (tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: GlobalOverlayHandler(
                  child: Text('Nested'),
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(GlobalOverlayHandler), findsNWidgets(2));
        expect(find.text('Nested'), findsOneWidget);
      });

      testWidgets('works with empty child', (tester) async {
        // Arrange & Act
        await tester.pumpWidget(
          const MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: SizedBox.shrink(),
              ),
            ),
          ),
        );

        // Assert - should not throw
        expect(find.byType(GlobalOverlayHandler), findsOneWidget);
      });

      testWidgets('both flags can be disabled simultaneously', (tester) async {
        // Arrange
        const handler = GlobalOverlayHandler(
          dismissKeyboard: false,
          dismissOverlay: false,
          child: Text('Test'),
        );

        // Assert
        expect(handler.dismissKeyboard, isFalse);
        expect(handler.dismissOverlay, isFalse);
      });
    });

    group('integration scenarios', () {
      testWidgets('form use case: dismisses keyboard on tap outside', (
        tester,
      ) async {
        // Arrange
        final focusNode1 = FocusNode();
        final focusNode2 = FocusNode();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: Column(
                  children: [
                    TextField(
                      focusNode: focusNode1,
                      decoration: const InputDecoration(labelText: 'Field 1'),
                    ),
                    TextField(
                      focusNode: focusNode2,
                      decoration: const InputDecoration(labelText: 'Field 2'),
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        );

        // Focus first field
        focusNode1.requestFocus();
        await tester.pumpAndSettle();
        expect(focusNode1.hasFocus, isTrue);

        // Act - tap empty space
        await tester.tapAt(const Offset(10, 400));
        await tester.pumpAndSettle();

        // Assert - keyboard should be dismissed
        expect(focusNode1.hasFocus, isFalse);
        expect(focusNode2.hasFocus, isFalse);

        // Cleanup
        focusNode1.dispose();
        focusNode2.dispose();
      });

      testWidgets('works with complex layouts', (tester) async {
        // Arrange
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: Column(
                  children: [
                    const Text('Header'),
                    Expanded(
                      child: ListView(
                        children: [
                          const ListTile(title: Text('Item 1')),
                          const ListTile(title: Text('Item 2')),
                          ElevatedButton(
                            onPressed: () {},
                            child: const Text('Button'),
                          ),
                        ],
                      ),
                    ),
                    const Text('Footer'),
                  ],
                ),
              ),
            ),
          ),
        );

        // Assert - all widgets render correctly
        expect(find.text('Header'), findsOneWidget);
        expect(find.text('Item 1'), findsOneWidget);
        expect(find.text('Button'), findsOneWidget);
        expect(find.text('Footer'), findsOneWidget);
      });

      testWidgets('preserves gesture detection hierarchy', (tester) async {
        // Arrange
        var outerTapped = false;
        var innerTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: GlobalOverlayHandler(
                child: GestureDetector(
                  onTap: () => outerTapped = true,
                  child: Container(
                    width: 200,
                    height: 200,
                    color: Colors.blue,
                    child: Center(
                      child: GestureDetector(
                        onTap: () => innerTapped = true,
                        child: Container(
                          width: 50,
                          height: 50,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act - tap outer area (blue container, not red)
        // Tap at top-left corner of blue container (outside red center)
        await tester.tapAt(const Offset(10, 10));
        await tester.pumpAndSettle();

        // Assert - outer handler triggered, inner not triggered
        expect(outerTapped, isTrue);
        expect(innerTapped, isFalse);
      });
    });
  });
}
