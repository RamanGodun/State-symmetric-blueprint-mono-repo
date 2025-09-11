import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_widgets.dart'
    show VerifyEmailCancelButton;
import 'package:app_on_riverpod/features_presentation/email_verification/provider/email_verification_provider.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

part 'widgets_for_email_verification_page.dart';

/// 🧼 [VerifyEmailPage] — screen that handles email verification flow
///     ✅ Automatically redirects when email gets verified
///     ✅ Centralized top-level error listeners (SignOut + EmailVerification)
///     ✅ State-agnostic UI via [_VerifyEmailView] + [AsyncStateView]
///     ✅ Riverpod flavor: `AsyncValue<T>` adapted to `AsyncStateView<T>`
//
final class VerifyEmailPage extends ConsumerWidget {
  ///--------------------------------------------
  const VerifyEmailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// ▶️ Trigger polling (notifier starts flow in build)
    ref.read(emailVerificationNotifierProvider);

    /// 🖼️ Declarative UI bound to [emailVerificationNotifierProvider]
    final emailVerificationProvider = ref.watch(
      emailVerificationNotifierProvider,
    );

    /// 🔌 Adapter: `AsyncValue<void>` → `AsyncStateView<void>` (for state-agnostic UI)
    final emailVerificationState = emailVerificationProvider
        .asRiverpodAsyncStateView();

    /// ⛑️ Centralized (SignOut + EmailVerification) one-shot errors handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return ErrorsListenerForAppOnRiverpod(
      providers: [
        signOutProvider, // ⛑️ catch signOut errors
        emailVerificationNotifierProvider, // ⛑️ catch verification errors
      ],
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: _VerifyEmailView(state: emailVerificationState),
    );
  }

  //
}
