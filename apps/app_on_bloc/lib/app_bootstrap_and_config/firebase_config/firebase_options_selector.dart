/*

import 'package:app_on_bloc/app_bootstrap_and_config/constants/flavors.dart';
import 'package:app_on_bloc/firebase_options_dev.dart' as dev;
import 'package:app_on_bloc/firebase_options_stg.dart' as stg;
import 'package:app_on_bloc/firebase_options_prod.dart' as prod; // якщо буде

import 'package:firebase_core/firebase_core.dart';


final class FirebaseOptionsSelector {
  FirebaseOptionsSelector._();

  
  static FirebaseOptions get current {
    return switch (FlavorConfig.current) {
      AppFlavor.development => dev.DefaultFirebaseOptions.currentPlatform,
      AppFlavor.staging => stg.DefaultFirebaseOptions.currentPlatform,
      AppFlavor.production  => prod.DefaultFirebaseOptions.currentPlatform,
    };
  }
}

 */
