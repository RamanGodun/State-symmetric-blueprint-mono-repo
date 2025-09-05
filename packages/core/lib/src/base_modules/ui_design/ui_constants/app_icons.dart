// 📌 No need for public API docs.
// ignore_for_file: public_member_api_docs

part of '_app_constants.dart';

/// 🖼️ [AppIcons] — Centralized collection of app-wide icon constants.
///   ✅ Provides all commonly used [IconData] for themes, actions, profiles, and languages.
///   ✅ Ensures consistency and easy refactoring of UI icons across the app.
///   Should be used everywhere instead of raw Icons.* for maintainability.
//
abstract final class AppIcons {
  /// ──────────────-----------
  const AppIcons._();

  // 🌤 Theme & UI
  static const IconData sun = Icons.sunny;
  static const IconData lightMode = Icons.light_mode;
  static const IconData darkMode = Icons.dark_mode;
  static const IconData sync = Icons.sync;
  static const IconData changeCircle = Icons.change_circle;

  // 📤 UI Actions
  static const IconData remove = Icons.remove;
  static const IconData delete = Icons.delete_forever;

  // 👤 Profile / Auth
  static const IconData profile = Icons.account_circle;
  static const IconData logout = Icons.exit_to_app;
  static const IconData email = Icons.email;
  static const IconData name = Icons.account_box;
  static const IconData password = Icons.lock;
  static const IconData confirmPassword = Icons.lock_outline;

  // 🌐 Language toggle icons
  static const IconData languageEn = Icons.language;
  static const IconData languageUk = Icons.g_translate;
  static const IconData languagePl = Icons.language;
  static const IconData language = Icons.language;

  //
}

////

////

/// 🌓 [ThemeIconX] — Extension for easily toggling between dark/light mode icons.
///   Useful for building dynamic theme toggles in the UI.
//
extension ThemeIconX on IconData {
  /// Returns the opposite theme icon:
  /// - [AppIcons.darkMode] -> [AppIcons.lightMode]
  /// - [AppIcons.lightMode] (or any other) -> [AppIcons.darkMode]
  IconData get toggled =>
      this == AppIcons.darkMode ? AppIcons.lightMode : AppIcons.darkMode;
}
