import 'package:app_bootstrap/bootstrap_contracts/_remote_database.dart'
    show IRemoteDataBase;
import 'package:app_bootstrap/configs/env.dart' show EnvConfig, EnvFileName;
import 'package:app_bootstrap/configs/flavor.dart' show FlavorConfig;
import 'package:firebase_adapter/bootstrap/dotenv_options.dart';
import 'package:firebase_adapter/utils/env_loader.dart';
import 'package:firebase_adapter/utils/firebase_utils.dart';
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
    final opts = DotenvFirebaseOptions.currentPlatform;

    /// 🛡️ Initializes Firebase once (idempotent).
    await SafeFirebaseInit.run(options: opts);
  }

  //
}
