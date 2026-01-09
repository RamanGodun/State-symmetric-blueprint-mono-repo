// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BuildContext,
        Container,
        EdgeInsets,
        Flexible,
        Icon,
        IconData,
        MainAxisSize,
        Row,
        SafeArea,
        SizedBox,
        StatelessWidget,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/animations.dart'
    show AnimatedOverlayShell, AnimationEngine;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show
        AppColors,
        AppSpacing,
        BlurContainer,
        BoxDecorationFactory,
        ContextPaddingX,
        ThemeXOnContext,
        UIConstants;
import 'package:shared_widgets/public_api/text_widgets.dart';

/// 🍎 [IOSToastBubble] — Glass-style toast for iOS/macOS
/// - Consistent with iOS dialog/banner system
/// - Appears briefly above tab bar or bottom edge
//
final class IOSToastBubble extends StatelessWidget {
  /// ───────────────────────────────────────────
  const IOSToastBubble({
    required this.message,
    required this.props,
    required this.engine,
    this.icon,
    super.key,
  });

  final String message;
  final IconData? icon;
  final OverlayUIPresetProps props;
  final AnimationEngine engine;

  //

  @override
  Widget build(BuildContext context) {
    //
    final isDark = context.isDarkMode;
    final color = isDark ? AppColors.white : AppColors.black;
    final decoration = BoxDecorationFactory.iosCard(isDark: isDark);

    return SafeArea(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedOverlayShell(
          engine: engine,
          child: BlurContainer(
            overlayType: ShowAs.snackbar,
            child: Container(
              margin: EdgeInsets.only(bottom: context.bottomPadding),
              padding: UIConstants.cardPadding,
              decoration: decoration,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (icon != null) Icon(icon, color: color, size: 20),
                  if (icon != null) const SizedBox(width: AppSpacing.xxxs),
                  Flexible(
                    child: TextWidget(
                      message,
                      TextType.titleSmall,
                      color: color,
                      isTextOnFewStrings: true,
                      maxLines: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //
}
