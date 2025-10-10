import 'package:app_on_bloc/core/shared_presentation/utils/images_paths/flavor_x.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_in/sign_in__page.dart'
    show SignInPage;
import 'package:app_on_bloc/features_presentation/auth/sign_up/cubit/form_fields_cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_up/cubit/sign_up_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/public_api/core.dart';
import 'package:features/features.dart' show SignUpUseCase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;

part 'sign_up_input_fields.dart';
part 'widgets_for_sign_up_page.dart';

/// 🧾🔐 [SignUpPage] — Entry point for the sign-up feature
//
final class SignUpPage extends StatelessWidget {
  ///----------------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(di<SignUpUseCase>())),
        BlocProvider(
          create: (_) => SignUpFormFieldCubit(),
        ),
      ],

      /// 🦻 Bloc side-effect listener (symmetry with Riverpod 'ref.listenSubmissionSideEffects')
      /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
      child: SubmissionStateSideEffects<SignUpCubit>(
        /// ✅ Success → snackbar + go [VerifyEmailPage]
        onSuccess: (ctx, _) =>
            ctx.showSnackbar(message: LocaleKeys.sign_up_success),
        // 🔁 Retry with current form state
        onRetry: (ctx) => ctx.submitSignUp(),

        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _SignUpScreen(),
      ),
    );
  }
}

////
////

/// 🔐 [_SignUpScreen] — Main UI layout for the sign-up form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignUpScreen extends HookWidget {
  ///--------------------------------------
  const _SignUpScreen();

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
          // used "LayoutBuilder+ConstrainedBox" pattern
          child: LayoutBuilder(
            builder: (context, constraints) {
              return ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: FocusTraversalGroup(
                  child: AutofillGroup(
                    ///
                    child: ListView(
                      children: [
                        /// 🔰 Logo with Hero animation
                        const _SignUpHeader(),

                        /// 👤 Name input field
                        _UserNameFormField(focusNodes),

                        /// 📧 Email input
                        _EmailFormField(focusNodes),

                        /// 🔒 Password input field
                        _PasswordFormField(focusNodes),

                        /// 🔐 Confirm password input
                        _ConfirmPasswordFormField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignUpSubmitButton(),

                        /// 🔁 Links to redirect to sign-in screen
                        const _SignUpPageFooterGuard(),
                      ],
                    ).centered().withPaddingHorizontal(AppSpacing.xxxm),
                    //
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

////
////

/// 🧩 [SignUpContextX] — Triggers sign-up using current form state (reads form cubit).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension SignUpContextX on BuildContext {
  ///----------------------------------
  /// 🚀 Perform submit, using current form state
  void submitSignUp() {
    unfocusKeyboard();
    final currentForm = read<SignUpFormFieldCubit>().state;
    read<SignUpCubit>().signUp(
      name: currentForm.name.value,
      email: currentForm.email.value,
      password: currentForm.password.value,
    );
  }
}
