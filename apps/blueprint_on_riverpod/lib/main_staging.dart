import 'package:app_bootstrap/app_launcher.dart';
import 'package:app_bootstrap/configs/flavor.dart' show AppFlavor, FlavorConfig;
import 'package:blueprint_on_riverpod/app_bootstrap/app_bootstrap.dart'
    show DefaultAppBootstrap;
import 'package:blueprint_on_riverpod/root_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:specific_for_riverpod/di_container/di_container.dart';

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
    builder: () => ProviderScope(
      parent: GlobalDIContainer.instance,
      child: const AppLocalizationShell(),
    ),
    //
  );
}
