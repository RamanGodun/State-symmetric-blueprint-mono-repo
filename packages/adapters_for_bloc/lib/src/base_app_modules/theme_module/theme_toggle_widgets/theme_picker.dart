import 'package:adapters_for_bloc/src/base_app_modules/theme_module/theme_cubit.dart'
    show AppThemeCubit;
import 'package:flutter/material.dart'
    show BuildContext, StatelessWidget, Widget;
import 'package:flutter_bloc/flutter_bloc.dart' show ReadContext, SelectContext;
import 'package:shared_core_modules/public_api/base_modules/ui_design.dart'
    show ThemePickerView, ThemeVariantsEnum;

/// 🧩 [ThemePicker] — Bloc adapter
/// ✅ Reads [AppThemeCubit] state and delegates it to the shared View.
/// ❌ Contains no UI logic — only passes props and callbacks.
///
final class ThemePicker extends StatelessWidget {
  ///--------------------------------------
  const ThemePicker({super.key});
  //

  @override
  Widget build(BuildContext context) {
    /// 🎯 Watch current preferences from Cubit
    final current = context.select<AppThemeCubit, ThemeVariantsEnum>(
      (c) => c.state.theme,
    );

    /// 🔌 Forward state + callback into the stateless view
    return ThemePickerView(
      current: current,
      onChanged: (ThemeVariantsEnum t) async =>
          context.read<AppThemeCubit>().setTheme(t),
    );
  }
}
