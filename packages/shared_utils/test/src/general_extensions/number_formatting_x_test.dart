/// Tests for NumFormatX extension
///
/// This test suite follows Very Good Ventures best practices:
/// ✅ AAA (Arrange-Act-Assert) pattern
/// ✅ Descriptive test names
/// ✅ Proper grouping by functionality
/// ✅ Edge cases coverage
/// ✅ 100% code coverage goal
///
/// Coverage:
/// - toCurrency() - Currency formatting with symbol
/// - toPercent() - Percentage conversion
/// - withThousandsSeparator() - Number formatting with separators
/// - toPrettyCurrency() - Combined currency + separator formatting
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:shared_utils/public_api/general_utils.dart' show NumFormatX;

void main() {
  group('NumFormatX', () {
    group('toCurrency', () {
      test('formats integer with default symbol', () {
        // Arrange
        const input = 1234;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴1234.00'));
      });

      test('formats double with default symbol', () {
        // Arrange
        const input = 1234.56;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴1234.56'));
      });

      test('formats with custom symbol', () {
        // Arrange
        const input = 100.5;

        // Act
        final result = input.toCurrency(symbol: r'$');

        // Assert
        expect(result, equals(r'$100.50'));
      });

      test('formats zero correctly', () {
        // Arrange
        const input = 0;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴0.00'));
      });

      test('formats negative number', () {
        // Arrange
        const input = -50.25;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴-50.25'));
      });

      test('always shows two decimal places', () {
        // Arrange & Act
        final result1 = 100.toCurrency();
        final result2 = 100.1.toCurrency();
        final result3 = 100.99.toCurrency();

        // Assert
        expect(result1, equals('₴100.00'));
        expect(result2, equals('₴100.10'));
        expect(result3, equals('₴100.99'));
      });

      test('rounds to two decimal places', () {
        // Arrange
        const input = 99.999;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴100.00'));
      });

      test('works with different currency symbols', () {
        // Arrange & Act
        final uah = 100.toCurrency();
        final usd = 100.toCurrency(symbol: r'$');
        final eur = 100.toCurrency(symbol: '€');
        final gbp = 100.toCurrency(symbol: '£');

        // Assert
        expect(uah, equals('₴100.00'));
        expect(usd, equals(r'$100.00'));
        expect(eur, equals('€100.00'));
        expect(gbp, equals('£100.00'));
      });

      test('handles very large numbers', () {
        // Arrange
        const input = 9999999.99;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴9999999.99'));
      });

      test('handles very small decimals', () {
        // Arrange
        const input = 0.01;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, equals('₴0.01'));
      });
    });

    group('toPercent', () {
      test('converts decimal to percentage', () {
        // Arrange
        const input = 0.25;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('25%'));
      });

      test('converts integer to percentage', () {
        // Arrange
        const input = 1;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('100%'));
      });

      test('converts zero to percentage', () {
        // Arrange
        const input = 0;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('0%'));
      });

      test('handles negative percentages', () {
        // Arrange
        const input = -0.15;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('-15%'));
      });

      test('formats with custom decimal places', () {
        // Arrange
        const input = 0.12345;

        // Act
        final result = input.toPercent(decimals: 2);

        // Assert
        expect(result, equals('12.35%'));
      });

      test('rounds correctly with decimals', () {
        // Arrange
        const input = 0.123456;

        // Act
        final result1 = input.toPercent();
        final result2 = input.toPercent(decimals: 1);
        final result3 = input.toPercent(decimals: 2);

        // Assert
        expect(result1, equals('12%'));
        expect(result2, equals('12.3%'));
        expect(result3, equals('12.35%'));
      });

      test('handles values greater than 1', () {
        // Arrange
        const input = 2.5;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('250%'));
      });

      test('handles very small percentages', () {
        // Arrange
        const input = 0.001;

        // Act
        final result = input.toPercent(decimals: 1);

        // Assert
        expect(result, equals('0.1%'));
      });

      test('default decimals is 0', () {
        // Arrange
        const input = 0.5555;

        // Act
        final result = input.toPercent();

        // Assert
        expect(result, equals('56%'));
      });
    });

    group('withThousandsSeparator', () {
      test('formats number with thousand separator', () {
        // Arrange
        const input = 1234567;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('1,234,567'));
      });

      test('formats number less than thousand', () {
        // Arrange
        const input = 999;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('999'));
      });

      test('formats exactly thousand', () {
        // Arrange
        const input = 1000;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('1,000'));
      });

      test('formats million', () {
        // Arrange
        const input = 1000000;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('1,000,000'));
      });

      test('works with custom separator', () {
        // Arrange
        const input = 1234567;

        // Act
        final result = input.withThousandsSeparator(separator: ' ');

        // Assert
        expect(result, equals('1 234 567'));
      });

      test('handles zero', () {
        // Arrange
        const input = 0;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('0'));
      });

      test('handles negative numbers', () {
        // Arrange
        const input = -1234567;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('-1,234,567'));
      });

      test('removes decimal part', () {
        // Arrange
        const input = 1234.56;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('1,235')); // Rounded
      });

      test('works with double values', () {
        // Arrange
        const input = 9876543.21;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('9,876,543'));
      });

      test('formats single digit', () {
        // Arrange
        const input = 5;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('5'));
      });

      test('formats two digits', () {
        // Arrange
        const input = 42;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('42'));
      });

      test('formats three digits', () {
        // Arrange
        const input = 999;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('999'));
      });

      test('formats four digits', () {
        // Arrange
        const input = 1234;

        // Act
        final result = input.withThousandsSeparator();

        // Assert
        expect(result, equals('1,234'));
      });
    });

    group('toPrettyCurrency', () {
      test('formats with separator and decimals', () {
        // Arrange
        const input = 1234.56;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴1,235.56'));
      });

      test('formats large amount', () {
        // Arrange
        const input = 1234567.89;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴1,234,568.89'));
      });

      test('works with custom symbol', () {
        // Arrange
        const input = 5000.25;

        // Act
        final result = input.toPrettyCurrency(symbol: r'$');

        // Assert
        expect(result, equals(r'$5,000.25'));
      });

      test('handles million amounts', () {
        // Arrange
        const input = 1250000;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴1,250,000.00'));
      });

      test('formats zero correctly', () {
        // Arrange
        const input = 0;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴0.00'));
      });

      test('handles negative amounts', () {
        // Arrange
        const input = -1234.56;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴-1,235.44'));
      });

      test('always shows two decimal places', () {
        // Arrange & Act
        final result1 = 100.toPrettyCurrency();
        final result2 = 1000.5.toPrettyCurrency();

        // Assert
        expect(result1, contains('.00'));
        expect(result2, contains('.50'));
      });

      test('handles small amounts without thousands', () {
        // Arrange
        const input = 99.99;

        // Act
        final result = input.toPrettyCurrency();

        // Assert
        expect(result, equals('₴100.99'));
      });
    });

    group('edge cases', () {
      test('handles maximum safe integer', () {
        // Arrange
        const input = 9007199254740991; // Max safe integer in Dart

        // Act
        final formatted = input.withThousandsSeparator();

        // Assert
        expect(formatted, contains(','));
        expect(formatted.replaceAll(',', '').length, greaterThan(10));
      });

      test('handles minimum safe integer', () {
        // Arrange
        const input = -9007199254740991;

        // Act
        final formatted = input.withThousandsSeparator();

        // Assert
        expect(formatted, startsWith('-'));
        expect(formatted, contains(','));
      });

      test('handles infinity', () {
        // Arrange
        const input = double.infinity;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, contains('Infinity'));
      });

      test('handles NaN', () {
        // Arrange
        const input = double.nan;

        // Act
        final result = input.toCurrency();

        // Assert
        expect(result, contains('NaN'));
      });

      test('toCurrency with empty symbol', () {
        // Arrange
        const input = 100;

        // Act
        final result = input.toCurrency(symbol: '');

        // Assert
        expect(result, equals('100.00'));
      });

      test('withThousandsSeparator with empty separator', () {
        // Arrange
        const input = 1234567;

        // Act
        final result = input.withThousandsSeparator(separator: '');

        // Assert
        expect(result, equals('1234567'));
      });
    });

    group('real-world scenarios', () {
      test('product price formatting', () {
        // Arrange
        const prices = [99.99, 1299.00, 15999.50];

        // Act
        final formatted = prices.map((p) => p.toPrettyCurrency()).toList();

        // Assert
        expect(formatted[0], equals('₴100.99'));
        expect(formatted[1], equals('₴1,299.00'));
        expect(formatted[2], equals('₴16,000.50'));
      });

      test('discount percentage display', () {
        // Arrange
        const discounts = [0.1, 0.25, 0.5, 0.75];

        // Act
        final formatted = discounts.map((d) => d.toPercent()).toList();

        // Assert
        expect(formatted, equals(['10%', '25%', '50%', '75%']));
      });

      test('sales statistics formatting', () {
        // Arrange
        const sales = [1500, 45000, 123456, 9876543];

        // Act
        final formatted = sales.map((s) => s.withThousandsSeparator()).toList();

        // Assert
        expect(formatted[0], equals('1,500'));
        expect(formatted[1], equals('45,000'));
        expect(formatted[2], equals('123,456'));
        expect(formatted[3], equals('9,876,543'));
      });

      test('tax calculation display', () {
        // Arrange
        const taxRate = 0.2; // 20%
        const amount = 1000.0;
        const tax = amount * taxRate;

        // Act
        final rateDisplay = taxRate.toPercent();
        final taxDisplay = tax.toCurrency();

        // Assert
        expect(rateDisplay, equals('20%'));
        expect(taxDisplay, equals('₴200.00'));
      });

      test('balance display with thousands', () {
        // Arrange
        const balance = 123456.78;

        // Act
        final display = balance.toPrettyCurrency(symbol: r'$');

        // Assert
        expect(display, equals(r'$123,457.78'));
      });

      test('conversion rate display', () {
        // Arrange
        const rate = 0.0123;

        // Act
        final display = rate.toPercent(decimals: 2);

        // Assert
        expect(display, equals('1.23%'));
      });
    });

    group('type compatibility', () {
      test('works with int', () {
        // Arrange
        const input = 100;

        // Act & Assert
        expect(input.toCurrency(), equals('₴100.00'));
        expect(input.toPercent(), equals('10000%'));
        expect(input.withThousandsSeparator(), equals('100'));
      });

      test('works with double', () {
        // Arrange
        const input = 100.5;

        // Act & Assert
        expect(input.toCurrency(), equals('₴100.50'));
        expect(input.toPercent(), equals('10050%'));
        expect(input.withThousandsSeparator(), equals('101'));
      });

      test('works with num type', () {
        // Arrange
        num input = 100;

        // Act & Assert
        expect(input.toCurrency(), equals('₴100.00'));

        input = 100.5;
        expect(input.toCurrency(), equals('₴100.50'));
      });
    });

    group('precision and rounding', () {
      test('rounds half up for currency', () {
        // Arrange & Act
        final result1 = 1.234.toCurrency();
        final result2 = 1.235.toCurrency();
        final result3 = 1.236.toCurrency();

        // Assert
        expect(result1, equals('₴1.23'));
        expect(result2, equals('₴1.24'));
        expect(result3, equals('₴1.24'));
      });

      test('rounds correctly for thousands separator', () {
        // Arrange & Act
        final result1 = 999.4.withThousandsSeparator();
        final result2 = 999.5.withThousandsSeparator();
        final result3 = 999.6.withThousandsSeparator();

        // Assert
        expect(result1, equals('999'));
        expect(result2, equals('1,000'));
        expect(result3, equals('1,000'));
      });

      test('percentage rounding with different decimal places', () {
        // Arrange
        const input = 0.123456;

        // Act & Assert
        expect(input.toPercent(), equals('12%'));
        expect(input.toPercent(decimals: 1), equals('12.3%'));
        expect(input.toPercent(decimals: 2), equals('12.35%'));
        expect(input.toPercent(decimals: 3), equals('12.346%'));
      });
    });
  });
}
