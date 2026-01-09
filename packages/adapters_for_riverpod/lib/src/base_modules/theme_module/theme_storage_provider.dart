part of 'theme_provider.dart';

/// 🧩 [themeStorageProvider] — shared GetStorage used by theme provider.
/// Assumes `GetStorage.init()` has been called in bootstrap.
//
final themeStorageProvider = Provider<GetStorage>((ref) => GetStorage());
