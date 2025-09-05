import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_in/cubit/sign_in_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show FormSubmitButton, OverlayStatusCubit, di;
import 'package:core/base_modules/errors_management.dart';
import 'package:core/base_modules/forms.dart'
    show
        FormValidationService,
        FormzStatusX,
        InputFieldFactory,
        InputFieldType,
        ObscureToggleIcon,
        useSignInFocusNodes;
import 'package:core/base_modules/localization.dart'
    show AppLocalizer, LocaleKeys;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/overlays.dart';
import 'package:core/base_modules/ui_design.dart' show AppColors, AppSpacing;
import 'package:core/shared_layers/presentation.dart' show AppTextButton;
import 'package:core/utils.dart';
import 'package:features/features.dart' show SignInUseCase;
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
