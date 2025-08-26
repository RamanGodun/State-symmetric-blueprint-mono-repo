// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/theme/widgets_and_utils/extensions/theme_x.dart';
import 'package:core/utils_shared/timing_control/timing_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// 🔘 [AppTextButton] — minimal, animated text-only button with underline option
//
final class AppTextButton extends StatelessWidget {
  ///-------------------------------------------
  const AppTextButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.foregroundColor,
    this.fontSize = 15,
    this.fontWeight = FontWeight.w200,
    this.isUnderlined = true,
    super.key,
  });
  //
  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Color? foregroundColor;
  final double? fontSize;
  final FontWeight? fontWeight;
  final bool? isUnderlined;

  //

  @override
  Widget build(BuildContext context) {
    //
    final colorScheme = context.colorScheme;
    final effectiveColor = (isEnabled && !isLoading)
        ? (foregroundColor ?? colorScheme.primary)
        : colorScheme.onSurface.withOpacity(0.4);

    return Semantics(
      button: true,
      enabled: isEnabled,
      label: label,
      child: TextButton(
        onPressed: (isEnabled && !isLoading) ? onPressed : null,
        style: TextButton.styleFrom(
          foregroundColor: effectiveColor,
          padding: EdgeInsets.zero,
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          visualDensity: VisualDensity.compact,
        ),
        child: AnimatedSize(
          duration: AppDurations.ms250,
          curve: Curves.easeInOut,

          child: AnimatedSwitcher(
            duration: AppDurations.ms250,
            switchInCurve: Curves.easeOut,
            switchOutCurve: Curves.easeIn,

            layoutBuilder: (currentChild, previousChildren) => Stack(
              alignment: Alignment.center,
              children: [
                if (currentChild != null) currentChild,
                ...previousChildren,
              ],
            ),

            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),

            child: isLoading
                ? const CupertinoActivityIndicator()
                : TextWidget(
                    label,
                    TextType.button,
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: foregroundColor ?? colorScheme.primary,
                    isUnderlined: isUnderlined,
                  ),
          ),
        ),
      ),
    );
  }
}
