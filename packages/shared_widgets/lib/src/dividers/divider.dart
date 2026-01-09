import 'package:flutter/material.dart';
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppColors, AppSpacing, ThemeXOnContext;

/// 🧊 [GlassTileDivider] — Subtle glass-style divider between dialog content and buttons.
/// Used in dialogs with translucent backgrounds and blurred layers.
//
final class GlassTileDivider extends StatelessWidget {
  /// ─────────────────────────────────────────────
  const GlassTileDivider({super.key});
  //

  @override
  Widget build(BuildContext context) {
    //
    final isDark = context.isDarkMode;

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxxm),
        Container(
          width: double.infinity,
          height: 0.5,
          margin: const EdgeInsets.only(bottom: AppSpacing.xxs),
          color: isDark ? AppColors.dividerLightOpacity : AppColors.darkBorder,
        ),
        const SizedBox(height: AppSpacing.xxxs),
      ],
    );
  }

  //
}
