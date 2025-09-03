part of 'sign_up_page.dart';

/// 🖼️ [_LogoImage] — Displays logo with hero animation
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
        height: 150,
      ),
    );
  }
}

////

////

/// 👤 [_NameField] — Handles name input with validation
//
final class _NameField extends StatelessWidget {
  ///---------------------------------------
  const _NameField({required this.focusNode, required this.nextFocusNode});
  //
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  //

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpCubit, SignUpState, String?>(
      selector: (state) => state.name.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<SignUpCubit>().onNameChanged,
          onSubmitted: nextFocusNode.requestFocus,
        );
      },
    );
  }
}

////

////

/// 📧 [_EmailField] — Handles email input with validation
//
final class _EmailField extends StatelessWidget {
  ///-----------------------------------------
  const _EmailField({required this.focusNode, required this.nextFocusNode});
  //
  final FocusNode focusNode;
  final FocusNode nextFocusNode;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpCubit, SignUpState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNode,
          errorText: errorText,
          onChanged: context.read<SignUpCubit>().onEmailChanged,
          onSubmitted: nextFocusNode.requestFocus,
        );
      },
    );
  }
}

////

////

/// 🔒 [_PasswordField] — Handles password input with toggle visibility
//
final class _PasswordField extends StatelessWidget {
  ///--------------------------------------------
  const _PasswordField({required this.focusNodes});
  //
  final ({
    FocusNode name,
    FocusNode email,
    FocusNode password,
    FocusNode confirmPassword,
  })
  focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpCubit, SignUpState, FieldUiState>(
      selector: (state) => (
        errorText: state.password.uiErrorKey,
        isObscure: state.isPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.password,
          focusNode: focusNodes.password,
          errorText: errorText,
          //
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: context.read<SignUpCubit>().togglePasswordVisibility,
          ),
          //
          onChanged: context.read<SignUpCubit>().onPasswordChanged,
          onSubmitted: focusNodes.confirmPassword.requestFocus,
        );
      },
    );
  }
}

////

////

/// 🔐 [_ConfirmPasswordField] — Validates match with password
//
final class _ConfirmPasswordField extends StatelessWidget {
  const _ConfirmPasswordField({required this.focusNode});

  ///---------------------------------------------------
  //
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    //
    return BlocSelector<SignUpCubit, SignUpState, FieldUiState>(
      selector: (state) => (
        errorText: state.confirmPassword.uiErrorKey,
        isObscure: state.isConfirmPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNode,
          errorText: errorText,
          //
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: context
                .read<SignUpCubit>()
                .toggleConfirmPasswordVisibility,
          ),
          //
          onChanged: context.read<SignUpCubit>().onConfirmPasswordChanged,
          onSubmitted: context.read<SignUpCubit>().submit,
        );
      },
    );
  }
}

////

////

/// 🚀 [_SubmitButton] — Validated submit with status feedback
//
final class _SubmitButton extends StatelessWidget {
  ///-------------------------------------------
  const _SubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return FormSubmitButton<SignUpCubit, SignUpState>(
      label: LocaleKeys.buttons_sign_up,
      onPressed: (context) {
        context.unfocusKeyboard();
        context.read<SignUpCubit>().submit();
      },
      statusSelector: (state) => state.status,
      isValidatedSelector: (state) => state.isValid,
    );
  }
}

////

////

/// 🔁 [_RedirectToSignInButton] — Disabled if submitting or overlay active
//
final class _RedirectToSignInButton extends StatelessWidget {
  ///-----------------------------------------------------
  const _RedirectToSignInButton();

  @override
  Widget build(BuildContext context) {
    //
    final isOverlayActive = context.select<OverlayStatusCubit, bool>(
      (cubit) => cubit.state,
    );

    return BlocSelector<SignUpCubit, SignUpState, bool>(
      selector: (state) => state.status.isSubmissionInProgress,
      builder: (context, isLoading) {
        final isEnabled = !isLoading && !isOverlayActive;

        return AppTextButton(
          label: LocaleKeys.buttons_redirect_to_sign_in,
          isEnabled: isEnabled,
          onPressed: () => context.popView(),
        );
      },
    );
  }
}
