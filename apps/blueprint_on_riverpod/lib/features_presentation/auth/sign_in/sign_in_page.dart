import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_riverpod/features_presentation/auth/sign_in/providers/sign_in__provider.dart';
import 'package:blueprint_on_riverpod/features_presentation/auth/sign_in/providers/sign_in_form_fields_provider.dart';
import 'package:core/base_modules/form_fields/_form_field_factory.dart'
    show InputFieldFactory;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;
import 'package:core/base_modules/form_fields/utils/use_auth_focus_nodes.dart'
    show useSignInFocusNodes;
import 'package:core/base_modules/form_fields/widgets/password_visibility_icon.dart'
    show ObscureToggleIcon;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/base_modules/theme/ui_constants/app_colors.dart'
    show AppColors;
import 'package:core/shared_presentation_layer/widgets_shared/buttons/filled_button.dart'
    show CustomFilledButton;
import 'package:core/shared_presentation_layer/widgets_shared/buttons/text_button.dart'
    show AppTextButton;
import 'package:core/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show HookConsumerWidget;
import 'package:riverpod_adapter/base_modules/errors_handling_module/show_dialog_when_error_x.dart';
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_status_x.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — screen that allows user to sign in.
//
final class SignInPage extends HookConsumerWidget {
  ///-------------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    final focus = useSignInFocusNodes();

    /// 🧠🔁 Intelligent failure listener (declarative side-effect for error displaying) with optional "Retry" logic.
    ref.listenRetryAwareFailure(
      signInProvider,
      context,
      ref: ref,
      onRetry: () => ref.submit(),
    );

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,

          /// used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  ///
                  child: ListView(
                    children: [
                      //
                      const _SignInHeader(),
                      _SignInEmailInputField(focus),
                      _SignInPasswordInputField(focus),
                      const _SigninSubmitButton(),
                      const _SigninFooter(),
                      //
                    ],
                  ).withPaddingHorizontal(AppSpacing.xxxm),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  //
}

////
////

/// 📩 Handles form validation and submission to [signInProvider].
//
extension SignInRefX on WidgetRef {
  ///-------------------------------
  //
  /// 📩 Triggers sign-in logic based on current form state
  void submit() {
    final form = read(signInFormProvider);
    read(
      signInProvider.notifier,
    ).signin(email: form.email.value, password: form.password.value);
  }
}
