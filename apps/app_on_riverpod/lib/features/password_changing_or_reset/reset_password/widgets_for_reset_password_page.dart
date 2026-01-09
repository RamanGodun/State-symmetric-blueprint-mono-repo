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
        Hero(
          tag: 'Logo',
          child: Image.asset(
            FlavorX.appIcon,
            width: AppSpacing.great,
            height: AppSpacing.great,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.l),
        ),
        const TextWidget(
          AppLocaleKeys.reset_password_header,
          TextType.headlineSmall,
        ),
        const TextWidget(
          AppLocaleKeys.reset_password_sub_header,
          TextType.titleSmall,
          isTextOnFewStrings: true,
        ).withPaddingBottom(AppSpacing.xxl),
      ],
    );
  }
}

////
////

/// 🧩 [_EmailFormField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _EmailFormField extends ConsumerWidget {
  ///--------------------------------------------
  const _EmailFormField(this.focusNodes);
  //
  final NodesForResetPasswordPage focusNodes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final (:errorText, :isValid, :epoch) = ref.watch(
      resetPasswordFormProvider.select(
        recordsForEmailFormField(useFormValidity: true),
      ),
    );
    final form = ref.read(resetPasswordFormProvider.notifier);
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('email_$epoch'),
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      //
      onChanged: form.onEmailChanged,
      onSubmitted: isValid ? () => ref.submitResetPassword() : null,
      //
    ).withPaddingBottom(AppSpacing.huge);
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [RiverpodAdapterForSubmitButton]
//
final class _ResetPasswordSubmitButton extends ConsumerWidget {
  ///-------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    return RiverpodAdapterForSubmitButton(
      label: AppLocaleKeys.buttons_reset_password,
      isFormValid: resetPasswordFormProvider.select(
        (state) => state.isValid,
      ),
      isLoadingSelector: resetPasswordProvider.select<bool>(
        (SubmissionFlowStateModel state) => state.isLoading,
      ),
      onPressed: () => ref.submitResetPassword(),
    ).withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🛡️ [_ResetPasswordPageFooterGuard] — Make footer disable during form submission or active overlay
//
final class _ResetPasswordPageFooterGuard extends StatelessWidget {
  ///----------------------------------------------
  const _ResetPasswordPageFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧠 Computes `isEnabled` [_ResetPasswordPageFooter]
    return RiverpodAdapterForFooterGuard(
      isLoadingSelector: resetPasswordProvider.select<bool>(
        (SubmissionFlowStateModel state) => state.isLoading,
      ),
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: const _ResetPasswordPageFooter(),
    );
  }
}

////
////

/// 🔁 [_ResetPasswordPageFooter] — sign in redirect link
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordPageFooter extends StatelessWidget {
  ///--------------------------------------------------
  const _ResetPasswordPageFooter();

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isEnabled = context.isFooterEnabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignInPage]
        const TextWidget(
          AppLocaleKeys.reset_password_remember,
          TextType.bodyMedium,
          fontWeight: FontWeight.w300,
        ),
        //
        AppTextButton(
          label: AppLocaleKeys.buttons_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        ).withPaddingBottom(AppSpacing.xxxm),
      ],
    );
  }
}
