import 'package:flutter/material.dart';

/// 👁️ Shared password visibility icon
//
final class ObscureToggleIcon extends StatelessWidget {
  ///-----------------------------------------------
  const ObscureToggleIcon({
    required this.isObscure,
    required this.onPressed,
    super.key,
  });

  ///
  final bool isObscure;

  ///
  final VoidCallback onPressed;

  ///

  @override
  Widget build(BuildContext context) {
    //
    return IconButton(
      icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
      onPressed: onPressed,
    );
  }
}
