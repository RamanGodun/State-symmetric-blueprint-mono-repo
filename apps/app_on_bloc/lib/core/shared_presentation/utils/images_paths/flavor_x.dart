import 'package:app_bootstrap/app_bootstrap.dart';
import 'package:app_on_bloc/core/shared_presentation/utils/images_paths/app_icons_paths.dart';

/// 🎨 [FlavorX] — extension on [FlavorConfig]
/// 🖼️ Returns the correct app icon asset depending on the current [FlavorConfig.current]
//
extension FlavorX on FlavorConfig {
  ///
  static String get appIcon => switch (FlavorConfig.current) {
    AppFlavor.development => AppIconsPaths.devIcon,
    AppFlavor.staging => AppIconsPaths.stgIcon,
  };
}
