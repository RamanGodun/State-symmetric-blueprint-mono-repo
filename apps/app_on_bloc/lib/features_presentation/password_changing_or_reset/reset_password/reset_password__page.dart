import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/reset_password/cubits/input_fields_cubit.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/reset_password/cubits/reset_password__cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features_barrels/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_reset_password_page.dart';

/// 🔐 [ResetPasswordPage] — Entry point for the sign-up feature,
/// 🧾 that allows user to request password reset
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
          create: (_) => ResetPasswordFormCubit(),
        ),
      ],

      /// 🛡️ Wraps [_ResetPasswordView] with side-effect listeners (handles ❌Error & ✅Success cases)
      child: SubmissionSideEffects<ResetPasswordCubit>(
        onSuccess: (ctx, _) => ctx
          ..showSnackbar(message: LocaleKeys.reset_password_success)
          ..goTo(RoutesNames.signIn),
        onResetForm: (ctx) => ctx.read<ResetPasswordFormCubit>().resetState(),
        //
        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _ResetPasswordView(),
      ),
    );
  }
}

/// 🔐 [_ResetPasswordView] — Screen that allows user to request password reset
/// 📩 Sends reset link to user's email using [ResetPasswordCubit]
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ResetPasswordView extends StatelessWidget {
  ///------------------------------------------------
  const _ResetPasswordView();

  @override
  Widget build(BuildContext context) {
    //
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
                    children: const [
                      /// ℹ️ Info section for [ResetPasswordPage]
                      _ResetPasswordHeader(),

                      /// 🔒 Password input field
                      _ResetPasswordEmailInputField(),

                      /// 🚀 Primary submit button
                      _ResetPasswordSubmitButton(),

                      /// 🔁 [_ResetPasswordPageFooter] — sign in redirect link with guard (during form submission or active overlay)
                      _ResetPasswordFooterGuard(),
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
