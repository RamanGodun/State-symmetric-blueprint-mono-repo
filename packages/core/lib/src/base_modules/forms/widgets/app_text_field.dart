//
// ignore_for_file: public_member_api_docs

import 'package:core/src/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/src/base_modules/localization/utils/string_x.dart';
import 'package:flutter/material.dart';

/// 🧱 [AppTextField] — Reusable, styled text input field used across the app.
/// Supports:
///   - label & prefix icon
///   - error display
///   - focus control
///   - submit action
///   - obscured (e.g. password) mode
//
final class AppTextField extends StatelessWidget {
  ///------------------------------------------
  const AppTextField({
    required this.focusNode,
    required this.label,
    required this.icon,
    required this.obscure,
    required this.onChanged,
    this.fieldKey,
    this.fallback,
    this.suffixIcon,
    this.errorKey,
    this.keyboardType,
    this.onSubmitted,
    super.key,
  });
  //
  final Key? fieldKey;
  final FocusNode focusNode;
  final String label;
  final String? fallback;
  final IconData icon;
  final bool obscure;
  final String? errorKey;
  final TextInputType? keyboardType;
  final void Function(String) onChanged;
  final VoidCallback? onSubmitted;
  final Widget? suffixIcon;

  ///

  @override
  Widget build(BuildContext context) {
    //
    final resolvedLabel = _resolveLabel(label, fallback);

    debugPrint('⚠️ label: $label');
    debugPrint('⚠️ errorText: $errorKey');

    return TextField(
      key: fieldKey,
      focusNode: focusNode,
      keyboardType: keyboardType,
      obscureText: obscure,
      textCapitalization: keyboardType == TextInputType.name
          ? TextCapitalization.words
          : TextCapitalization.none,
      autocorrect: false,
      decoration: InputDecoration(
        border: const OutlineInputBorder(),
        filled: true,
        labelText: resolvedLabel,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        errorText: errorKey?.translateOrNull,
      ),
      onChanged: onChanged,
      onSubmitted: (_) => onSubmitted?.call(),
    );
  }

  /// 🔤 Resolves [label] as localization key if applicable.
  /// - Uses [AppLocalizer.translateSafely] if initialized and key-like (contains '.')
  /// - Falls back to [fallback] or raw label
  String _resolveLabel(String raw, String? fallback) {
    final isLocalCaseKey = raw.contains('.');
    if (isLocalCaseKey && AppLocalizer.isInitialized) {
      return AppLocalizer.translateSafely(raw, fallback: fallback ?? raw);
    }
    return raw;
  }

  //
}
