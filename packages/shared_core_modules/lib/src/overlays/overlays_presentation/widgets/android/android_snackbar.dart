// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:flutter/material.dart'
    show
        Align,
        Alignment,
        BuildContext,
        Container,
        EdgeInsets,
        Expanded,
        Icon,
        IconData,
        Padding,
        Row,
        SafeArea,
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
        BoxDecorationFactory,
        ContextPaddingX,
        ThemeXOnContext,
        UIConstants;
import 'package:shared_widgets/public_api/text_widgets.dart';

/// 🍞 [AndroidSnackbarCard] — Native-like Android snackbar with M3 style
/// - Mimics Material Design 3 snackbar spec: minimal, flat, unobtrusive
/// - Appears at the bottom with slide+fade animation
//
final class AndroidSnackbarCard extends StatelessWidget {
  ///─────────────────────────────────────────────────
  const AndroidSnackbarCard({
    required this.message,
    required this.props,
    required this.engine,
    super.key,
    this.icon,
  });
  //
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
    final decoration = BoxDecorationFactory.androidCard(isDark: isDark);

    return SafeArea(
      minimum: const EdgeInsets.only(bottom: AppSpacing.xxxs),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: AnimatedOverlayShell(
          engine: engine,
          child: Container(
            margin: EdgeInsets.only(
              bottom: context.bottomPadding,
              right: AppSpacing.xxxs,
              left: AppSpacing.xxxs,
            ),
            padding: UIConstants.cardPaddingV26,
            decoration: decoration,
            child: Row(
              children: [
                if (icon != null)
                  Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.xxxs),
                    child: Icon(icon, size: 20, color: color),
                  ),
                Expanded(
                  child: TextWidget(
                    message,
                    TextType.bodyMedium,
                    isTextOnFewStrings: true,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                // Optional action (e.g., UNDO)
                // TextButton(
                //   onPressed: () {},
                //   child: TextWidget('UNDO', TextType.error),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //
}
