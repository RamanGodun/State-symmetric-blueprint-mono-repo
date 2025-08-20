import 'package:blueprint_on_riverpod/features/auth/presentation/sign_out/sign_out_provider.dart';
import 'package:core/base_modules/errors_handling/core_of_module/core_utils/specific_for_riverpod/show_dialog_when_error_x.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/shared_presentation_layer/shared_widgets/buttons/text_button.dart'
    show AppTextButton;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
