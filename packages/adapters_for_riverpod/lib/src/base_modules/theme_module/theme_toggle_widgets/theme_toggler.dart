import 'package:adapters_for_riverpod/adapters_for_riverpod.dart'
    show themeProvider;
import 'package:flutter/material.dart' show BuildContext, Widget;
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ConsumerWidget, WidgetRef;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeTogglerIconView;

/// 🧩 [ThemeTogglerIcon] — Riverpod adapter (no UI logic).
/// ✅ Reads from `themeProvider`, passes state + callback to the view.
///
final class ThemeTogglerIcon extends ConsumerWidget {
  ///-----------------------------------------
  const ThemeTogglerIcon({super.key});
  //

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    /// 🎯 Watch current theme state
    final isDark = ref.watch(themeProvider.select((p) => p.theme.isDark));

    /// 🔌 Read notifier for callback
    final notifier = ref.read(themeProvider.notifier);

    /// 🔌 Pass state + callback into the stateless view
    return ThemeTogglerIconView(
      isDark: isDark,
      onToggle: () async => notifier.toggleTheme(),
    );
  }
}
