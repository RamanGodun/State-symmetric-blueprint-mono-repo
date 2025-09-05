part of '_context_extensions.dart';

/// 🧩 [OtherContextX] — Miscellaneous helpers on [BuildContext]
//
extension OtherContextX on BuildContext {
  ///---------------------------------
  //
  /// ⌨️ Unfocus current input field and hides keyboard
  void unfocusKeyboard() => FocusScope.of(this).unfocus();
  //
}
