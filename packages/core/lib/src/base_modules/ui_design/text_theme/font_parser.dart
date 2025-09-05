part of 'text_theme_factory.dart';

/// 🔡 Unified parser of fonts names from storage
//
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
