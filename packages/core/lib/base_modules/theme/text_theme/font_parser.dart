part of 'text_theme_factory.dart';

/// 🔡 Уніфікований парсер назви шрифту з персистентного сховища/мережі.
///
/// Підтримує:
/// - 'sfPro', 'SFProText' (legacy) → Inter
/// - 'inter'/'Inter' → Inter
/// - 'montserrat'/'Montserrat' → Montserrat
/// - будь-що інше → Inter (safe default)
AppFontFamily parseAppFontFamily(String? raw) {
  switch (raw) {
    case 'sfPro':
    case 'SFProText':
      return AppFontFamily.inter;
    case 'montserrat':
    case 'Montserrat':
      return AppFontFamily.montserrat;
    case 'inter':
    case 'Inter':
    default:
      return AppFontFamily.inter;
  }
}
