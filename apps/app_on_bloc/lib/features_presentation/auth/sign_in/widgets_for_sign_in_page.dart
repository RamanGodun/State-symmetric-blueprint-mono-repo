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

  //

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignInFormCubit, SignInFormState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          onChanged: context.read<SignInFormCubit>().onEmailChanged,
          onSubmitted: focusNodes.password.requestFocus,
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
  const _SignInPasswordInputField(this.focusNode);
  //
  final ({FocusNode email, FocusNode password}) focusNode;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignInFormCubit, SignInFormState, FieldUiState>(
      selector: (state) => (
        errorText: state.password.uiErrorKey,
        isObscure: state.isPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNode.password,
          errorText: errorText,
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: context.read<SignInFormCubit>().togglePasswordVisibility,
          ),
          onChanged: context.read<SignInFormCubit>().onPasswordChanged,
          onSubmitted: () {
            final form = context.read<SignInFormCubit>().state;
            if (form.isValid) {
              context.read<SignInCubit>().submit(
                email: form.email.value,
                password: form.password.value,
              );
            }
          },
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}

////
////

/// 🚀 [_SignInSubmitButton] — Button for triggering sign-in logic
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [FormSubmitButtonForBlocApps]
//
final class _SignInSubmitButton extends StatelessWidget {
  ///--------------------------------------------
  const _SignInSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (c) => c.state,
    );
    final isLoading = context.select<SignInCubit, bool>(
      (c) => c.state.isLoading,
    );

    return BlocSelector<SignInFormCubit, SignInFormState, bool>(
      selector: (s) => s.isValid,
      builder: (context, isValid) {
        final isEnabled = isValid && !isLoading && !isOverlayActive;

        return CustomFilledButton(
          label: isLoading
              ? LocaleKeys.buttons_submitting
              : LocaleKeys.buttons_sign_in,
          isLoading: isLoading,
          isEnabled: isEnabled,
          onPressed: isEnabled
              ? () {
                  context.unfocusKeyboard();
                  final form = context.read<SignInFormCubit>().state;
                  context.read<SignInCubit>().submit(
                    email: form.email.value,
                    password: form.password.value,
                  );
                }
              : null,
        ).withPaddingBottom(AppSpacing.l);
      },
    );
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
