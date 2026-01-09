import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show
        RiverpodAdapterForFooterGuard,
        RiverpodAdapterForSubmissionFlowSideEffects,
        RiverpodAdapterForSubmitButton;
import 'package:app_on_riverpod/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_riverpod/core/shared_presentation/utils/flavor_x.dart'
    show FlavorX;
import 'package:app_on_riverpod/features/password_changing_or_reset/reset_password/providers/input_fields_provider.dart'
    show resetPasswordFormProvider;
import 'package:app_on_riverpod/features/password_changing_or_reset/reset_password/providers/reset_password__provider.dart'
    show resetPasswordProvider;
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
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
final class ResetPasswordPage extends ConsumerWidget {
  ///----------------------------------------------
  const ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🦻 Riverpod-side effects listener (symmetry with BLoC 'SubmissionSideEffects')
    /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
    ref.listenSubmissionSideEffects(
      resetPasswordProvider,
      context,
      config: SubmissionSideEffectsConfig(
        // ✅ Success → snackbar + go [SignInPage]
        onSuccess: (ctx, _) => ctx
          ..showSnackbar(message: AppLocaleKeys.reset_password_success)
          ..goTo(RoutesNames.signIn),
        // 🔁 Retry with current form state
        onRetry: (ctx) => ref.submitResetPassword(),
        // 🧹 (optional) forms' reset after error
        // onResetForm: (ctx) => ref.read(resetPasswordFormProvider.notifier).reset(),
      ),
    );
    //
    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _ResetPasswordScreen();
  }
}

////
////

/// 🔐 [_ResetPasswordScreen] — Screen that allows the user to reset password.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ResetPasswordScreen extends HookWidget {
  ///---------------------------------------------
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

                      /// 🔁 Links to redirect to sign-in screen
                      const _ResetPasswordPageFooterGuard(),
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

////
////

/// 🧩 [ResetPasswordRefX] — Triggers reset-password using current form state (reads form provider).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension ResetPasswordRefX on WidgetRef {
  ///----------------------------------
  /// 📤 Submits the password reset request using the current form state.
  void submitResetPassword() {
    final form = read(resetPasswordFormProvider);
    context.unfocusKeyboard();
    read(resetPasswordProvider.notifier).resetPassword(email: form.email.value);
  }
}
