// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart'
    show
        Align,
        BuildContext,
        Container,
        EdgeInsets,
        FractionalOffset,
        Icon,
        IconData,
        MainAxisSize,
        Row,
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
        ThemeXOnContext,
        WidgetPaddingX;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

/// 🪧 [IOSBanner] — Glass-style animated system banner (macOS-like)
/// - Fade + scale animation via [AnimationEngine]
/// - Glassmorphism with dynamic shadows and adaptive border
/// - Fully respects current theme (light/dark)
//
final class IOSBanner extends StatelessWidget {
  ///---------------------------------------
  const IOSBanner({
    required this.message,
    required this.icon,
    required this.engine,
    required this.props,
    super.key,
  });

  final String message;
  final IconData icon;
  final OverlayUIPresetProps props;
  final AnimationEngine engine;
  //

  @override
  Widget build(BuildContext context) {
    //
    final isDark = context.isDarkMode;
    final color = isDark ? AppColors.white : AppColors.black;

    return Align(
      alignment: const FractionalOffset(0.5, 0.25),
      child: AnimatedOverlayShell(
        engine: engine,
        child: BlurContainer(
          overlayType: ShowAs.banner,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.xxs,
              vertical: AppSpacing.xxxs,
            ),
            decoration: BoxDecorationFactory.iosCard(isDark: isDark),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: AppSpacing.xxxs),
                TextWidget(message, TextType.bodyMedium, color: color),
              ],
            ),
          ),
        ).withPaddingHorizontal(AppSpacing.xl),
      ),
    );
  }

  //
}
