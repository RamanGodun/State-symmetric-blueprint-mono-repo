import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_riverpod/features_presentation/auth/sign_in/sign_in_page.dart';
import 'package:blueprint_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password__provider.dart';
import 'package:blueprint_on_riverpod/features_presentation/password_changing_or_reset/change_password/providers/change_password_form_provider.dart';
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/form_fields/_form_field_factory.dart'
    show InputFieldFactory;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;
import 'package:core/base_modules/form_fields/utils/use_auth_focus_nodes.dart'
    show useChangePasswordFocusNodes;
import 'package:core/base_modules/form_fields/widgets/password_visibility_icon.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/shared_presentation_layer/widgets_shared/buttons/filled_button.dart';
import 'package:core/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart' show HookConsumerWidget;
import 'package:riverpod_adapter/base_modules/overlays_module/overlay_dispatcher_provider.dart';

part 'widgets_for_change_password.dart';
part 'x_on_ref_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Screen that allows the user to update their password.
//
final class ChangePasswordPage extends HookConsumerWidget {
  ///-------------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // 🔁 Declarative side-effect for ChangePassword
    ref.listenToPasswordChange(context);

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
                _PasswordField(focus: focus),
                _ConfirmPasswordField(focus: focus),
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
