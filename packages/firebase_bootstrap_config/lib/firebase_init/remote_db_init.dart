import 'package:app_bootstrap_and_config/app_bootstrap_and_config.dart';
import 'package:firebase_bootstrap_config/firebase_config/_barrel_for_firebase_config.dart';
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
    await FirebaseUtils.safeFirebaseInit(
      options: DotenvFirebaseOptions.currentPlatform,
    );
  }

  //
}
