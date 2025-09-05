import 'package:app_on_bloc/app_bootstrap/di_container/modules/auth_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/email_verification.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/firebase_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/form_fields_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/navigation_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/overlays_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/password_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/profile_module.dart';
import 'package:app_on_bloc/app_bootstrap/di_container/modules/theme_module.dart';
import 'package:bloc_adapter/bloc_adapter.dart' show ModuleManager;
import 'package:flutter/foundation.dart' show debugPrint;

/// 🚀 [DIContainer] — centralized entry point for dependency registration
/// ✅ Aggregates all DI modules (services, data sources, use cases, blocs, etc.)
/// ✅ Provides possibility of phased initialization: minimal (for splash) vs. full (for whole main app)
//
abstract final class DIContainer {
  ///--------------------------
  DIContainer._();

  /// 🎯 Initializes the **full DI stack** for the application
  /// ✅ Registers all feature modules: theme, firebase, auth, navigation, etc.
  static Future<void> initFull() async {
    await ModuleManager.registerModules([
      ThemeModule(),
      FirebaseModule(),
      AuthModule(),
      NavigationModule(),
      EmailVerificationModule(),
      ProfileModule(),
      PasswordModule(),
      OverlaysModule(),
      FormFieldsModule(),
    ]);
    debugPrint('📦 Full DI initialized with modules');
  }

  /// 🎯 Initializes **minimal DI stack** for splash/loader
  ///   - Typically includes only theme or very lightweight dependencies
  ///   - Allows splash to render before heavy services are bootstrapped
  static Future<void> initNecessaryForAppSplashScreen() async {
    await ModuleManager.registerModules([ThemeModule()]);
    debugPrint('📦 Minimal DI initialized (currently: Theme cubit)');
  }

  //
}
