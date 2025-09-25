part of 'reset_password_page.dart';

/// ℹ️ Info section for [_ResetPasswordHeader]
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordHeader extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const FlutterLogo(
          size: AppSpacing.great,
        ).withPaddingOnly(top: AppSpacing.great, bottom: AppSpacing.l),
        const TextWidget(
          LocaleKeys.reset_password_header,
          TextType.headlineSmall,
        ),
        const TextWidget(
          LocaleKeys.reset_password_sub_header,
          TextType.bodyMedium,
        ).withPaddingBottom(AppSpacing.xxl),
      ],
    );
  }
}

////
////

/// 🧩 [_ResetPasswordEmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _ResetPasswordEmailInputField extends ConsumerWidget {
  ///----------------------------------------------------------
  const _ResetPasswordEmailInputField(this.focusNodes);
  //
  final ({FocusNode email}) focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (emailError, isValid, epoch) = ref.watch(
      resetPasswordFormProvider.select(
        (state) => (state.email.uiErrorKey, state.isValid, state.epoch),
      ),
    );
    final notifier = ref.read(resetPasswordFormProvider.notifier);

    return InputFieldFactory.create(
      fieldKeyOverride: ValueKey('email_$epoch'),
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: emailError,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      onChanged: notifier.onEmailChanged,
      onSubmitted: isValid ? () => ref.submitResetPassword() : null,
    ).withPaddingBottom(AppSpacing.huge);
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [FormSubmitButtonForRiverpodApps]
//
final class _ResetPasswordSubmitButton extends ConsumerWidget {
  ///-------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return FormSubmitButtonForRiverpodApps(
      label: LocaleKeys.buttons_reset_password,
      isValidProvider: resetPasswordFormProvider.select(
        (state) => state.isValid,
      ),
      isLoadingProvider: resetPasswordProvider.select(
        (state) => state.isLoading,
      ),
      onPressed: () => ref.submitResetPassword(),
    ).withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🛡️ [_ResetPasswordFooterGuard] — Make footer disable during form submission or active overlay
//
final class _ResetPasswordFooterGuard extends ConsumerWidget {
  ///----------------------------------------------
  const _ResetPasswordFooterGuard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ⏳ Submission loading (primitive bool)
    final isLoading = ref.watch(
      resetPasswordProvider.select((state) => state.isLoading),
    );
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = ref.isOverlayActive;
    final isEnabled = !isLoading && !isOverlayActive;

    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return _ResetPasswordPageFooter(isEnabled: isEnabled);
  }
}

////
////

/// 🔁 [_ResetPasswordPageFooter] — sign in redirect link
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordPageFooter extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordPageFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignInPage]
        const TextWidget(
          LocaleKeys.reset_password_remember,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xs),
        //
        AppTextButton(
          label: LocaleKeys.buttons_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        ).withPaddingBottom(AppSpacing.xxxm),
      ],
    );
  }
}
