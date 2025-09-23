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
          child: const FlutterLogo(
            size: AppSpacing.massive,
          ).withPaddingOnly(top: AppSpacing.huge, bottom: AppSpacing.xxl),
        ),
        //
        /// 🏷️ Main header text
        const TextWidget(LocaleKeys.sign_in_header, TextType.headlineSmall),
        //
        /// 📝 Sub-header text
        const TextWidget(
          LocaleKeys.sign_in_sub_header,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.xxxl),
      ],
    );
  }
}

////
////

/// 📧 [_SignInEmailInputField] — Email input field with validation & focus handling
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _SignInEmailInputField extends StatelessWidget {
  ///-----------------------------------------
  const _SignInEmailInputField(this.focusNodes);
  //
  final ({FocusNode email, FocusNode password}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignInFormCubit, SignInFormState, (String?, int)>(
      selector: (state) => (state.email.uiErrorKey, state.epoch),
      builder: (context, tuple) {
        final (errorText, epoch) = tuple;
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.username, AutofillHints.email],
          onChanged: context.read<SignInFormCubit>().onEmailChanged,
          onEditingComplete: () => context.requestFocus(focusNodes.password),
          fieldKeyOverride: ValueKey('email_$epoch'),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔒 [_SignInPasswordInputField] — Password field with toggle visibility logic
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignInPasswordInputField extends StatelessWidget {
  ///--------------------------------------------
  const _SignInPasswordInputField(this.focusNodes);
  //
  final ({FocusNode email, FocusNode password}) focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      SignInFormCubit,
      SignInFormState,
      (FormFieldUiState, int)
    >(
      selector: (state) => (
        (
          errorText: state.password.uiErrorKey,
          isObscure: state.isPasswordObscure,
        ),
        state.epoch,
      ),
      builder: (context, pair) {
        final (field, epoch) = pair;
        final (:errorText, :isObscure) = field;
        final formCubit = context.read<SignInFormCubit>();

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNodes.password,
          errorText: errorText,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.password],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.togglePasswordVisibility,
          ),
          onChanged: formCubit.onPasswordChanged,
          onEditingComplete: () {
            final form = formCubit.state;
            if (form.isValid) {
              context.read<SignInCubit>().submit(
                email: form.email.value,
                password: form.password.value,
              );
            }
          },
          fieldKeyOverride: ValueKey('password_$epoch'),
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}

////
////

/// 🚀 [_SignInSubmitButton] — Button for triggering sign-in logic
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [UniversalSubmitButton]
//
final class _SignInSubmitButton extends StatelessWidget {
  ///--------------------------------------------
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return UniversalSubmitButton<SignInFormCubit, SignInFormState, SignInCubit>(
      label: LocaleKeys.buttons_sign_in,
      loadingLabel: LocaleKeys.buttons_submitting,
      isFormValid: (state) => state.isValid,
      onPressed: () => context.unfocusKeyboard().submitSignIn,
    ).withPaddingBottom(AppSpacing.l);
  }
}

////
////

/// 🛡️ [_SignInPageFooterGuard] — Make footer disable during form submission or active overlay
//
final class _SignInPageFooterGuard extends StatelessWidget {
  ///------------------------------------------------------
  const _SignInPageFooterGuard();

  @override
  Widget build(BuildContext context) {
    //
    return FooterGuard<SignInCubit, ButtonSubmissionState>(
      isLoadingSelector: (state) => state.isLoading,
      childBuilder: (_, isEnabled) =>
          /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
          _SignInPageFooter(isEnabled: isEnabled),
    );
  }
}

////
////

/// 🔁 [_SignInPageFooter] — sign up & reset password links
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignInPageFooter extends StatelessWidget {
  ///-----------------------------------------------
  const _SignInPageFooter({required this.isEnabled});
  //
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        /// 🧭 Redirect to [SignUpPage]
        const TextWidget(
          LocaleKeys.buttons_redirect_to_sign_up,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.s),
        AppTextButton(
          label: LocaleKeys.buttons_sign_up,
          isEnabled: isEnabled,
          onPressed: () => context.goPushTo(RoutesNames.signUp),
        ).withPaddingBottom(AppSpacing.xxxm),

        /// 🧭 Redirect to [ResetPasswordPage]
        const TextWidget(
          LocaleKeys.sign_in_forgot_password,
          TextType.bodyLarge,
        ).withPaddingBottom(AppSpacing.s),
        AppTextButton(
          label: LocaleKeys.buttons_reset_password,
          foregroundColor: AppColors.forErrors,
          isEnabled: isEnabled,
          onPressed: () => context.goPushTo(RoutesNames.resetPassword),
        ),
      ],
    );
  }
}
