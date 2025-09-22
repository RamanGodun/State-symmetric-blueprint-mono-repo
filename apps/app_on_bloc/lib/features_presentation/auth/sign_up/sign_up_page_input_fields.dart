part of 'sign_up__page.dart';

/// 👤  [_SignUpUserNameInputField] — User name input field with localized validation
/// ✅ Rebuilds only when `name.uiError` changes
//
final class _SignUpUserNameInputField extends StatelessWidget {
  ///---------------------------------------
  const _SignUpUserNameInputField(this.focusNodes);
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
    return BlocSelector<SignUpFormFieldCubit, SignUpFormState, String?>(
      selector: (state) => state.name.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.name,
          focusNode: focusNodes.name,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.name],
          onChanged: context.read<SignUpFormFieldCubit>().onNameChanged,
          onEditingComplete: context.focusNext(focusNodes.email),
          // onEditingComplete: () => context.nextFocus(),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🧩 [_SignUpEmailInputField] — User email input field with localized validation
/// ✅ Rebuilds only when `email.uiError` changes
//
final class _SignUpEmailInputField extends StatelessWidget {
  ///-----------------------------------------
  const _SignUpEmailInputField(this.focusNodes);
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
    return BlocSelector<SignUpFormFieldCubit, SignUpFormState, String?>(
      selector: (state) => state.email.uiErrorKey,
      builder: (context, errorText) {
        return InputFieldFactory.create(
          type: InputFieldType.email,
          focusNode: focusNodes.email,
          errorText: errorText,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.email],
          onChanged: context.read<SignUpFormFieldCubit>().onEmailChanged,
          onEditingComplete: () => context.requestFocus(focusNodes.password),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔒 [_SignUpPasswordInputField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _SignUpPasswordInputField extends StatelessWidget {
  ///--------------------------------------------
  const _SignUpPasswordInputField(this.focusNodes);
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
    final formCubit = context.read<SignUpFormFieldCubit>();

    return BlocSelector<
      SignUpFormFieldCubit,
      SignUpFormState,
      FormFieldUiState
    >(
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
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.togglePasswordVisibility,
          ),
          onChanged: formCubit.onPasswordChanged,
          onEditingComplete: () =>
              context.requestFocus(focusNodes.confirmPassword),
        ).withPaddingBottom(AppSpacing.xm);
      },
    );
  }
}

////
////

/// 🔐 [_SignUpConfirmPasswordInputField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _SignUpConfirmPasswordInputField extends StatelessWidget {
  ///---------------------------------------------------
  const _SignUpConfirmPasswordInputField(this.focusNodes);
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
    final formCubit = context.read<SignUpFormFieldCubit>();
    final formCubitState = formCubit.state;

    return BlocSelector<
      SignUpFormFieldCubit,
      SignUpFormState,
      FormFieldUiState
    >(
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
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
          isObscure: isObscure,
          suffixIcon: ObscureToggleIcon(
            isObscure: isObscure,
            onPressed: formCubit.toggleConfirmPasswordVisibility,
          ),
          onChanged: formCubit.onConfirmPasswordChanged,
          onEditingComplete: () {
            if (formCubit.state.isValid) {
              context.read<SignUpCubit>().submit(
                name: formCubitState.name.value,
                email: formCubitState.email.value,
                password: formCubitState.password.value,
              );
            }
          },
          //
        ).withPaddingBottom(AppSpacing.xl);
      },
    );
  }
}
