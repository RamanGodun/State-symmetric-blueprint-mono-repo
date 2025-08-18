import 'package:blueprint_on_qubit/app/app.dart';
import 'package:blueprint_on_qubit/app_bootstrap_and_config/bootstrap.dart';
import 'package:blueprint_on_qubit/app_bootstrap_and_config/constants/flavors.dart';

void main() {
  FlavorConfig.current = AppFlavor.development;
  bootstrap(() => const App());
}
