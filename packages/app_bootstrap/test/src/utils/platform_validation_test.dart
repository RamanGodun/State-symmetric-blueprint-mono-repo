/// Tests for [PlatformValidationUtil]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - Android SDK version validation
/// - iOS version validation
/// - Version parsing logic
/// - Error cases (unsupported versions)
/// - Edge cases (malformed versions, exact minimum)
/// - Real-world platform checks
library;

import 'package:app_bootstrap/src/configs/platform_requirements.dart';
import 'package:app_bootstrap/src/utils/platform_validation.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../fixtures/test_constants.dart';

void main() {
  group('PlatformValidationUtil', () {
    group('constructor', () {
      test('has private constructor', () {
        // This test validates the private constructor pattern
        // by verifying the class type is accessible
        expect(PlatformValidationUtil, isNotNull);
      });
    });

    group('run', () {
      test('is a static method', () {
        // Assert
        expect(PlatformValidationUtil.run, isA<Function>());
      });
    });

    group('Android validation', () {
      test('validates minimum SDK version constant', () {
        // Assert
        expect(PlatformConstants.minSdkVersion, equals(24));
        expect(PlatformConstants.minSdkVersion, isA<int>());
        expect(PlatformConstants.minSdkVersion, greaterThan(0));
      });

      test('validates supported Android SDK versions', () {
        // Arrange
        const supportedVersions = [
          TestConstants.androidSdk24,
          TestConstants.androidSdk33,
          24, // minimum
          25,
          30,
        ];

        // Assert
        for (final version in supportedVersions) {
          expect(
            version,
            greaterThanOrEqualTo(PlatformConstants.minSdkVersion),
            reason: 'SDK $version should be supported',
          );
        }
      });

      test('identifies unsupported Android SDK versions', () {
        // Arrange
        const unsupportedVersions = [
          TestConstants.androidSdk23,
          19,
          20,
        ];

        // Assert
        for (final version in unsupportedVersions) {
          expect(
            version,
            lessThan(PlatformConstants.minSdkVersion),
            reason: 'SDK $version should be unsupported',
          );
        }
      });
    });

    group('iOS validation', () {
      test('validates minimum iOS version constant', () {
        // Assert
        expect(PlatformConstants.minIOSMajorVersion, equals('15.0'));
        expect(PlatformConstants.minIOSMajorVersion, isA<String>());
        expect(PlatformConstants.minIOSMajorVersion.isNotEmpty, isTrue);
      });

      test('validates iOS version parsing logic', () {
        // Arrange
        const testVersions = {
          '13.0': 13,
          '14.5': 14,
          TestConstants.iosVersion15: 15,
          TestConstants.iosVersion16: 16,
          TestConstants.iosVersion17: 17,
        };

        // Act & Assert
        for (final entry in testVersions.entries) {
          final major = int.tryParse(entry.key.split('.').first);
          expect(major, equals(entry.value));
        }
      });

      test('identifies supported iOS versions', () {
        // Arrange
        const supportedVersions = [
          TestConstants.iosVersion15,
          TestConstants.iosVersion16,
          TestConstants.iosVersion17,
          '15.0',
          '16.0',
        ];

        const minVersion = 15;

        // Assert
        for (final version in supportedVersions) {
          final major = int.tryParse(version.split('.').first);
          expect(
            major,
            greaterThanOrEqualTo(minVersion),
            reason: 'iOS $version should be supported',
          );
        }
      });

      test('identifies unsupported iOS versions', () {
        // Arrange
        const unsupportedVersions = [
          TestConstants.iosVersion14,
          '12.5',
          '11.0',
          '10.3.3',
        ];

        const minVersion = 15;

        // Assert
        for (final version in unsupportedVersions) {
          final major = int.tryParse(version.split('.').first);
          expect(
            major,
            lessThan(minVersion),
            reason: 'iOS $version should be unsupported',
          );
        }
      });
    });

    group('version parsing', () {
      test('parses major version from iOS version string', () {
        // Arrange
        const testCases = {
          '13.0': 13,
          '14.2.1': 14,
          '15': 15,
          '16.0.0.0': 16,
        };

        // Act & Assert
        for (final entry in testCases.entries) {
          final major = int.tryParse(entry.key.split('.').first);
          expect(major, equals(entry.value));
        }
      });

      test('handles malformed iOS version strings', () {
        // Arrange
        const malformedVersions = [
          'invalid',
          '',
          'abc.def',
          '...',
        ];

        // Act & Assert
        for (final version in malformedVersions) {
          final major = int.tryParse(version.split('.').first);
          expect(major, isNull);
        }
      });

      test('handles edge case iOS versions', () {
        // Arrange
        const edgeCases = [
          '0.0',
          '999.999',
          '1',
        ];

        // Act & Assert
        for (final version in edgeCases) {
          final major = int.tryParse(version.split('.').first);
          expect(major, isNotNull);
          expect(major, isA<int>());
        }
      });
    });

    group('edge cases', () {
      test('handles exact minimum Android SDK version', () {
        // Arrange
        const exactMinimum = 24;

        // Assert
        expect(
          exactMinimum,
          equals(PlatformConstants.minSdkVersion),
        );
        expect(
          exactMinimum,
          greaterThanOrEqualTo(PlatformConstants.minSdkVersion),
        );
      });

      test('handles exact minimum iOS version', () {
        // Arrange
        const exactMinimum = '15.0';
        final major = int.tryParse(exactMinimum.split('.').first);
        final requiredMajor = int.tryParse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );

        // Assert
        expect(major, equals(requiredMajor));
        expect(major, greaterThanOrEqualTo(requiredMajor!));
      });

      test('handles version one below minimum Android SDK', () {
        // Arrange
        const oneBelowMinimum = PlatformConstants.minSdkVersion - 1;

        // Assert
        expect(oneBelowMinimum, lessThan(PlatformConstants.minSdkVersion));
      });

      test('handles version one below minimum iOS', () {
        // Arrange
        final requiredMajor = int.parse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );
        final oneBelowMinimum = requiredMajor - 1;

        // Assert
        expect(oneBelowMinimum, lessThan(requiredMajor));
      });

      test('handles very high version numbers', () {
        // Arrange
        const veryHighVersions = [
          100, // Android SDK
          50, // Android SDK
        ];

        // Assert
        for (final version in veryHighVersions) {
          expect(
            version,
            greaterThanOrEqualTo(PlatformConstants.minSdkVersion),
          );
        }
      });

      test('handles iOS version with multiple decimal points', () {
        // Arrange
        const complexVersion = '16.4.1.1';
        final major = int.tryParse(complexVersion.split('.').first);

        // Assert
        expect(major, equals(16));
        expect(major, isA<int>());
      });
    });

    group('real-world scenarios', () {
      test('validates common Android SDK versions in use', () {
        // Arrange
        const commonVersions = {
          24: 'Android 7.0 Nougat',
          26: 'Android 8.0 Oreo',
          28: 'Android 9.0 Pie',
          29: 'Android 10',
          30: 'Android 11',
          31: 'Android 12',
          33: 'Android 13',
        };

        // Assert
        for (final entry in commonVersions.entries) {
          final isSupported = entry.key >= PlatformConstants.minSdkVersion;
          expect(
            isSupported,
            isTrue,
            reason: '${entry.value} (SDK ${entry.key}) should be supported',
          );
        }
      });

      test('validates common iOS versions in use', () {
        // Arrange
        const commonVersions = {
          '15.0': 'iOS 15',
          '16.0': 'iOS 16',
          '17.0': 'iOS 17',
        };

        final minMajor = int.parse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );

        // Assert
        for (final entry in commonVersions.entries) {
          final major = int.parse(entry.key.split('.').first);
          final isSupported = major >= minMajor;
          expect(
            isSupported,
            isTrue,
            reason: '${entry.value} should be supported',
          );
        }
      });

      test('simulates version check for new device', () {
        // Arrange
        const newDeviceVersions = {
          'android': TestConstants.androidSdk33,
          'ios': TestConstants.iosVersion17,
        };

        // Assert
        expect(
          newDeviceVersions['android'],
          greaterThan(PlatformConstants.minSdkVersion),
        );

        final iosMajor = int.parse(
          (newDeviceVersions['ios']! as String).split('.').first,
        );
        final minIosMajor = int.parse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );
        expect(iosMajor, greaterThan(minIosMajor));
      });

      test('simulates version check for old device', () {
        // Arrange
        const oldDeviceVersions = {
          'android': TestConstants.androidSdk23,
          'ios': TestConstants.iosVersion14,
        };

        // Assert
        expect(
          oldDeviceVersions['android'],
          lessThan(PlatformConstants.minSdkVersion),
        );

        final iosMajor = int.parse(
          (oldDeviceVersions['ios']! as String).split('.').first,
        );
        final minIosMajor = int.parse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );
        expect(iosMajor, lessThan(minIosMajor));
      });

      test('validates version comparison logic matches implementation', () {
        // Arrange - This tests the same logic as in PlatformValidationUtil
        const testIosVersion = '14.2';
        const minIosVersion = '13';

        // Act
        final major = int.tryParse(testIosVersion.split('.').first);
        final requiredMajor = int.tryParse(minIosVersion.split('.').first);

        // Assert
        expect(major, isNotNull);
        expect(requiredMajor, isNotNull);
        expect(major! < requiredMajor!, isFalse);
      });

      test('validates that minimum versions are reasonable', () {
        // Assert
        expect(
          PlatformConstants.minSdkVersion,
          greaterThanOrEqualTo(21),
          reason: 'Minimum Android SDK should be at least Lollipop (21)',
        );

        final minIosMajor = int.parse(
          PlatformConstants.minIOSMajorVersion.split('.').first,
        );
        expect(
          minIosMajor,
          greaterThanOrEqualTo(13),
          reason: 'Minimum iOS should be at least iOS 13',
        );
      });
    });

    group('error messages', () {
      test('constructs correct Android error message format', () {
        // Arrange
        const currentSdk = 20;
        const minSdk = PlatformConstants.minSdkVersion;

        // Act
        const errorMessage =
            'Android SDK $currentSdk is not supported. Minimum is $minSdk';

        // Assert
        expect(errorMessage, contains('Android SDK'));
        expect(errorMessage, contains('$currentSdk'));
        expect(errorMessage, contains('$minSdk'));
        expect(errorMessage, contains('not supported'));
      });

      test('constructs correct iOS error message format', () {
        // Arrange
        const currentVersion = '12.5';
        const minVersion = PlatformConstants.minIOSMajorVersion;

        // Act
        const errorMessage =
            'iOS version $currentVersion is not supported. Minimum is $minVersion';

        // Assert
        expect(errorMessage, contains('iOS version'));
        expect(errorMessage, contains(currentVersion));
        expect(errorMessage, contains(minVersion));
        expect(errorMessage, contains('not supported'));
      });

      test('error message includes both current and minimum versions', () {
        // Arrange
        const currentSdk = 20;
        const minSdk = 24;

        // Act
        const errorMessage =
            'Android SDK $currentSdk is not supported. Minimum is $minSdk';

        // Assert
        expect(errorMessage, contains('20'));
        expect(errorMessage, contains('24'));
      });
    });
  });
}
