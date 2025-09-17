import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/change_password/cubit/change_password_cubit.dart';
import 'package:app_on_bloc/features_presentation/password_changing_or_reset/change_password/cubit/change_password_form_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:features/features.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_change_password.dart';

/// 🔐 [ChangePasswordPage] — Entry point for the sign-up feature,
/// 🧾 that allows user to request password change
/// ✅ Provides scoped cubit with injected services
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
        BlocProvider(
          create: (_) => ChangePasswordFormCubit(di<FormValidationService>()),
        ),
        BlocProvider(
          create: (_) => ChangePasswordCubit(
            di<PasswordRelatedUseCases>(),
            di<SignOutUseCase>(),
          ),
        ),
      ],

      ///
      child: MultiBlocListener(
        listeners: [
          /// ❌ Error Listener
          BlocListener<ChangePasswordCubit, ChangePasswordState>(
            listenWhen: (prev, curr) => prev.runtimeType != curr.runtimeType,
            listener: (context, state) async {
              //
              switch (state) {
                //
                /// ✅ Success
                case ChangePasswordSuccess():
                  context
                    ..showSnackbar(
                      message: LocaleKeys.reauth_password_updated.tr(),
                    )
                    // 🧭 Navigation after success
                    ..goIfMounted(RoutesNames.home);

                /// ❌ Error
                case ChangePasswordError(:final failure):
                  context.showError(failure.toUIEntity());
                  context.read<ChangePasswordCubit>().resetState();

                /// 🔄 Requires Reauth → show dialog, than signOut for reAuth
                case ChangePasswordRequiresReauth(:final failure):
                  context.showError(
                    failure.toUIEntity(),
                    onConfirm: () async {
                      await context.read<ChangePasswordCubit>().confirmReauth();
                    },
                  );

                ///
                default:
                  break;
                //
              }
            },
          ),
        ],

        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _ChangePasswordView(),
      ),
    );
  }
}

////
////

/// 🔐 [_ChangePasswordView] — Screen that allows the user to update their password.
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _ChangePasswordView extends HookWidget {
  ///-------------------------------------------
  const _ChangePasswordView();

  @override
  Widget build(BuildContext context) {
    //
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
                      //
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
