// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart';
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/src/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:flutter/material.dart';

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
