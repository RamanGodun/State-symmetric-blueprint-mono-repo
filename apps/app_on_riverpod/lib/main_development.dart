import 'package:app_bootstrap/app_bootstrap.dart';
import 'package:app_on_riverpod/app_bootstrap/app_bootstrap.dart';
import 'package:app_on_riverpod/root_shell.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/riverpod_adapter.dart';

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
