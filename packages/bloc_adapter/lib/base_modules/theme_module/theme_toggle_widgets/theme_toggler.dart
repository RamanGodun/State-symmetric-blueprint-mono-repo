import 'package:bloc_adapter/base_modules/theme_module/theme_cubit.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_switchers/theme_toggler_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
