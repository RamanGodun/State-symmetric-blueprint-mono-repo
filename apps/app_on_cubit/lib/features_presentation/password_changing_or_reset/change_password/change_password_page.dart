import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_cubit/features_presentation/password_changing_or_reset/change_password/cubit/change_password_cubit.dart';
import 'package:app_on_cubit/features_presentation/password_changing_or_reset/reset_password/reset_password_page.dart'
    show ResetPasswordPage;
import 'package:bloc_adapter/di/core/di.dart';
import 'package:bloc_adapter/presentation_shared/widgets_shared/form_submit_button.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/form_fields/_form_field_factory.dart'
    show InputFieldFactory;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;
import 'package:core/base_modules/form_fields/input_validation/x_on_forms_submission_status.dart';
import 'package:core/base_modules/form_fields/utils/form_validation_service.dart'
    show FormValidationService;
import 'package:core/base_modules/form_fields/utils/use_auth_focus_nodes.dart'
    show useChangePasswordFocusNodes;
import 'package:core/base_modules/form_fields/widgets/password_visibility_icon.dart'
    show ObscureToggleIcon;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/overlays/core/_overlay_base_methods.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:core/utils_shared/type_definitions.dart' show FieldUiState;
import 'package:easy_localization/easy_localization.dart';
import 'package:features/password_changing_or_reset/domain/password_actions_use_case.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — allows user to request password change
/// 🔁 Declarative side-effect for [ResetPasswordPage]
//
final class ChangePasswordPage extends StatelessWidget {
  ///---------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (_) => ChangePasswordCubit(
        di<PasswordRelatedUseCases>(),
        di<FormValidationService>(),
      ),
      child: MultiBlocListener(
        listeners: [
          /// ❌ Error Listener
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionFailure,
            listener: (context, state) {
              final error = state.failure?.consume();
              if (error != null) {
                context.showError(error.toUIEntity());
                context.read<ChangePasswordCubit>().clearFailure();
              }
            },
          ),

          /// ✅ Success Listener
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionSuccess,
            listener: (context, state) {
              context
                ..showSnackbar(message: LocaleKeys.change_password_success)
                // 🧭 Navigation after success
                ..goTo(RoutesNames.home);
            },
          ),
        ],

        child: const _ChangePasswordView(),
      ),
    );
  }
}

/// 🔐 [_ChangePasswordView] — Screen that allows the user to update their password.
//
final class _ChangePasswordView extends HookWidget {
  ///-------------------------------------------
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    //
    final focus = useChangePasswordFocusNodes();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,
          child: FocusTraversalGroup(
            child: ListView(
              shrinkWrap: true,
              children: [
                //
                const _ChangePasswordInfo(),
                _PasswordField(focusNodes: focus),
                _ConfirmPasswordField(focusNodes: focus),
                const _ChangePasswordSubmitButton(),
                //
              ],
            ).withPaddingHorizontal(AppSpacing.l),
          ),
        ),
      ),
    );
  }

  //
}
