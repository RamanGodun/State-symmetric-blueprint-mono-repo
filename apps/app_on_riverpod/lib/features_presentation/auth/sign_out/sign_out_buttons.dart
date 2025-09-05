import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_provider.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

/// 🔘 [SignOutTextButton] — triggers logout via [signOutProvider]
/// 🧼 Declarative error handling with overlay via `.listen()`
//
final class SignOutTextButton extends ConsumerWidget {
  ///--------------------------------------
  const SignOutTextButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // ❗️ Shows (declarative) error state
    ref.listenFailure(signOutProvider, context);

    return AppTextButton(
      onPressed: () => ref.read(signOutProvider.notifier).signOut(),
      label: LocaleKeys.buttons_sign_out,
    );
  }
}

////
////

/// 🔓 [SignOutIconButton] — used in AppBar to logout
/// 🧼 Shows errors using overlay on failure
//
final class SignOutIconButton extends ConsumerWidget {
  ///----------------------------------
  const SignOutIconButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    // ❗️ Shows (declarative) error state
    ref.listenFailure(signOutProvider, context);

    return IconButton(
      icon: const Icon(Icons.logout),
      onPressed: () => ref.read(signOutProvider.notifier).signOut(),
    );
  }
}
