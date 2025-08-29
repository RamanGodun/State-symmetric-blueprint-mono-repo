import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_switchers/theme_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart';

/// 🧩 [ThemePicker] — Riverpod adapter
/// ✅ Watches `themeProvider` and forwards state + change handler into the View.
/// ❌ Contains no UI logic — only props + callbacks.
///
final class ThemePicker extends ConsumerWidget {
  ///--------------------------------------
  const ThemePicker({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 🎯 Watch current preferences from provider
    final prefs = ref.watch(themeProvider);

    /// 🔌 Read notifier for callbacks
    final notifier = ref.read(themeProvider.notifier);

    /// 🔌 Pass state + handler into the stateless view
    return ThemePickerView(
      current: prefs.theme,
      onChanged: (ThemeVariantsEnum t) async => notifier.setTheme(t),
    );
  }
}
