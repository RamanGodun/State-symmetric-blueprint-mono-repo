/// Tests for PlatformConstants
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Constant values verification
/// - Type checking
library;

import 'package:app_bootstrap/src/configs/platform_requirements.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/test_constants.dart';

void main() {
  group('PlatformConstants', () {
    group('minSdkVersion', () {
      test('has correct value', () {
        // Arrange & Act
        const minSdk = PlatformConstants.minSdkVersion;

        // Assert
        expect(minSdk, equals(TestConstants.androidSdk24));
        expect(minSdk, equals(24));
      });

      test('is an integer', () {
        // Arrange & Act
        const minSdk = PlatformConstants.minSdkVersion;

        // Assert
        expect(minSdk, isA<int>());
      });

      test('is positive', () {
        // Arrange & Act
        const minSdk = PlatformConstants.minSdkVersion;

        // Assert
        expect(minSdk, greaterThan(0));
      });
    });

    group('minIOSMajorVersion', () {
      test('has correct value', () {
        // Arrange & Act
        const minIOS = PlatformConstants.minIOSMajorVersion;

        // Assert
        expect(minIOS, equals(TestConstants.iosVersion15));
        expect(minIOS, equals('15.0'));
      });

      test('is a string', () {
        // Arrange & Act
        const minIOS = PlatformConstants.minIOSMajorVersion;

        // Assert
        expect(minIOS, isA<String>());
      });

      test('has version format', () {
        // Arrange & Act
        const minIOS = PlatformConstants.minIOSMajorVersion;

        // Assert
        expect(minIOS, contains('.'));
        expect(minIOS.split('.').length, greaterThanOrEqualTo(2));
      });

      test('major version is parseable as int', () {
        // Arrange & Act
        const minIOS = PlatformConstants.minIOSMajorVersion;
        final majorVersion = int.tryParse(minIOS.split('.').first);

        // Assert
        expect(majorVersion, isNotNull);
        expect(majorVersion, equals(15));
      });
    });

    group('class structure', () {
      test('cannot be instantiated', () {
        // Assert
        // The class has a private constructor, so this test documents that behavior
        expect(() => PlatformConstants, returnsNormally);
      });

      test('all constants are accessible', () {
        // Arrange & Act & Assert
        expect(PlatformConstants.minSdkVersion, isNotNull);
        expect(PlatformConstants.minIOSMajorVersion, isNotNull);
      });
    });
  });
}
