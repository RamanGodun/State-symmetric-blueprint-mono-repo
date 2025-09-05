// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:core/src/base_modules/animations/module_core/animation__engine.dart';
import 'package:core/src/base_modules/animations/overlays_animation/animation_wrapper/animated_overlay_shell.dart';
import 'package:core/src/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/src/base_modules/overlays/core/enums_for_overlay_module.dart';
import 'package:core/src/base_modules/overlays/overlays_presentation/overlay_presets/overlay_preset_props.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/_app_constants.dart';
import 'package:core/src/base_modules/ui_design/ui_constants/app_colors.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/blur_wrapper.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/box_decorations/_box_decorations_factory.dart';
import 'package:core/src/base_modules/ui_design/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/src/utils_shared/extensions/extension_on_widget/_widget_x.dart';
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
              horizontal: AppSpacing.p16,
              vertical: AppSpacing.p10,
            ),
            decoration: BoxDecorationFactory.iosCard(isDark: isDark),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: color, size: 22),
                const SizedBox(width: AppSpacing.xxxs),
                TextWidget(message, TextType.titleSmall, color: color),
              ],
            ),
          ),
        ).withPaddingHorizontal(AppSpacing.xl),
      ),
    );
  }

  //
}
