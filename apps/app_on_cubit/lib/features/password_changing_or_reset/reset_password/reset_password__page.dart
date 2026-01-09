import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show
        BlocAdapterForFooterGuard,
        BlocAdapterForSubmissionFlowSideEffects,
        BlocAdapterForSubmitButton,
        BlocWatchSelectX,
        di;
import 'package:app_on_cubit/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_cubit/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_cubit/core/shared_presentation/utils/flavor_x.dart'
    show FlavorX;
import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/form_fields_cubit.dart'
    show ResetPasswordFormFieldsCubit;
import 'package:app_on_cubit/features/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart'
    show ResetPasswordCubit;
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
    show OverlayBaseMethods;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, OtherContextX, WidgetPaddingX;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionStateX,
        SubmissionFlowStateModel,
        SubmissionSideEffectsConfig;
import 'package:shared_widgets/public_api/buttons.dart' show AppTextButton;
import 'package:shared_widgets/public_api/footers.dart'
    show FooterEnabledContextX;
import 'package:shared_widgets/public_api/text_widgets.dart';

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
            ..showSnackbar(message: AppLocaleKeys.reset_password_success)
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
