import 'package:flutter/material.dart'
    show Color, FontWeight, TextAlign, TextOverflow, Widget;
import 'package:shared_widgets/public_api/text_widgets.dart'
    show TextType, TextWidget;

/// 📜 Extension for fast TextWidget creation from string

extension GetTextWidget on String {
  ///----------------------------------

  Widget from(
    TextType type, {
    Color? color,
    TextAlign? align,
    FontWeight? weight,
    double? size,
    double? spacing,
    double? height,
    TextOverflow? overflow,
    int? maxLines,
    bool shadow = false,
    bool? multiline,
    bool? underline,
  }) {
    return TextWidget(
      this,
      type,
      color: color,
      alignment: align,
      fontWeight: weight,
      fontSize: size,
      letterSpacing: spacing,
      height: height,
      overflow: overflow,
      maxLines: maxLines,
      enableShadow: shadow,
      isTextOnFewStrings: multiline,
      isUnderlined: underline,
    );
  }

  //
}
