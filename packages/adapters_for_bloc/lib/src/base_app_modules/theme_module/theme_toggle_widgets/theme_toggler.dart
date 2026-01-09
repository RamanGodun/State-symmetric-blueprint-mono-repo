import 'package:adapters_for_bloc/src/base_app_modules/theme_module/theme_cubit.dart'
    show AppThemeCubit;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, SelectContext;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemeTogglerIconView;

/// 🧩 [ThemeTogglerIcon] — Bloc adapter
/// ✅ Reads state from [AppThemeCubit] and forwards it into the shared View.
/// ❌ Contains no UI logic — only passes data and delegates callbacks.
///
final class ThemeTogglerIcon extends StatelessWidget {
  ///----------------------------------------------
  const ThemeTogglerIcon({super.key});
  //

  @override
  Widget build(BuildContext context) {
    /// 🎯 Selects the current theme state (dark / light)
    final isDark = context.select<AppThemeCubit, bool>(
      (cubit) => cubit.state.theme.isDark,
    );

    /// 🔌 Passes state + callback into the stateless view
    return ThemeTogglerIconView(
      isDark: isDark,
      onToggle: () async => context.read<AppThemeCubit>().toggleTheme(),
    );
  }
}
