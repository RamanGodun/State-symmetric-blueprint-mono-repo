/// Test constants for unit tests
library;

import 'package:shared_core_modules/src/shared_contracts/auth/auth_snapshot.dart'
    show AuthSession;

class TestConstants {
  TestConstants._();

  // Delays for async operations
  static const Duration shortDelay = Duration(milliseconds: 100);
  static const Duration mediumDelay = Duration(milliseconds: 300);
  static const Duration longDelay = Duration(milliseconds: 500);
  static const int mediumDelayMs = 300;

  // Email validation test cases
  static const String validEmail = 'test@example.com';
  static const String validEmail2 = 'user@test.com';
  static const String invalidEmail = 'invalid.email';
  static const String emptyString = '';

  // Password validation test cases
  static const String validPassword = 'Password123!';
  static const String validPassword2 = 'SecurePass456!';
  static const String weakPassword = '123';

  // Test user credentials (legacy - kept for compatibility)
  static const String testEmail = 'test@example.com';
  static const String testPassword = 'password123';
  static const String testName = 'Test User';
  static const String testUserId = 'test-user-id-123';

  // Test error messages
  static const String testErrorMessage = 'Test error message';
  static const String networkErrorMessage = 'Network error';
  static const String authErrorMessage = 'Authentication failed';

  // Test URLs and paths
  static const String testApiUrl = 'https://api.test.com';
  static const String testImageUrl = 'https://test.com/image.png';

  // Auth session test cases
  static const AuthSession authenticatedSession = AuthSession(
    uid: 'test-user-id-123',
    email: 'test@example.com',
    emailVerified: true,
    isAnonymous: false,
  );

  static const AuthSession unauthenticatedSession = AuthSession(
    uid: null,
    email: null,
    emailVerified: false,
    isAnonymous: true,
  );

  static const AuthSession unverifiedSession = AuthSession(
    uid: 'unverified-user-id',
    email: 'unverified@example.com',
    emailVerified: false,
    isAnonymous: false,
  );
}
