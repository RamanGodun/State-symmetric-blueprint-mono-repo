// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart'
    show
        Align,
        BuildContext,
        Container,
        FadeTransition,
        Flexible,
        FractionalOffset,
        Icon,
        IconData,
        MainAxisAlignment,
        MainAxisSize,
        Row,
        SafeArea,
        SizedBox,
        StatelessWidget,
        TextOverflow,
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
        UIConstants;
import 'package:shared_widgets/public_api/text_widgets.dart';

/// 🪧 [AndroidBanner] — Android-style animated banner (Material)
/// - Appears at the top with the same style as dialogs
/// - Shared decoration logic with [BoxDecorationFactory.androidCard]
/// - Applies fade/scale or slide/fade/scale animation via [FadeTransition]
//
final class AndroidBanner extends StatelessWidget {
  ///───────────────────────────────────────────
  const AndroidBanner({
    required this.message,
    required this.icon,
    required this.props,
    required this.engine,
    this.useBlur = true,
    super.key,
  });
  //
  final String message;
  final IconData icon;
  final OverlayUIPresetProps props;
  final AnimationEngine engine;
  final bool useBlur;

  //

  @override
  Widget build(BuildContext context) {
    //
    final isDark = context.isDarkMode;
    final color = isDark ? AppColors.white : AppColors.black;
    final decoration = BoxDecorationFactory.androidCard(isDark: isDark);

    return SafeArea(
      child: Align(
        alignment: const FractionalOffset(0.5, 0.25),
        child: AnimatedOverlayShell(
          engine: engine,
          child: Container(
            decoration: decoration,
            padding: UIConstants.cardPaddingV26,
            child: BlurContainer(
              overlayType: ShowAs.banner,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(icon, color: color),
                  const SizedBox(width: AppSpacing.xxxm),
                  Flexible(
                    child: TextWidget(
                      message,
                      TextType.bodyMedium,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      isTextOnFewStrings: true,
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
}
