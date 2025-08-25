import 'package:app_bootstrap_and_config/app_runner.dart';
import 'package:app_bootstrap_and_config/enums_and_constants/flavor_config.dart';
import 'package:blueprint_on_riverpod/app_bootstrap/app_bootstrap.dart'
    show DefaultAppBootstrap;
import 'package:blueprint_on_riverpod/root_shell.dart'
    show AppLocalizationShell;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specific_for_riverpod/di_container/di_container.dart';

/// 🏁 Application entrypoint — Defines environment flavor and launches the app
//
void main() async {
  /// 🌱 Select active environment (development/staging/production)
  FlavorConfig.current = AppFlavor.development;

  /// 🚀 Run the full startup pipeline and launch the root widget
  await AppLauncher.run(
    ///
    bootstrap: DefaultAppBootstrap(
      // ? Here can be plugged in custom dependencies (e.g.  "localStorage: IsarLocalStorage()," )
    ),
    //
    builder: () => ProviderScope(
      parent: GlobalDIContainer.instance,
      child: const AppLocalizationShell(),
    ),
    //
  );
}
