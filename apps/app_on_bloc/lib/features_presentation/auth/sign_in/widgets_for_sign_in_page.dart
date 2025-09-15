part of 'sign_in_page.dart';

/// 🖼️ [_SignInHeader] — app logo + welcome texts
/// 📦 Contains branding, main header, and sub-header
//
final class _SignInHeader extends StatelessWidget {
  ///------------------------------------------
  const _SignInHeader();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
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
        ).withPaddingBottom(AppSpacing.l),
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
  const _SignInEmailInputField(this.focusNode);
  //
  final ({FocusNode email, FocusNode password}) focusNode;

  //

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignInCubit, SignInPageState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode.email,
          errorText: errorText,
          onChanged: context.read<SignInCubit>().emailChanged,
          onSubmitted: () =>
              FocusScope.of(context).requestFocus(focusNode.password),
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
    return BlocSelector<SignInCubit, SignInPageState, FieldUiState>(
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
            onPressed: context.read<SignInCubit>().togglePasswordVisibility,
          ),
          onChanged: context.read<SignInCubit>().passwordChanged,
          onSubmitted: () {
            final isValid = context.read<SignInCubit>().state.isValid;
            if (isValid) context.read<SignInCubit>().submit();
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
    return FormSubmitButtonForBlocApps<SignInCubit, SignInPageState>(
      label: LocaleKeys.buttons_sign_in,
      onPressed: (context) {
        context.unfocusKeyboard();
        context.read<SignInCubit>().submit();
      },
      statusSelector: (state) => state.status,
      isValidatedSelector: (state) => state.isValid,
    ).withPaddingBottom(AppSpacing.l);
  }
}

////

////

/// 🔁 [_SignInFooter] — sign up & reset password links
/// ✅ Disabled during form submission or overlay
//
final class _SignInFooter extends StatelessWidget {
  ///------------------------------------------------------
  const _SignInFooter();

  @override
  Widget build(BuildContext context) {
    //
    /// 🛡️ Overlay guard (blocks navigation while dialogs/overlays shown)
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocSelector<SignInCubit, SignInPageState, bool>(
      selector: (state) => state.status.isSubmissionInProgress,
      builder: (context, isLoading) {
        final isEnabled = !isLoading && !isOverlayActive;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Redirect to [SignUpPage]
            const TextWidget(
              LocaleKeys.buttons_redirect_to_sign_up,
              TextType.bodyLarge,
            ).withPaddingBottom(AppSpacing.s),
            AppTextButton(
              label: LocaleKeys.buttons_sign_up,
              isEnabled: isEnabled,
              onPressed: () => context.goPushTo(RoutesNames.signUp),
            ).withPaddingBottom(AppSpacing.xxxm),

            /// Redirect to [ResetPasswordPage]
            const TextWidget(
              LocaleKeys.sign_in_forgot_password,
              TextType.bodyLarge,
            ).withPaddingBottom(AppSpacing.s),
            AppTextButton(
              label: LocaleKeys.buttons_reset_password,
              foregroundColor: AppColors.forErrors,
              isEnabled: isEnabled,
              onPressed: () => context.goTo(RoutesNames.resetPassword),
            ),
          ],
        );
      },
    );
  }
}
