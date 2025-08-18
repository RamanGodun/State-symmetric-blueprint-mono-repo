/*
 * 📜 License
 * This package is licensed under the same terms as the monorepo’s root
 * [LICENSE](../../../LICENSE).
 */

import 'package:app_on_riverpod/app_bootstrap_and_config/bootstrap.dart'
    show bootstrap;
import 'package:app_on_riverpod/root_view_shell.dart' show AppLocalizationShell;

/// 🏁 Application entry point
//
void main() {
  bootstrap(() => const AppLocalizationShell());
}
