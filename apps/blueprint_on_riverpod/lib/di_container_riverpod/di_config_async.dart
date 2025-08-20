// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:get_storage/get_storage.dart' show GetStorage;
// import '../../features/profile/data/profile_repo_impl.dart';
// import '../../features/profile/data/profile_data_layer_providers.dart';
// import '../../features/profile/data/remote_data_source.dart';
// import '../../core/base_modules/navigation/core/go_router_provider.dart';
// import '../../core/base_modules/overlays/overlays_dispatcher/_overlay_dispatcher.dart';
// import '../../core/base_modules/overlays/overlays_dispatcher/overlay_dispatcher_provider.dart';
// import '../../core/base_modules/theme/theme_provider/theme_config_provider.dart';

// /// 🔧 [IDIConfigAsync] — Abstraction for DI configuration
// ///     Can be used if DI Container became big and managing/testing become complicated
// //
// abstract interface class IDIConfigAsync {
//   ///----------------------------
//   //
//   Future<List<Override>> buildOverrides();
//   //
// }

// ////
// ////

// /// 🔧 [DiConfig] — Production DI configuration
// //
// final class DiConfig implements IDIConfigAsync {
//   ///------------------------------------------
//   const DiConfig();

//   @override
//   Future<List<Override>> buildOverrides() async {
//     // Import your existing diOverrides logic here
//     return [
//       //
//       /// 🎨 Theme providers: Storage and ThemeConfig
//       themeStorageProvider.overrideWith((ref) => GetStorage()),
//       themeProvider.overrideWith(
//         (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
//       ),

//       /// 🗺️ Navigation: GoRouter
//       goRouter.overrideWith((ref) => buildGoRouter(ref)),

//       /// 📤 Overlay dispatcher for modal overlays/toasts
//       overlayDispatcherProvider.overrideWith(
//         (ref) => OverlayDispatcher(
//           onOverlayStateChanged:
//               ref.read(overlayStatusProvider.notifier).update,
//         ),
//       ),

//       /// 🧩 Profile repository with remote data source
//       profileRepoProvider.overrideWith(
//         (ref) => ProfileRepoImpl(ProfileRemoteDataSourceImpl()),
//       ),

//       //
//     ];
//   }
// }
