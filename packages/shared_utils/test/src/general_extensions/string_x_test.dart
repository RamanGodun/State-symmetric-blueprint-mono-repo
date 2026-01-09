/// Tests for StringX extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - capitalize() - First letter capitalization
/// - capitalizeWords() - Title case
/// - obscureEmail - Email privacy/masking
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart' show StringX;

void main() {
  group('StringX', () {
    group('capitalize', () {
      test('capitalizes first letter of lowercase string', () {
        // Arrange
        const input = 'hello';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('Hello'));
      });

      test('keeps first letter capitalized if already uppercase', () {
        // Arrange
        const input = 'Hello';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('Hello'));
      });

      test('capitalizes first letter of all lowercase string', () {
        // Arrange
        const input = 'flutter';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('Flutter'));
      });

      test('handles single character string', () {
        // Arrange
        const input = 'a';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('A'));
      });

      test('handles empty string', () {
        // Arrange
        const input = '';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals(''));
      });

      test('does not modify rest of string', () {
        // Arrange
        const input = 'hELLO wORLD';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('HELLO wORLD'));
      });

      test('works with numbers at start', () {
        // Arrange
        const input = '123abc';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('123abc'));
      });

      test('works with special characters at start', () {
        // Arrange
        const input = '@hello';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('@hello'));
      });

      test('handles Unicode characters', () {
        // Arrange
        const input = 'über';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('Über'));
      });

      test('handles emoji at start', () {
        // Arrange
        const input = '😀hello';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('😀hello'));
      });
    });

    group('capitalizeWords', () {
      test('capitalizes each word in sentence', () {
        // Arrange
        const input = 'hello world';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello World'));
      });

      test('capitalizes multiple words', () {
        // Arrange
        const input = 'the quick brown fox';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('The Quick Brown Fox'));
      });

      test('handles single word', () {
        // Arrange
        const input = 'hello';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello'));
      });

      test('handles empty string', () {
        // Arrange
        const input = '';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals(''));
      });

      test('handles single space', () {
        // Arrange
        const input = ' ';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals(' '));
      });

      test('preserves multiple spaces between words', () {
        // Arrange
        const input = 'hello  world';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello  World'));
      });

      test('handles leading spaces', () {
        // Arrange
        const input = '  hello world';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('  Hello World'));
      });

      test('handles trailing spaces', () {
        // Arrange
        const input = 'hello world  ';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello World  '));
      });

      test('handles already capitalized words', () {
        // Arrange
        const input = 'Hello World';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello World'));
      });

      test('handles mixed case input', () {
        // Arrange
        const input = 'hELLO wORLD';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('HELLO WORLD'));
      });

      test('handles numbers in words', () {
        // Arrange
        const input = 'hello 123 world';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Hello 123 World'));
      });

      test('handles single character words', () {
        // Arrange
        const input = 'i a m';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('I A M'));
      });

      test('handles Unicode words', () {
        // Arrange
        const input = 'über café naïve';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('Über Café Naïve'));
      });
    });

    group('obscureEmail', () {
      test('obscures standard email correctly', () {
        // Arrange
        const input = 'user@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('u****r@example.com'));
      });

      test('shows first and last character of username', () {
        // Arrange
        const input = 'john@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('j****n@example.com'));
      });

      test('obscures long username', () {
        // Arrange
        const input = 'verylongusername@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('v****e@example.com'));
        expect(result, contains('****'));
      });

      test('obscures short username', () {
        // Arrange
        const input = 'ab@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('a****b@example.com'));
      });

      test('preserves domain unchanged', () {
        // Arrange
        const input = 'user@mail.example.org';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, endsWith('@mail.example.org'));
        expect(result, contains('mail.example.org'));
      });

      test('works with different domains', () {
        // Arrange
        const input1 = 'user@gmail.com';
        const input2 = 'user@yahoo.com';
        const input3 = 'user@company.co.uk';

        // Act
        final result1 = input1.obscureEmail;
        final result2 = input2.obscureEmail;
        final result3 = input3.obscureEmail;

        // Assert
        expect(result1, endsWith('@gmail.com'));
        expect(result2, endsWith('@yahoo.com'));
        expect(result3, endsWith('@company.co.uk'));
      });

      test('works with email containing dots', () {
        // Arrange
        const input = 'john.doe@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('j****e@example.com'));
      });

      test('works with email containing plus', () {
        // Arrange
        const input = 'user+tag@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('u****g@example.com'));
      });

      test('works with email containing numbers', () {
        // Arrange
        const input = 'user123@example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('u****3@example.com'));
      });

      test('always shows exactly 4 asterisks', () {
        // Arrange
        const inputs = [
          'ab@example.com',
          'abc@example.com',
          'abcd@example.com',
          'abcdefgh@example.com',
        ];

        // Act & Assert
        for (final input in inputs) {
          final result = input.obscureEmail;
          expect(result, contains('****'));
          expect('****'.allMatches(result).length, equals(1));
        }
      });

      test('real-world email examples', () {
        // Arrange & Act
        final gmail = 'john.doe@gmail.com'.obscureEmail;
        final corporate = 'employee@company.org'.obscureEmail;
        final tagged = 'user+newsletter@example.com'.obscureEmail;

        // Assert
        expect(gmail, equals('j****e@gmail.com'));
        expect(corporate, equals('e****e@company.org'));
        expect(tagged, equals('u****r@example.com'));
      });
    });

    group('edge cases', () {
      test('capitalize handles whitespace-only string', () {
        // Arrange
        const input = '   ';

        // Act
        final result = input.capitalize();

        // Assert
        expect(result, equals('   '));
      });

      test('capitalizeWords handles only spaces', () {
        // Arrange
        const input = '     ';

        // Act
        final result = input.capitalizeWords();

        // Assert
        expect(result, equals('     '));
      });

      test('obscureEmail with subdomain', () {
        // Arrange
        const input = 'user@mail.example.com';

        // Act
        final result = input.obscureEmail;

        // Assert
        expect(result, equals('u****r@mail.example.com'));
      });

      test('capitalize with very long string', () {
        // Arrange
        final input = 'a' * 1000;

        // Act
        final result = input.capitalize();

        // Assert
        expect(result[0], equals('A'));
        expect(result.length, equals(1000));
      });

      test('capitalizeWords with very long sentence', () {
        // Arrange
        final words = List.generate(100, (i) => 'word$i').join(' ');

        // Act
        final result = words.capitalizeWords();

        // Assert
        expect(result, startsWith('Word0'));
        expect(result.split(' ').length, equals(100));
      });
    });

    group('real-world scenarios', () {
      test('capitalize for form labels', () {
        // Arrange
        const fields = ['email', 'password', 'username', 'firstName'];

        // Act
        final labels = fields.map((f) => f.capitalize()).toList();

        // Assert
        expect(labels, equals(['Email', 'Password', 'Username', 'FirstName']));
      });

      test('capitalizeWords for titles', () {
        // Arrange
        const rawTitles = [
          'getting started with flutter',
          'advanced state management',
          'building responsive UIs',
        ];

        // Act
        final titles = rawTitles.map((t) => t.capitalizeWords()).toList();

        // Assert
        expect(
          titles,
          equals([
            'Getting Started With Flutter',
            'Advanced State Management',
            'Building Responsive UIs',
          ]),
        );
      });

      test('obscureEmail for privacy display', () {
        // Arrange
        const userEmails = [
          'john.doe@gmail.com',
          'alice@company.org',
          'bob+work@example.com',
        ];

        // Act
        final obscured = userEmails.map((e) => e.obscureEmail).toList();

        // Assert
        expect(obscured[0], equals('j****e@gmail.com'));
        expect(obscured[1], equals('a****e@company.org'));
        expect(obscured[2], equals('b****k@example.com'));
      });

      test('capitalize for enum display names', () {
        // Arrange
        const enumValues = ['pending', 'approved', 'rejected'];

        // Act
        final displayNames = enumValues.map((e) => e.capitalize()).toList();

        // Assert
        expect(displayNames, equals(['Pending', 'Approved', 'Rejected']));
      });
    });

    group('chaining operations', () {
      test('capitalize after trimming', () {
        // Arrange
        const input = '  hello  ';

        // Act
        final result = input.trim().capitalize();

        // Assert
        expect(result, equals('Hello'));
      });

      test('capitalizeWords after replacing', () {
        // Arrange
        const input = 'hello_world_example';

        // Act
        final result = input.replaceAll('_', ' ').capitalizeWords();

        // Assert
        expect(result, equals('Hello World Example'));
      });

      test('obscure email after trimming', () {
        // Arrange
        const input = '  user@example.com  ';

        // Act
        final result = input.trim().obscureEmail;

        // Assert
        expect(result, equals('u****r@example.com'));
      });
    });
  });
}
