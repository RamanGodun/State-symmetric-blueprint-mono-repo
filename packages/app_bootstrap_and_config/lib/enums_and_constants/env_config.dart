import 'package:app_bootstrap_and_config/enums_and_constants/flavor_config.dart';

/// 🌐 [Environment] — Enum that defines app runtime modes.
///
/// ✅ Used for switching configuration, matches `.env.*` file naming convention (e.g., `.env.dev`, `.env.staging`)
/// ⚠️ Must remain consistent across build flavors, env files, and CI/CD pipelines
//
enum Environment {
  /// 🧪 Development environment (Local APIs / mocks, verbose logging & debug tools enabled)
  dev,

  /// 🟡 Staging environment(Pre-production testing, QA, UAT, or internal builds)
  staging,

  /// 🟢 Production environment (Live APIs, Logging/reporting only (Crashlytics, Sentry, etc.))
  // prod,
}

////
////

/// 🧩 [EnvFileName] — Extension to map each [Environment] to its corresponding `.env` file.
/// ✅ Used to dynamically load environment-specific config via `flutter_dotenv`.
//
extension EnvFileName on Environment {
  /// 📦 Returns the associated `.env` filename for this [Environment] variant.
  String get fileName => switch (this) {
    Environment.dev => '.env.dev',
    Environment.staging => '.env.staging',
    // Environment.prod => '.env',
  };
}

////

////

/// 🌐 [EnvConfig] — Environment-based configuration
/// Supports dev, staging, and prod modes via `flutter_dotenv`.
/// ! Never store secrets directly here.
/// Used for: API base URLs, Feature toggles, Logging flags
//
final class EnvConfig {
  ///-----------------
  EnvConfig._();
  //

  /// 🌍 Current environment (⚠️ adjust before release!)
  static Environment get currentEnv => switch (FlavorConfig.current) {
    AppFlavor.development => Environment.dev,
    AppFlavor.staging => Environment.staging,
  };

  /// 🐞 Toggle for debug tools and verbose logging
  static bool get isDebugMode => currentEnv == Environment.dev;

  /// 🚀 Toggle for staging QA tools
  static bool get isStagingMode => currentEnv == Environment.staging;

  /// 🔐 Indicates if app is running in production
  // static bool get isProduction => currentEnv == Environment.prod;

  /*
  /// 🌐 API base URL by environment
  static String get apiBaseUrl => switch (currentEnv) {
    Environment.dev => 'https://api-dev.example.com',
    Environment.staging => 'https://api-staging.example.com',
    // Environment.prod => 'https://api.example.com',
  };

  /// 🔥 Firebase key (fallback mock only — real one via dotenv)
  static String get firebaseApiKey => switch (currentEnv) {
    Environment.dev => 'DEV_FIREBASE_KEY',
    Environment.staging => 'STAGING_FIREBASE_KEY',
    // Environment.prod => 'PROD_FIREBASE_KEY',
  };
 */

  //
}
