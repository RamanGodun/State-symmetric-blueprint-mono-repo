part of 'profile_page.dart';

/// [_ProfileAppBar] — Top bar with profile title, language and sign-out actions.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ProfileAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  ///----------------------------
  const _ProfileAppBar();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return const CustomAppBar(
      title: LocaleKeys.pages_profile,
      actionWidgets: [LanguageToggleButton(), SignOutIconButton()],
    );
  }
}

////
////

/// 🧾 [_UserProfileCard] — Displays user information after successful fetch.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _UserProfileCard extends StatelessWidget {
  ///-----------------------------------------------
  const _UserProfileCard({required this.user});
  //
  final UserEntity user;
  //

  @override
  Widget build(BuildContext context) {
    //
    return Center(
      child: BlurContainer(
        child: Card(
          margin: const EdgeInsets.all(AppSpacing.xxm),
          clipBehavior: Clip.antiAlias,
          elevation: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                imageUrl: user.profileImage,
                placeholder: (_, _) => Image.asset(
                  AppImagesPaths.loading,
                  package: 'core',
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
                errorWidget: (_, _, _) => const Icon(Icons.error, size: 48),
                width: double.infinity,
                height: 200,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.all(AppSpacing.l),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// 👤 Name
                    KeyValueTextWidget(
                      labelKey: LocaleKeys.profile_name,
                      value: user.name,
                      labelTextType: TextType.bodyMedium,
                      valueTextType: TextType.titleMedium,
                    ),

                    /// 🆔 ID
                    KeyValueTextWidget(
                      labelKey: LocaleKeys.profile_id,
                      value: user.id,
                      labelTextType: TextType.bodyMedium,
                      valueTextType: TextType.bodySmall,
                    ),

                    /// 📧 Email
                    KeyValueTextWidget(
                      labelKey: LocaleKeys.profile_email,
                      value: user.email,
                      labelTextType: TextType.bodyMedium,
                      valueTextType: TextType.titleSmall,
                    ),

                    /// 📊 Points
                    KeyValueTextWidget(
                      labelKey: LocaleKeys.profile_points,
                      value: user.point.toString(),
                      labelTextType: TextType.bodyMedium,
                    ),

                    /// 🏆 Rank
                    KeyValueTextWidget(
                      labelKey: LocaleKeys.profile_rank,
                      value: user.rank,
                      labelTextType: TextType.bodyMedium,
                    ),
                    const SizedBox(height: AppSpacing.l),

                    ///
                    const _ThemeSection(),
                    const SizedBox(height: AppSpacing.xl),

                    const _ChangePasswordButton(),
                    //
                  ],
                ),
              ),
            ],
          ),
        ),
      ).withPaddingOnly(bottom: AppSpacing.huge),
    );
  }
}

////

////

/// 🎨 [_ThemeSection] — UI section for selecting app theme and toggling appearance.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ThemeSection extends StatelessWidget {
  ///--------------------------------------------
  const _ThemeSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          LocaleKeys.theme_choose_theme.tr(),
          TextType.titleMedium,
          fontWeight: FontWeight.w700,
        ),
        Row(
          children: [
            ThemePicker(
              key: ValueKey(Localizations.localeOf(context).languageCode),
            ),
            const ThemeTogglerIcon().withPaddingOnly(left: AppSpacing.l),
          ],
        ),
      ],
    );
  }
}

////

////

/// 🔒 [_ChangePasswordButton] — Navigates user to Change Password screen.
/// ✅ Same widget used in BLoC app for perfect parity
//
final class _ChangePasswordButton extends StatelessWidget {
  const _ChangePasswordButton();

  @override
  Widget build(BuildContext context) {
    return CustomFilledButton(
      onPressed: () => context.goTo(RoutesNames.changePassword),
      label: LocaleKeys.change_password_title,
    );
  }
}
