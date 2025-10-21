import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/core/shared_presentation/utils/images_paths/flavor_x.dart';
import 'package:app_on_bloc/features/auth/sign_in/cubit/form_fields_cubit.dart';
import 'package:app_on_bloc/features/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/public_api/core.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — Entry point for the sign-in feature
//
final class SignInPage extends StatelessWidget {
  ///----------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// ✅ Provides screen-scoped cubits with injected services (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignInCubit(di<SignInUseCase>())),
        BlocProvider(create: (_) => SignInFormCubit()),
      ],

      /// 🦻 Bloc side-effect listener (symmetry with Riverpod 'ref.listenSubmissionSideEffects')
      /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
      child: BlocAdapterForSubmissionFlowSideEffects<SignInCubit>(
        config: SubmissionSideEffectsConfig(
          // ✅ Success → snackbar + go home
          onSuccess: (ctx, _) =>
              ctx.showSnackbar(message: LocaleKeys.sign_in_success),
          // 🔁 Retry with current form state
          onRetry: (ctx) => ctx.submitSignIn(),
          // 🧹 (optional) forms' reset after error
          // onResetForm: (ctx) => ctx.read<SignInFormFieldsCubit>().reset(),
        ),
        //
        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _SignInScreen(),
      ),
    );
  }
}

////
////

/// 🔐 [_SignInScreen] — Main UI layout for the sign-in form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignInScreen extends HookWidget {
  ///--------------------------------------
  const _SignInScreen();

  @override
  Widget build(BuildContext context) {
    //
    ///  📌 Initialize and memoize focus nodes for fields
    final focusNodes = useSignInFocusNodes();

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
                        /// 🖼️ Logo with Hero animation
                        const _SignInHeader(),

                        /// 📧 Email input field
                        _EmailFormField(focusNodes),

                        /// 🔒 Password input field
                        _PasswordFormField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignInSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _SignInPageFooterGuard(),
                        //
                      ],
                    ).centered().withPaddingHorizontal(AppSpacing.xxxm),
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

/// 🧩 [SignInContextX] — Triggers sign-in using current form state (reads form cubit).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension SignInContextX on BuildContext {
  ///----------------------------------
  /// 🚀 Perform submit, using current form state
  void submitSignIn() {
    unfocusKeyboard();
    final form = read<SignInFormCubit>().state;
    read<SignInCubit>().signin(
      email: form.email.value,
      password: form.password.value,
    );
  }
}
