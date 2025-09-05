part of '_widget_x.dart';

/// 🟦 [BorderRadiusX] — Adds convenient border radius wrapping to widgets
/// ✅ Wraps widget with [ClipRRect] and configurable corner radius
//
extension BorderRadiusX on Widget {
  ///------------------------------
  //
  /// 🔲 Applies rounded corners to the widget
  /// - [r] — Radius value (default: 12)
  Widget withRoundedCorners([double r = 12]) =>
      ClipRRect(borderRadius: BorderRadius.circular(r), child: this);
  //
}
