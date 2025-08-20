/*


/// 🔧 [IDIConfigAsync] — Abstraction for DI configuration
///     Can be used if DI Container became big and managing/testing become complicated
//
abstract interface class IDIConfigAsync {
  ///----------------------------
  //
  Future<List<Override>> buildOverrides();
  //
}

////
////

/// 🔧 [DiConfig] — Production DI configuration
//
final class DiConfig implements IDIConfigAsync {
  ///------------------------------------------
  const DiConfig();

  @override
  Future<List<Override>> buildOverrides() async {
    // Import your existing diOverrides logic here
    return [
      //
      /// 🎨 Theme providers: Storage and ThemeConfig
      themeStorageProvider.overrideWith((ref) => GetStorage()),
      themeProvider.overrideWith(
        (ref) => ThemeConfigNotifier(ref.watch(themeStorageProvider)),
      ),

      /// 🗺️ Navigation: GoRouter
      goRouter.overrideWith((ref) => buildGoRouter(ref)),

      /// 📤 Overlay dispatcher for modal overlays/toasts
      overlayDispatcherProvider.overrideWith(
        (ref) => OverlayDispatcher(
          onOverlayStateChanged:
              ref.read(overlayStatusProvider.notifier).update,
        ),
      ),

      /// 🧩 Profile repository with remote data source
      profileRepoProvider.overrideWith(
        (ref) => ProfileRepoImpl(ProfileRemoteDataSourceImpl()),
      ),

      //
    ];
  }
}

 */
