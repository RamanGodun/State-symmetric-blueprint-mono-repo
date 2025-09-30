/// 💲 [NumFormatX] — Extension for formatting numerical values (currency, percentages, etc.)
/// ✅ Adds formatting helpers for display-friendly output
//
extension NumFormatX on num {
  ///----------------------

  /// 💰 Converts number to currency string (e.g. `1234.5` → `₴1234.50`)
  String toCurrency({String symbol = '₴'}) => '$symbol${toStringAsFixed(2)}';

  /// 📉 Converts to percentage string (e.g. `0.25` → `25%`)
  String toPercent({int decimals = 0}) =>
      '${(this * 100).toStringAsFixed(decimals)}%';

  /// 🔢 Adds thousand separators (e.g. `1234567` → `1,234,567`)
  String withThousandsSeparator({String separator = ','}) {
    final parts = toStringAsFixed(0).split('');
    final buffer = StringBuffer();
    for (var i = 0; i < parts.length; i++) {
      final index = parts.length - i;
      buffer.write(parts[i]);
      if (index > 1 && index % 3 == 1 && i != parts.length - 1) {
        buffer.write(separator);
      }
    }
    return buffer.toString();
  }

  /// 🧪 Example: 1250000 → ₴1,250,000.00
  String toPrettyCurrency({String symbol = '₴'}) =>
      '$symbol${withThousandsSeparator()}.${(this % 1).toStringAsFixed(2).split('.')[1]}';

  //
}
