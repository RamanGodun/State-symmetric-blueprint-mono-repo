//
// ignore_for_file: directives_ordering, dangling_library_doc_comments

/// 🧱 BlocAdapter — Clean Public API
/// ✨ Everything public re-exported from `src/`
/// 🧩 Keep internals under `src/` to avoid “src leaks”
//

/// ─────────────────────────────────────────────────────────────────────────
/// 1) Base Modules — Observer
///    • Global BLoC observer & diagnostics
/// ─────────────────────────────────────────────────────────────────────────
export 'src/base_modules/observer/bloc_observer.dart' show AppBlocObserver;

/// ─────────────────────────────────────────────────────────────────────────
/// 2) Base Modules — Overlays
///    • Wiring overlays into app lifecycle
///    • Bridge to activity status via Cubit
/// ─────────────────────────────────────────────────────────────────────────
export 'src/base_modules/overlays_module/overlay_status_cubit.dart';

export 'src/base_modules/overlays_module/overlay_activity_port_bloc.dart'
    show BlocOverlayActivityPort;

export 'src/base_modules/overlays_module/overlay_resolver_wiring.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// 3) Base Modules — Theme
///    • Theme Cubit + tiny adapter widgets
/// ─────────────────────────────────────────────────────────────────────────
export 'src/base_modules/theme_module/theme_cubit.dart';

export 'src/base_modules/theme_module/theme_toggle_widgets/theme_toggler.dart'
    show ThemeTogglerIcon;

export 'src/base_modules/theme_module/theme_toggle_widgets/theme_picker.dart'
    show ThemePicker;

/// ─────────────────────────────────────────────────────────────────────────
/// 4) DI Core (GetIt-based)
///    • Minimal DI surface: container, modules, manager, helpers
/// ─────────────────────────────────────────────────────────────────────────
export 'src/di/core/di.dart' show di;

export 'src/di/core/di_module_interface.dart' show DIModule;

export 'src/di/core/di_module_manager.dart' show ModuleManager;

export 'src/di/x_on_get_it.dart';

/// ─────────────────────────────────────────────────────────────────────────
/// 5) Shared Presentation Layer
///    • Reusable Cubits & widgets (agnostic to features)
/// ─────────────────────────────────────────────────────────────────────────
export 'src/presentation_shared/cubits/auth_cubit.dart'
    show
        AuthCubit,
        AuthViewError,
        AuthViewLoading,
        AuthViewReady,
        AuthViewState;

export 'src/presentation_shared/widgets_shared/form_submit_button.dart'
    show FormSubmitButton;

/// ─────────────────────────────────────────────────────────────────────────
/// 5) State adapters
/// ─────────────────────────────────────────────────────────────────────────
export 'src/utils/async/async_cubit.dart';
export 'src/utils/async/like_core_async_implementation.dart';
