import 'package:blueprint_on_riverpod/app/app.dart';
import 'package:blueprint_on_riverpod/app_bootstrap_and_config/bootstrap.dart';
import 'package:blueprint_on_riverpod/app_bootstrap_and_config/flavor_config.dart';

void main() {
  FlavorConfig.current = AppFlavor.staging;
  bootstrap(() => const App());
}
