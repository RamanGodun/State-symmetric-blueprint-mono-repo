/// 🏷️ Application flavors
/// Used to distinguish between different runtime environments
enum AppFlavor {
  /// 🧪 Local development environment
  development,

  /// 🚀 Staging / pre-production environment
  staging,

  /// 🏢 Production environment (final release)
  /// Uncomment when ready to configure production
  // production,
}

////

////

/// ⚙️ Global flavor configuration
/// Stores the active flavor and provides utility getters
final class FlavorConfig {
  /// 🔹 Currently selected flavor (set at app bootstrap)
  static late final AppFlavor current;

  /// 📛 Human-readable flavor name
  /// Used for logs, analytics, and Firebase initialization
  static String get name => switch (current) {
    AppFlavor.development => 'development',
    AppFlavor.staging => 'staging',
    // AppFlavor.production => 'production',
  };

  /// ✅ Quick flag for dev environment
  static bool get isDev => current == AppFlavor.development;

  /// ✅ Quick flag for staging environment
  static bool get isStg => current == AppFlavor.staging;

  /// ✅ Quick flag for production environment
  /// Uncomment when ready for production
  // static bool get isProd => current == AppFlavor.production;

  //
}
