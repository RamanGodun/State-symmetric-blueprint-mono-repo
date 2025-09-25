import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/change_password/cubit/change_password__cubit.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/change_password/cubit/input_fields_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Entry point for the change-password feature,
//
final class ChangePasswordPage extends StatelessWidget {
  ///---------------------------------------
  const ChangePasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => ChangePasswordFormFieldsCubit()),
        BlocProvider(
          create: (_) => ChangePasswordCubit(
            di<PasswordRelatedUseCases>(),
            di<SignOutUseCase>(),
          ),
        ),
      ],

      /// 🦻 Bloc side-effect listener (symmetry with Riverpod 'ref.listenSubmissionSideEffects')
      /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
      child: SubmissionSideEffects<ChangePasswordCubit>(
        // ✅ Success → snackbar + go home
        onSuccess: (ctx, _) => ctx
          ..showSnackbar(message: LocaleKeys.reauth_password_updated.tr())
          ..goIfMounted(RoutesNames.home),
        // 🔄 Requires reauth → dialog with confirm → signOut
        onRequiresReauth: (ctx, ui, _) =>
            ctx.showError(ui, onConfirm: ctx.onReAuthConfirm),
        // 🔁 Retry with current form state
        onRetry: (ctx) => ctx.submitChangePassword(),

        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _ChangePasswordScreen(),
      ),
    );
  }
}

////
////

/// 🔐 [_ChangePasswordScreen] — Screen that allows the user to update their password.
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ChangePasswordScreen extends HookWidget {
  ///----------------------------------------------
  const _ChangePasswordScreen();

  @override
  Widget build(BuildContext context) {
    //
    /// 📌 Shared focus nodes for form fields
    final focusNodes = useChangePasswordFocusNodes();

    return Scaffold(
      appBar: AppBar(),
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
                      /// ℹ️ Info section for [ChangePasswordPage]
                      const _ChangePasswordInfo(),

                      /// 🔒 Password input field
                      _PasswordInputField(focusNodes),

                      /// 🔐 Confirm password input
                      _ConfirmPasswordInputField(focusNodes),

                      /// 🚀 Primary submit button
                      const _ChangePasswordSubmitButton(),
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

/// 🧩 [ChangePasswordContextX] — UI-side actions for ChangePassword flow (BLoC)
//
extension ChangePasswordContextX on BuildContext {
  /// 📤 Submit password change using current form values (and hide keyboard)
  void submitChangePassword() {
    unfocusKeyboard();
    final currentState = read<ChangePasswordFormFieldsCubit>().state;
    read<ChangePasswordCubit>().submit(currentState.password.value);
  }

  /// ✅ Confirm the re-authentication requirement (delegated to cubit)
  void onReAuthConfirm() => read<ChangePasswordCubit>().confirmReauth();
  //
}
