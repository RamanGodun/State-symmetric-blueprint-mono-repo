//
// ignore_for_file: public_member_api_docs

import 'package:core/base_modules/localization.dart' show LocaleKeys;
import 'package:core/core.dart' show CustomFilledButton;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

/// 🚀 [FormSubmitButtonForRiverpodApps] — Riverpod-aware smart submit button
///
/// ✅ Wraps [CustomFilledButton] with declarative state binding
/// ✅ Listens to form validity + loading providers
/// ✅ Blocks press if form invalid / submitting / overlay active
/// ✅ Minimal rebuilds via primitive bool providers
final class FormSubmitButtonForRiverpodApps extends ConsumerWidget {
  ///-----------------------------------------------
  const FormSubmitButtonForRiverpodApps({
    required this.label,
    required this.onPressed,
    required this.isValidProvider,
    required this.isLoadingProvider,
    this.loadingLabel,
    super.key,
  });

  /// Button label (usually localized)
  final String label;

  /// 🔄 Label text shown while submitting
  final String? loadingLabel;

  /// Triggered only when button is enabled
  final VoidCallback onPressed;

  /// Provider returning `bool isValid`
  final ProviderListenable<bool> isValidProvider;

  /// Provider returning `bool isLoading`
  final ProviderListenable<bool> isLoadingProvider;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🎯 Minimal subscriptions
    final isValid = ref.watch(isValidProvider);
    final isLoading = ref.watch(isLoadingProvider);

    // 🧱 Overlay guard to avoid double submissions
    final isOverlayActive = ref.isOverlayActive;
    final isEnabled = isValid && !isLoading && !isOverlayActive;

    final currentLabel = isLoading
        ? (loadingLabel ?? LocaleKeys.buttons_submitting)
        : label;

    return CustomFilledButton(
      label: currentLabel,
      isEnabled: isEnabled,
      isValidated: isValid,
      isLoading: isLoading,
      onPressed: isEnabled ? onPressed : null,
    );
  }
}
