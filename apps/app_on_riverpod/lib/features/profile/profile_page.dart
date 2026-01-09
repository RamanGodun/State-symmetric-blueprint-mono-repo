import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show
        AsyncStateIntrospectionRiverpodX,
        FailureSelectorX,
        RiverpodAdapterForErrorsMultiListeners,
        ThemePicker,
        ThemeTogglerIcon;
import 'package:app_on_riverpod/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart'
    show RoutesNames;
import 'package:app_on_riverpod/core/shared_presentation/utils/spider/images_paths/app_images_paths.dart'
    show AppImagesPaths;
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_provider.dart'
    show signOutProvider;
import 'package:app_on_riverpod/features/auth/sign_out/sign_out_widgets.dart'
    show SignOutIconButton;
import 'package:app_on_riverpod/features/profile/providers/profile_page_provider.dart'
    show profileProvider;
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncValue, ConsumerWidget, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/localization.dart'
    show CoreLocaleKeys, LanguageToggleButton;
import 'package:shared_core_modules/public_api/base_modules/navigation.dart'
    show NavigationX;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppSpacing, BlurContainer, WidgetPaddingX;
import 'package:shared_layers/public_api/domain_layer_shared.dart'
    show UserEntity;
import 'package:shared_widgets/public_api/bars.dart' show CustomAppBar;
import 'package:shared_widgets/public_api/buttons.dart' show CustomFilledButton;
import 'package:shared_widgets/public_api/loaders.dart' show AppLoader;
import 'package:shared_widgets/public_api/text_widgets.dart';

part 'widgets_for_profile_page.dart';

/// 👤 [ProfilePage] - Entry point for profile feature
/// ✅ State-symmetric UI via [_ProfileScreen] + [AsyncValue]
/// ✅ `AsyncValue<T>` adapted to `AsyncStateView<T>`
/// ✅  Top-level error listeners (SignOut + Profile) are centralized
//
final class ProfilePage extends ConsumerWidget {
  ///----------------------------------
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //
    /// 👀🖼️ Declarative UI bound to [profileProvider(uid)]
    final asyncUser = ref.watch<AsyncValue<UserEntity>>(profileProvider);

    /// ⛑️ Centralized (SignOut + Profile) one-shot error handling via overlays
    ///    - OverlayDispatcher resolves conflicts/priority internally
    return RiverpodAdapterForErrorsMultiListeners(
      failureSources: [
        signOutProvider.failureSource, // ⛑️ catch signOut errors
        profileProvider.failureSource, // ⛑️ catch profile fetch errors
      ],
      //
      /// ♻️ Render state-agnostic UI (identical to same widget on app with BLoC)
      child: _ProfileScreen(state: asyncUser),
    );
  }
}

////
////

/// 📄 [_ProfileScreen] — State-symmetric rendering via [AsyncValue]
/// ✅ Symmetric widget used in BLoC app for parity
//
final class _ProfileScreen extends StatelessWidget {
  ///--------------------------------------------
  const _ProfileScreen({required this.state});
  //
  final AsyncValue<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      appBar: const _ProfileAppBar(),
      //
      body: state.whenUI(
        //
        /// ⏳ Loading
        loading: () => const AppLoader(),

        /// ✅ Data
        data: (user) => _UserProfileCard(user: user),

        /// 🧨 Error — handled by overlay listener (silent here)
        error: (_) => const SizedBox.shrink(),
        //
      ),
    );
  }
}
