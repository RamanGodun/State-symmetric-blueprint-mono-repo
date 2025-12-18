import 'package:core/public_api/base_modules/animations.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AnimatedOverlayWrapper', () {
    group('construction', () {
      testWidgets('creates with required parameters', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: const Duration(seconds: 3),
        );

        // Assert
        expect(wrapper, isA<AnimatedOverlayWrapper>());
      });

      testWidgets('creates with optional onDismiss', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var dismissed = false;

        // Act
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Test'),
          displayDuration: const Duration(seconds: 3),
          onDismiss: () => dismissed = true,
        );

        // Assert
        expect(wrapper, isA<AnimatedOverlayWrapper>());
        expect(dismissed, isFalse);
      });

      testWidgets('creates with optional placeholder', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        final wrapper = AnimatedOverlayWrapper(
          engine: engine,
          builder: (engine) => const Text('Content'),
          displayDuration: const Duration(seconds: 3),
          placeholder: const CircularProgressIndicator(),
        );

        // Assert
        expect(wrapper, isA<AnimatedOverlayWrapper>());
      });
    });

    group('initialization', () {
      testWidgets('initializes engine on mount', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Test'),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
      });

      testWidgets('plays animation automatically', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Auto Play'),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(1.0));
        expect(find.text('Auto Play'), findsOneWidget);
      });

      testWidgets('shows placeholder until initialized', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Content'),
                displayDuration: const Duration(seconds: 3),
                placeholder: const Text('Loading'),
              ),
            ),
          ),
        );

        // Assert - Before initialization
        expect(find.text('Loading'), findsOneWidget);
        expect(find.text('Content'), findsNothing);

        await tester.pumpAndSettle();

        // Assert - After initialization
        expect(find.text('Content'), findsOneWidget);
        expect(find.text('Loading'), findsNothing);
      });

      testWidgets('shows SizedBox.shrink when no placeholder', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Content'),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        // Assert - Before initialization
        expect(find.byType(SizedBox), findsWidgets);
        expect(find.text('Content'), findsNothing);

        await tester.pumpAndSettle();

        // Assert - After initialization
        expect(find.text('Content'), findsOneWidget);
      });
    });

    group('builder', () {
      testWidgets('calls builder with engine', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var builderCalled = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (receivedEngine) {
                  builderCalled = true;
                  expect(receivedEngine, equals(engine));
                  return const Text('Builder Called');
                },
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(builderCalled, isTrue);
        expect(find.text('Builder Called'), findsOneWidget);
      });

      testWidgets('builder can use engine animations', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('Animated Content'),
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Animated Content'), findsOneWidget);
        expect(find.byType(AnimatedOverlayShell), findsOneWidget);
      });
    });

    group('auto-dismiss', () {
      testWidgets('dismisses after displayDuration', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var dismissed = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Auto Dismiss'),
                displayDuration: const Duration(milliseconds: 100),
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Before dismiss
        expect(dismissed, isFalse);
        expect(find.text('Auto Dismiss'), findsOneWidget);

        // Act - Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        // Assert - After dismiss
        expect(dismissed, isTrue);
      });

      testWidgets('does not auto-dismiss when duration is zero', (
        tester,
      ) async {
        // Arrange
        final engine = FallbackAnimationEngine();
        var dismissed = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('No Auto Dismiss'),
                displayDuration: Duration.zero,
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Wait some time
        await tester.pump(const Duration(seconds: 1));

        // Assert - Should not dismiss
        expect(dismissed, isFalse);
      });

      testWidgets('calls onDismiss after reverse completes', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        var dismissed = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Dismiss Test'),
                displayDuration: const Duration(milliseconds: 50),
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Before dismiss
        expect(dismissed, isFalse);

        // Act - Trigger auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - After dismiss
        expect(dismissed, isTrue);
      });
    });

    group('lifecycle', () {
      testWidgets('disposes engine on widget dispose', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act - Mount widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Test'),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Unmount widget
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert - Widget removed
        expect(find.text('Test'), findsNothing);
      });

      testWidgets('full lifecycle: init > play > auto-dismiss', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        var dismissed = false;

        // Act - Mount and initialize
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('Full Lifecycle'),
                ),
                displayDuration: const Duration(milliseconds: 100),
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Initialized and playing
        expect(find.text('Full Lifecycle'), findsOneWidget);
        expect(engine.opacity.value, equals(1.0));

        // Act - Auto-dismiss
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        // Assert - Dismissed
        expect(dismissed, isTrue);
      });

      testWidgets('handles early disposal gracefully', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act - Mount widget
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Early Dispose'),
                displayDuration: const Duration(milliseconds: 100),
              ),
            ),
          ),
        );

        // Don't wait for pumpAndSettle - dispose early
        await tester.pumpWidget(const MaterialApp(home: Scaffold()));

        // Assert - No errors thrown
        expect(find.text('Early Dispose'), findsNothing);
      });
    });

    group('Android engine integration', () {
      testWidgets('works with Android banner engine', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('Android Banner'),
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Android Banner'), findsOneWidget);
        expect(engine.slide, isNotNull);
      });

      testWidgets('works with Android dialog engine', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('Android Dialog'),
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Android Dialog'), findsOneWidget);
        expect(engine.slide, isNotNull);
      });
    });

    group('iOS engine integration', () {
      testWidgets('works with iOS banner engine', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('iOS Banner'),
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('iOS Banner'), findsOneWidget);
        expect(engine.slide, isNull);
      });

      testWidgets('works with iOS dialog engine', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: const Text('iOS Dialog'),
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('iOS Dialog'), findsOneWidget);
        expect(engine.slide, isNull);
      });
    });

    group('fallback engine integration', () {
      testWidgets('works with fallback engine', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('Fallback'),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Fallback'), findsOneWidget);
        expect(engine.opacity.value, equals(1.0));
      });
    });

    group('edge cases', () {
      testWidgets('handles null onDismiss callback', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => const Text('No Callback'),
                displayDuration: const Duration(milliseconds: 50),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Act - Wait for auto-dismiss
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert - No errors thrown
        expect(find.text('No Callback'), findsOneWidget);
      });

      testWidgets('handles complex builder widget', (tester) async {
        // Arrange
        final engine = FallbackAnimationEngine();

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => Column(
                  children: [
                    const Text('Title'),
                    Row(
                      children: [
                        const Icon(Icons.star),
                        Container(width: 50, height: 50, color: Colors.red),
                      ],
                    ),
                  ],
                ),
                displayDuration: const Duration(seconds: 3),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });
    });

    group('real-world scenarios', () {
      testWidgets('success notification banner', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);
        var dismissed = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    color: Colors.green,
                    child: const Row(
                      children: [
                        Icon(Icons.check_circle, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Success!', style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                displayDuration: const Duration(milliseconds: 100),
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert - Shown
        expect(find.text('Success!'), findsOneWidget);

        // Act - Auto-dismiss
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        // Assert - Dismissed
        expect(dismissed, isTrue);
      });

      testWidgets('confirmation dialog', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog);

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: AnimatedOverlayWrapper(
                  engine: engine,
                  builder: (engine) => AnimatedOverlayShell(
                    engine: engine,
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Text('Are you sure?'),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  displayDuration: Duration.zero,
                ),
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('Are you sure?'), findsOneWidget);
        expect(find.text('Cancel'), findsOneWidget);
        expect(find.text('Confirm'), findsOneWidget);
      });

      testWidgets('snackbar with undo action', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar);
        var dismissed = false;

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AnimatedOverlayWrapper(
                engine: engine,
                builder: (engine) => AnimatedOverlayShell(
                  engine: engine,
                  child: Container(
                    color: Colors.grey[800],
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '3 items deleted',
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'UNDO',
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                displayDuration: const Duration(milliseconds: 100),
                onDismiss: () => dismissed = true,
              ),
            ),
          ),
        );

        await tester.pumpAndSettle();

        // Assert
        expect(find.text('3 items deleted'), findsOneWidget);
        expect(find.text('UNDO'), findsOneWidget);

        // Act - Auto-dismiss
        await tester.pump(const Duration(milliseconds: 150));
        await tester.pumpAndSettle();

        // Assert
        expect(dismissed, isTrue);
      });
    });
  });
}
