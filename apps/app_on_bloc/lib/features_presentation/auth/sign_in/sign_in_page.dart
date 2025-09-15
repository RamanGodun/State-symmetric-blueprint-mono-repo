import 'package:app_on_bloc/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_bloc/features_presentation/auth/sign_in/cubit/sign_in_page_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:features/features_barrels/auth/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

part 'widgets_for_sign_in_page.dart';

/// 🔐 [SignInPage] — Entry point for the sign-in feature
/// ✅ Provides scoped cubit with injected services
//
final class SignInPage extends StatelessWidget {
  ///----------------------------------------
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// 🧩 Provide screen-scoped cubits (disposed on pop)
    return BlocProvider(
      create: (_) => SignInCubit(
        di<SignInUseCase>(),
        di<FormValidationService>(),
      ),

      /// 🔄 [RetryAwareFailureListener] — Bloc listener for one-shot
      ///    error handling (with optional "retry" logic) via overlays
      /// 🧠 OverlayDispatcher resolves conflicts/priority internally
      child: FailureListenerForAppWithBloc<SignInPageState, SignInCubit>(
        onRetry: (cubit) => cubit.submit(),

        /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
        child: const _SignInPageView(),
      ),
    );
  }
}

////
////

/// 🔐 [_SignInPageView] — Main UI layout for the sign-in form
///    Uses HookWidget for managing focus nodes & rebuild optimization
/// ✅ Same widget used in Riverpod app for perfect parity
//
final class _SignInPageView extends HookWidget {
  ///----------------------------------------------
  const _SignInPageView();

  @override
  Widget build(BuildContext context) {
    //
    ///  📌 Initialize and memoize focus nodes for fields
    final focus = useSignInFocusNodes();

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
                        /// 🖼️ Logo with Hero animation for smooth transitions
                        const _SignInHeader(),

                        /// 📧 Email input field
                        _SignInEmailInputField(focus),

                        /// 🔒 Password input field
                        _SignInPasswordInputField(focus),

                        /// 🚀 Primary submit button
                        const _SignInSubmitButton(),

                        /// 🔁 Links to redirect to sign-up or reset-password screen
                        const _WrapperForFooter(),
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
