import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:flutter/material.dart';

/// 🔑 [KeyValueTextWidget] — Combines a localized key with a dynamic value in a single line,
/// with baseline alignment and columnar spacing for visual consistency.
//
final class KeyValueTextWidget extends StatelessWidget {
  ///------------------------------------------------
  const KeyValueTextWidget({
    required this.labelKey,
    required this.value,
    required this.labelTextType,
    this.valueTextType,
    super.key,
  });
  //
  ///
  final String labelKey;

  ///
  final String value;

  /// 🅰️ Style for localized label
  final TextType labelTextType;

  /// 🅱️ Optional style override for value
  final TextType? valueTextType;

  //

  @override
  Widget build(BuildContext context) {
    //
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,

        children: [
          /// 🏷️ Localized label (intrinsic width)
          IntrinsicWidth(
            child: TextWidget(
              labelKey,
              labelTextType,
              alignment: TextAlign.start,
              fontWeight: FontWeight.w300,
            ),
          ),

          const SizedBox(width: 12),

          /// 🧾 Dynamic value (flexible & aligned)
          Expanded(
            child: TextWidget(
              value,
              valueTextType ?? TextType.bodyMedium,
              alignment: TextAlign.start,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  //
}
