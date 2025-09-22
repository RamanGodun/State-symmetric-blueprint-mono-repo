part of '_context_extensions.dart';

/// 🧩 [OtherContextX] — Miscellaneous helpers on [BuildContext]
//
extension OtherContextX on BuildContext {
  ///---------------------------------
  //
  /// ⌨️ Unfocus current input field and hides keyboard
  // void unfocusKeyboard() => FocusScope.of(this).unfocus();
  BuildContext unfocusKeyboard() {
    FocusScope.of(this).unfocus();
    return this;
  }

  //
  /// 🔀 Request focus on a given FocusNode
  BuildContext requestFocus(FocusNode node) {
    FocusScope.of(this).requestFocus(node);
    return this;
  }

  //
  /// Returns a VoidCallback that requests focus (nice for onEditingComplete)
  VoidCallback focusNext(FocusNode node) =>
      () => requestFocus(node);
  //
  /// Move focus to the next node via FocusScope traversal
  void nextFocus() => FocusScope.of(this).nextFocus();
  //
  /// Move focus to the previous node via FocusScope traversal
  void previousFocus() => FocusScope.of(this).previousFocus();
  //
}
