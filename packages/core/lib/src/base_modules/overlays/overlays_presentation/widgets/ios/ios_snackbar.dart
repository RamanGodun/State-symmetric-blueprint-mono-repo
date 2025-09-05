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
import 'package:core/src/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:flutter/material.dart';

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
