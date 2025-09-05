import 'package:flutter/material.dart';

/// 🧩 [ThemeProps] — InheritedWidget for providing theme configuration to the subtree.
///    - Makes [theme], [darkTheme], and [themeMode] available to all descendant widgets via context.
///    - Ensures that only widgets depending on these properties rebuild when they change.
///    - Used for optimizing theme-dependent UI and for easy context access.
//
class ThemeProps extends InheritedWidget {
  ///-------------------------------------------
  const ThemeProps({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
    required super.child,
    super.key,
  });

  /// Current (light) [ThemeData]
  final ThemeData theme;

  /// Current [ThemeData] for dark mode
  final ThemeData darkTheme;

  /// [ThemeMode] (light/dark/system)
  final ThemeMode themeMode;

  /// Gets the nearest [ThemeProps] instance from the widget tree.
  /// Throws if not found (should always be present if used correctly).
  static ThemeProps of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ThemeProps>()!;

  @override
  bool updateShouldNotify(covariant ThemeProps oldWidget) =>
      theme != oldWidget.theme ||
      darkTheme != oldWidget.darkTheme ||
      themeMode != oldWidget.themeMode;

  //
}

/*

 Example usage:
  ThemeProps.of(context).theme

 */
