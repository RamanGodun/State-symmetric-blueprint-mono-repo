part of 'sign_up__page.dart';

/// 👤  [_UserNameInputField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _UserNameInputField extends StatelessWidget {
  ///---------------------------------------
  const _UserNameInputField(this.focusNodes);
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
    return BlocSelector<SignUpCubit, SignUpPageState, String?>(
      selector: (state) => state.name.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNodes.name,
          errorText: errorText,
          onChanged: context.read<SignUpCubit>().onNameChanged,
          onSubmitted: focusNodes.email.requestFocus,
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🧩 [_EmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _EmailInputField extends StatelessWidget {
  ///-----------------------------------------
  const _EmailInputField(this.focusNodes);
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
    return BlocSelector<SignUpCubit, SignUpPageState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          onChanged: context.read<SignUpCubit>().onEmailChanged,
          onSubmitted: focusNodes.password.requestFocus,
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔒 [_PasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordInputField extends StatelessWidget {
  ///--------------------------------------------
  const _PasswordInputField(this.focusNodes);
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
    return BlocSelector<SignUpCubit, SignUpPageState, FieldUiState>(
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
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔐 [_ConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _ConfirmPasswordInputField extends StatelessWidget {
  ///---------------------------------------------------
  const _ConfirmPasswordInputField(this.focusNodes);
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
    return BlocSelector<SignUpCubit, SignUpPageState, FieldUiState>(
      selector: (state) => (
        errorText: state.confirmPassword.uiErrorKey,
        isObscure: state.isConfirmPasswordObscure,
      ),
      builder: (context, field) {
        final (errorText: errorText, isObscure: isObscure) = field;

        return InputFieldFactory.create(
          type: InputFieldType.confirmPassword,
          focusNode: focusNodes.confirmPassword,
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
          onSubmitted: () {
            final cubit = context.read<SignUpCubit>();
            if (cubit.state.isValid) cubit.submit();
          },
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}
