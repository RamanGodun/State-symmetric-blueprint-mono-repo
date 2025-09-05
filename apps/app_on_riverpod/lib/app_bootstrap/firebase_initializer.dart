import 'package:app_bootstrap/app_bootstrap.dart'
    show EnvConfig, EnvFileName, FlavorConfig, IRemoteDataBase;
import 'package:firebase_adapter/firebase_adapter.dart'
    show EnvLoader, FirebaseEnvOptions, FirebaseInitGuard;
import 'package:flutter/foundation.dart' show debugPrint;

/// 🧩🔥 [FirebaseRemoteDataBase] — Current implementation of [IRemoteDataBase], with Firebase+Env initialization logic
//
final class FirebaseRemoteDataBase implements IRemoteDataBase {
  ///-------------------------------------------------------
  const FirebaseRemoteDataBase();

  @override
  Future<void> init() async {
    //📀 Loads environment configuration (.env file), based on current environment
    await EnvLoader.load(EnvConfig.currentEnv.fileName);
    debugPrint('✅ Loaded env file: ${EnvConfig.currentEnv.fileName}');
    // у FirebaseRemoteDataBase.init()
    debugPrint('🔥 Flavor: ${FlavorConfig.name}');
    debugPrint('🔥 Env file: ${EnvConfig.currentEnv.fileName}');

    ///
    final opts = FirebaseEnvOptions.current;

    /// 🛡️ Initializes Firebase once (idempotent).
    await FirebaseInitGuard.ensureInitialized(options: opts);
  }

  //
}
