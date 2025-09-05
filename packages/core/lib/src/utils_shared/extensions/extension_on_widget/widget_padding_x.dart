part of '_widget_x.dart';

/// 🧩 [WidgetPaddingX] — Fluent widget padding extension
/// ✅ Simplifies padding application with expressive syntax
//
extension WidgetPaddingX on Widget {
  ///----------------------------

  /// 🔲 Apply uniform padding
  Widget withPaddingAll(double value) =>
      Padding(padding: EdgeInsets.all(value), child: this);

  /// ↔️↕️ Apply symmetric horizontal/vertical padding
  Widget withPaddingSymmetric({double h = 0, double v = 0}) => Padding(
    padding: EdgeInsets.symmetric(horizontal: h, vertical: v),
    child: this,
  );

  /// 🔁 Apply custom padding to each side
  Widget withPaddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) => Padding(
    padding: EdgeInsets.only(
      left: left,
      top: top,
      right: right,
      bottom: bottom,
    ),
    child: this,
  );

  /// ↔️ Apply horizontal padding only
  Widget withPaddingHorizontal(double value) => Padding(
    padding: EdgeInsets.symmetric(horizontal: value),
    child: this,
  );

  /// ↕️ Apply vertical padding only
  Widget withPaddingVertical(double value) => Padding(
    padding: EdgeInsets.symmetric(vertical: value),
    child: this,
  );

  /// ⬆️ Apply top padding
  Widget withPaddingTop(double value) => Padding(
    padding: EdgeInsets.only(top: value),
    child: this,
  );

  /// ⬇️ Apply bottom padding
  Widget withPaddingBottom(double value) => Padding(
    padding: EdgeInsets.only(bottom: value),
    child: this,
  );

  /// ⬅️ Apply left padding
  Widget withPaddingLeft(double value) => Padding(
    padding: EdgeInsets.only(left: value),
    child: this,
  );

  /// ➡️ Apply right padding
  Widget withPaddingRight(double value) => Padding(
    padding: EdgeInsets.only(right: value),
    child: this,
  );

  //
}
