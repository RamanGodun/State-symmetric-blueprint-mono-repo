import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show
        RiverpodAdapterForFooterGuard,
        RiverpodAdapterForSubmissionFlowSideEffects,
        RiverpodAdapterForSubmitButton;
import 'package:app_on_riverpod/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_riverpod/core/shared_presentation/utils/flavor_icon_path__x.dart'
    show FlavorIconPathX;
import 'package:app_on_riverpod/features/auth/sign_in/providers/input_form_fields_provider.dart'
    show signInFormProvider;
import 'package:app_on_riverpod/features/auth/sign_in/providers/sign_in__provider.dart'
    show signInProvider;
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
    show AppColors, AppSpacing, OtherContextX, WidgetAlignX, WidgetPaddingX;
import 'package:shared_layers/public_api/presentation_layer_shared.dart'
    show
        ButtonSubmissionStateX,
        SubmissionFlowStateModel,
        SubmissionSideEffectsConfig;
import 'package:shared_widgets/public_api/buttons.dart' show AppTextButton;
import 'package:shared_widgets/public_api/footers.dart'
    show FooterEnabledContextX;
import 'package:shared_widgets/public_api/text_widgets.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — Entry point for the sign-in feature
//
final class SignInPage extends ConsumerWidget {
  ///---------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 🦻 Riverpod-side effects listener (symmetry with BLoC 'SubmissionSideEffects')
    /// 🧠🛡️ OverlayDispatcher resolves conflicts/priority internally
    ref.listenSubmissionSideEffects(
      signInProvider,
      context,
      config: SubmissionSideEffectsConfig(
        // ✅ Success → snackbar + go home
        onSuccess: (ctx, _) =>
            ctx.showSnackbar(message: AppLocaleKeys.sign_in_success),
        // 🔁 Retry with current form state
        onRetry: (ctx) => ref.submitSignIn(),
        // 🧹 (optional) forms' reset after error
        // onResetForm: (ctx) => ref.read(signInFormProvider.notifier).reset(),
      ),
    );
    //
    /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
    return const _SignInScreen();
  }
}

////
////

/// 🔐 [_SignInScreen] — Main UI layout for the sign-in form
/// ✅ Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in BLoC app for perfect parity
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

/// 🧩 [SignInRefX] — Triggers sign-in using current form state (reads form provider).
/// 🧼 UX: unfocus keyboard before submit to avoid field glitches on navigation
//
extension SignInRefX on WidgetRef {
  ///---------------------------
  //
  /// 📩 Triggers sign-in logic based on current form state
  void submitSignIn() {
    context.unfocusKeyboard();
    final form = read(signInFormProvider);
    read(
      signInProvider.notifier,
    ).signin(
      email: form.email.value,
      password: form.password.value,
    );
  }
}
