part of 'sign_in__page.dart';

/// 🖼️ [_SignInHeader] — app logo + welcome texts
/// 📦 Contains branding, main header, and sub-header
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignInHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignInHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🖼️ App logo with Hero animation for smooth transitions
        Hero(
          tag: 'Logo',
          child: Image.asset(
            FlavorX.appIcon,
            width: AppSpacing.massive,
            height: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.l),
        ),
        //
        /// 🏷️ Main header text
        const TextWidget(AppLocaleKeys.sign_in_header, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          AppLocaleKeys.sign_in_sub_header,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xl),
      ],
    );
  }
}

////
////

/// 📧 [_EmailFormField] — Email input field with validation & focus handling
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _EmailFormField extends StatelessWidget {
  ///---------------------------------------------
  const _EmailFormField(this.focusNodes);
  //
  final NodesForSignInPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isValid, :epoch) = context
        .watchAndSelect<
          SignInFormCubit,
          SignInFormState,
          SelectedValuesForEmailFormField
        >(
          recordsForEmailFormField(),
        );
    final form = context.read<SignInFormCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('email_$epoch'),
      type: InputFieldType.email,
      focusNode: focusNodes.email,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.username, AutofillHints.email],
      //
      onChanged: form.onEmailChanged,
      onSubmitted: goNext(focusNodes.password),
      //
    ).withPaddingBottom(AppSpacing.xm);
  }
}

////
////

/// 🔒 [_PasswordFormField] — Password field with toggle visibility logic
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordFormField extends StatelessWidget {
  ///-------------------------------------------------
  const _PasswordFormField(this.focusNodes);
  //
  final NodesForSignInPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchAndSelect<
          SignInFormCubit,
          SignInFormState,
          SelectedValuesForPasswordFormField
        >(
          recordsForPasswordFormField(useFormValidity: true),
        );
    final form = context.read<SignInFormCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('password_$epoch'),
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.togglePasswordVisibility,
      ),
      //
      onChanged: form.onPasswordChanged,
      onSubmitted: isValid ? () => context.submitSignIn() : null,
      //
    ).withPaddingBottom(AppSpacing.xl);
  }
}

////
////

/// 🚀 [_SignInSubmitButton] — Button for triggering sign-in logic
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [BlocAdapterForSubmitButton]
//
final class _SignInSubmitButton extends StatelessWidget {
  ///-------------------------------------------------
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return BlocAdapterForSubmitButton<
          SignInFormCubit,
          SignInFormState,
          SignInCubit
        >(
          label: AppLocaleKeys.buttons_sign_in,
          isFormValid: (state) => state.isValid,
          isLoadingSelector: (state) => state.isLoading,
          onPressed: () => context.submitSignIn(),
        )
        .withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🔁 [_SignInPageFooterGuard] — sign up & reset password links
/// ✅ Disabled during form submission or overlay
//
final class _SignInPageFooterGuard extends StatelessWidget {
  ///----------------------------------------------------
  const _SignInPageFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧠 Computes `isEnabled` [_SignInPageFooter]
    return BlocAdapterForFooterGuard<SignInCubit, SubmissionFlowStateModel>(
      isLoadingSelector: (state) => state.isLoading,
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: const _SignInPageFooter(),
    );
  }
}

////
////

/// 🔁 [_SignInPageFooter] — Sign up & reset password links
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignInPageFooter extends StatelessWidget {
  ///-----------------------------------------------
  const _SignInPageFooter();

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isEnabled = context.isFooterEnabled;
    //
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignUpPage]
        const TextWidget(
          AppLocaleKeys.buttons_redirect_to_sign_up,
          TextType.bodyMedium,
        ),
        AppTextButton(
          label: AppLocaleKeys.buttons_sign_up,
          isEnabled: isEnabled,
          onPressed: () => context.goPushTo(RoutesNames.signUp),
        ).withPaddingBottom(AppSpacing.xxxm),

        /// 🧭 Redirect to [ResetPasswordPage]
        const TextWidget(
          AppLocaleKeys.sign_in_forgot_password,
          TextType.bodyMedium,
        ),
        AppTextButton(
          label: AppLocaleKeys.buttons_reset_password,
          foregroundColor: AppColors.forErrors,
          isEnabled: isEnabled,
          onPressed: () => context.goPushTo(RoutesNames.resetPassword),
        ),
      ],
    );
  }
}
