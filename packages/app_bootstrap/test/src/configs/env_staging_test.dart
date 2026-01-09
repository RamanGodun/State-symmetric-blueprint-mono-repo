/// Tests for EnvConfig in Staging environment
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - EnvConfig behavior when FlavorConfig is staging
/// - currentEnv derivation
/// - isStagingMode flag
///
/// Note: FlavorConfig.current is 'late final', so we set it once at the start
library;

import 'package:app_bootstrap/src/configs/env.dart';
import 'package:app_bootstrap/src/configs/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Set flavor once for all tests in this file
  setUpAll(() {
    FlavorConfig.current = AppFlavor.staging;
  });

  group('EnvConfig (Staging)', () {
    test('currentEnv returns staging', () {
      // Act
      final currentEnv = EnvConfig.currentEnv;

      // Assert
      expect(currentEnv, equals(Environment.staging));
    });

    test('isDebugMode returns false', () {
      // Act
      final isDebug = EnvConfig.isDebugMode;

      // Assert
      expect(isDebug, isFalse);
    });

    test('isStagingMode returns true', () {
      // Act
      final isStaging = EnvConfig.isStagingMode;

      // Assert
      expect(isStaging, isTrue);
    });

    test('flags are mutually exclusive', () {
      // Act & Assert
      expect(EnvConfig.isDebugMode, isFalse);
      expect(EnvConfig.isStagingMode, isTrue);
      expect(EnvConfig.isDebugMode && EnvConfig.isStagingMode, isFalse);
    });

    test('environment file is .env.staging', () {
      // Act
      final envFile = EnvConfig.currentEnv.fileName;

      // Assert
      expect(envFile, equals('.env.staging'));
    });
  });
}
