import 'package:app_on_bloc/app_bootstrap_and_config/firebase_config/env_config.dart';
import 'package:app_on_bloc/app_bootstrap_and_config/firebase_config/env_firebase_options.dart'
    show EnvFirebaseOptions;
import 'package:app_on_bloc/app_bootstrap_and_config/firebase_config/firebase_utils.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// 📦💾 [IRemoteDataBase] — Abstraction to decouple startup logic and enable mocking in tests.
//
abstract interface class IRemoteDataBase {
  ///---------------------------------
  //
  /// Initializes all [IRemoteDataBase] services
  Future<void> init();
  //
}

////

////

/// 🔥🧩 [FirebaseRemoteDataBase] — Current implementation of [IRemoteDataBase], with Firebase+Env initialization logic
//
final class FirebaseRemoteDataBase implements IRemoteDataBase {
  ///----------------------------------------------------
  const FirebaseRemoteDataBase();

  @override
  Future<void> init() async {
    //
    debugPrint('🔥 FirebaseStack: loading env file...');
    //📀 Loads environment configuration (.env file), based on current environment
    await dotenv.load(fileName: EnvConfig.currentEnv.fileName);
    debugPrint('✅ Loaded env file: ${EnvConfig.currentEnv.fileName}');

    /// 🔥 Initializes Firebase if not already initialized
    if (!FirebaseUtils.isDefaultAppInitialized) {
      try {
        debugPrint('🔥 Initializing Firebase...');
        await Firebase.initializeApp(
          options: EnvFirebaseOptions.currentPlatform,
          // options: FirebaseOptionsSelector.current,
        );
        debugPrint('🔥 Firebase initialized!');
      } on FirebaseException catch (e) {
        if (e.code == 'duplicate-app') {
          debugPrint('⚠️ Firebase already initialized, skipping...');
        } else {
          rethrow;
        }
      }
    } else {
      debugPrint('⚠️ Firebase already initialized (checked manually)');
    }

    // Log all initialized Firebase apps for debug.
    FirebaseUtils.logAllApps();
    //
  }

  //
}
