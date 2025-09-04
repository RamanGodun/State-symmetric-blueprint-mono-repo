import 'package:app_on_riverpod/core/base_modules/navigation/module_core/router_provider.dart'
    show routerProvider;
import 'package:core/base_modules/localization/core_of_module/localization_wrapper.dart'
    show LocalizationWrapper;
import 'package:core/base_modules/localization/generated/locale_keys.g.dart'
    show LocaleKeys;
import 'package:core/base_modules/overlays/core/global_overlay_handler.dart'
    show GlobalOverlayHandler;
import 'package:core/base_modules/theme/module_core/app_theme_preferences.dart'
    show ThemePreferences;
import 'package:core/base_modules/theme/module_core/theme_variants.dart'
    show ThemeVariantsEnum;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart'
    show themeProvider;

/// 🌍✅ [AppLocalizationShell] — Ensures the entire app tree is properly localized before rendering the root UI.
//
final class AppLocalizationShell extends StatelessWidget {
  ///----------------------------------------------
  const AppLocalizationShell({super.key});

  @override
  Widget build(BuildContext context) {
    //
    /// Injects localization context into the widget tree (provides all supported locales and translation assets)
    return LocalizationWrapper.configure(const _AppViewShell());
  }
}

////

////

/// 🌳🧩 [_AppViewShell] — reactive entry shell
/// ✅ Listens to [themeProvider] for theme changes
/// ✅ Keeps router instance stable across rebuilds
//
final class _AppViewShell extends ConsumerWidget {
  ///------------------------------------------------
  const _AppViewShell();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ///
    /// 🧭 Stable GoRouter instance (updates only if replaced in DI)
    final router = ref.watch(routerProvider);

    /// 🎯 Select only precise theme dependencies
    final themeMode = ref.watch(themeProvider.select((p) => p.mode));
    final font = ref.watch(themeProvider.select((p) => p.font));
    final themeVariant = ref.watch(themeProvider.select((p) => p.theme));

    /// 🌓 Build themes through cache (without catching the whole prefs object)
    final lightTheme = ThemePreferences(
      theme: ThemeVariantsEnum.light,
      font: font,
    ).buildLight();

    final darkTheme = ThemePreferences(
      theme: themeVariant,
      font: font,
    ).buildDark();
    //

    return _AppRootView(
      router: router,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
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

      /// To right catch of system text scale/locale/etc
      useInheritedMediaQuery: true,

      // 🧩 Gesture handler to dismiss overlays and keyboard
      builder: (context, child) => GlobalOverlayHandler(child: child!),
    );
  }
}
