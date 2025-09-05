import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_in/cubit/sign_in_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show FormSubmitButton, OverlayStatusCubit, di;
import 'package:core/base_modules/errors_handling/core_of_module/failure_ui_mapper.dart';
import 'package:core/base_modules/errors_handling/extensible_part/failure_extensions/failure_led_retry_x.dart';
import 'package:core/base_modules/form_fields/_form_field_factory.dart'
    show InputFieldFactory;
import 'package:core/base_modules/form_fields/input_validation/validation_enums.dart'
    show InputFieldType;
import 'package:core/base_modules/form_fields/input_validation/x_on_forms_submission_status.dart';
import 'package:core/base_modules/form_fields/utils/form_validation_service.dart';
import 'package:core/base_modules/form_fields/utils/use_auth_focus_nodes.dart'
    show useSignInFocusNodes;
import 'package:core/base_modules/form_fields/widgets/password_visibility_icon.dart'
    show ObscureToggleIcon;
import 'package:core/base_modules/localization/core_of_module/init_localization.dart'
    show AppLocalizer;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/overlays/core/enums_for_overlay_module.dart'
    show ShowAs;
import 'package:core/base_modules/overlays/utils/overlay_utils.dart'
    show OverlayUtils;
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/base_modules/theme/ui_constants/app_colors.dart'
    show AppColors;
import 'package:core/shared_presentation_layer/widgets_shared/buttons/text_button.dart';
import 'package:core/utils_shared/extensions/context_extensions/_context_extensions.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:core/utils_shared/spider/app_images_paths.dart';
import 'package:features/auth/domain/use_cases/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;

part 'sign_in_widgets.dart';

/// 🔐 [SignInPage] — Entry point for the sign-in feature
/// ✅ Provides scoped cubit with injected services
//
final class SignInPage extends StatelessWidget {
  ///----------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    return BlocProvider(
      create: (_) =>
          SignInCubit(di<SignInUseCase>(), di<FormValidationService>()),

      /// 🔄 [_SignInErrorsListener] — Bloc listener for one-shot error feedback.
      /// ✅ Uses `Consumable<FailureUIModel>` for single-use error overlays.
      child: BlocListener<SignInCubit, SignInPageState>(
        listenWhen: (prev, curr) =>
            prev.status != curr.status && curr.status.isSubmissionFailure,

        /// 📣 Show once retryable dialog if supported, otherwise info dialog
        /// and then reset failure + status
        listener: (context, state) {
          final error = state.failure?.consume();

          if (error != null) {
            if (error.isRetryable) {
              context.showError(
                error.toUIEntity(),
                showAs: ShowAs.dialog,
                onConfirm: OverlayUtils.dismissAndRun(
                  () => context.read<SignInCubit>().submit(),
                  context,
                ),
                confirmText: AppLocalizer.translateSafely(
                  LocaleKeys.buttons_retry,
                ),
              );
            } else {
              context.showError(error.toUIEntity());
            }

            context.read<SignInCubit>()
              ..resetStatus()
              ..clearFailure();
          }
        },

        ///
        child: const SignInPageView(),
      ),
    );
  }
}

////

////

/// 🔐 [SignInPageView] — Main UI layout for the sign-in form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
//
final class SignInPageView extends HookWidget {
  ///----------------------------------------
  const SignInPageView({super.key});

  @override
  Widget build(BuildContext context) {
    //
    // 📌 Initialize and memoize focus nodes for fields
    final focusNodes = useSignInFocusNodes();

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: context.unfocusKeyboard,
          child: FocusTraversalGroup(
            child: AutofillGroup(
              child:
                  ///
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.l,
                    ),
                    children: [
                      /// 🖼️ Logo with Hero animation for smooth transitions
                      const _LogoImage(),
                      const SizedBox(height: AppSpacing.l),

                      /// 📧 Email input field
                      _EmailField(
                        focusNode: focusNodes.email,
                        nextFocus: focusNodes.password,
                      ),
                      const SizedBox(height: AppSpacing.l),

                      /// 🔒 Password input field
                      _PasswordField(focusNode: focusNodes.password),
                      const SizedBox(height: AppSpacing.xl),

                      /// 🚀 Primary submit button
                      const _SubmitButton(),
                      const SizedBox(height: AppSpacing.l),

                      /// 🔁 Link to redirect to sign-up screen
                      const _SignInFooter(),
                    ],
                  ).centered(),
            ),
          ),
        ),
      ),
    );
  }

  //
}
