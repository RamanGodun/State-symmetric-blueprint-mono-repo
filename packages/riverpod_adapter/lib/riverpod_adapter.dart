///
// ignore_for_file: directives_ordering, dangling_library_doc_comments

/// 📦 Riverpod Adapter — Public API
/// ✅ Bridges `features` package with Riverpod providers
/// ✅ Includes DI helpers, base modules, and utilities
///

/// --- Utils (auth, async safety, typedefs)
export 'src/utils/auth/auth_stream_adapter.dart';
export 'src/utils/auth/firebase_providers.dart';
export 'src/utils/safe_async_state.dart';
export 'src/utils/typedefs.dart';

/// --- Async States utils
export 'src/utils/async/async_state_view_for_riverpod.dart';
export 'src/utils/async/async_error_listener.dart';
export 'src/utils/async/async_value_to_core_async.dart';
export 'src/utils/async/async_multi_errors_listener.dart';

/// --- Base Modules: Errors
export 'src/base_modules/errors_handling_module/async_value_failure_x.dart';
export 'src/base_modules/errors_handling_module/async_value_match_x.dart';
export 'src/base_modules/errors_handling_module/show_dialog_when_error_x_on_ref.dart';

/// --- Base Modules: Observing
export 'src/base_modules/observing/async_value_xx.dart';
export 'src/base_modules/observing/providers_debug_observer.dart';

/// --- Base Modules: Overlays
export 'src/base_modules/overlays_module/overlay_adapters_providers.dart';
export 'src/base_modules/overlays_module/overlay_resolver_wiring.dart';
export 'src/base_modules/overlays_module/overlay_status_x.dart';

/// --- Base Modules: Theme
export 'src/base_modules/theme_module/theme_provider.dart';
export 'src/base_modules/theme_module/theme_toggle_widgets/theme_picker.dart';
export 'src/base_modules/theme_module/theme_toggle_widgets/theme_toggler.dart';

/// --- DI
export 'src/di/global_di_container.dart';
export 'src/di/i_di_config.dart';
export 'src/di/read_di_x_on_context.dart';
export 'src/di/di_config_examples/di_config_sync.dart';
export 'src/di/di_config_examples/di_config_async.dart';

/// --- Feature Providers: Auth
export 'src/features_providers/auth/data_layer_providers/data_layer_providers.dart';
export 'src/features_providers/auth/domain_layer_providers/use_cases_providers.dart';

/// --- Feature Providers: Email Verification
export 'src/features_providers/email_verification/data_layer_providers/data_layer_providers.dart';
export 'src/features_providers/email_verification/domain_layer_providers/use_case_provider.dart';

/// --- Feature Providers: Password Changing / Reset
export 'src/features_providers/password_changing_or_reset/data_layer_providers/data_layer_providers.dart';
export 'src/features_providers/password_changing_or_reset/domain_layer_providers/use_cases_provider.dart';

/// --- Feature Providers: Profile
export 'src/features_providers/profile/data_layers_providers/data_layer_providers.dart';
export 'src/features_providers/profile/domain_layer_providers/use_case_provider.dart';
