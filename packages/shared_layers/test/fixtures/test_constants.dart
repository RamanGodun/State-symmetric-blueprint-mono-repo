/// Test constants and sample data for shared_layers_and_utils package tests
library;

/// Common test constants used across multiple test files
class TestConstants {
  const TestConstants._();

  // Valid test data
  static const validEmail = 'test@example.com';
  static const validEmail2 = 'another.user@domain.org';
  static const validName = 'Test User';
  static const validName2 = 'John Doe';
  static const validId = 'test-id-123';
  static const validId2 = 'test-id-456';

  // Invalid test data
  static const invalidEmail = 'not-an-email';
  static const emptyString = '';
  static const whitespaceString = '   ';

  // Numeric values
  static const testInt = 42;
  static const testDouble = 3.14;
  static const testNegative = -1;
  static const testZero = 0;
  static const testLargeNumber = 1234567;
  static const testDecimal = 1234.56;

  // Timing
  static const shortDelayMs = 50;
  static const mediumDelayMs = 100;
  static const longDelayMs = 500;

  // Currency
  static const currencySymbol = '₴';
  static const currencySymbolUSD = r'$';
  static const currencySymbolEUR = '€';

  // User data
  static const testUserId = 'user-123';
  static const testUserEmail = 'john.doe@example.com';
  static const testUserName = 'John Doe';
  static const testProfileImage = 'https://example.com/avatar.jpg';
  static const testPoints = 100;
  static const testRank = 5;
}
