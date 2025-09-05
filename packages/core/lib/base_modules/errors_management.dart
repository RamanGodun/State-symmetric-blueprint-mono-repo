/// 🛡️ Errors Handling Module — barrel exports
/// Facade + domain models + DSL/utils + logging + BLoC helpers.
// ignore_for_file: directives_ordering
library;

//
// ─── FACADE (ENTRY POINT) ──────────────────────────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/_errors_handling_entry_point.dart';
/*
  Contains:
  - ResultFutureExtension<T>.runWithErrorHandling()
  - exception→failure mapping via `part` files (firebase/dio/etc)
*/

//
// ─── CORE DOMAIN MODELS ────────────────────────────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/either.dart';
export '../src/base_modules/errors_management/core_of_module/failure_entity.dart';
export '../src/base_modules/errors_management/core_of_module/failure_type.dart'; // has `part`s for concrete types
export '../src/base_modules/errors_management/core_of_module/failure_ui_entity.dart';
export '../src/base_modules/errors_management/core_of_module/failure_ui_mapper.dart';

//
// ─── CORE UTILS & DSL (SYNC/ASYNC HANDLERS) ───────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/core_utils/result_handler.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/result_handler_async.dart';

//
// ─── EITHER EXTENSIONS (SYNC/ASYNC + GETTERS + TEST HELPERS) ──────────────────
//
export '../src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/either__x.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/either_async_x.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/either_getters_x.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/extensions_on_either/for_tests_either_x.dart';

//
// ─── FAILURE EXTENSIONS (CONVERSIONS / HELPERS) ────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/core_utils/extensions_on_failure/failure_to_either_x.dart';

//
// ─── OBSERVABILITY & LOGGING ───────────────────────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/core_utils/errors_observing/loggers/errors_log_util.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/errors_observing/loggers/failure_logger_x.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/errors_observing/result_loggers/result_logger_x.dart';

//
// ─── STATE MANAGER SPECIFICS (BLOC/CUBIT) ──────────────────────────────────────
//
export '../src/base_modules/errors_management/core_of_module/core_utils/specific_for_bloc/consumable.dart';
export '../src/base_modules/errors_management/core_of_module/core_utils/specific_for_bloc/consumable_extensions.dart';

//
// ─── EXTENSIBLE PART: UI/DIAGNOSTICS HELPERS & CODES ──────────────────────────
//  (Do NOT export exception mappers here — they are `part` of the facade above.)
//
export '../src/base_modules/errors_management/extensible_part/failure_extensions/failure_diagnostics_x.dart';
export '../src/base_modules/errors_management/extensible_part/failure_extensions/failure_icons_x.dart';
export '../src/base_modules/errors_management/extensible_part/failure_extensions/failure_led_retry_x.dart';
export '../src/base_modules/errors_management/extensible_part/failure_types/failure_codes.dart';
