import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/public_api/base_modules/animations.dart';
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ShowAs;

void main() {
  group('AnimatedOverlayShell', () {
    group('construction', () {
      testWidgets('creates with required parameters', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine()..initialize(tester);
        const child = Text('Test');

        // Act
        final shell = AnimatedOverlayShell(
          engine: engine,
          child: child,
        );

        // Assert
        expect(shell, isA<AnimatedOverlayShell>());

        engine.dispose();
      });

      testWidgets('creates with Android engine', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        const child = Text('Test');

        // Act
        final shell = AnimatedOverlayShell(
          engine: engine,
          child: child,
        );

        // Assert
        expect(shell, isA<AnimatedOverlayShell>());

        engine.dispose();
      });

      testWidgets('creates with iOS engine', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        const child = Text('Test');

        // Act
        final shell = AnimatedOverlayShell(
          engine: engine,
          child: child,
        );

        // Assert
        expect(shell, isA<AnimatedOverlayShell>());

        engine.dispose();
      });
    });

    group('widget composition', () {
      testWidgets('renders child correctly', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine()..initialize(tester);
        const child = Text('Content');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);
        expect(find.text('Content'), findsOneWidget);

        engine.dispose();
      });

      testWidgets('renders with complex child', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        const child = Text('Nested');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);
        expect(find.text('Nested'), findsOneWidget);

        engine.dispose();
      });
    });

    group('Android engine integration', () {
      testWidgets('banner animation with slide from top', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        final child = Container(
          width: 200,
          height: 50,
          color: Colors.blue,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pump();

        // Assert
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);
        expect(engine.slide, isNotNull);

        engine.dispose();
      });

      testWidgets('dialog animation with slide from bottom', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);
        const child = Card(child: Text('Dialog'));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Dialog'), findsOneWidget);
        expect(engine.opacity.value, equals(1.0));

        engine.dispose();
      });

      testWidgets('snackbar animation with slide', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);
        const child = Text('Snackbar');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Snackbar'), findsOneWidget);
        expect(engine.slide!.value, equals(Offset.zero));

        engine.dispose();
      });
    });

    group('iOS engine integration', () {
      testWidgets('banner animation without slide', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        final child = Container(
          width: 200,
          height: 50,
          color: Colors.green,
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('dialog animation scale only', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);
        const child = Card(child: Text('iOS Dialog'));

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('iOS Dialog'), findsOneWidget);
        expect(engine.scale.value, equals(1.0));

        engine.dispose();
      });
    });

    group('fallback engine integration', () {
      testWidgets('works with no-op fallback engine', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine()..initialize(tester);
        const child = Text('Fallback Content');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pump();

        // Assert
        expect(find.text('Fallback Content'), findsOneWidget);
        expect(engine.opacity.value, equals(1.0));
        expect(engine.scale.value, equals(1.0));

        engine.dispose();
      });
    });

    group('lifecycle', () {
      testWidgets('full animation lifecycle', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        const child = Text('Lifecycle');

        // Act - Build
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        // Act - Play
        engine.play();
        await tester.pumpAndSettle();

        // Assert - Forward complete
        expect(engine.opacity.value, equals(1.0));
        expect(find.text('Lifecycle'), findsOneWidget);

        // Act - Reverse (use fast mode to avoid hanging)
        // ignore: unawaited_futures
        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        // Assert - Reverse initiated
        expect(engine.opacity.value, lessThan(1.0));

        engine.dispose();
      });

      testWidgets('can rebuild with new engine', (tester) async {
        // Arrange
        final engine1 = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        final engine2 = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        const child = Text('Rebuild');

        // Act - Build with first engine
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine1,
                child: child,
              ),
            ),
          ),
        );

        // Assert - First engine
        expect(find.text('Rebuild'), findsOneWidget);

        // Act - Rebuild with second engine
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine2,
                child: child,
              ),
            ),
          ),
        );

        // Assert - Second engine
        expect(find.text('Rebuild'), findsOneWidget);

        engine1.dispose();
        engine2.dispose();
      });
    });

    group('edge cases', () {
      testWidgets('works with complex child widget', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine()..initialize(tester);
        final child = Column(
          children: [
            const Text('Title'),
            Row(
              children: [
                const Icon(Icons.star),
                Container(width: 50, height: 50, color: Colors.red),
              ],
            ),
          ],
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);

        engine.dispose();
      });

      testWidgets('handles empty child', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine()..initialize(tester);
        const child = SizedBox.shrink();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        // Assert
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);

        engine.dispose();
      });
    });

    group('real-world scenarios', () {
      testWidgets('banner notification with Android slide', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);
        final child = Container(
          padding: const EdgeInsets.all(16),
          color: Colors.blue,
          child: const Row(
            children: [
              Icon(Icons.info, color: Colors.white),
              SizedBox(width: 8),
              Text('New message', style: TextStyle(color: Colors.white)),
            ],
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('New message'), findsOneWidget);
        expect(find.byIcon(Icons.info), findsOneWidget);

        engine.dispose();
      });

      testWidgets('iOS dialog with smooth scale', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);
        final child = Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Confirm Action'),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Cancel')),
                    TextButton(onPressed: () {}, child: const Text('OK')),
                  ],
                ),
              ],
            ),
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AnimatedOverlayShell(
                  engine: engine,
                  child: child,
                ),
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Confirm Action'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('OK'), findsOneWidget);

        engine.dispose();
      });

      testWidgets('snackbar with action button', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);
        final child = Container(
          color: Colors.grey[800],
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Item deleted', style: TextStyle(color: Colors.white)),
              TextButton(
                onPressed: () {},
                child: const Text('UNDO', style: TextStyle(color: Colors.blue)),
              ),
            ],
          ),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayShell(
                engine: engine,
                child: child,
              ),
            ),
          ),
        );

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Item deleted'), findsOneWidget);
        expect(find.text('UNDO'), findsOneWidget);

        engine.dispose();
      });
    });
  });
}
