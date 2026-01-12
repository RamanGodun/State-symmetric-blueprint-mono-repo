/// Tests for FlavorIconPathX
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
///
/// Coverage:
/// - App icon path retrieval
/// - Path format validation
library;

import 'package:app_bootstrap/app_bootstrap.dart';
import 'package:app_on_cubit/core/shared_presentation/utils/flavor_icon_path__x.dart'
    show FlavorIconPathX;
import 'package:app_on_cubit/core/shared_presentation/utils/spider/icons_paths/app_icons_paths.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUpAll(() {
    // Initialize FlavorConfig for testing
    FlavorConfig.current = AppFlavor.development;
  });

  group('FlavorIconPathX', () {
    group('appIcon getter', () {
      test('returns a valid icon path', () {
        // Arrange & Act
        final iconPath = FlavorIconPathX.appIcon;

        // Assert
        expect(iconPath, isA<String>());
        expect(iconPath, isNotEmpty);
      });

      test('returns path from AppIconsPaths constants', () {
        // Arrange & Act
        final iconPath = FlavorIconPathX.appIcon;

        // Assert
        expect(
          [AppIconsPaths.devIcon, AppIconsPaths.stgIcon],
          contains(iconPath),
          reason: 'Icon path should be one of the defined app icon paths',
        );
      });

      test('icon path points to assets/icons directory', () {
        // Arrange & Act
        final iconPath = FlavorIconPathX.appIcon;

        // Assert
        expect(iconPath, startsWith('assets/icons/'));
      });

      test('icon path has .png extension', () {
        // Arrange & Act
        final iconPath = FlavorIconPathX.appIcon;

        // Assert
        expect(iconPath, endsWith('.png'));
      });

      test('returns consistent path for same flavor', () {
        // Arrange & Act
        final iconPath1 = FlavorIconPathX.appIcon;
        final iconPath2 = FlavorIconPathX.appIcon;

        // Assert
        expect(iconPath1, equals(iconPath2));
      });
    });

    group('AppIconsPaths constants', () {
      test('devIcon has correct value', () {
        // Arrange & Act & Assert
        expect(AppIconsPaths.devIcon, equals('assets/icons/dev_icon.png'));
      });

      test('stgIcon has correct value', () {
        // Arrange & Act & Assert
        expect(AppIconsPaths.stgIcon, equals('assets/icons/stg_icon.png'));
      });

      test('icon paths are different', () {
        // Arrange & Act & Assert
        expect(AppIconsPaths.devIcon, isNot(equals(AppIconsPaths.stgIcon)));
      });
    });
  });
}
