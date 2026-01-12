part of 'reset_password__page.dart';

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
            FlavorIconPathX.appIcon,
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
final class _EmailFormField extends StatelessWidget {
  ///---------------------------------------------
  const _EmailFormField(this.focusNodes);
  //
  final NodesForResetPasswordPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isValid, :epoch) = context
        .watchAndSelect<
          ResetPasswordFormFieldsCubit,
          ResetPasswordFormState,
          SelectedValuesForEmailFormField
        >(
          recordsForEmailFormField(useFormValidity: true),
        );
    final form = context.read<ResetPasswordFormFieldsCubit>();
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
      onSubmitted: isValid ? () => context.submitResetPassword() : null,
      //
    ).withPaddingBottom(AppSpacing.huge);
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [BlocAdapterForSubmitButton]
//
final class _ResetPasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return BlocAdapterForSubmitButton<
          ResetPasswordFormFieldsCubit,
          ResetPasswordFormState,
          ResetPasswordCubit
        >(
          label: AppLocaleKeys.buttons_reset_password,
          isFormValid: (state) => state.isValid,
          isLoadingSelector: (state) => state.isLoading,
          onPressed: () => context.submitResetPassword(),
        )
        .withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🛡️ [_ResetPasswordPageFooterGuard] — Make footer disable during form submission or active overlay
//
final class _ResetPasswordPageFooterGuard extends StatelessWidget {
  ///-------------------------------------------------------
  const _ResetPasswordPageFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧠 Computes `isEnabled` [_ResetPasswordPageFooter]
    return BlocAdapterForFooterGuard<
      ResetPasswordCubit,
      SubmissionFlowStateModel
    >(
      isLoadingSelector: (state) => state.isLoading,

      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: const _ResetPasswordPageFooter(),
    );
  }
}

////
////

/// 🔁 [_ResetPasswordPageFooter] — sign in redirect link
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ResetPasswordPageFooter extends StatelessWidget {
  ///------------------------------------------------------
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
