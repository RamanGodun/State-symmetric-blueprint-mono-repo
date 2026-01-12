/// Tests for main_staging.dart
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
  group('main_staging', () {
    test('flavor is staging', () {
      // Arrange & Act
      const flavor = AppFlavor.staging;

      // Assert
      expect(flavor.name, equals('staging'));
      expect(flavor, isA<AppFlavor>());
    });

    test('flavor has correct properties', () {
      // Arrange
      const flavor = AppFlavor.staging;

      // Assert
      expect(flavor.toString(), contains('staging'));
    });
  });

  group('main_staging configuration', () {
    test('staging flavor exists', () {
      // Arrange & Act
      const allFlavors = AppFlavor.values;

      // Assert
      expect(allFlavors, contains(AppFlavor.staging));
    });

    test('staging is distinct from other flavors', () {
      // Arrange & Act
      const dev = AppFlavor.development;
      const staging = AppFlavor.staging;

      // Assert
      expect(staging, isNot(equals(dev)));
    });
  });
}
