import 'package:adapters_for_bloc/adapters_for_bloc.dart' show ModuleManager;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/auth_module.dart'
    show AuthModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/email_verification.dart'
    show EmailVerificationModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/firebase_module.dart'
    show FirebaseModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/form_fields_module.dart'
    show FormFieldsModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/navigation_module.dart'
    show NavigationModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/overlays_module.dart'
    show OverlaysModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/password_module.dart'
    show PasswordModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/profile_module.dart'
    show ProfileModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/theme_module.dart'
    show ThemeModule;
import 'package:app_on_cubit/app_bootstrap/di_container/modules/warmup_module.dart'
    show WarmupModule;
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
      WarmupModule(),
      PasswordModule(),
      OverlaysModule(),
      FormFieldsModule(),
    ]);
    debugPrint('📦 Full DI initialized with modules');
  }

  //
}
