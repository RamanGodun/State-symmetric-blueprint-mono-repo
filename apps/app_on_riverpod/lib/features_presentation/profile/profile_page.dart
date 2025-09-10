import 'package:app_on_riverpod/core/base_modules/navigation/routes/app_routes.dart';
import 'package:app_on_riverpod/features_presentation/auth/sign_out/sign_out_buttons.dart';
import 'package:app_on_riverpod/features_presentation/profile/providers/profile_provider.dart';
import 'package:cached_network_image/cached_network_image.dart'
    show CachedNetworkImage;
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_adapter/firebase_adapter.dart' show FirebaseRefs;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

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
    final uid = FirebaseRefs.auth.currentUser?.uid;
    if (uid == null) return const SizedBox();
    final asyncUser = ref.watch<AsyncValue<UserEntity>>(profileProvider(uid));

    // ❗️ Listen and display any async errors as overlays
    ref.listenFailure(profileProvider(uid), context);

    ///
    // 🔌 Adapt AsyncValue → AsyncLike and render shared UI
    return ProfileView(state: asyncUser.asAsyncLike());
  }
}

////

////

/// 📄 [ProfileView] — State-agnostic rendering via [AsyncLike]
/// ✅ Same widget used in Cubit/BLoC app for perfect parity
//
final class ProfileView extends StatelessWidget {
  ///------------------------------------------
  const ProfileView({required this.state, super.key});

  ///
  final AsyncLike<UserEntity> state;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const _ProfileAppBar(),

      ///
      body: state.when(
        /// ⏳ Loading
        loading: () => const AppLoader(),

        /// ✅ Data
        data: (u) => _UserProfileCard(user: u),

        /// 🧨 Error — handled by overlay listener (silent here)
        error: (_) => const SizedBox.shrink(),
      ),
    );
  }
}
