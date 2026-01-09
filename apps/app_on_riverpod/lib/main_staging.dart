import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show GlobalDIContainer;
import 'package:app_bootstrap/app_bootstrap.dart'
    show AppFlavor, AppLauncher, FlavorConfig;
import 'package:app_on_riverpod/app_bootstrap/app_bootstrap.dart'
    show DefaultAppBootstrap;
import 'package:app_on_riverpod/root_shell.dart' show AppLocalizationShell;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show UncontrolledProviderScope;

/// 🏁 Application entrypoint — Defines environment flavor and launches the app
//
void main() async {
  /// 🌱 Select active environment (development/staging/production)
  FlavorConfig.current = AppFlavor.staging;

  /// 🚀 Run the full startup pipeline and launch the root widget
  await AppLauncher.run(
    ///
    bootstrap: DefaultAppBootstrap(
      // ? Here can be plugged in custom dependencies (e.g.  "localStorage: IsarLocalStorage()," )
    ),
    //
    builder: () => UncontrolledProviderScope(
      container: GlobalDIContainer.instance,
      child: const AppLocalizationShell(),
    ),
    //
  );
}
