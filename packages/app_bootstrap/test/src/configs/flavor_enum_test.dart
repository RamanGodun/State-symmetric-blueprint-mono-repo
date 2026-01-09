/// Tests for AppFlavor enum
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - AppFlavor enum values and structure
library;

import 'package:app_bootstrap/src/configs/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppFlavor', () {
    test('has development flavor', () {
      // Arrange & Act
      const flavor = AppFlavor.development;

      // Assert
      expect(flavor, isA<AppFlavor>());
      expect(flavor, equals(AppFlavor.development));
    });

    test('has staging flavor', () {
      // Arrange & Act
      const flavor = AppFlavor.staging;

      // Assert
      expect(flavor, isA<AppFlavor>());
      expect(flavor, equals(AppFlavor.staging));
    });

    test('has exactly 2 flavors', () {
      // Arrange & Act
      const flavors = AppFlavor.values;

      // Assert
      expect(flavors.length, equals(2));
      expect(flavors, contains(AppFlavor.development));
      expect(flavors, contains(AppFlavor.staging));
    });

    test('flavors are distinct', () {
      // Arrange & Act
      const dev = AppFlavor.development;
      const stg = AppFlavor.staging;

      // Assert
      expect(dev, isNot(equals(stg)));
    });
  });
}
