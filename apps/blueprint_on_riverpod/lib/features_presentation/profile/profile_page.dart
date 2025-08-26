import 'package:blueprint_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:blueprint_on_riverpod/features_presentation/auth/sign_out/sign_out_buttons.dart';
import 'package:blueprint_on_riverpod/features_presentation/profile/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/localization/module_widgets/language_toggle_button/toggle_button.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/navigation/utils/extensions/navigation_x_on_context.dart';
import 'package:core/base_modules/theme/ui_constants/_app_constants.dart'
    show AppSpacing;
import 'package:core/base_modules/theme/widgets_and_utils/blur_wrapper.dart'
    show BlurContainer;
import 'package:core/base_modules/theme/widgets_and_utils/theme_toggle_widgets/theme_picker.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_toggle_widgets/theme_toggler.dart';
import 'package:core/shared_domain_layer/shared_entities/_user_entity.dart'
    show UserEntity;
import 'package:core/shared_presentation_layer/widgets_shared/app_bar.dart';
import 'package:core/shared_presentation_layer/widgets_shared/buttons/filled_button.dart';
import 'package:core/shared_presentation_layer/widgets_shared/key_value_text_widget.dart';
import 'package:core/shared_presentation_layer/widgets_shared/loader.dart';
import 'package:core/utils_shared/extensions/extension_on_widget/_widget_x_barrel.dart';
import 'package:core/utils_shared/spider/app_images_paths.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_bootstrap_config/firebase_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specific_for_riverpod/base_modules/errors_handling/show_dialog_when_error_x.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] — Displays user details, handles logout, navigation to password change, and provides theme/language toggling.
/// Uses [profileProvider] for user data and listens for error overlays.
//
final class ProfilePage extends ConsumerWidget {
  ///----------------------------------
  const ProfilePage({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// Get current user UID (null if not signed in)
    final uid = FirebaseConstants.fbAuthInstance.currentUser?.uid;
    if (uid == null) return const SizedBox();
    final asyncUser = ref.watch<AsyncValue<UserEntity>>(profileProvider(uid));

    // ❗️ Listen and display any async errors as overlays
    ref.listenFailure(profileProvider(uid), context);

    ///
    return Scaffold(
      appBar: const _ProfileAppBar(),

      /// User data loaded — render profile details
      body: asyncUser.when(
        data: (user) => _UserProfileCard(user: user),

        /// Show loader while data is loading
        loading: () => const AppLoader(),

        /// Show nothing, as overlay handles errors
        error: (_, _) => const SizedBox.shrink(),

        //
      ),
    );
  }
}
