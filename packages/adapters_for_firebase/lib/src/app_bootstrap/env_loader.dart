import 'package:flutter_dotenv/flutter_dotenv.dart' show dotenv;

/// 🧩 [EnvLoader] — safe facade for `.env` access
/// ✅ Keeps `flutter_dotenv` hidden inside adapter layer.
///    Apps/features import this instead of depending on dotenv directly.
//
abstract final class EnvLoader {
  ///------------------------
  /// 📀 Loads environment file by given [fileName]
  /// Use at app bootstrap before any Firebase/services init.
  static Future<void> load(String fileName) => dotenv.load(fileName: fileName);

  /// 🔑 Reads optional env value by [key]
  /// Returns `null` if the key is not present in .env
  static String? get(String key) => dotenv.maybeGet(key);
  //
}
