/// Tests for EnvConfig in Development environment
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - EnvConfig behavior when FlavorConfig is development
/// - currentEnv derivation
/// - isDebugMode flag
///
/// Note: FlavorConfig.current is 'late final', so we set it once at the start
library;

import 'package:app_bootstrap/src/configs/env.dart';
import 'package:app_bootstrap/src/configs/flavor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // Set flavor once for all tests in this file
  setUpAll(() {
    FlavorConfig.current = AppFlavor.development;
  });

  group('EnvConfig (Development)', () {
    test('currentEnv returns dev', () {
      // Act
      final currentEnv = EnvConfig.currentEnv;

      // Assert
      expect(currentEnv, equals(Environment.dev));
    });

    test('isDebugMode returns true', () {
      // Act
      final isDebug = EnvConfig.isDebugMode;

      // Assert
      expect(isDebug, isTrue);
    });

    test('isStagingMode returns false', () {
      // Act
      final isStaging = EnvConfig.isStagingMode;

      // Assert
      expect(isStaging, isFalse);
    });

    test('flags are mutually exclusive', () {
      // Act & Assert
      expect(EnvConfig.isDebugMode, isTrue);
      expect(EnvConfig.isStagingMode, isFalse);
      expect(EnvConfig.isDebugMode && EnvConfig.isStagingMode, isFalse);
    });

    test('environment file is .env.dev', () {
      // Act
      final envFile = EnvConfig.currentEnv.fileName;

      // Assert
      expect(envFile, equals('.env.dev'));
    });
  });
}
