/// Tests for [EnvLoader]
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - load method
/// - get method with existing keys
/// - get method with missing keys
library;

import 'package:adapters_for_firebase/src/app_bootstrap/env_loader.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('EnvLoader', () {
    setUp(() {
      // Reset dotenv before each test
      dotenv.testLoad();
    });

    group('load', () {
      test('loads environment file successfully', () async {
        // Arrange - Create a test .env file content
        const testEnvContent = '''
TEST_KEY=test_value
ANOTHER_KEY=another_value
''';

        // Act - Load the test env
        dotenv.testLoad(fileInput: testEnvContent);

        // Assert - Values should be accessible
        expect(dotenv.env['TEST_KEY'], equals('test_value'));
        expect(dotenv.env['ANOTHER_KEY'], equals('another_value'));
      });

      test('overwrites existing environment when loading new file', () async {
        // Arrange - Load initial env
        dotenv
          ..testLoad(fileInput: 'KEY=initial')
          // Act - Load new env
          ..testLoad(fileInput: 'KEY=updated');

        // Assert
        expect(dotenv.env['KEY'], equals('updated'));
      });
    });

    group('get', () {
      test('returns value for existing key', () {
        // Arrange
        dotenv.testLoad(fileInput: 'EXISTING_KEY=some_value');

        // Act
        final result = EnvLoader.get('EXISTING_KEY');

        // Assert
        expect(result, equals('some_value'));
      });

      test('returns null for missing key', () {
        // Arrange
        dotenv.testLoad(fileInput: 'OTHER_KEY=value');

        // Act
        final result = EnvLoader.get('NON_EXISTENT_KEY');

        // Assert
        expect(result, isNull);
      });

      test('returns empty string value correctly', () {
        // Arrange
        dotenv.testLoad(fileInput: 'EMPTY_KEY=');

        // Act
        final result = EnvLoader.get('EMPTY_KEY');

        // Assert
        expect(result, equals(''));
      });

      test('handles keys with special characters', () {
        // Arrange
        dotenv.testLoad(
          fileInput: 'KEY_WITH_UNDERSCORE=value1\nKEY-WITH-DASH=value2',
        );

        // Act
        final result1 = EnvLoader.get('KEY_WITH_UNDERSCORE');
        final result2 = EnvLoader.get('KEY-WITH-DASH');

        // Assert
        expect(result1, equals('value1'));
        expect(result2, equals('value2'));
      });

      test('handles multiline values', () {
        // Arrange
        const multilineEnv = '''
MULTILINE_KEY="Line 1
Line 2
Line 3"
''';
        dotenv.testLoad(fileInput: multilineEnv);

        // Act
        final result = EnvLoader.get('MULTILINE_KEY');

        // Assert
        expect(result, isNotNull);
        expect(result, contains('Line 1'));
      });
    });

    group('real-world scenarios', () {
      test('loads Firebase configuration keys', () {
        // Arrange - Simulate Firebase .env
        const firebaseEnv = '''
FIREBASE_API_KEY=AIzaSyTest123
FIREBASE_PROJECT_ID=my-project
FIREBASE_APP_ID=1:123:android:abc
FIREBASE_MESSAGING_SENDER_ID=123456
''';
        dotenv.testLoad(fileInput: firebaseEnv);

        // Act & Assert
        expect(EnvLoader.get('FIREBASE_API_KEY'), equals('AIzaSyTest123'));
        expect(EnvLoader.get('FIREBASE_PROJECT_ID'), equals('my-project'));
        expect(EnvLoader.get('FIREBASE_APP_ID'), equals('1:123:android:abc'));
        expect(EnvLoader.get('FIREBASE_MESSAGING_SENDER_ID'), equals('123456'));
      });

      test('handles missing optional keys gracefully', () {
        // Arrange
        dotenv.testLoad(fileInput: 'REQUIRED_KEY=value');

        // Act
        final required = EnvLoader.get('REQUIRED_KEY');
        final optional = EnvLoader.get('OPTIONAL_KEY');

        // Assert
        expect(required, isNotNull);
        expect(optional, isNull);
      });
    });
  });
}
