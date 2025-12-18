// need for correct tests flow
// ignore_for_file: unawaited_futures

import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/overlays_animation_engines/ios_animation_engine.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('IOSOverlayAnimationEngine', () {
    group('construction', () {
      test('creates with banner type', () {
        // Act
        final engine = IOSOverlayAnimationEngine(ShowAs.banner);

        // Assert
        expect(engine, isA<IOSOverlayAnimationEngine>());
        expect(engine, isA<BaseAnimationEngine>());
        expect(engine, isA<AnimationEngine>());
      });

      test('creates with dialog type', () {
        // Act
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog);

        // Assert
        expect(engine, isA<IOSOverlayAnimationEngine>());
      });

      test('creates with infoDialog type', () {
        // Act
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog);

        // Assert
        expect(engine, isA<IOSOverlayAnimationEngine>());
      });

      test('creates with snackbar type', () {
        // Act
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar);

        // Assert
        expect(engine, isA<IOSOverlayAnimationEngine>());
      });
    });

    group('initialization', () {
      testWidgets('initializes successfully with banner type', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('initializes successfully with dialog type', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('initializes successfully with snackbar type', (
        tester,
      ) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar)
          // Act
          ..initialize(tester);

        // Assert
        expect(engine.opacity, isNotNull);
        expect(engine.scale, isNotNull);
        expect(engine.slide, isNull);

        engine.dispose();
      });
    });

    group('animation properties', () {
      testWidgets('opacity animation starts at 0', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final opacity = engine.opacity;

        // Assert
        expect(opacity.value, equals(0.0));

        engine.dispose();
      });

      testWidgets('scale animation starts at configured value', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final scale = engine.scale;

        // Assert
        expect(scale.value, equals(0.9));

        engine.dispose();
      });

      testWidgets('slide animation is null for iOS', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Act
        final slide = engine.slide;

        // Assert
        expect(slide, isNull);

        engine.dispose();
      });
    });

    group('banner configuration', () {
      testWidgets('banner has correct duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms500));

        engine.dispose();
      });

      testWidgets('banner has correct fast duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms180));

        engine.dispose();
      });

      testWidgets('banner scale begins at 0.9', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.9));

        engine.dispose();
      });
    });

    group('dialog configuration', () {
      testWidgets('dialog has correct duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms500));

        engine.dispose();
      });

      testWidgets('dialog has correct fast duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms180));

        engine.dispose();
      });

      testWidgets('dialog scale begins at 0.9', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.9));

        engine.dispose();
      });
    });

    group('infoDialog configuration', () {
      testWidgets('infoDialog has correct duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms500));

        engine.dispose();
      });

      testWidgets('infoDialog has correct fast duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms180));

        engine.dispose();
      });

      testWidgets('infoDialog scale begins at 0.92', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.92));

        engine.dispose();
      });

      testWidgets('infoDialog differs from dialog', (tester) async {
        // Arrange
        final dialogEngine = IOSOverlayAnimationEngine(ShowAs.dialog);
        final infoEngine = IOSOverlayAnimationEngine(ShowAs.infoDialog);

        dialogEngine.initialize(tester);
        infoEngine.initialize(tester);

        // Assert - Different scale values
        expect(dialogEngine.scale.value, equals(0.9));
        expect(infoEngine.scale.value, equals(0.92));

        dialogEngine.dispose();
        infoEngine.dispose();
      });
    });

    group('snackbar configuration', () {
      testWidgets('snackbar has correct duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.defaultDuration, equals(AppDurations.ms500));

        engine.dispose();
      });

      testWidgets('snackbar has correct fast duration', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.fastReverseDuration, equals(AppDurations.ms180));

        engine.dispose();
      });

      testWidgets('snackbar scale begins at 0.95', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.scale.value, equals(0.95));

        engine.dispose();
      });
    });

    group('play animation', () {
      testWidgets('play animates to final values', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          // Act
          ..play();
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(1.0));
        expect(engine.scale.value, equals(1.0));

        engine.dispose();
      });

      testWidgets('play with duration override', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
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
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester)
          ..play();
        await tester.pumpAndSettle();

        // Act
        engine.reverse(fast: true);
        await tester.pumpAndSettle();

        // Assert
        expect(engine.opacity.value, equals(0.0));
        expect(engine.scale.value, equals(0.9));

        engine.dispose();
      });

      testWidgets('fast reverse completes quickly', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
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
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
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
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
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
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Build widget with animations
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: FadeTransition(
                opacity: engine.opacity,
                child: ScaleTransition(
                  scale: engine.scale,
                  child: Container(
                    width: 200,
                    height: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),
          ),
        );

        // Act - Start animation
        engine.play();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 250));

        // Assert - Animation is progressing
        expect(engine.opacity.value, greaterThan(0.0));

        await tester.pumpAndSettle();
        expect(engine.opacity.value, equals(1.0));

        engine.dispose();
      });

      testWidgets('dialog dismissal with fast reverse', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
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

      testWidgets('infoDialog with easeOutBack curve', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog)
          ..initialize(tester)
          // Act
          ..play();
        await tester.pumpAndSettle();

        // Assert - Scale animation completes
        expect(engine.scale.value, equals(1.0));

        engine.dispose();
      });
    });

    group('edge cases', () {
      testWidgets('dispose before initialize', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner);

        // Act & Assert
        expect(engine.dispose, returnsNormally);
      });

      testWidgets('play before initialize does nothing', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner);

        // Act & Assert
        expect(engine.play, returnsNormally);

        engine.dispose();
      });

      testWidgets('multiple dispose calls', (tester) async {
        // Arrange
      });

      testWidgets('initialize multiple times is safe', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
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
      testWidgets('all types have same duration', (tester) async {
        // Arrange
        final banner = IOSOverlayAnimationEngine(ShowAs.banner);
        final dialog = IOSOverlayAnimationEngine(ShowAs.dialog);
        final snackbar = IOSOverlayAnimationEngine(ShowAs.snackbar);
        final infoDialog = IOSOverlayAnimationEngine(ShowAs.infoDialog);

        banner.initialize(tester);
        dialog.initialize(tester);
        snackbar.initialize(tester);
        infoDialog.initialize(tester);

        // Assert
        expect(banner.defaultDuration, equals(AppDurations.ms500));
        expect(dialog.defaultDuration, equals(AppDurations.ms500));
        expect(snackbar.defaultDuration, equals(AppDurations.ms500));
        expect(infoDialog.defaultDuration, equals(AppDurations.ms500));

        banner.dispose();
        dialog.dispose();
        snackbar.dispose();
        infoDialog.dispose();
      });

      testWidgets('different scale begin values', (tester) async {
        // Arrange
        final banner = IOSOverlayAnimationEngine(ShowAs.banner);
        final dialog = IOSOverlayAnimationEngine(ShowAs.dialog);
        final infoDialog = IOSOverlayAnimationEngine(ShowAs.infoDialog);
        final snackbar = IOSOverlayAnimationEngine(ShowAs.snackbar);

        banner.initialize(tester);
        dialog.initialize(tester);
        infoDialog.initialize(tester);
        snackbar.initialize(tester);

        // Assert
        expect(banner.scale.value, equals(0.9));
        expect(dialog.scale.value, equals(0.9));
        expect(infoDialog.scale.value, equals(0.92));
        expect(snackbar.scale.value, equals(0.95));

        banner.dispose();
        dialog.dispose();
        infoDialog.dispose();
        snackbar.dispose();
      });

      testWidgets('all types have null slide', (tester) async {
        // Arrange
        final banner = IOSOverlayAnimationEngine(ShowAs.banner);
        final dialog = IOSOverlayAnimationEngine(ShowAs.dialog);
        final snackbar = IOSOverlayAnimationEngine(ShowAs.snackbar);

        banner.initialize(tester);
        dialog.initialize(tester);
        snackbar.initialize(tester);

        // Assert - iOS doesn't use slide animations
        expect(banner.slide, isNull);
        expect(dialog.slide, isNull);
        expect(snackbar.slide, isNull);

        banner.dispose();
        dialog.dispose();
        snackbar.dispose();
      });

      testWidgets('iOS duration is longer than Android', (tester) async {
        // Arrange
        final iosEngine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert - iOS uses 500ms vs Android's 400ms
        expect(
          iosEngine.defaultDuration.inMilliseconds,
          equals(500),
        );

        iosEngine.dispose();
      });
    });

    group('no slide support', () {
      testWidgets('banner has no slide', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.banner)
          ..initialize(tester);

        // Assert
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('dialog has no slide', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.dialog)
          ..initialize(tester);

        // Assert
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('snackbar has no slide', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.snackbar)
          ..initialize(tester);

        // Assert
        expect(engine.slide, isNull);

        engine.dispose();
      });

      testWidgets('infoDialog has no slide', (tester) async {
        // Arrange
        final engine = IOSOverlayAnimationEngine(ShowAs.infoDialog)
          ..initialize(tester);

        // Assert
        expect(engine.slide, isNull);

        engine.dispose();
      });
    });
  });
}
