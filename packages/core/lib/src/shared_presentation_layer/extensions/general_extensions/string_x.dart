/// 🔤 [StringX] — Utility extensions for string formatting & casing
//
extension StringX on String {
  ///---------------------

  /// Returns string value if not null and not empty,
  /// otherwise returns provided fallback.
  String orLocale(String fallback) => switch (this) {
    final value when value.isNotEmpty => value,
    _ => fallback,
  };

  /// 🔠 Capitalizes the first letter of the string
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';

  /// 🔠 Capitalizes every word (e.g. for titles)
  String capitalizeWords() =>
      split(' ').map((word) => word.capitalize()).join(' ');

  ///
  String get obscureEmail {
    // split the email into username and domain
    final index = indexOf('@');
    var username = substring(0, index);
    final domain = substring(index + 1);

    // Obscure the username and display only the first and last characters
    username = '${username[0]}****${username[username.length - 1]}';
    return '$username@$domain';
  }

  //
}

////
////

/// 🔤 [NullableStringX] — Utilities for nullable strings
//
extension NullableStringX on String? {
  ///---------------------

  /// Returns string value if not null and not empty,
  /// otherwise returns provided fallback.
  String orLocale(String fallback) => switch (this) {
    final value? when value.isNotEmpty => value,
    _ => fallback,
  };

  //
}
