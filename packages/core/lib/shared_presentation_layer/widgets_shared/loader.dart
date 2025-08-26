import 'dart:io' show Platform;
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 🔄 [AppLoader] — cross-platform activity indicator with customization.
///    used for:
///     - showing loader during bootstrap (wrapInMaterialApp = true)
///     - loading states in UI (wrapInMaterialApp = false)
//
final class AppLoader extends StatelessWidget {
  ///---------------------------------------
  const AppLoader({
    super.key,
    this.wrapInMaterialApp = false,
    this.size = 24.0,
    this.strokeWidth = 2.8,
    this.cupertinoRadius = 10.0,
    this.cupertinoAnimating = true,
    this.color,
    this.semanticsLabel,
    this.alignment = Alignment.center,
  });

  ///  Whether to wrap with [MaterialApp]
  final bool wrapInMaterialApp;

  /// Loader size (for Material spinner).
  final double size;

  /// Thickness of the loader stroke (Material only).
  final double strokeWidth;

  /// Radius for Cupertino spinner.
  final double cupertinoRadius;

  /// Whether the indicator is active (Cupertino only).
  final bool cupertinoAnimating;

  /// Color override (both platforms).
  final Color? color;

  /// Optional semantic label.
  final String? semanticsLabel;

  /// Custom alignment.
  final Alignment alignment;

  //

  @override
  Widget build(BuildContext context) {
    //
    final isCupertino = Platform.isIOS || Platform.isMacOS;
    final colorScheme = context.colorScheme;
    final primaryColor = color ?? colorScheme.primary;

    return Align(
      alignment: alignment,
      child: isCupertino
          ? CupertinoActivityIndicator(
              radius: cupertinoRadius,
              animating: cupertinoAnimating,
              color: color ?? primaryColor,
            )
          : Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: colorScheme.surface.withOpacity(0.08),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withOpacity(0.05),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: CircularProgressIndicator(
                strokeWidth: strokeWidth,
                color: color ?? primaryColor,
                semanticsLabel: semanticsLabel,
              ),
            ),
    );
  }
}
