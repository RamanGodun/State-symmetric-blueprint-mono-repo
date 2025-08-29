import 'package:core/base_modules/theme/widgets_and_utils/theme_switchers/theme_toggler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_adapter/base_modules/theme_module/theme_provider.dart';

/// 🧩 [ThemeTogglerIcon] — Riverpod adapter
/// ✅ Reads state via `themeProvider`, forwards data + async callback.
/// ❌ Contains no UI logic — only props + delegates.
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
