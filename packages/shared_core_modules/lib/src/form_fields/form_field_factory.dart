import 'package:flutter/material.dart'
    show
        FocusNode,
        Key,
        TextEditingController,
        TextInputAction,
        TextInputType,
        VoidCallback,
        Widget;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show CoreLocaleKeys;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppIcons;
import 'package:shared_core_modules/src/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;
import 'package:shared_core_modules/src/form_fields/utils/keys.dart'
    show FormFieldsKeys;
import 'package:shared_core_modules/src/form_fields/widgets/app_form_field.dart'
    show AppFormField;

/// 🏗️ Factory method that returns a themed [AppFormField], based on the [InputFieldType].
/// Ensures consistent look & feel across forms (SignUp/Login).
//
abstract final class FormFieldFactory {
  ///--------------------------------
  FormFieldFactory._();

  ///
  static Widget create({
    required InputFieldType type,
    required FocusNode focusNode,
    required String? errorText,
    required void Function(String) onChanged,
    bool isObscure = false,
    Widget? suffixIcon,
    VoidCallback? onSubmitted,
    TextInputAction? textInputAction,
    Iterable<String>? autofillHints,
    VoidCallback? onEditingComplete,
    TextEditingController? controller,
    Key? fieldKeyOverride,
  }) {
    ///
    return switch (type) {
      ///
      InputFieldType.name => AppFormField(
        key: fieldKeyOverride ?? FormFieldsKeys.nameField,
        focusNode: focusNode,
        label: CoreLocaleKeys.form_name,
        icon: AppIcons.name,
        obscure: false,
        errorKey: errorText,
        keyboardType: TextInputType.name,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: (_) => onSubmitted?.call(),
        controller: controller,
      ),

      ///
      InputFieldType.email => AppFormField(
        key: fieldKeyOverride ?? FormFieldsKeys.emailField,
        focusNode: focusNode,
        label: CoreLocaleKeys.form_email,
        icon: AppIcons.email,
        obscure: false,
        errorKey: errorText,
        keyboardType: TextInputType.emailAddress,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: (_) => onSubmitted?.call(),
        controller: controller,
      ),

      ///
      InputFieldType.password => AppFormField(
        key: fieldKeyOverride ?? FormFieldsKeys.passwordField,
        focusNode: focusNode,
        label: CoreLocaleKeys.form_password,
        icon: AppIcons.password,
        obscure: isObscure,
        suffixIcon: suffixIcon,
        errorKey: errorText,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: (_) => onSubmitted?.call(),
        controller: controller,
      ),

      ///
      InputFieldType.confirmPassword => AppFormField(
        key: fieldKeyOverride ?? FormFieldsKeys.confirmPasswordField,
        focusNode: focusNode,
        label: CoreLocaleKeys.form_confirm_password,
        icon: AppIcons.confirmPassword,
        obscure: isObscure,
        suffixIcon: suffixIcon,
        errorKey: errorText,
        keyboardType: TextInputType.visiblePassword,
        textInputAction: textInputAction,
        autofillHints: autofillHints,
        onChanged: onChanged,
        onEditingComplete: onEditingComplete,
        onSubmitted: (_) => onSubmitted?.call(),
        controller: controller,
      ),

      //
    };
  }
}
