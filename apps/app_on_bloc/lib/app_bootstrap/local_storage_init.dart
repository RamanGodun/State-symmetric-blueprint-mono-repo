import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:hydrated_bloc/hydrated_bloc.dart'
    show HydratedBloc, HydratedStorage, HydratedStorageDirectory;
import 'package:path_provider/path_provider.dart'
    show getApplicationDocumentsDirectory;

/// 💾 [ILocalStorage] — Abstraction to decouple startup logic and enable mocking in tests.
//
abstract interface class ILocalStorage {
  ///--------------------------------
  //
  /// Initializes all local storage services
  Future<void> init();
  //
}

////
////

/// 🧩📦 [HydratedLocalStorage] — Current implementation of [ILocalStorage] with initialization logic.
//
final class HydratedLocalStorage implements ILocalStorage {
  ///------------------------------------------------------------
  const HydratedLocalStorage();

  @override
  Future<void> init() async {
    debugPrint('💾 Initializing HydratedBloc storage...');

    // Configures HydratedBloc persistent storage (Web or native)
    final storage = await HydratedStorage.build(
      storageDirectory: kIsWeb
          ? HydratedStorageDirectory.web
          : HydratedStorageDirectory(
              (await getApplicationDocumentsDirectory()).path,
            ),
    );
    HydratedBloc.storage = storage;
    debugPrint('💾 HydratedBloc storage initialized.');
  }

  /// Initialize other storages (e.g., SharedPreferences, Isar, SecureStorage) here, if needed.
  //

  //
}
