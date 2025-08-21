part of 'sign_in_page.dart';

/// 🖼️ [_LogoImage] — Displays Flutter logo with hero animation
//
final class _LogoImage extends StatelessWidget {
  ///-----------------------------------------
  const _LogoImage();

  @override
  Widget build(BuildContext context) {
    //
    return const Hero(
      tag: 'Logo',
      child: Image(
        image: AssetImage(AppImagesPaths.flutterLogo, package: 'core'),
        width: 250,
      ),
    );
  }
}

////

////

/// 📧 [_EmailField] — Email input field with validation & focus handling
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _EmailField extends StatelessWidget {
  ///-----------------------------------------
  const _EmailField({required this.focusNode, required this.nextFocus});
  //
  final FocusNode focusNode;
  final FocusNode nextFocus;

  //

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignIncubit, SignInPageState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<SignIncubit>().emailChanged,
          onSubmitted: () => FocusScope.of(context).requestFocus(nextFocus),
        );
      },
    );
  }
}

////

////

/// 🔒 [_PasswordField] — Password field with toggle visibility logic
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordField extends StatelessWidget {
  ///--------------------------------------------
  const _PasswordField({required this.focusNode});
  //
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<
      SignIncubit,
      SignInPageState,
      ({String? errorText, bool isObscure})
    >(
      selector: (state) => (
        errorText: state.password.uiErrorKey,
        isObscure: state.isPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNode,
          errorText: errorText,
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: context.read<SignIncubit>().togglePasswordVisibility,
          ),
          onChanged: context.read<SignIncubit>().passwordChanged,
          onSubmitted: () => context.read<SignIncubit>().submit(),
        );
      },
    );
  }
}

////

////

/// 🚀 [_SubmitButton] — Button for triggering sign-in logic
/// ✅ Uses [FormSubmitButton] for automatic loading state binding
//
final class _SubmitButton extends StatelessWidget {
  ///--------------------------------------------
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return FormSubmitButton<SignIncubit, SignInPageState>(
      label: LocaleKeys.buttons_sign_in,
      onPressed: (context) {
        context.unfocusKeyboard();
        context.read<SignIncubit>().submit();
      },
      statusSelector: (state) => state.status,
      isValidatedSelector: (state) => state.isValid,
    );
  }
}

////

////

/// 🔁 [_SignInFooter] — Button to navigate to the sign-up screen
/// ✅ Disabled during form submission or overlay
//
final class _SignInFooter extends StatelessWidget {
  ///------------------------------------------------------
  const _SignInFooter();

  @override
  Widget build(BuildContext context) {
    //
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocSelector<SignIncubit, SignInPageState, bool>(
      selector: (state) => state.status.isSubmissionInProgress,
      builder: (context, isLoading) {
        final isEnabled = !isLoading && !isOverlayActive;

        return Column(
          children: [
            AppTextButton(
              label: LocaleKeys.buttons_redirect_to_sign_up,
              isEnabled: isEnabled,
              onPressed: () => context.goPushTo(RoutesNames.signUp),
            ),
            const SizedBox(height: AppSpacing.l),

            AppTextButton(
              onPressed: () => context.goPushTo(RoutesNames.resetPassword),
              label: LocaleKeys.sign_in_forgot_password,
              foregroundColor: AppColors.forErrors,
            ),
          ],
        );
      },
    );
  }
}
