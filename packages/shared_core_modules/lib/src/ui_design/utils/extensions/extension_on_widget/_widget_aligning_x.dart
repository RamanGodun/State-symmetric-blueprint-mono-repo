part of 'widget_x.dart';

/// 🎯 [WidgetAlignX] — Easily align widgets in common positions
//
extension WidgetAlignX on Widget {
  ///--------------------------

  /// 🧭 Aligns widget with given [Alignment]
  Widget aligned(Alignment alignment) =>
      Align(alignment: alignment, child: this);

  /// 🎯 Shortcut: Centers the widget
  Widget centered() => Center(child: this);

  /// 🎯 Aligns to center-left
  Widget centerLeft() => aligned(Alignment.centerLeft);

  /// 🎯 Aligns to center-right
  Widget centerRight() => aligned(Alignment.centerRight);

  /// 🔼 Aligns to top-center
  Widget topCenter() => aligned(Alignment.topCenter);

  /// 🔽 Aligns to bottom-center
  Widget bottomCenter() => aligned(Alignment.bottomCenter);

  //
}
