/*
 * 📜 License
 * This package is licensed under the same terms as the monorepo’s root
 * [LICENSE](../../../LICENSE).
 */

import 'package:app_on_bloc/app_bootstrap_and_config/bootstrap.dart'
    show bootstrap;
import 'package:app_on_bloc/app_bootstrap_and_config/constants/flavors.dart'
    show AppFlavor, FlavorConfig;
import 'package:app_on_bloc/app_bootstrap_and_config/di_container/global_di_container.dart'
    show GlobalProviders;
import 'package:app_on_bloc/root_view_shell.dart' show AppLocalizationShell;

/// 🏁 Application entry point
//
void main() {
  ///
  FlavorConfig.current = AppFlavor.development;
  //
  /// 🏁 Run bootstrap, then launches app with all global Cubits/Blocs from DI.
  bootstrap(() => const GlobalProviders(child: AppLocalizationShell()));
  //
}
