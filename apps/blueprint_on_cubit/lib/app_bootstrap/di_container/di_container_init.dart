import 'package:bloc_adapter/di/core/di_module_manager.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/email_verification.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/form_fields_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/overlays_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/password_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/profile_module.dart';
import 'package:blueprint_on_cubit/app_bootstrap/di_container/modules/theme_module.dart';
import 'package:flutter/foundation.dart' show debugPrint;

/// 🚀 [DIContainer] — Centralized class for dependency registration
/// ✅ Separates all responsibilities by layers: Services, DataSources, UseCases, Blocs, etc.
///    - Call [initNecessaryForAppSplashScreen] first for splash/loader dependencies.
///    - Call [initFull] for all core app dependencies after the splash.
//
abstract final class DIContainer {
  ///---------------------
  DIContainer._();
  //

  /// 🎯  Registers all core dependencies for the main app tree
  static Future<void> initFull() async {
    await ModuleManager.registerModules([
      //
      ThemeModule(),
      //
      FirebaseModule(),
      //
      AuthModule(),
      EmailVerificationModule(),
      //
      ProfileModule(),
      //
      PasswordModule(),
      //
      OverlaysModule(),
      //
      FormFieldsModule(),

      //
    ]);
    debugPrint('📦 Full DI initialized with modules');
  }

  ////

  /// 🎯 Registers only the minimal DI needed for the splash/loader (e.g. theme cubit).
  static Future<void> initNecessaryForAppSplashScreen() async {
    await ModuleManager.registerModules([ThemeModule()]);
    debugPrint('📦 Minimal DI initialized (currently: Theme cubit) ');
  }

  //
}
