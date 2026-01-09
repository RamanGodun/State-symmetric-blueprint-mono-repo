/// Tests for FlavorConfig in Staging mode
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - FlavorConfig behavior when set to staging
/// - isStg flag
/// - name getter
///
/// Note: FlavorConfig.current is 'late final', so we set it once at the start
library;

import 'package:app_bootstrap/src/configs/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Set flavor once for all tests in this file
  setUpAll(() {
    FlavorConfig.current = AppFlavor.staging;
  });

  group('FlavorConfig (Staging)', () {
    test('current is staging', () {
      // Act
      final current = FlavorConfig.current;

      // Assert
      expect(current, equals(AppFlavor.staging));
    });

    test('name returns "staging"', () {
      // Act
      final name = FlavorConfig.name;

      // Assert
      expect(name, equals('staging'));
    });

    test('isDev returns false', () {
      // Act
      final isDev = FlavorConfig.isDev;

      // Assert
      expect(isDev, isFalse);
    });

    test('isStg returns true', () {
      // Act
      final isStg = FlavorConfig.isStg;

      // Assert
      expect(isStg, isTrue);
    });

    test('flags are mutually exclusive', () {
      // Act & Assert
      expect(FlavorConfig.isDev, isFalse);
      expect(FlavorConfig.isStg, isTrue);
      expect(FlavorConfig.isDev && FlavorConfig.isStg, isFalse);
    });
  });
}
