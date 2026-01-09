import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_core_modules/shared_core_modules.dart';

void main() {
  group('AndroidOverlayAnimationConfig', () {
    group('construction', () {
      test('creates with all required parameters', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );

        // Assert
        expect(config, isA<AndroidOverlayAnimationConfig>());
      });

      test('creates with optional slide parameters', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
          slideCurve: Curves.linear,
          slideOffset: Offset(0, 0.1),
        );

        // Assert
        expect(config.slideCurve, equals(Curves.linear));
        expect(config.slideOffset, equals(const Offset(0, 0.1)));
      });

      test('creates without slide parameters', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );

        // Assert
        expect(config.slideCurve, isNull);
        expect(config.slideOffset, isNull);
      });
    });

    group('properties', () {
      late AndroidOverlayAnimationConfig config;

      setUp(() {
        config = const AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 400),
          fastDuration: Duration(milliseconds: 200),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.95,
          slideCurve: Curves.easeOut,
          slideOffset: Offset(0, -0.05),
        );
      });

      test('duration is accessible', () {
        // Assert
        expect(config.duration, equals(const Duration(milliseconds: 400)));
      });

      test('fastDuration is accessible', () {
        // Assert
        expect(config.fastDuration, equals(const Duration(milliseconds: 200)));
      });

      test('opacityCurve is accessible', () {
        // Assert
        expect(config.opacityCurve, equals(Curves.easeInOut));
      });

      test('scaleCurve is accessible', () {
        // Assert
        expect(config.scaleCurve, equals(Curves.decelerate));
      });

      test('scaleBegin is accessible', () {
        // Assert
        expect(config.scaleBegin, equals(0.95));
      });

      test('slideCurve is accessible', () {
        // Assert
        expect(config.slideCurve, equals(Curves.easeOut));
      });

      test('slideOffset is accessible', () {
        // Assert
        expect(config.slideOffset, equals(const Offset(0, -0.05)));
      });
    });

    group('const constructor', () {
      test('creates const instance', () {
        // Act
        const config1 = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );
        const config2 = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );

        // Assert
        expect(identical(config1, config2), isTrue);
      });
    });

    group('real-world presets', () {
      test('banner config preset', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 400),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeOut,
          scaleBegin: 0.98,
          scaleCurve: Curves.decelerate,
          slideCurve: Curves.easeOut,
          slideOffset: Offset(0, -0.06),
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(400));
        expect(config.scaleBegin, lessThan(1.0));
        expect(config.slideOffset, isNotNull);
      });

      test('dialog config preset', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 400),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeOut,
          scaleBegin: 0.95,
          scaleCurve: Curves.easeOut,
          slideCurve: Curves.easeOut,
          slideOffset: Offset(0, 0.12),
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(400));
        expect(config.scaleBegin, lessThan(1.0));
        expect(config.slideOffset!.dy, greaterThan(0));
      });

      test('snackbar config preset', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 400),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.easeInOut,
          scaleBegin: 0.96,
          scaleCurve: Curves.easeOut,
          slideCurve: Curves.easeOut,
          slideOffset: Offset(0, 0.1),
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(400));
        expect(config.slideOffset!.dy, greaterThan(0));
      });
    });

    group('edge cases', () {
      test('zero duration', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration.zero,
          fastDuration: Duration.zero,
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 1,
        );

        // Assert
        expect(config.duration, equals(Duration.zero));
        expect(config.fastDuration, equals(Duration.zero));
      });

      test('scaleBegin at 1.0 (no scaling)', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 1,
        );

        // Assert
        expect(config.scaleBegin, equals(1.0));
      });

      test('zero slide offset', () {
        // Act
        const config = AndroidOverlayAnimationConfig(
          duration: Duration(milliseconds: 300),
          fastDuration: Duration(milliseconds: 150),
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 0.9,
          slideOffset: Offset.zero,
        );

        // Assert
        expect(config.slideOffset, equals(Offset.zero));
      });
    });
  });

  group('IOSOverlayAnimationConfig', () {
    group('construction', () {
      test('creates with all required parameters', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.9,
        );

        // Assert
        expect(config, isA<IOSOverlayAnimationConfig>());
      });

      test('creates const instance when identical', () {
        // Act
        const config1 = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );
        const config2 = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeIn,
          scaleCurve: Curves.easeOut,
          scaleBegin: 0.9,
        );

        // Assert - const objects with same values are identical
        expect(identical(config1, config2), isTrue);
      });
    });

    group('properties', () {
      late IOSOverlayAnimationConfig config;

      setUp(() {
        config = const IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.9,
        );
      });

      test('duration is accessible', () {
        // Assert
        expect(config.duration, equals(const Duration(milliseconds: 500)));
      });

      test('fastDuration is accessible', () {
        // Assert
        expect(config.fastDuration, equals(const Duration(milliseconds: 180)));
      });

      test('opacityCurve is accessible', () {
        // Assert
        expect(config.opacityCurve, equals(Curves.easeInOut));
      });

      test('scaleCurve is accessible', () {
        // Assert
        expect(config.scaleCurve, equals(Curves.decelerate));
      });

      test('scaleBegin is accessible', () {
        // Assert
        expect(config.scaleBegin, equals(0.9));
      });
    });

    group('const constructor', () {
      test('creates const instance', () {
        // Act
        const config1 = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.9,
        );
        const config2 = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.9,
        );

        // Assert
        expect(identical(config1, config2), isTrue);
      });
    });

    group('real-world presets', () {
      test('banner config preset', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleBegin: 0.9,
          scaleCurve: Curves.decelerate,
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(500));
        expect(config.scaleBegin, lessThan(1.0));
      });

      test('dialog config preset', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleBegin: 0.9,
          scaleCurve: Curves.decelerate,
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(500));
        expect(config.fastDuration.inMilliseconds, equals(180));
      });

      test('infoDialog config preset', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeOut,
          scaleBegin: 0.92,
          scaleCurve: Curves.easeOutBack,
        );

        // Assert
        expect(config.scaleCurve, equals(Curves.easeOutBack));
        expect(config.scaleBegin, equals(0.92));
      });

      test('snackbar config preset', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleBegin: 0.95,
          scaleCurve: Curves.decelerate,
        );

        // Assert
        expect(config.duration.inMilliseconds, equals(500));
        expect(config.scaleBegin, equals(0.95));
      });
    });

    group('edge cases', () {
      test('zero duration', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration.zero,
          fastDuration: Duration.zero,
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 1,
        );

        // Assert
        expect(config.duration, equals(Duration.zero));
        expect(config.fastDuration, equals(Duration.zero));
      });

      test('scaleBegin at 1.0 (no scaling)', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 1,
        );

        // Assert
        expect(config.scaleBegin, equals(1.0));
      });

      test('very long duration', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(seconds: 10),
          fastDuration: Duration(seconds: 5),
          opacityCurve: Curves.linear,
          scaleCurve: Curves.linear,
          scaleBegin: 0.5,
        );

        // Assert
        expect(config.duration.inSeconds, equals(10));
        expect(config.fastDuration.inSeconds, equals(5));
      });
    });

    group('no slide support', () {
      test('iOS config does not have slide properties', () {
        // Act
        const config = IOSOverlayAnimationConfig(
          duration: Duration(milliseconds: 500),
          fastDuration: Duration(milliseconds: 180),
          opacityCurve: Curves.easeInOut,
          scaleCurve: Curves.decelerate,
          scaleBegin: 0.9,
        );

        // Assert - verify no slide-related fields exist
        expect(config, isA<IOSOverlayAnimationConfig>());
        expect(config.duration, isNotNull);
        expect(config.fastDuration, isNotNull);
        expect(config.opacityCurve, isNotNull);
        expect(config.scaleCurve, isNotNull);
        expect(config.scaleBegin, isNotNull);
      });
    });
  });

  group('config comparison', () {
    test('Android config has slide support', () {
      // Act
      const androidConfig = AndroidOverlayAnimationConfig(
        duration: Duration(milliseconds: 400),
        fastDuration: Duration(milliseconds: 150),
        opacityCurve: Curves.easeOut,
        scaleCurve: Curves.easeOut,
        scaleBegin: 0.95,
        slideOffset: Offset(0, 0.1),
      );

      // Assert
      expect(androidConfig.slideOffset, isNotNull);
    });

    test('Android typically faster than iOS', () {
      // Act
      const androidConfig = AndroidOverlayAnimationConfig(
        duration: Duration(milliseconds: 400),
        fastDuration: Duration(milliseconds: 150),
        opacityCurve: Curves.easeOut,
        scaleCurve: Curves.easeOut,
        scaleBegin: 0.95,
      );
      const iosConfig = IOSOverlayAnimationConfig(
        duration: Duration(milliseconds: 500),
        fastDuration: Duration(milliseconds: 180),
        opacityCurve: Curves.easeInOut,
        scaleCurve: Curves.decelerate,
        scaleBegin: 0.9,
      );

      // Assert
      expect(
        androidConfig.duration.inMilliseconds,
        lessThan(iosConfig.duration.inMilliseconds),
      );
      expect(
        androidConfig.fastDuration.inMilliseconds,
        lessThan(iosConfig.fastDuration.inMilliseconds),
      );
    });
  });
}
