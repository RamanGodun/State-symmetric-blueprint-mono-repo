/// Tests for FlavorConfig in Development mode
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - FlavorConfig behavior when set to development
/// - isDev flag
/// - name getter
///
/// Note: FlavorConfig.current is 'late final', so we set it once at the start
library;

import 'package:app_bootstrap/src/configs/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Set flavor once for all tests in this file
  setUpAll(() {
    FlavorConfig.current = AppFlavor.development;
  });

  group('FlavorConfig (Development)', () {
    test('current is development', () {
      // Act
      final current = FlavorConfig.current;

      // Assert
      expect(current, equals(AppFlavor.development));
    });

    test('name returns "development"', () {
      // Act
      final name = FlavorConfig.name;

      // Assert
      expect(name, equals('development'));
    });

    test('isDev returns true', () {
      // Act
      final isDev = FlavorConfig.isDev;

      // Assert
      expect(isDev, isTrue);
    });

    test('isStg returns false', () {
      // Act
      final isStg = FlavorConfig.isStg;

      // Assert
      expect(isStg, isFalse);
    });

    test('flags are mutually exclusive', () {
      // Act & Assert
      expect(FlavorConfig.isDev, isTrue);
      expect(FlavorConfig.isStg, isFalse);
      expect(FlavorConfig.isDev && FlavorConfig.isStg, isFalse);
    });
  });
}
