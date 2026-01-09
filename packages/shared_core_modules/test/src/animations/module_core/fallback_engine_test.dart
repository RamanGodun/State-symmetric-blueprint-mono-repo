import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/shared_core_modules.dart';

void main() {
  group('FallbackAnimationEngine', () {
    late FallbackAnimationEngine engine;

    setUp(() {
      engine = FallbackAnimationEngine();
    });

    group('construction', () {
      test('creates instance successfully', () {
        // Act & Assert
        expect(engine, isA<FallbackAnimationEngine>());
        expect(engine, isA<AnimationEngine>());
      });

      test('creates multiple independent instances', () {
        // Act
        final engine1 = FallbackAnimationEngine();
        final engine2 = FallbackAnimationEngine();

        // Assert
        expect(engine1, isNot(same(engine2)));
      });
    });

    group('initialize', () {
      testWidgets('does not throw when called', (tester) async {
        // Act & Assert
        expect(() => engine.initialize(tester), returnsNormally);
      });

      testWidgets('can be called multiple times', (tester) async {
        // Act & Assert
        expect(() {
          engine
            ..initialize(tester)
            ..initialize(tester)
            ..initialize(tester);
        }, returnsNormally);
      });
    });

    group('play', () {
      test('does not throw when called', () {
        // Act & Assert
        expect(() => engine.play(), returnsNormally);
      });

      test('accepts duration override', () {
        // Act & Assert
        expect(
          () =>
              engine.play(durationOverride: const Duration(milliseconds: 100)),
          returnsNormally,
        );
      });

      test('can be called multiple times', () {
        // Act & Assert
        expect(() {
          engine
            ..play()
            ..play()
            ..play();
        }, returnsNormally);
      });
    });

    group('reverse', () {
      test('completes immediately', () async {
        // Act
        final future = engine.reverse();

        // Assert
        expect(future, completes);
        await future;
      });

      test('accepts fast parameter', () async {
        // Act & Assert
        expect(engine.reverse(fast: true), completes);
        expect(engine.reverse(), completes);
      });

      test('can be called multiple times', () async {
        // Act & Assert
        await engine.reverse();
        await engine.reverse();
        await engine.reverse();
      });
    });

    group('dispose', () {
      test('does not throw when called', () {
        // Act & Assert
        expect(() => engine.dispose(), returnsNormally);
      });

      test('can be called multiple times', () {
        // Act & Assert
        expect(() {
          engine
            ..dispose()
            ..dispose()
            ..dispose();
        }, returnsNormally);
      });

      test('can be called after play', () {
        // Arrange
        engine.play();

        // Act & Assert
        expect(() => engine.dispose(), returnsNormally);
      });
    });

    group('opacity', () {
      test('returns kAlwaysCompleteAnimation', () {
        // Act
        final opacity = engine.opacity;

        // Assert
        expect(opacity, equals(kAlwaysCompleteAnimation));
      });

      test('opacity value is always 1.0', () {
        // Act
        final opacity = engine.opacity;

        // Assert
        expect(opacity.value, equals(1.0));
      });

      test('returns same instance on multiple calls', () {
        // Act
        final opacity1 = engine.opacity;
        final opacity2 = engine.opacity;

        // Assert
        expect(opacity1, same(opacity2));
      });
    });

    group('scale', () {
      test('returns kAlwaysCompleteAnimation', () {
        // Act
        final scale = engine.scale;

        // Assert
        expect(scale, equals(kAlwaysCompleteAnimation));
      });

      test('scale value is always 1.0', () {
        // Act
        final scale = engine.scale;

        // Assert
        expect(scale.value, equals(1.0));
      });

      test('returns same instance on multiple calls', () {
        // Act
        final scale1 = engine.scale;
        final scale2 = engine.scale;

        // Assert
        expect(scale1, same(scale2));
      });
    });

    group('slide', () {
      test('returns null', () {
        // Act
        final slide = engine.slide;

        // Assert
        expect(slide, isNull);
      });

      test('consistently returns null', () {
        // Act & Assert
        expect(engine.slide, isNull);
        expect(engine.slide, isNull);
        expect(engine.slide, isNull);
      });
    });

    group('lifecycle', () {
      testWidgets('full lifecycle without errors', (tester) async {
        // Arrange
        final testEngine = FallbackAnimationEngine();

        // Act & Assert
        expect(() => testEngine.initialize(tester), returnsNormally);
        expect(testEngine.play, returnsNormally);
        expect(testEngine.reverse(), completes);
        expect(testEngine.dispose, returnsNormally);
      });

      test('operations work in any order', () async {
        // Arrange
        final testEngine = FallbackAnimationEngine();

        // Act & Assert - out of order operations
        expect(testEngine.play, returnsNormally);
        await testEngine.reverse();
        expect(testEngine.dispose, returnsNormally);
        expect(testEngine.play, returnsNormally);
      });
    });

    group('animations are always complete', () {
      test('opacity is complete immediately', () {
        // Act
        final opacity = engine.opacity;

        // Assert
        expect(opacity.isCompleted, isTrue);
        expect(opacity.value, equals(1.0));
      });

      test('scale is complete immediately', () {
        // Act
        final scale = engine.scale;

        // Assert
        expect(scale.isCompleted, isTrue);
        expect(scale.value, equals(1.0));
      });

      test('animations remain complete after operations', () async {
        // Arrange
        engine.play();
        await engine.reverse();

        // Act & Assert
        expect(engine.opacity.isCompleted, isTrue);
        expect(engine.scale.isCompleted, isTrue);
      });
    });

    group('real-world scenarios', () {
      testWidgets('used as fallback for unsupported platform', (tester) async {
        // Arrange
        final fallback = FallbackAnimationEngine()
          ..initialize(tester)
          // Act
          ..play();

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FadeTransition(
                opacity: fallback.opacity,
                child: ScaleTransition(
                  scale: fallback.scale,
                  child: const Text('Content'),
                ),
              ),
            ),
          ),
        );

        // Assert - widget displays immediately without animation
        expect(find.text('Content'), findsOneWidget);
        expect(fallback.opacity.value, equals(1.0));
        expect(fallback.scale.value, equals(1.0));
      });

      testWidgets('no-op behavior in overlay dismissal', (tester) async {
        // Arrange
        final fallback = FallbackAnimationEngine()
          ..initialize(tester)
          ..play();

        // Act - fast dismiss
        final dismissFuture = fallback.reverse(fast: true);

        // Assert - completes immediately
        expect(dismissFuture, completes);
        await dismissFuture;
      });
    });

    group('edge cases', () {
      test('dispose before initialize', () {
        // Arrange
        final testEngine = FallbackAnimationEngine();

        // Act & Assert
        expect(testEngine.dispose, returnsNormally);
      });

      test('play before initialize', () {
        // Arrange
        final testEngine = FallbackAnimationEngine();

        // Act & Assert
        expect(testEngine.play, returnsNormally);
      });

      test('reverse before initialize', () async {
        // Arrange
        final testEngine = FallbackAnimationEngine();

        // Act & Assert
        expect(testEngine.reverse(), completes);
      });

      test('multiple dispose calls', () {
        // Arrange
        final testEngine = FallbackAnimationEngine()
          // Act & Assert
          ..dispose()
          ..dispose()
          ..dispose();
        expect(testEngine.dispose, returnsNormally);
      });
    });

    group('comparison with other engines', () {
      test('implements AnimationEngine interface', () {
        // Assert
        expect(engine, isA<AnimationEngine>());
      });

      test('provides all required animation properties', () {
        // Act & Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(() => engine.slide, returnsNormally);
      });

      testWidgets('implements all required methods', (tester) async {
        // Act & Assert
        expect(() => engine.initialize(tester), returnsNormally);
        expect(() => engine.play(), returnsNormally);
        expect(engine.reverse(), completes);
        expect(() => engine.dispose(), returnsNormally);
      });
    });
  });
}
