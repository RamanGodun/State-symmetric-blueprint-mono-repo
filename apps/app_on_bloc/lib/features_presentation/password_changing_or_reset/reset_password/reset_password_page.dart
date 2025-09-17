import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart'
    show FormSubmitButtonForBlocApps, di;
import 'package:core/core.dart';
import 'package:features/features_barrels/password_changing_or_reset/password_changing_or_reset.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:formz/formz.dart';

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
    return BlocProvider(
      create: (_) => ResetPasswordCubit(
        di<PasswordRelatedUseCases>(),
        di<FormValidationService>(),
      ),

      ///
      child: MultiBlocListener(
        listeners: [
          /// ❌ Error Listener
          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionFailure,
            listener: (context, state) {
              final error = state.failure?.consume();
              if (error != null) {
                context.showError(error.toUIEntity());
                context.read<ResetPasswordCubit>().clearFailure();
              }
            },
          ),

          /// ✅ Success Listener
          BlocListener<ResetPasswordCubit, ResetPasswordState>(
            listenWhen: (prev, curr) =>
                prev.status != curr.status && curr.status.isSubmissionSuccess,
            listener: (context, state) {
              context
                ..showSnackbar(message: LocaleKeys.reset_password_success)
                // 🧭 Navigation after success
                ..goTo(RoutesNames.signIn);
            },
          ),
        ],

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
                      SizedBox(height: AppSpacing.huge),

                      /// 🚀 Primary submit button
                      _ResetPasswordSubmitButton(),
                      SizedBox(height: AppSpacing.xxxs),

                      _ResetPasswordFooter(),
                    ],
                  ).withPaddingHorizontal(AppSpacing.l),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
