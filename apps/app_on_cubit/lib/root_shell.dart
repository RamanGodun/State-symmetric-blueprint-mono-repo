import 'package:adapters_for_bloc/adapters_for_bloc.dart'
    show AppThemeCubit, BlocWatchSelectX;
import 'package:app_on_cubit/core/base_modules/localization/generated/app_locale_keys.g.dart'
    show AppLocaleKeys;
import 'package:app_on_cubit/core/base_modules/localization/localization_wrapper.dart'
    show LocalizationWrapper;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart'
    show
        BuildContext,
        MaterialApp,
        StatelessWidget,
        ThemeData,
        ThemeMode,
        Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext;
import 'package:go_router/go_router.dart' show GoRouter;
import 'package:shared_core_modules/public_api/base_modules/overlays.dart'
    show GlobalOverlayHandler;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show AppFontFamily, ThemePreferences, ThemeVariantsEnum;

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
/// ✅ Listens to [AppThemeCubit] for theme changes
/// ✅ Keeps router instance stable across rebuilds
//
final class _AppViewShell extends StatelessWidget {
  ///------------------------------------------------
  const _AppViewShell();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧭 Stable GoRouter instance from DI/context
    final router = context.read<GoRouter>();
    //
    /// 🎯 Granular subscriptions, select only precise theme dependencies
    final themeMode = context
        .watchAndSelect<AppThemeCubit, ThemePreferences, ThemeMode>(
          (s) => s.mode,
        );
    final font = context
        .watchAndSelect<AppThemeCubit, ThemePreferences, AppFontFamily>(
          (s) => s.font,
        );
    final themeVariant = context
        .watchAndSelect<AppThemeCubit, ThemePreferences, ThemeVariantsEnum>(
          (s) => s.theme,
        );
    //
    /// 🌓 Build themes through cache (without catching the whole prefs object)
    final lightTheme = ThemePreferences(
      theme: ThemeVariantsEnum.light,
      font: font,
    ).buildLight();
    final darkTheme = ThemePreferences(
      theme: themeVariant,
      font: font,
    ).buildDark();

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
    required this.router,
    required this.theme,
    required this.darkTheme,
    required this.themeMode,
  });
  //
  final GoRouter router;
  final ThemeData theme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;
  //

  @override
  Widget build(BuildContext context) {
    ///
    return MaterialApp.router(
      title: AppLocaleKeys.app_title.tr(),
      //
      /// 🌍 Localization setup via EasyLocalization
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      //
      /// 🧭 GoRouter configuration for declarative navigation
      routerConfig: router,
      //
      /// 🎨 Theme configuration
      theme: theme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      //
      /// 🧩 Gesture handler to dismiss overlays and keyboard
      builder: (context, child) => GlobalOverlayHandler(child: child!),
      //
    );
  }
}
