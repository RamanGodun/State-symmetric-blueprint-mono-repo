import 'package:bloc_adapter/base_modules/theme_module/theme_cubit.dart';
import 'package:core/base_modules/localization/core_of_module/localization_wrapper.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/overlays/core/global_overlay_handler.dart';
import 'package:core/base_modules/theme/module_core/app_theme_preferences.dart';
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

/// 🌳🧩 [_AppViewShell] — Top-level reactive widget listening to [AppThemeCubit].
/// ✅ Rebuilds GoRouter reactively on any AuthState change.
//
final class _AppViewShell extends StatelessWidget {
  ///------------------------------------------------
  const _AppViewShell();

  @override
  Widget build(BuildContext context) {
    //
    /// 🧭 Listen to stable [GoRouter] instance
    final router = context.read<GoRouter>();

    /// Listen to current theme preferences from [AppThemeCubit].
    return BlocSelector<AppThemeCubit, ThemePreferences, ThemePreferences>(
      selector: (config) => config,
      builder: (context, config) {
        // Pass all resolved config (router + theme) to root view.
        return _AppRootView(
          router: router,
          lightTheme: config.buildLight(),
          darkTheme: config.buildDark(),
          themeMode: config.mode,
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
