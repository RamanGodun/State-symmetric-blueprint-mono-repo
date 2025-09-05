// packages/core/lib/base_modules/theme/widgets/theme_picker_view.dart
import 'package:core/base_modules/localization/core_of_module/init_localization.dart';
import 'package:core/base_modules/localization/generated/locale_keys.g.dart';
import 'package:core/base_modules/localization/module_widgets/text_widget.dart';
import 'package:core/base_modules/overlays/core/_context_x_for_overlays.dart';
import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:flutter/material.dart';

/// 🌗 [ThemePickerView] — Stateless “dumb-widget”
/// ✅ Renders a dropdown with theme variants; invokes the provided callback.
/// ❌ No dependency on state managers (Cubit/Riverpod) — receives data via props.
///
final class ThemePickerView extends StatelessWidget {
  ///--------------------------------------
  const ThemePickerView({
    required this.current,
    required this.onChanged,
    super.key,
  });

  /// Currently selected theme variant
  final ThemeVariantsEnum current;

  /// Delegated handler for changing theme (provided by Cubit/Riverpod wrapper)
  final Future<void> Function(ThemeVariantsEnum) onChanged;

  /// 🔽 Available theme variants
  static const List<ThemeVariantsEnum> _variants = [
    ThemeVariantsEnum.light,
    ThemeVariantsEnum.dark,
    ThemeVariantsEnum.amoled,
  ];

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);

    return DropdownButton<ThemeVariantsEnum>(
      key: ValueKey(locale.languageCode),
      value: current,
      icon: const Icon(Icons.arrow_drop_down),
      underline: const SizedBox(),

      /// 🔄 User picked a theme
      onChanged: (ThemeVariantsEnum? selected) async {
        final showUserBanner = context.showUserBanner;
        if (selected == null) return;
        await onChanged(selected);

        /// 🏷️ Show confirmation banner
        final label = _chosenThemeLabel(selected);
        showUserBanner(message: label, icon: Icons.palette);
      },

      /// 🧾 Options list
      items: _variants
          .map(
            (type) => DropdownMenuItem<ThemeVariantsEnum>(
              value: type,
              child: TextWidget(
                _themeLabel(type),
                TextType.titleMedium,
              ),
            ),
          )
          .toList(),
    );
  }

  ////

  /// 🏷️ Localized label for dropdown items
  String _themeLabel(ThemeVariantsEnum type) => switch (type) {
    ThemeVariantsEnum.light => AppLocalizer.translateSafely(
      LocaleKeys.theme_light,
    ),
    ThemeVariantsEnum.dark => AppLocalizer.translateSafely(
      LocaleKeys.theme_dark,
    ),
    ThemeVariantsEnum.amoled => AppLocalizer.translateSafely(
      LocaleKeys.theme_amoled,
    ),
  };

  /// 🏷️ Localized label for confirmation banner
  String _chosenThemeLabel(ThemeVariantsEnum type) => switch (type) {
    ThemeVariantsEnum.light => AppLocalizer.translateSafely(
      LocaleKeys.theme_light_enabled,
    ),
    ThemeVariantsEnum.dark => AppLocalizer.translateSafely(
      LocaleKeys.theme_dark_enabled,
    ),
    ThemeVariantsEnum.amoled => AppLocalizer.translateSafely(
      LocaleKeys.theme_amoled_enabled,
    ),
  };
}
