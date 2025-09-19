import 'package:app_on_bloc/features_presentation/auth/sign_up/cubit/sign_up__cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_up/cubit/input_fields_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features.dart' show SignUpUseCase;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart' show HookWidget;

part 'sign_up_page_side_effects.dart';
part 'sign_up_page_input_fields.dart';
part 'widgets_for_sign_up_page.dart';

/// 🧾🔐 [SignUpPage] — Entry point for the sign-up feature
//
final class SignUpPage extends StatelessWidget {
  ///-----------------------------------------
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => SignUpCubit(di<SignUpUseCase>())),
        BlocProvider(
          create: (_) => SignUpFormCubit(di<FormValidationService>()),
        ),
      ],

      /// 🛡️ Wrap with Bloc side-effect listeners (with optional "retry" logic)
      /// 🧠 OverlayDispatcher resolves conflicts/priority internally
      child: const _ErrorsListenersForSignUpPage(
        //
        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: _SignUpView(),
      ),
    );
  }
}

////
////

/// 🔐 [_SignUpView] — Main UI layout for the sign-up form
///    Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignUpView extends HookWidget {
  ///------------------------------------
  const _SignUpView();

  @override
  Widget build(BuildContext context) {
    //
    // 📌 Shared focus nodes for form fields
    final focusNodes = useSignUpFocusNodes();

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
                        /// 🔰 Logo with Hero animation
                        const _SignUpHeader(),

                        /// 👤 Name input field
                        _SignUpUserNameInputField(focusNodes),

                        /// 📧 Email input
                        _SignUpEmailInputField(focusNodes),

                        /// 🔒 Password input field
                        _SignUpPasswordInputField(focusNodes),

                        /// 🔐 Confirm password input
                        _SignUpConfirmPasswordInputField(focusNodes),

                        /// 🚀 Primary submit button
                        const _SignUpSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _SignUpFooterGuard(),
                      ],
                    ).centered().withPaddingHorizontal(AppSpacing.xxxm),
                    //
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
