import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_cubit/sign_out_cubit.dart';
import 'package:app_on_bloc/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show VerifyEmailCancelButton;
import 'package:app_on_bloc/features_presentation/email_verification/email_verification_cubit/email_verification_cubit.dart';
import 'package:bloc_adapter/bloc_adapter.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — screen that handles email verification flow
///     ✅ Automatically redirects when email gets verified
///     ✅ Centralized top-level error listeners (SignOut + EmailVerification)
///     ✅ State-agnostic UI via [_VerifyEmailView] + [AsyncStateView]
///     ✅ BLoC flavor: `AsyncState<T>` adapted to `AsyncStateView<T>`
//
final class VerifyEmailPage extends StatelessWidget {
  ///---------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// Provide screen-scoped cubits (disposed on pop)
    return MultiBlocProvider(
      providers: [
        BlocProvider<EmailVerificationCubit>(
          create: (_) => di<EmailVerificationCubit>(),
        ),
        BlocProvider<SignOutCubit>(create: (_) => di<SignOutCubit>()),
      ],

      /// ⛑️ Centralized (SignOut + EmailVerification) one-shot errors handling via overlays
      ///    - OverlayDispatcher resolves conflicts/priority internally
      child: AsyncMultiErrorListener(
        resolveBlocs: (ctx) => [
          ctx.read<SignOutCubit>(), // ⛑️ catch SignOut errors
          ctx
              .read<
                EmailVerificationCubit
              >(), // ⛑️ catch EmailVerification errors
        ],

        /// 🖼️ Declarative UI bound to [EmailVerificationCubit]
        child: BlocBuilder<EmailVerificationCubit, AsyncState<void>>(
          builder: (context, state) {
            /// 🔌 Adapter: `AsyncState<void>` → `AsyncStateView<void>` (for state-agnostic UI)
            final emailVerificationState = state.asCubitAsyncStateView();

            /// ♻️ Render state-agnostic UI (identical to same widget on app with Riverpod)
            return _VerifyEmailView(state: emailVerificationState);
          },
        ),
      ),
    );
  }
}
