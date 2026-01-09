import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show themeProvider;
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemePickerView, ThemeVariantsEnum;

/// 🧩 [ThemePicker] — Riverpod adapter (no UI logic).
/// ✅ Watches `themeProvider` and forwards props + callbacks to the view.
///
final class ThemePicker extends ConsumerWidget {
  ///--------------------------------------
  const ThemePicker({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 🎯 Watch current preferences from provider
    final current = ref.watch(themeProvider.select((p) => p.theme));

    /// 🔌 Read notifier for callbacks
    final notifier = ref.read(themeProvider.notifier);

    /// 🔌 Pass state + handler into the stateless view
    return ThemePickerView(
      current: current,
      onChanged: (ThemeVariantsEnum t) async => notifier.setTheme(t),
    );
  }
}
