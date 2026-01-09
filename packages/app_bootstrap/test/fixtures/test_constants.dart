/// Test constants and sample data for app_bootstrap package tests
library;

/// Common test constants used across multiple test files
class TestConstants {
  const TestConstants._();

  // Platform version constants
  static const androidSdk24 = 24; // Minimum supported
  static const androidSdk23 = 23; // Below minimum
  static const androidSdk33 = 33; // Above minimum

  static const iosVersion15 = '15.0'; // Minimum supported
  static const iosVersion14 = '14.9'; // Below minimum
  static const iosVersion16 = '16.2'; // Above minimum
  static const iosVersion17 = '17.0.1'; // Above minimum with patch

  // Environment file names
  static const envDevFileName = '.env.dev';
  static const envStagingFileName = '.env.staging';
  static const envProdFileName = '.env.prod';

  // Flavor names
  static const flavorDevName = 'Development';
  static const flavorStagingName = 'Staging';
  static const flavorProductionName = 'Production';

  // Delay constants for async tests
  static const shortDelayMs = 50;
  static const mediumDelayMs = 100;
  static const longDelayMs = 500;
}
