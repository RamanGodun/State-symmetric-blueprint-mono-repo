/// Test constants and sample data for features_dd_layers package tests
library;

import 'package:shared_layers/public_api/domain_layer_shared.dart';

/// Common test constants used across multiple test files
class TestConstants {
  const TestConstants._();

  // Valid credentials
  static const validEmail = 'test@example.com';
  static const validEmail2 = 'another.user@domain.org';
  static const validPassword = 'Password123!';
  static const validPassword2 = 'SecurePass456!';

  // Invalid credentials
  static const invalidEmail = 'not-an-email';
  static const weakPassword = '123';
  static const emptyString = '';

  // User IDs
  static const testUserId = 'test-user-id-123';
  static const testUserId2 = 'test-user-id-456';

  // User entities
  static const testUserEntity = UserEntity(
    id: testUserId,
    email: validEmail,
    name: 'Test User',
    profileImage: 'https://example.com/avatar.jpg',
    point: 100,
    rank: '5',
  );

  static const testUserEntity2 = UserEntity(
    id: testUserId2,
    email: validEmail2,
    name: 'John Doe',
    profileImage: 'https://example.com/avatar2.jpg',
    point: 200,
    rank: '10',
  );

  // Verification codes
  static const validVerificationCode = '123456';
  static const invalidVerificationCode = '000000';

  // Timing
  static const shortDelayMs = 50;
  static const mediumDelayMs = 100;
  static const longDelayMs = 500;

  // User maps for DTO/Entity conversion
  static const Map<String, Object> testUserMap = {
    'id': testUserId,
    'name': 'Test User',
    'email': validEmail,
    'profileImage': 'https://example.com/avatar.jpg',
    'point': 100,
    'rank': '5',
  };

  // Auth data for profile creation
  static const Map<String, String> testAuthData = {
    'uid': testUserId,
    'name': 'Test User',
    'email': validEmail,
  };
}
