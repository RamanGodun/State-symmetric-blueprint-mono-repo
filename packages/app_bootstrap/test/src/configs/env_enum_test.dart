/// Tests for Environment enum and EnvFileName extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Environment enum values
/// - EnvFileName extension
library;

import 'package:app_bootstrap/src/configs/env.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/test_constants.dart';

void main() {
  group('Environment', () {
    test('has dev environment', () {
      // Arrange & Act
      const env = Environment.dev;

      // Assert
      expect(env, isA<Environment>());
      expect(env, equals(Environment.dev));
    });

    test('has staging environment', () {
      // Arrange & Act
      const env = Environment.staging;

      // Assert
      expect(env, isA<Environment>());
      expect(env, equals(Environment.staging));
    });

    test('has exactly 2 environments', () {
      // Arrange & Act
      const environments = Environment.values;

      // Assert
      expect(environments.length, equals(2));
      expect(environments, contains(Environment.dev));
      expect(environments, contains(Environment.staging));
    });

    test('environments are distinct', () {
      // Arrange & Act
      const dev = Environment.dev;
      const staging = Environment.staging;

      // Assert
      expect(dev, isNot(equals(staging)));
    });
  });

  group('EnvFileName extension', () {
    test('returns correct filename for dev environment', () {
      // Arrange
      const env = Environment.dev;

      // Act
      final fileName = env.fileName;

      // Assert
      expect(fileName, equals(TestConstants.envDevFileName));
      expect(fileName, equals('.env.dev'));
    });

    test('returns correct filename for staging environment', () {
      // Arrange
      const env = Environment.staging;

      // Act
      final fileName = env.fileName;

      // Assert
      expect(fileName, equals(TestConstants.envStagingFileName));
      expect(fileName, equals('.env.staging'));
    });

    test('all filenames start with .env', () {
      // Arrange & Act
      final devFile = Environment.dev.fileName;
      final stagingFile = Environment.staging.fileName;

      // Assert
      expect(devFile, startsWith('.env'));
      expect(stagingFile, startsWith('.env'));
    });

    test('all filenames are unique', () {
      // Arrange & Act
      final fileNames = Environment.values.map((e) => e.fileName).toSet();

      // Assert
      expect(fileNames.length, equals(Environment.values.length));
    });

    test('filenames can be used for path construction', () {
      // Arrange
      const env = Environment.dev;

      // Act
      final envFile = env.fileName;
      final fullPath = 'assets/$envFile';

      // Assert
      expect(fullPath, equals('assets/.env.dev'));
    });
  });
}
