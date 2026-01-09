// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeXOnContext;
import 'package:shared_utils/public_api/general_utils.dart' show AppDurations;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

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
    this.fontSize = 17,
    this.fontWeight = FontWeight.w400,
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
        : colorScheme.onSurface.withValues(alpha: 0.4);

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
                ?currentChild,
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
