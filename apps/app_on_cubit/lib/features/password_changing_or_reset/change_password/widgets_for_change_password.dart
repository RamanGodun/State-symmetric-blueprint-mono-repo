part of 'change_password_page.dart';

/// ℹ️ Info section for [ChangePasswordPage]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ChangePasswordInfo extends StatelessWidget {
  ///-------------------------------------------------
  const _ChangePasswordInfo();

  @override
  Widget build(BuildContext context) {
    //
    return Column(
      children: [
        const SizedBox(height: AppSpacing.massive),
        const TextWidget(
          LocaleKeys.change_password_title,
          TextType.headlineSmall,
        ),
        const SizedBox(height: AppSpacing.xxxs),
        const TextWidget(
          LocaleKeys.change_password_warning,
          TextType.titleSmall,
        ),
        Text.rich(
          TextSpan(
            text: LocaleKeys.change_password_prefix.tr(),
            style: context.textTheme.titleSmall,
            children: [
              TextSpan(
                text: LocaleKeys.change_password_signed_out.tr(),
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).withPaddingOnly(top: AppSpacing.xxl, bottom: AppSpacing.xxxm);
  }
}

////
////

/// 🧾 [_PasswordFormField] — Password input field with localized validation
/// ✅ Rebuilds only when password error or visibility state changes
//
final class _PasswordFormField extends StatelessWidget {
  ///-------------------------------------------------
  const _PasswordFormField(this.focusNodes);
  //
  final NodesForChangePasswordPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchAndSelect<
          ChangePasswordFormFieldsCubit,
          ChangePasswordFormState,
          SelectedValuesForPasswordFormField
        >(
          recordsForPasswordFormField(),
        );
    final form = context.read<ChangePasswordFormFieldsCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('password_$epoch'),
      type: InputFieldType.password,
      focusNode: focusNodes.password,
      errorText: errorText,
      textInputAction: TextInputAction.next,
      autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.togglePasswordVisibility,
      ),
      //
      onChanged: form.onPasswordChanged,
      onSubmitted: goNext(focusNodes.confirmPassword),
      //
    ).withPaddingBottom(AppSpacing.m);
  }
}

////
////

/// 🧾 [_ConfirmPasswordFormField] — Confirm password input field with localized validation
/// ✅ Rebuilds only when 'confirm password' error or visibility state changes
//
final class _ConfirmPasswordFormField extends StatelessWidget {
  ///-------------------------------------------------------
  const _ConfirmPasswordFormField(this.focusNodes);
  //
  final NodesForChangePasswordPage focusNodes;

  @override
  Widget build(BuildContext context) {
    //
    final (:errorText, :isObscure, :isValid, :epoch) = context
        .watchAndSelect<
          ChangePasswordFormFieldsCubit,
          ChangePasswordFormState,
          SelectedValuesForConfirmPasswordFormField
        >(
          recordsForConfirmPasswordFormField(useFormValidity: true),
        );
    final form = context.read<ChangePasswordFormFieldsCubit>();
    //
    return FormFieldFactory.create(
      fieldKeyOverride: ValueKey('confirm_$epoch'),
      type: InputFieldType.confirmPassword,
      focusNode: focusNodes.confirmPassword,
      errorText: errorText,
      textInputAction: TextInputAction.done,
      autofillHints: const [AutofillHints.password],
      isObscure: isObscure,
      suffixIcon: ObscureToggleIcon(
        isObscure: isObscure,
        onPressed: form.toggleConfirmPasswordVisibility,
      ),
      //
      onChanged: form.onConfirmPasswordChanged,
      onSubmitted: isValid ? () => context.submitChangePassword() : null,
      //
    ).withPaddingBottom(AppSpacing.xxxl);
  }
}

////
////

/// 🔐 [_ChangePasswordSubmitButton] — dispatches the password change request
/// 🧠 Rebuilds only on `isValid` or `isLoading` changes
/// ✅ Delegates behavior to [BlocAdapterForSubmitButton]
//
final class _ChangePasswordSubmitButton extends StatelessWidget {
  ///--------------------------------------------------------
  const _ChangePasswordSubmitButton();

  @override
  Widget build(BuildContext context) {
    //
    return BlocAdapterForSubmitButton<
          ChangePasswordFormFieldsCubit,
          ChangePasswordFormState,
          ChangePasswordCubit
        >(
          label: LocaleKeys.change_password_title,
          isFormValid: (state) => state.isValid,
          isLoadingSelector: (state) => state.isLoading,
          onPressed: () => context.submitChangePassword(),
        )
        .withPaddingBottom(AppSpacing.l);
  }
}
