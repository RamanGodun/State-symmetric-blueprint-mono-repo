import 'package:bloc_adapter/bloc_adapter.dart' show AppThemeCubit;
import 'package:core/core.dart'
    show
        AppFontFamily,
        GlobalOverlayHandler,
        LocaleKeys,
        LocalizationWrapper,
        ThemePreferences,
        ThemeVariantsEnum;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart' show GoRouter;

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

    /// 🎯 Select only (theme, font) for precise rebuilds
    return BlocSelector<
      AppThemeCubit,
      ThemePreferences,
      (ThemeVariantsEnum, AppFontFamily)
    >(
      selector: (s) => (s.theme, s.font),
      builder: (context, sel) {
        final (theme, font) = sel;
        // Local prefs for mode + darkTheme calculation
        final prefs = ThemePreferences(theme: theme, font: font);

        return _AppRootView(
          router: router,

          /// 🌞 Light theme always based on [light] + current font
          lightTheme: ThemePreferences(
            theme: ThemeVariantsEnum.light,
            font: font,
          ).buildLight(),

          /// 🌙 Dark/AMOLED based on current variant
          darkTheme: prefs.buildDark(),

          /// 🌓 ThemeMode resolved from prefs
          themeMode: prefs.mode,
          //
        );
      },
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
    required this.lightTheme,
    required this.darkTheme,
    required this.themeMode,
  });
  //
  final GoRouter router;
  final ThemeData lightTheme;
  final ThemeData darkTheme;
  final ThemeMode themeMode;

  //

  @override
  Widget build(BuildContext context) {
    ///
    return MaterialApp.router(
      ///
      title: LocaleKeys.app_title.tr(),

      /// 🌐  Localization setup via EasyLocalization
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,

      /// 🎨 Theme configuration
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,

      /// To right catch of system text scale/locale/etc
      useInheritedMediaQuery: true,

      /// 🔁 Router setup for declarative navigation
      routerConfig: router,

      // 🧩 Gesture handler to dismiss overlays and keyboard
      builder: (context, child) => GlobalOverlayHandler(child: child!),

      //
    );
  }
}
