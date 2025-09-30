import 'package:core/public_api/base_modules/ui_design.dart'
    show ThemeTogglerIconView;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/src/core/base_modules/theme_module/theme_provider.dart';

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
