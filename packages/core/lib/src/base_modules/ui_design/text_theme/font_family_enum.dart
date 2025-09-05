//
// ignore_for_file: public_member_api_docs

part of 'text_theme_factory.dart';

/// 🔤 [AppFontFamily] — Enhanced enum for supported fonts (match pubspec.yaml names)
/// 🧩 Can be extended to support Google Fonts in future
//
enum AppFontFamily {
  ///-------------

  inter('Inter'),
  montserrat('Montserrat');
  // sfPro('SFProText');
  // aeonik('Aeonik'),
  // poppins('Poppins');
  // google => custom dynamic font loading could go here later

  const AppFontFamily(this.value);

  ///
  final String value;

  //
}
