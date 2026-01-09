import 'package:flutter/material.dart'
    show Color, FontStyle, FontWeight, TextStyle;

/// 🎨 [TextStyleX] — Utilities to modify [TextStyle] fluently
/// ✅ Enables fluent, chainable style adjustments:
//
extension TextStyleX on TextStyle {
  ///-----------------------------

  /// 🏋️ Sets font weight
  TextStyle withWeight(FontWeight weight) => copyWith(fontWeight: weight);

  /// 🔠 Sets font size
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// 🎨 Sets font color
  TextStyle withColor(Color color) => copyWith(color: color);

  /// 🔡 Sets letter spacing
  TextStyle withSpacing(double spacing) => copyWith(letterSpacing: spacing);

  /// 🔤 Sets font family
  TextStyle withFont(String family) => copyWith(fontFamily: family);

  /// 📏 Enables italic style
  TextStyle italic() => copyWith(fontStyle: FontStyle.italic);

  /// ⬛ Makes font bold
  TextStyle bold() => copyWith(fontWeight: FontWeight.bold);

  //
}
