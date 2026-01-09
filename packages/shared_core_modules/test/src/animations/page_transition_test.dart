import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_core_modules/public_api/base_modules/animations.dart';
import 'package:shared_utils/shared_utils.dart' show AppDurations;

void main() {
  group('AppTransitions', () {
    group('fade', () {
      testWidgets('creates CustomTransitionPage with fade animation', (
        tester,
      ) async {
        // Arrange
        final childWidget = Container(key: const Key('test-child'));

        // Act
        final page = AppTransitions.fade<void>(childWidget);

        // Assert
        expect(page, isA<CustomTransitionPage<void>>());
        expect(page.child, equals(childWidget));
      });

      testWidgets('uses correct transition duration', (tester) async {
        // Arrange
        final childWidget = Container();

        // Act
        final page = AppTransitions.fade<void>(childWidget);

        // Assert
        expect(page.transitionDuration, equals(AppDurations.ms250));
      });

      testWidgets('creates FadeTransition in transitionsBuilder', (
        tester,
      ) async {
        // Arrange
        const childWidget = Text('Test');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);

        // Act
        final transition = page.transitionsBuilder(
          context,
          const AlwaysStoppedAnimation(1),
          const AlwaysStoppedAnimation(0),
          childWidget,
        );

        // Assert
        expect(transition, isA<FadeTransition>());
      });

      testWidgets('FadeTransition uses provided animation', (tester) async {
        // Arrange
        const childWidget = Text('Test');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);
        const testAnimation = AlwaysStoppedAnimation(0.5);

        // Act
        final transition = page.transitionsBuilder(
          context,
          testAnimation,
          const AlwaysStoppedAnimation(0),
          childWidget,
        );

        // Assert
        expect(transition, isA<FadeTransition>());
        final fadeTransition = transition as FadeTransition;
        expect(fadeTransition.opacity.value, equals(0.5));
      });

      testWidgets('FadeTransition contains child widget', (tester) async {
        // Arrange
        const childWidget = Text('Test Child');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);

        // Act
        final transition =
            page.transitionsBuilder(
                  context,
                  const AlwaysStoppedAnimation(1),
                  const AlwaysStoppedAnimation(0),
                  childWidget,
                )
                as FadeTransition;

        // Assert
        expect(transition.child, equals(childWidget));
      });
    });

    group('type parameters', () {
      test('supports different generic types', () {
        // Act & Assert
        expect(
          AppTransitions.fade<String>(Container()),
          isA<CustomTransitionPage<String>>(),
        );
        expect(
          AppTransitions.fade<int>(Container()),
          isA<CustomTransitionPage<int>>(),
        );
        expect(
          AppTransitions.fade<void>(Container()),
          isA<CustomTransitionPage<void>>(),
        );
      });
    });

    group('integration', () {
      testWidgets('fade animation works in widget tree', (tester) async {
        // Arrange
        final childWidget = Container(
          key: const Key('test-container'),
          color: Colors.blue,
          width: 100,
          height: 100,
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final page = AppTransitions.fade<void>(childWidget);
                  return page.transitionsBuilder(
                    context,
                    const AlwaysStoppedAnimation(1),
                    const AlwaysStoppedAnimation(0),
                    childWidget,
                  );
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.byKey(const Key('test-container')), findsOneWidget);
      });

      testWidgets('opacity changes with animation value', (tester) async {
        // Arrange
        const childWidget = Text('Animated Text');
        const testAnimation = AlwaysStoppedAnimation(0.3);

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final page = AppTransitions.fade<void>(childWidget);
                  return page.transitionsBuilder(
                    context,
                    testAnimation,
                    const AlwaysStoppedAnimation(0),
                    childWidget,
                  );
                },
              ),
            ),
          ),
        );

        // Assert - widget exists
        expect(find.text('Animated Text'), findsOneWidget);
        expect(find.byType(FadeTransition), findsWidgets);
      });
    });

    group('edge cases', () {
      testWidgets('handles animation value of 0', (tester) async {
        // Arrange
        const childWidget = Text('Test');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);

        // Act
        final transition =
            page.transitionsBuilder(
                  context,
                  const AlwaysStoppedAnimation(0),
                  const AlwaysStoppedAnimation(0),
                  childWidget,
                )
                as FadeTransition;

        // Assert
        expect(transition.opacity.value, equals(0.0));
      });

      testWidgets('handles animation value of 1', (tester) async {
        // Arrange
        const childWidget = Text('Test');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);

        // Act
        final transition =
            page.transitionsBuilder(
                  context,
                  const AlwaysStoppedAnimation(1),
                  const AlwaysStoppedAnimation(0),
                  childWidget,
                )
                as FadeTransition;

        // Assert
        expect(transition.opacity.value, equals(1.0));
      });

      testWidgets('works with complex widget children', (tester) async {
        // Arrange
        final complexChild = Column(
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

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Builder(
                builder: (context) {
                  final page = AppTransitions.fade<void>(complexChild);
                  return page.transitionsBuilder(
                    context,
                    const AlwaysStoppedAnimation(1),
                    const AlwaysStoppedAnimation(0),
                    complexChild,
                  );
                },
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
        expect(find.byType(Container), findsWidgets);
      });
    });

    group('real-world scenarios', () {
      testWidgets('fade transition for navigation', (tester) async {
        // Arrange
        final destinationPage = Scaffold(
          appBar: AppBar(title: const Text('Destination')),
          body: const Center(child: Text('Destination Page')),
        );

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: Builder(
                  builder: (context) {
                    final page = AppTransitions.fade<void>(destinationPage);
                    return page.transitionsBuilder(
                      context,
                      const AlwaysStoppedAnimation(1),
                      const AlwaysStoppedAnimation(0),
                      destinationPage,
                    );
                  },
                ),
              ),
            ),
          ),
        );

        // Assert
        expect(find.text('Destination Page'), findsOneWidget);
      });

      testWidgets('smooth transition from 0 to 1 opacity', (tester) async {
        // Arrange
        const childWidget = Text('Fading In');

        await tester.pumpWidget(MaterialApp(home: Container()));
        final context = tester.element(find.byType(Container));

        final page = AppTransitions.fade<void>(childWidget);

        // Test at different opacity values
        final opacityValues = [0.0, 0.25, 0.5, 0.75, 1.0];

        for (final opacity in opacityValues) {
          // Act
          final transition =
              page.transitionsBuilder(
                    context,
                    AlwaysStoppedAnimation(opacity),
                    const AlwaysStoppedAnimation(0),
                    childWidget,
                  )
                  as FadeTransition;

          // Assert
          expect(transition.opacity.value, equals(opacity));
        }
      });
    });
  });
}
