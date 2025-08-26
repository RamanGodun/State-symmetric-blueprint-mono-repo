/*
 * 📜 License
 * This package is licensed under the same terms as the monorepo’s root
 * [LICENSE](../../../LICENSE).
 */

import 'package:app_bootstrap/app_launcher.dart';
import 'package:app_bootstrap/configs/flavor.dart';
import 'package:blueprint_on_cubit/app_bootstrap/app_bootstrap.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/global_di_container.dart'
    show GlobalProviders;
import 'package:blueprint_on_cubit/root_shell.dart';

/// 🏁 Application entrypoint — Defines environment flavor and launches the app
//
void main() async {
  /// 🌱 Select active environment (development/staging/production)
  FlavorConfig.current = AppFlavor.staging;

  /// 🚀 Run the full startup pipeline and launch the root widget
  await AppLauncher.run(
    ///
    bootstrap: const DefaultAppBootstrap(
      // ? Here can be plugged in custom dependencies (e.g.  "localStorage: IsarLocalStorage()," )
    ),
    //
    builder: () => const GlobalProviders(child: AppLocalizationShell()),
    //
  );
}
