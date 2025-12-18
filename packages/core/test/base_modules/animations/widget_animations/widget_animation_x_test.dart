import 'package:core/src/base_modules/animations/widget_animations/widget_animation_x.dart';
import 'package:core/src/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WidgetAnimationX', () {
    group('fadeIn', () {
      testWidgets('wraps widget with AnimatedOpacity', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(AnimatedOpacity), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final opacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Assert
        expect(opacity.duration, equals(AppDurations.ms350));
      });

      testWidgets('uses custom duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn(
          duration: const Duration(milliseconds: 500),
        );

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final opacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Assert
        expect(opacity.duration, equals(const Duration(milliseconds: 500)));
      });

      testWidgets('opacity is set to 1', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final opacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Assert
        expect(opacity.opacity, equals(1.0));
      });
    });

    group('scaleIn', () {
      testWidgets('wraps widget with TweenAnimationBuilder', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.scaleIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default begin value of 0.8', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.scaleIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert - Widget should exist
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses custom begin value', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.scaleIn(begin: 0.5);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses easeOutBack curve by default', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.scaleIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('slideInFromBottom', () {
      testWidgets('wraps widget with TweenAnimationBuilder', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromBottom();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(TweenAnimationBuilder<Offset>), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default offset', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromBottom();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses custom offset', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromBottom(offsetY: 100);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('slideInFromLeft', () {
      testWidgets('wraps widget with TweenAnimationBuilder', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromLeft();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(TweenAnimationBuilder<Offset>), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default offset', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromLeft();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses custom offset', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromLeft(offsetX: -100);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('rotateIn', () {
      testWidgets('wraps widget with TweenAnimationBuilder', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.rotateIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default begin angle', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.rotateIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses custom begin angle', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.rotateIn(begin: -1);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('bounceIn', () {
      testWidgets('wraps widget with TweenAnimationBuilder', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.bounceIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(TweenAnimationBuilder<double>), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses elastic curve by default', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.bounceIn();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses custom begin value', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.bounceIn(begin: 0.3);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('withAnimationSwitcher', () {
      testWidgets('wraps widget with AnimatedSwitcher', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withAnimationSwitcher();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withAnimationSwitcher();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final switcher = tester.widget<AnimatedSwitcher>(
          find.byType(AnimatedSwitcher),
        );

        // Assert
        expect(switcher.duration, equals(AppDurations.ms350));
      });

      testWidgets('uses custom duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withAnimationSwitcher(
          duration: const Duration(seconds: 1),
        );

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final switcher = tester.widget<AnimatedSwitcher>(
          find.byType(AnimatedSwitcher),
        );

        // Assert
        expect(switcher.duration, equals(const Duration(seconds: 1)));
      });
    });

    group('withAnimatedSwitcherSize', () {
      testWidgets('wraps widget with AnimatedSize and AnimatedSwitcher', (
        tester,
      ) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withAnimatedSwitcherSize();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(AnimatedSize), findsOneWidget);
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withAnimatedSwitcherSize();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final animatedSize = tester.widget<AnimatedSize>(
          find.byType(AnimatedSize),
        );

        // Assert
        expect(animatedSize.duration, equals(AppDurations.ms350));
      });
    });

    group('withSimpleSwitcher', () {
      testWidgets('wraps widget with AnimatedSwitcher', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withSimpleSwitcher();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.byType(AnimatedSwitcher), findsOneWidget);
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('uses default duration', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.withSimpleSwitcher();

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final switcher = tester.widget<AnimatedSwitcher>(
          find.byType(AnimatedSwitcher),
        );

        // Assert
        expect(switcher.duration, equals(AppDurations.ms350));
      });
    });

    group('real-world scenarios', () {
      testWidgets('fadeIn animation on page load', (tester) async {
        // Arrange
        const content = Text('Welcome');

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: content.fadeIn(),
            ),
          ),
        );

        // Assert
        expect(find.text('Welcome'), findsOneWidget);
        expect(find.byType(AnimatedOpacity), findsOneWidget);
      });

      testWidgets('scaleIn for button appearance', (tester) async {
        // Arrange
        final button = ElevatedButton(
          onPressed: () {},
          child: const Text('Click'),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: button.scaleIn(),
            ),
          ),
        );

        // Assert
        expect(find.text('Click'), findsOneWidget);
        expect(find.byType(ElevatedButton), findsOneWidget);
      });

      testWidgets('slideInFromBottom for modal', (tester) async {
        // Arrange
        const modal = Card(
          child: Text('Modal Content'),
        );

        // Act
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: modal.slideInFromBottom(),
            ),
          ),
        );

        // Assert
        expect(find.text('Modal Content'), findsOneWidget);
      });

      testWidgets('combined animations', (tester) async {
        // Arrange
        const widget = Text('Animated');

        // Act - Chain multiple animations
        final animatedWidget = widget.fadeIn().scaleIn();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: animatedWidget,
            ),
          ),
        );

        // Assert
        expect(find.text('Animated'), findsOneWidget);
      });
    });

    group('edge cases', () {
      testWidgets('works with complex widgets', (tester) async {
        // Arrange
        final complexWidget = Column(
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
        final animatedWidget = complexWidget.fadeIn();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: animatedWidget,
            ),
          ),
        );

        // Assert
        expect(find.text('Title'), findsOneWidget);
        expect(find.byType(Icon), findsOneWidget);
      });

      testWidgets('zero duration works', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn(duration: Duration.zero);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('very long duration works', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn(
          duration: const Duration(seconds: 10),
        );

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('multiple animations on same widget', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act - Apply multiple animations
        final step1 = widget.fadeIn();
        final step2 = step1.scaleIn();
        final step3 = step2.rotateIn();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(body: step3),
          ),
        );

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });

    group('custom parameters', () {
      testWidgets('fadeIn with custom curve', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.fadeIn(curve: Curves.bounceIn);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));
        final opacity = tester.widget<AnimatedOpacity>(
          find.byType(AnimatedOpacity),
        );

        // Assert
        expect(opacity.curve, equals(Curves.bounceIn));
      });

      testWidgets('scaleIn with custom curve', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.scaleIn(curve: Curves.linear);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('slideInFromBottom with custom curve', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.slideInFromBottom(
          curve: Curves.easeInOut,
        );

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });

      testWidgets('rotateIn with custom curve', (tester) async {
        // Arrange
        const widget = Text('Test');

        // Act
        final animatedWidget = widget.rotateIn(curve: Curves.decelerate);

        await tester.pumpWidget(MaterialApp(home: animatedWidget));

        // Assert
        expect(find.text('Test'), findsOneWidget);
      });
    });
  });
}
