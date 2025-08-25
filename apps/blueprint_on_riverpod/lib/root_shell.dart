import 'package:blueprint_on_riverpod/core/base_modules/navigation/module_core/go_router__provider.dart';
import 'package:core/base_modules/localization/core_of_module/localization_wrapper.dart'
    show LocalizationWrapper;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/overlays/core/global_overlay_handler.dart'
    show GlobalOverlayHandler;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:specific_for_riverpod/theme_providers/theme_provider.dart';

/// 🌍✅ [AppLocalizationShell] — Ensures the entire app tree is properly localized before rendering the root UI.
//
final class AppLocalizationShell extends StatelessWidget {
  ///----------------------------------------------
  const AppLocalizationShell({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// Injects localization context into the widget tree (provides all supported locales and translation assets)
    return LocalizationWrapper.configure(const AppViewShell());
  }
}

////

////

/// 🧩 [AppViewShell] — Combines both Theme and Router configuration
/// ✅ Ensures minimal rebuilds using selective `ref.watch(...)`
//
final class AppViewShell extends ConsumerWidget {
  ///------------------------------------------------
  const AppViewShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    // 🔀 Watch GoRouter only if instance changes
    final router = ref.watch(routerProvider.select((r) => r));

    // 🎯 Watch only theme
    final themeConfig = ref.watch(themeProvider.select((t) => t));

    // 🌓 Build modes and themes based on cached methods
    final lightTheme = themeConfig.buildLight();
    final darkTheme = themeConfig.buildDark();
    final themeMode = themeConfig.mode;

    return _AppRootView(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      router: router,
    );
  }
}

////

////

/// 📱🧱 [_AppRootView] — Final stateless [MaterialApp.router] widget.
/// ✅ Receives fully resolved config: theme + router + localization.
//
final class _AppRootView extends StatelessWidget {
  ///------------------------------------------
  const _AppRootView({
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
    required this.router,
  });
  //
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  final GoRouter router;

  @override
  Widget build(BuildContext context) {
    //
    return MaterialApp.router(
      title: LocaleKeys.app_title.tr(),

      // 🌍 Localization config
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      // 🔀 GoRouter configuration
      routerConfig: router,

      /// 🎨 Theme configuration
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      // 🧩 Gesture handler to dismiss overlays and keyboard
      builder: (context, child) => GlobalOverlayHandler(child: child!),
    );
  }
}
