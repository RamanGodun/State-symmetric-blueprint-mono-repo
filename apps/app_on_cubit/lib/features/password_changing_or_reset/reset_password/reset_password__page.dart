import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_cubit/core/shared_presentation/utils/images_paths/flavor_x.dart';
import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/form_fields_cubit.dart';
import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/public_api/core.dart';
import 'package:features/features_barrels/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_reset_password_page.dart';

/// 🔐 [ResetPasswordPage] — Entry point for the reset-password feature,
//
final class ResetPasswordPage extends StatelessWidget {
  ///---------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ResetPasswordCubit(di<PasswordRelatedUseCases>()),
        ),
        BlocProvider(
          create: (_) => ResetPasswordFormFieldsCubit(),
        ),
      ],

      /// 🦻 Bloc side-effect listener (symmetry with Riverpod 'ref.listenSubmissionSideEffects')
      /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
      child: BlocAdapterForSubmissionFlowSideEffects<ResetPasswordCubit>(
        config: SubmissionSideEffectsConfig(
          // ✅ Success → snackbar + go [SignInPage]
          onSuccess: (ctx, _) => ctx
            ..showSnackbar(message: LocaleKeys.reset_password_success)
            ..goTo(RoutesNames.signIn),
          // 🔁 Retry with current form state
          onRetry: (ctx) => ctx.submitResetPassword(),
          // 🧹 (optional) forms' reset after error
          // onResetForm: (ctx) => ctx.read<ResetPasswordFormFieldsCubit>().reset(),
        ),
        //
        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _ResetPasswordScreen(),
      ),
    );
  }
}

/// 🔐 [_ResetPasswordScreen] — Screen that allows user to request password reset
/// 📩 Sends reset link to user's email using [ResetPasswordCubit]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ResetPasswordScreen extends HookWidget {
  ///--------------------------------------------------
  const _ResetPasswordScreen();

  @override
  Widget build(BuildContext context) {
    //
    /// 📌 Shared focus nodes for form fields
    final focusNodes = useResetPasswordFocusNodes();

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
                  ///
                  child: ListView(
                    children: [
                      /// ℹ️ Info section for [ResetPasswordPage]
                      const _ResetPasswordHeader(),

                      /// 📧 Email input field
                      _EmailFormField(focusNodes),

                      /// 🚀 Primary submit button
                      const _ResetPasswordSubmitButton(),

                      /// 🔁 [_ResetPasswordPageFooter] — sign in redirect link with guard (during form submission or active overlay)
                      const _ResetPasswordPageFooterGuard(),
                      //
                    ],
                  ).withPaddingHorizontal(AppSpacing.l),
                  //
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

/// 🧩 [ResetPasswordContextX] — Triggers reset-password using current form state (reads form cubit).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension ResetPasswordContextX on BuildContext {
  ///-----------------------------------------
  /// 🚀 Perform submit, using current form state
  void submitResetPassword() {
    unfocusKeyboard();
    final currentState = read<ResetPasswordFormFieldsCubit>().state;
    read<ResetPasswordCubit>().resetPassword(
      currentState.email.value,
    );
  }
}
