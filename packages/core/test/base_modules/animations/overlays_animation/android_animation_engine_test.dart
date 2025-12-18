// need for correct tests flow
// ignore_for_file: unawaited_futures

import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/overlays_animation_engines/android_animation_engine.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AndroidOverlayAnimationEngine', () {
    group('construction', () {
      test('creates with banner type', () {
        // Act
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Assert
        expect(engine, isA<AndroidOverlayAnimationEngine>());
        expect(engine, isA<BaseAnimationEngine>());
        expect(engine, isA<AnimationEngine>());
      });

      test('creates with dialog type', () {
        // Act
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog);

        // Assert
        expect(engine, isA<AndroidOverlayAnimationEngine>());
      });

      test('creates with infoDialog type', () {
        // Act
        final engine = AndroidOverlayAnimationEngine(ShowAs.infoDialog);

        // Assert
        expect(engine, isA<AndroidOverlayAnimationEngine>());
      });

      test('creates with snackbar type', () {
        // Act
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar);

        // Assert
        expect(engine, isA<AndroidOverlayAnimationEngine>());
      });

      test('stores overlay type', () {
        // Act
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Assert
        expect(engine.overlayType, equals(ShowAs.banner));
      });
    });

    group('initialization', () {
      testWidgets('initializes successfully with banner type', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNotNull);

        engine.dispose();
      });

      testWidgets('initializes successfully with dialog type', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNotNull);

        engine.dispose();
      });

      testWidgets('initializes successfully with snackbar type', (
        tester,
      ) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNotNull);

        engine.dispose();
      });
    });

    group('animation properties', () {
      testWidgets('opacity animation starts at 0', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final opacity = engine.opacity;

        // Assert
        expect(opacity.value, equals(0.0));

        engine.dispose();
      });

      testWidgets('scale animation starts at configured value', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final scale = engine.scale;

        // Assert
        expect(scale.value, equals(0.98));

        engine.dispose();
      });

      testWidgets('slide animation is not null for banner', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final slide = engine.slide;

        // Assert
        expect(slide, isNotNull);
        expect(slide!.value, equals(const Offset(0, -0.06)));

        engine.dispose();
      });

      testWidgets('slide animation is not null for dialog', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Act
        final slide = engine.slide;

        // Assert
        expect(slide, isNotNull);
        expect(slide!.value, equals(const Offset(0, 0.12)));

        engine.dispose();
      });

      testWidgets('slide animation is not null for snackbar', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Act
        final slide = engine.slide;

        // Assert
        expect(slide, isNotNull);
        expect(slide!.value, equals(const Offset(0, 0.1)));

        engine.dispose();
      });
    });

    group('banner configuration', () {
      testWidgets('banner has correct duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms400));

        engine.dispose();
      });

      testWidgets('banner has correct fast duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms150));

        engine.dispose();
      });

      testWidgets('banner scale begins at 0.98', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.98));

        engine.dispose();
      });

      testWidgets('banner slide offset is negative Y', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.slide!.value.dy, lessThan(0));

        engine.dispose();
      });
    });

    group('dialog configuration', () {
      testWidgets('dialog has correct duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms400));

        engine.dispose();
      });

      testWidgets('dialog has correct fast duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms150));

        engine.dispose();
      });

      testWidgets('dialog scale begins at 0.95', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.95));

        engine.dispose();
      });

      testWidgets('dialog slide offset is positive Y', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.slide!.value.dy, greaterThan(0));

        engine.dispose();
      });
    });

    group('infoDialog configuration', () {
      testWidgets('infoDialog uses same config as dialog', (tester) async {
        // Arrange
        final dialogEngine = AndroidOverlayAnimationEngine(ShowAs.dialog);
        final infoEngine = AndroidOverlayAnimationEngine(ShowAs.infoDialog);

        dialogEngine.initialize(tester);
        infoEngine.initialize(tester);

        // Assert
        expect(
          infoEngine.defaultDuration,
          equals(dialogEngine.defaultDuration),
        );
        expect(
          infoEngine.fastReverseDuration,
          equals(dialogEngine.fastReverseDuration),
        );
        expect(infoEngine.scale.value, equals(dialogEngine.scale.value));

        dialogEngine.dispose();
        infoEngine.dispose();
      });
    });

    group('snackbar configuration', () {
      testWidgets('snackbar has correct duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms400));

        engine.dispose();
      });

      testWidgets('snackbar has correct fast duration', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms150));

        engine.dispose();
      });

      testWidgets('snackbar scale begins at 0.96', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.96));

        engine.dispose();
      });

      testWidgets('snackbar slide offset is positive Y', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.slide!.value.dy, greaterThan(0));

        engine.dispose();
      });
    });

    group('play animation', () {
      testWidgets('play animates to final values', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          // Act
          ..play();
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(1.0));
        expect(engine.scale.value, equals(1.0));
        expect(engine.slide!.value, equals(Offset.zero));

        engine.dispose();
      });

      testWidgets('play with duration override', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          // Act
          ..play(durationOverride: const Duration(milliseconds: 100));
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(1.0));
        expect(engine.scale.value, equals(1.0));

        engine.dispose();
      });
    });

    group('reverse animation', () {
      testWidgets('reverse returns to initial values', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          ..play();
        await tester.pumpAndSettle();

        // Act
        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(0.0));
        expect(engine.scale.value, equals(0.98));

        engine.dispose();
      });

      testWidgets('fast reverse completes quickly', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          ..play();
        await tester.pumpAndSettle();

        // Act
        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        // Assert - Reverse completed
        expect(engine.opacity.value, equals(0.0));

        engine.dispose();
      });
    });

    group('lifecycle', () {
      testWidgets('full lifecycle completes without errors', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          // Act & Assert
          ..initialize(tester);
        expect(engine.opacity, isNotNull);

        engine.play();
        await tester.pumpAndSettle();
        expect(engine.opacity.value, equals(1.0));

        engine.reverse(fast: true);
        await tester.pumpAndSettle();
        expect(engine.opacity.value, equals(0.0));

        engine.dispose();
      });

      testWidgets('can play multiple times', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          // Act
          ..play();
        await tester.pumpAndSettle();

        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        engine.play();
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(1.0));

        engine.dispose();
      });
    });

    group('real-world scenarios', () {
      testWidgets('banner animation in overlay', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Build widget with animations
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FadeTransition(
                opacity: engine.opacity,
                child: ScaleTransition(
                  scale: engine.scale,
                  child: SlideTransition(
                    position: engine.slide!,
                    child: Container(
                      width: 200,
                      height: 50,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );

        // Act - Start animation
        engine.play();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 200));

        // Assert - Animation is progressing
        expect(engine.opacity.value, greaterThan(0.0));

        await tester.pumpAndSettle();
        expect(engine.opacity.value, equals(1.0));

        engine.dispose();
      });

      testWidgets('dialog dismissal with fast reverse', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester)
          // Show dialog
          ..play();
        await tester.pumpAndSettle();

        // Act - Quick dismiss
        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(0.0));

        engine.dispose();
      });

      testWidgets('snackbar slide from bottom', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester)
          // Act
          ..play();
        await tester.pumpAndSettle();

        // Assert - Slide ended at zero (visible position)
        expect(engine.slide!.value, equals(Offset.zero));

        engine.dispose();
      });
    });

    group('edge cases', () {
      testWidgets('dispose before initialize', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act & Assert
        expect(engine.dispose, returnsNormally);
      });

      testWidgets('play before initialize does nothing', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner);

        // Act & Assert
        expect(engine.play, returnsNormally);

        engine.dispose();
      });

      testWidgets('multiple dispose calls', (tester) async {
        // Arrange
      });

      testWidgets('initialize multiple times is safe', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          // Act
          ..initialize(tester)
          ..initialize(tester)
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);

        engine.dispose();
      });
    });

    group('comparison between types', () {
      testWidgets('banner slides from top', (tester) async {
        // Arrange
        final engine = AndroidOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.slide!.value.dy, lessThan(0));

        engine.dispose();
      });

      testWidgets('dialog and snackbar slide from bottom', (tester) async {
        // Arrange
        final dialogEngine = AndroidOverlayAnimationEngine(ShowAs.dialog);
        final snackbarEngine = AndroidOverlayAnimationEngine(ShowAs.snackbar);

        dialogEngine.initialize(tester);
        snackbarEngine.initialize(tester);

        // Assert
        expect(dialogEngine.slide!.value.dy, greaterThan(0));
        expect(snackbarEngine.slide!.value.dy, greaterThan(0));

        dialogEngine.dispose();
        snackbarEngine.dispose();
      });

      testWidgets('all types have same duration', (tester) async {
        // Arrange
        final banner = AndroidOverlayAnimationEngine(ShowAs.banner);
        final dialog = AndroidOverlayAnimationEngine(ShowAs.dialog);
        final snackbar = AndroidOverlayAnimationEngine(ShowAs.snackbar);

        banner.initialize(tester);
        dialog.initialize(tester);
        snackbar.initialize(tester);

        // Assert
        expect(banner.defaultDuration, equals(AppDurations.ms400));
        expect(dialog.defaultDuration, equals(AppDurations.ms400));
        expect(snackbar.defaultDuration, equals(AppDurations.ms400));

        banner.dispose();
        dialog.dispose();
        snackbar.dispose();
      });
    });
  });
}
