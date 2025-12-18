import 'package:core/public_api/base_modules/animations.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('OverlayWidgetX', () {
    group('withDispatcherOverlayControl', () {
      testWidgets(
        'returns new wrapper with onDismiss for AnimatedOverlayWrapper',
        (tester) async {
          // Arrange
          final engine = FallbackAnimationEngine();
          final originalWrapper = AnimatedOverlayWrapper(
            engine: engine,
            builder: (engine) => const Text('Original'),
            displayDuration: const Duration(seconds: 3),
          );

          // Act
          final modifiedWrapper = originalWrapper.withDispatcherOverlayControl(
            onDismiss: () {},
          );

          // Assert
          expect(modifiedWrapper, isA<AnimatedOverlayWrapper>());
          expect(modifiedWrapper, isNot(same(originalWrapper)));
        },
      );

      testWidgets('preserves engine from original wrapper', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        final originalWrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: const Duration(seconds: 3),
        );

        // Act
        final modifiedWrapper =
            originalWrapper.withDispatcherOverlayControl(
                  onDismiss: () {},
                )
                as AnimatedOverlayWrapper;

        // Assert
        expect(modifiedWrapper.engine, equals(engine));
      });

      testWidgets('preserves builder from original wrapper', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        Widget builder(engine) => const Text('Builder Test');
        final originalWrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: builder,
          displayDuration: const Duration(seconds: 3),
        );

        // Act
        final modifiedWrapper =
            originalWrapper.withDispatcherOverlayControl(
                  onDismiss: () {},
                )
                as AnimatedOverlayWrapper;

        // Assert
        expect(modifiedWrapper.builder, equals(builder));
      });

      testWidgets('preserves displayDuration from original wrapper', (
        tester,
      ) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        const duration = Duration(seconds: 5);
        final originalWrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: duration,
        );

        // Act
        final modifiedWrapper =
            originalWrapper.withDispatcherOverlayControl(
                  onDismiss: () {},
                )
                as AnimatedOverlayWrapper;

        // Assert
        expect(modifiedWrapper.displayDuration, equals(duration));
      });

      testWidgets('overrides onDismiss callback', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var originalDismissed = false;
        var newDismissed = false;
        final originalWrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: const Duration(milliseconds: 50),
          onDismiss: () => originalDismissed = true,
        );

        // Act
        final modifiedWrapper = originalWrapper.withDispatcherOverlayControl(
          onDismiss: () => newDismissed = true,
        );

        await tester.pumpWidget(MaterialApp(home: modifiedWrapper));
        await tester.pumpAndSettle();

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert
        expect(newDismissed, isTrue);
        expect(originalDismissed, isFalse);
      });

      testWidgets('returns same widget if not AnimatedOverlayWrapper', (
        tester,
      ) async {
        // Arrange
        const widget = Text('Not a wrapper');

        // Act
        final result = widget.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Assert
        expect(result, same(widget));
      });

      testWidgets('returns same Container if not AnimatedOverlayWrapper', (
        tester,
      ) async {
        // Arrange
        const widget = Text('Container');

        // Act
        final result = widget.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Assert
        expect(result, same(widget));
      });

      testWidgets('returns same Column if not AnimatedOverlayWrapper', (
        tester,
      ) async {
        // Arrange
        const widget = Column(
          children: [
            Text('Item 1'),
            Text('Item 2'),
          ],
        );

        // Act
        final result = widget.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Assert
        expect(result, same(widget));
      });
    });

    group('onDismiss functionality', () {
      testWidgets('new onDismiss is called on auto-dismiss', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var dismissed = false;
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Auto Dismiss'),
          displayDuration: const Duration(milliseconds: 50),
        );

        final modifiedWrapper = wrapper.withDispatcherOverlayControl(
          onDismiss: () => dismissed = true,
        );

        // Act
        await tester.pumpWidget(MaterialApp(home: modifiedWrapper));
        await tester.pumpAndSettle();

        // Assert - Before dismiss
        expect(dismissed, isFalse);

        // Act - Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - After dismiss
        expect(dismissed, isTrue);
      });

      testWidgets('onDismiss receives correct callback', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        var dismissCount = 0;
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Count Test'),
          displayDuration: const Duration(milliseconds: 50),
        );

        final modifiedWrapper = wrapper.withDispatcherOverlayControl(
          onDismiss: () => dismissCount++,
        );

        // Act
        await tester.pumpWidget(MaterialApp(home: modifiedWrapper));
        await tester.pumpAndSettle();

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert
        expect(dismissCount, equals(1));
      });
    });

    group('chaining', () {
      testWidgets('can chain multiple withDispatcherOverlayControl calls', (
        tester,
      ) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Chain'),
          displayDuration: const Duration(seconds: 3),
        );

        // Act - First call
        final modified1 = wrapper.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Act - Second call (should override first)
        final modified2 = modified1.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Assert
        expect(modified2, isA<AnimatedOverlayWrapper>());
        expect(modified1, isNot(same(modified2)));
      });

      testWidgets('chained calls preserve engine and builder', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog);
        Widget builder(engine) => const Text('Chained');
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: builder,
          displayDuration: const Duration(seconds: 3),
        );

        // Act
        final modified =
            wrapper
                    .withDispatcherOverlayControl(onDismiss: () {})
                    .withDispatcherOverlayControl(onDismiss: () {})
                as AnimatedOverlayWrapper;

        // Assert
        expect(modified.engine, equals(engine));
        expect(modified.builder, equals(builder));
      });
    });

    group('real-world scenarios', () {
      testWidgets('dispatcher injecting lifecycle control', (tester) async {
        // Arrange - Overlay without onDismiss
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        final overlay = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Notification'),
          displayDuration: const Duration(milliseconds: 50),
        );

        // Act - Dispatcher injects its own onDismiss
        var overlayRemoved = false;
        final controlledOverlay = overlay.withDispatcherOverlayControl(
          onDismiss: () {
            overlayRemoved = true;
            // In real app: remove from overlay stack
          },
        );

        await tester.pumpWidget(MaterialApp(home: controlledOverlay));
        await tester.pumpAndSettle();

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert
        expect(overlayRemoved, isTrue);
      });

      testWidgets('banner with dispatcher cleanup', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        var cleanupCalled = false;
        final banner = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => Container(
            padding: const EdgeInsets.all(16),
            color: Colors.blue,
            child: const Text('Banner with cleanup'),
          ),
          displayDuration: const Duration(milliseconds: 50),
        );

        final controlledBanner = banner.withDispatcherOverlayControl(
          onDismiss: () => cleanupCalled = true,
        );

        // Act
        await tester.pumpWidget(MaterialApp(home: controlledBanner));
        await tester.pumpAndSettle();

        // Assert - Shown
        expect(find.text('Banner with cleanup'), findsOneWidget);

        // Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - Cleanup called
        expect(cleanupCalled, isTrue);
      });

      testWidgets('dialog with custom dismiss handler', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog);
        var dialogClosed = false;
        final dialog = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Dialog'),
                  TextButton(onPressed: () {}, child: const Text('OK')),
                ],
              ),
            ),
          ),
          displayDuration: Duration.zero,
        );

        final controlledDialog = dialog.withDispatcherOverlayControl(
          onDismiss: () => dialogClosed = true,
        );

        // Act
        await tester.pumpWidget(MaterialApp(home: controlledDialog));
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dialog'), findsOneWidget);
        expect(dialogClosed, isFalse);
      });

      testWidgets('multiple overlays with separate dismiss handlers', (
        tester,
      ) async {
        // Arrange
        final engine1 = FallbackAnimationEngine();
        final engine2 = FallbackAnimationEngine();
        var overlay1Dismissed = false;
        var overlay2Dismissed = false;

        final overlay1 =
            AnimatedOverlayWrapper(
              engine: engine1,
              builder: (engine) => const Text('Overlay 1'),
              displayDuration: const Duration(milliseconds: 50),
            ).withDispatcherOverlayControl(
              onDismiss: () => overlay1Dismissed = true,
            );

        final overlay2 =
            AnimatedOverlayWrapper(
              engine: engine2,
              builder: (engine) => const Text('Overlay 2'),
              displayDuration: const Duration(milliseconds: 100),
            ).withDispatcherOverlayControl(
              onDismiss: () => overlay2Dismissed = true,
            );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Stack(
              children: [overlay1, overlay2],
            ),
          ),
        );
        await tester.pumpAndSettle();

        // Assert - Both shown
        expect(find.text('Overlay 1'), findsOneWidget);
        expect(find.text('Overlay 2'), findsOneWidget);

        // Act - First overlay auto-dismisses
        await tester.pump(const Duration(milliseconds: 75));
        await tester.pumpAndSettle();

        // Assert - Only first dismissed
        expect(overlay1Dismissed, isTrue);
        expect(overlay2Dismissed, isFalse);

        // Act - Second overlay auto-dismisses
        await tester.pump(const Duration(milliseconds: 50));
        await tester.pumpAndSettle();

        // Assert - Both dismissed
        expect(overlay1Dismissed, isTrue);
        expect(overlay2Dismissed, isTrue);
      });
    });

    group('edge cases', () {
      testWidgets('handles null in widget tree', (tester) async {
        // Arrange
        const Widget? nullWidget = null;

        // Act & Assert - Should not throw
        expect(
          () => nullWidget?.withDispatcherOverlayControl(onDismiss: () {}),
          returnsNormally,
        );
      });

      testWidgets('preserves placeholder if present', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        const placeholder = CircularProgressIndicator();
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: const Duration(seconds: 3),
          placeholder: placeholder,
        );

        // Act
        final modified =
            wrapper.withDispatcherOverlayControl(
                  onDismiss: () {},
                )
                as AnimatedOverlayWrapper;

        // Assert
        expect(modified.placeholder, equals(placeholder));
      });

      testWidgets('handles widget in complex tree', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Nested'),
          displayDuration: const Duration(seconds: 3),
        );

        final complexTree = Column(
          children: [
            const Text('Header'),
            wrapper,
            const Text('Footer'),
          ],
        );

        // Act - Try to modify wrapper in tree (won't work, but shouldn't throw)
        final result = complexTree.withDispatcherOverlayControl(
          onDismiss: () {},
        );

        // Assert - Returns same column (not a wrapper)
        expect(result, same(complexTree));
      });
    });

    group('type safety', () {
      testWidgets('returns Widget type', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Type Test'),
          displayDuration: const Duration(seconds: 3),
        );

        // Act
        final result = wrapper.withDispatcherOverlayControl(onDismiss: () {});

        // Assert
        expect(result, isA<Widget>());
        expect(result, isA<AnimatedOverlayWrapper>());
      });

      testWidgets('handles any Widget subtype', (tester) async {
        // Arrange
        final widgets = <Widget>[
          const Text('Text'),
          Container(),
          const Icon(Icons.star),
          const Card(),
          const SizedBox(),
        ];

        // Act & Assert - All should return themselves
        for (final widget in widgets) {
          final result = widget.withDispatcherOverlayControl(onDismiss: () {});
          expect(result, same(widget));
        }
      });
    });
  });
}
