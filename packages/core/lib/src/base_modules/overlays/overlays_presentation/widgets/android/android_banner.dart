// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart'
    show AnimatedOverlayShell;
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart'
    show AppSpacing, UIConstants;
import 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/blur_wrapper.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:flutter/material.dart';

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
                      TextType.titleSmall,
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
