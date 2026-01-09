/// Test constants and sample data for core package tests
library;

/// Common test constants used across multiple test files
class TestConstants {
  const TestConstants._();

  // Valid credentials
  static const validEmail = 'test@example.com';
  static const validEmail2 = 'another.user@domain.org';
  static const validPassword = 'Password123!';
  static const validPassword2 = 'SecurePass456!';
  static const validName = 'Test User';
  static const validName2 = 'John Doe';

  // Invalid credentials
  static const invalidEmail = 'not-an-email';
  static const invalidEmailMissingAt = 'test.example.com';
  static const invalidEmailMissingDomain = 'test@';
  static const weakPassword = '123';
  static const emptyPassword = '';
  static const shortName = 'A';
  static const emptyString = '';
  static const whitespaceString = '   ';

  // Edge cases
  static const veryLongEmail =
      'verylongemailaddress@verylongdomainname.verylongtld';
  static const veryLongPassword = r'AVeryLongPassword123!@#$%^&*()';
  // Note: String multiplication not allowed in const, use runtime generation
  static String get veryLongName => 'A' * 100;

  // Special characters
  static const emailWithSpecialChars = 'test+user@example.com';
  static const passwordWithSpecialChars = r'P@ssw0rd!#$%';
  static const nameWithAccents = "Francois O'Brien";

  // UIDs and IDs
  static const testUserId = 'test-user-id-123';
  static const testUserId2 = 'test-user-id-456';
  static const testDocId = 'test-doc-id-789';

  // Numeric values
  static const testInt = 42;
  static const testDouble = 3.14;
  static const testNegative = -1;
  static const testZero = 0;

  // Timing
  static const shortDelayMs = 50;
  static const mediumDelayMs = 100;
  static const longDelayMs = 500;
}
