import 'package:bloc_adapter/base_modules/theme_module/theme_cubit.dart';
import 'package:core/base_modules/theme/module_core/theme_variants.dart';
import 'package:core/base_modules/theme/widgets_and_utils/theme_switchers/theme_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    final prefs = context.watch<AppThemeCubit>().state;

    /// 🔌 Forward state + callback into the stateless view
    return ThemePickerView(
      current: prefs.theme,
      onChanged: (ThemeVariantsEnum t) async =>
          context.read<AppThemeCubit>().setTheme(t),
    );
  }
}
