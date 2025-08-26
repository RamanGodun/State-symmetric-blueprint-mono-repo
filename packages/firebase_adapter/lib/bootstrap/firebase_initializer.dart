import 'package:app_bootstrap/bootstrap_contracts/_remote_database.dart'
    show IRemoteDataBase;
import 'package:app_bootstrap/configs/env.dart' show EnvConfig, EnvFileName;
import 'package:firebase_adapter/bootstrap/dotenv_options.dart';
import 'package:firebase_adapter/utils/firebase_utils.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 🧩🔥 [FirebaseRemoteDataBase] — Current implementation of [IRemoteDataBase], with Firebase+Env initialization logic
//
final class FirebaseRemoteDataBase implements IRemoteDataBase {
  ///-------------------------------------------------------
  const FirebaseRemoteDataBase();

  @override
  Future<void> init() async {
    //📀 Loads environment configuration (.env file), based on current environment
    await dotenv.load(fileName: EnvConfig.currentEnv.fileName);
    debugPrint('✅ Loaded env file: ${EnvConfig.currentEnv.fileName}');

    /// 🛡️ Initializes Firebase once (idempotent).
    await SafeFirebaseInit.run(
      options: DotenvFirebaseOptions.currentPlatform,
    );
  }

  //
}
