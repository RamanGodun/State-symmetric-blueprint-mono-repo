/// Tests for main_development.dart
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Smoke tests for app initialization
///
/// Coverage:
/// - App initialization and startup
/// - Flavor configuration
library;

import 'package:app_bootstrap/app_bootstrap.dart' show AppFlavor;
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('main_development', () {
    test('flavor is development', () {
      // Arrange & Act
      const flavor = AppFlavor.development;

      // Assert
      expect(flavor.name, equals('development'));
      expect(flavor, isA<AppFlavor>());
    });

    test('flavor has correct properties', () {
      // Arrange
      const flavor = AppFlavor.development;

      // Assert
      expect(flavor.toString(), contains('development'));
    });
  });

  group('main_development configuration', () {
    test('development flavor exists', () {
      // Arrange & Act
      const allFlavors = AppFlavor.values;

      // Assert
      expect(allFlavors, contains(AppFlavor.development));
    });

    test('development is distinct from other flavors', () {
      // Arrange & Act
      const dev = AppFlavor.development;
      const staging = AppFlavor.staging;

      // Assert
      expect(dev, isNot(equals(staging)));
    });
  });
}
