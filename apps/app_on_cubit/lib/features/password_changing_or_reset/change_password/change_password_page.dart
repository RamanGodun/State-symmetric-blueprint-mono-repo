import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show
        BlocAdapterForSubmissionFlowSideEffects,
        BlocAdapterForSubmitButton,
        BlocWatchSelectX,
        di;
import 'package:app_on_cubit/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_cubit/features/password_changing_or_reset/change_password/cubit/change_password_cubit.dart'
    show ChangePasswordCubit;
import 'package:app_on_cubit/features/password_changing_or_reset/change_password/cubit/form_fields_cubit.dart'
    show ChangePasswordFormFieldsCubit;
import 'package:easy_localization/easy_localization.dart';
import 'package:features_dd_layers/public_api/auth/auth.dart'
    show SignOutUseCase;
import 'package:features_dd_layers/public_api/password_changing_or_reset/password_changing_or_reset.dart'
    show PasswordRelatedUseCases;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'
    show BlocProvider, MultiBlocProvider, ReadContext;
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:shared_core_modules/public_api/base_modules/forms.dart';
import 'package:shared_core_modules/public_api/base_modules/navigation.dart'
    show NavigationX;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show ContextXForOverlays, OverlayBaseMethods;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, OtherContextX, ThemeXOnContext, WidgetPaddingX;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show ButtonSubmissionStateX, SubmissionSideEffectsConfig;
import 'package:shared_widgets/public_api/text_widgets.dart';

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
      child: BlocAdapterForSubmissionFlowSideEffects<ChangePasswordCubit>(
        config: SubmissionSideEffectsConfig(
          // ✅ Success → snackbar + go home
          onSuccess: (ctx, _) => ctx
            ..showSnackbar(
              message: AppLocaleKeys.change_password_password_updated.tr(),
            )
            ..goIfMounted(RoutesNames.home),
          // 🔄 Requires reauth → dialog with confirm → signOut
          onRequiresReauth: (ctx, ui, _) =>
              ctx.showError(ui, onConfirm: ctx.onReAuthConfirm),
          // 🔁 Retry with current form state
          onRetry: (ctx) => ctx.submitChangePassword(),
          // 🧹 (optional) forms' reset after error
          // onResetForm: (ctx) => ctx.read<ChangePasswordFormFieldsCubit>().reset(),
        ),
        //
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
                      _PasswordFormField(focusNodes),

                      /// 🔐 Confirm password input
                      _ConfirmPasswordFormField(focusNodes),

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
    read<ChangePasswordCubit>().changePassword(currentState.password.value);
  }

  /// ✅ Confirm the re-authentication requirement (delegated to cubit)
  void onReAuthConfirm() => read<ChangePasswordCubit>().confirmReauth();
  //
}
