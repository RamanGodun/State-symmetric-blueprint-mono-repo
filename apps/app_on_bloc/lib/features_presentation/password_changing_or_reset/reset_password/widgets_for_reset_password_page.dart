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
final class _ResetPasswordEmailInputField extends StatelessWidget {
  ///------------------------------------------------------
  const _ResetPasswordEmailInputField(this.focusNodes);
  //
  final ({FocusNode email}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      ResetPasswordFormFieldsCubit,
      ResetPasswordFormState,
      (String?, int)
    >(
      selector: (state) => (state.email.uiErrorKey, state.epoch),
      builder: (context, tuple) {
        final (errorText, epoch) = tuple;
        final isValid = context
            .read<ResetPasswordFormFieldsCubit>()
            .state
            .isValid;

        return InputFieldFactory.create(
          fieldKeyOverride: ValueKey('email_$epoch'),
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          onChanged: context
              .read<ResetPasswordFormFieldsCubit>()
              .onEmailChanged,
          onSubmitted: isValid ? () => context.submitResetPassword() : null,
        ).withPaddingBottom(AppSpacing.huge);
      },
    );
  }
}

////
////

/// 🔘 [_ResetPasswordSubmitButton] — Confirms reset action button
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [FormSubmitButtonForBLoCApps]
//
final class _ResetPasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ResetPasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return FormSubmitButtonForBLoCApps<
          ResetPasswordFormFieldsCubit,
          ResetPasswordFormState,
          ResetPasswordCubit
        >(
          label: LocaleKeys.buttons_reset_password,
          isFormValid: (state) => state.isValid,
          onPressed: () => context.submitResetPassword(),
        )
        .withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🛡️ [_ResetPasswordFooterGuard] — Make footer disable during form submission or active overlay
//
final class _ResetPasswordFooterGuard extends StatelessWidget {
  ///-------------------------------------------------------
  const _ResetPasswordFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    return FooterGuard<ResetPasswordCubit, ButtonSubmissionState>(
      isLoadingSelector: (state) => state.isLoading,
      childBuilder: (_, isEnabled) =>
          /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
          _ResetPasswordPageFooter(isEnabled: isEnabled),
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
