import 'package:app_on_bloc/features_presentation/auth/sign_up/cubit/sign_up_page_cubit.dart'
    show SignUpCubit, SignUpState;
import 'package:bloc_adapter/bloc_adapter.dart'
    show
        FailureListenerForAppWithBloc,
        FormSubmitButtonForBlocApps,
        OverlayStatusCubit,
        di;
import 'package:core/base_modules/forms.dart'
    show
        FormValidationService,
        FormzStatusX,
        InputFieldFactory,
        InputFieldType,
        ObscureToggleIcon,
        useSignUpFocusNodes;
import 'package:core/base_modules/localization.dart'
    show LocaleKeys, TextType, TextWidget;
import 'package:core/base_modules/navigation.dart';
import 'package:core/base_modules/ui_design.dart' show AppSpacing;
import 'package:core/shared_layers/presentation.dart' show AppTextButton;
import 'package:core/utils.dart';
import 'package:features/features.dart' show SignUpUseCase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;

part 'sign_up_widgets.dart';

/// 🧾 [SignUpPage] — Entry point for the sign-up feature
/// ✅ Provides scoped cubit with injected service
//
final class SignUpPage extends StatelessWidget {
  ///-----------------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return BlocProvider(
      create: (_) => SignUpCubit(
        di<SignUpUseCase>(),
        di<FormValidationService>(),
      ),

      /// 🔄 [RetryAwareFailureListener] — Bloc listener for one-shot
      ///    error handling (with optional "retry" logic) via overlays
      /// 🧠 OverlayDispatcher resolves conflicts/priority internally
      child: FailureListenerForAppWithBloc<SignUpState, SignUpCubit>(
        onRetry: (cubit) => cubit.submit(),

        ///
        child: const _SignUpView(),
      ),
    );
  }
}

////

////

/// 🔐 [_SignUpView] — Main UI layout for the sign-in form
///    Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignUpView extends HookWidget {
  ///------------------------------------
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    //
    // 📌 Shared focus nodes for form fields
    final focusNodes = useSignUpFocusNodes();

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          // 🔕 Dismiss keyboard on outside tap
          onTap: context.unfocusKeyboard,
          //
          child: FocusTraversalGroup(
            child: ListView(
              shrinkWrap: true,
              children: [
                /// 🔰 Logo with optional hero animation
                const _SignInHeader(),
                const SizedBox(height: AppSpacing.l),

                /// 👤 Name input
                _SignInEmailInputField(
                  focusNode: focusNodes.name,
                  nextFocusNode: focusNodes.email,
                ),
                const SizedBox(height: AppSpacing.l),

                /// 📧 Email input
                _EmailField(
                  focusNode: focusNodes.email,
                  nextFocusNode: focusNodes.password,
                ),
                const SizedBox(height: AppSpacing.l),

                /// 🔒 Password input
                _PasswordField(focusNodes: focusNodes),
                const SizedBox(height: AppSpacing.l),

                /// 🔐 Confirm password input
                _ConfirmPasswordField(focusNode: focusNodes.confirmPassword),
                const SizedBox(height: AppSpacing.xxxl),

                /// 🚀 Form submission button
                const _SubmitButton(),
                const SizedBox(height: AppSpacing.xxxs),

                /// 🔁 Redirect to Sign In page
                const _RedirectToSignInButton(),
              ],
            ).centered().withPaddingHorizontal(AppSpacing.l),
          ),
        ),
      ),
    );
  }
}
