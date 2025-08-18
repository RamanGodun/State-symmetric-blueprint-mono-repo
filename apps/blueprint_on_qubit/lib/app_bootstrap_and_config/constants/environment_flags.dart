/// 🔧 Runtime environment flags
/// 📂 Paths, filenames, and fallback environment references
//
final class AppEnvFlags {
  ///-------------------
  AppEnvFlags._();
  //

  ///   🧪 Flag for release mode
  static const bool isRelease = bool.fromEnvironment('dart.vm.product');

  /// 👀 Flag for debug mode
  static bool get isDebug => !isRelease;

  /// 🤖 CI/CD flag (GitHub Actions, Bitbucket Pipelines, etc.)
  static const bool isCI = bool.fromEnvironment('CI');

  /// 🧪 Flag for test environment (e.g. Flutter test)
  static const bool isTest = bool.fromEnvironment('FLUTTER_TEST');

  /// 🚧 Toggle feature flags (can be overridden in .env or injected)
  static const bool enableExperimentalUI = false;

  /// 🔍 Enable detailed error logging
  static bool get showVerboseErrors => isDebug || isCI;

  /// 🛠️ Fallback path for .env file (used in tests, CLI)
  static const String defaultEnvFile = '.env';

  //
}
