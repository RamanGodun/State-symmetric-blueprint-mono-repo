import 'package:app_bootstrap/bootstrap_contracts/_local_storage.dart'
    show ILocalStorage;
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:get_storage/get_storage.dart';

/// 🧩📦 [LocalStorage] — Current implementation of [ILocalStorage] with initialization logic.
//
final class LocalStorage implements ILocalStorage {
  ///----------------------------------------------------
  const LocalStorage();
  //
  /// Initializes GetStorage (local key-value storage).
  @override
  Future<void> init() async {
    await GetStorage.init();
    debugPrint('💾 GetStorage initialized!');
  }

  /// Initialize other storages (e.g., SharedPreferences, Isar, SecureStorage) here, if needed.
  //

  //
}
