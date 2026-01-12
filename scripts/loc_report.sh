#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# State-Symmetric LOC Cost Report (Average per migration = RoundTrip/2)
# - Skips generated (*.g.dart, *.freezed.dart, *.mocks.dart, *.gr.dart)
# - Skips comments
# - Aggregates by track: SCSM (Shared Custom State Models) and AVLSM (AsyncValue-Like State Models)
# - Calculates amortization for N features
# =============================================================================

# ---- Dependencies ------------------------------------------------------------
command -v rg  >/dev/null 2>&1 || { echo "Please: brew install ripgrep"; exit 1; }
command -v awk >/dev/null 2>&1 || { echo "awk required"; exit 1; }

# ---- Excludes ---------------------------------------------------------------
EXCLUDES=('!**/*.g.dart' '!**/*.freezed.dart' '!**/*.mocks.dart' '!**/*.gr.dart')
RG_EXCLUDES=(); for e in "${EXCLUDES[@]}"; do RG_EXCLUDES+=(--glob "$e"); done

# ---- Helpers -----------------------------------------------------------------
hr()   { printf '%*s\n' "$(tput cols 2>/dev/null || echo 100)" '' | tr ' ' '='; }
sec()  { echo; hr; echo "# $*"; hr; echo; }

# 5-column table: RP→CB | CB→RP | RoundTrip/2 | %Track
row5(){ printf "| %-22s | %10s | %10s | %12s | %8s |\n" "$1" "$2" "$3" "$4" "$5"; }
hdr5(){
  printf "| %-22s | %10s | %10s | %12s | %8s |\n" "Scenario" "RP→CB" "CB→RP" "Avg (RT/2)" "%Track";
  printf "|-%-22s-|-%10s-|-%10s-|-%12s-|-%8s-|\n" "----------------------" "----------" "----------" "------------" "--------";
}

# Savings mini-table (LOC + % of track)
row_sav(){ printf "| %-34s | %10s | %8s |\n" "$1" "$2" "$3"; }
hdr_sav(){
  printf "| %-34s | %10s | %8s |\n" "Bucket" "LOC" "%Track";
  printf "|-%-34s-|-%10s-|-%8s-|\n" "----------------------------------" "----------" "--------";
}

# Overhead table
row_over(){ printf "| %-54s | %10s | %12s |\n" "$1" "$2" "$3"; }
hdr_over(){
  printf "| %-54s | %10s | %12s |\n" "Track (LOC & % of track codebase)" "LOC" "% of track";
  printf "|-%-54s-|-%10s-|-%12s-|\n" "------------------------------------------------------" "----------" "------------";
}

# Amortization table
row_amort(){ printf "| %10s | %12s | %12s | %12s |\n" "$1" "$2" "$3" "$4"; }
hdr_amort(){
  printf "| %10s | %12s | %12s | %12s |\n" "N Features" "OH/Feature" "Break-Even" "Savings";
  printf "|--%10s-|-%12s-|-%12s-|-%12s-|\n" "----------" "------------" "------------" "------------";
}

pct() {
  local num=${1:-0} den=${2:-0}
  if [ "$den" -eq 0 ]; then echo "0.0%"; return; fi
  printf "%.1f%%" "$(awk "BEGIN {print ($num*100.0)/$den}")"
}

# Count non-empty, non-comment LOC in a dir
count_dir_code() {
  local dir="$1"
  [[ -d "$dir" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -t dart -n '^\s*\S' "$dir" \
    | cut -d: -f3 \
    | grep -Ev '^\s*//|^\s*/\*|^\s*\*|^\s*\*/' \
    | wc -l | tr -d ' '
}

# Count LOC in a single file
count_file_code() {
  local f="$1"
  [[ -f "$f" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -n '^\s*\S' "$f" \
    | cut -d: -f3 \
    | grep -Ev '^\s*//|^\s*/\*|^\s*\*|^\s*\*/' \
    | wc -l | tr -d ' '
}

sum_files() { local t=0; for f in "$@"; do [[ -n "${f:-}" ]] && t=$(( t + $(count_file_code "$f") )); done; echo "$t"; }

# Integer half (rounded)
half_num() { awk "BEGIN { printf \"%d\", ($1/2)+0.5 }"; }

# =============================================================================
# CONFIG — Explicit file lists per bucket
# =============================================================================

# --- BUCKET 2: Reused Core (Domain/Data) -------------------------------------
# SCSM Track
SCSM_CORE_FILES=(
  "packages/features_dd_layers/lib/src/auth/data/auth_repo_implementations/sign_in_repo_impl.dart"
  "packages/features_dd_layers/lib/src/auth/data/auth_repo_implementations/sign_up_repo_impl.dart"
  "packages/features_dd_layers/lib/src/auth/data/remote_database_contract.dart"
  "packages/features_dd_layers/lib/src/auth/data/remote_database_impl.dart"
  "packages/features_dd_layers/lib/src/auth/domain/use_cases/sign_in.dart"
  "packages/features_dd_layers/lib/src/auth/domain/use_cases/sign_up.dart"
  "packages/features_dd_layers/lib/src/auth/domain/repo_contracts.dart"
  "packages/features_dd_layers/lib/src/password_changing_or_reset/data/password_actions_repo_impl.dart"
  "packages/features_dd_layers/lib/src/password_changing_or_reset/data/remote_database_contract.dart"
  "packages/features_dd_layers/lib/src/password_changing_or_reset/data/remote_database_impl.dart"
  "packages/features_dd_layers/lib/src/password_changing_or_reset/domain/password_actions_use_case.dart"
  "packages/features_dd_layers/lib/src/password_changing_or_reset/domain/repo_contract.dart"
)

# AVLSM Track
AVLSM_CORE_FILES=(
  "packages/features_dd_layers/lib/src/email_verification/data/email_verification_repo_impl.dart"
  "packages/features_dd_layers/lib/src/email_verification/data/remote_database_contract.dart"
  "packages/features_dd_layers/lib/src/email_verification/data/remote_database_impl.dart"
  "packages/features_dd_layers/lib/src/email_verification/domain/email_verification_use_case.dart"
  "packages/features_dd_layers/lib/src/email_verification/domain/repo_contract.dart"
  "packages/features_dd_layers/lib/src/profile/data/implementation_of_profile_fetch_repo.dart"
  "packages/features_dd_layers/lib/src/profile/data/remote_database_contract.dart"
  "packages/features_dd_layers/lib/src/profile/data/remote_database_impl.dart"
  "packages/features_dd_layers/lib/src/profile/domain/fetch_profile_use_case.dart"
  "packages/features_dd_layers/lib/src/profile/domain/repo_contract.dart"
  "packages/features_dd_layers/lib/src/auth/data/auth_repo_implementations/sign_out_repo_impl.dart"
  "packages/features_dd_layers/lib/src/auth/domain/use_cases/sign_out.dart"
)

# Shared stateless widgets
SHARED_WIDGET_FILES=(
  "packages/shared_layers/lib/src/shared_presentation_layer/pages/splash_page.dart"
  "packages/shared_widgets/lib/src/footers/footer_guard_while_loading.dart"
  "packages/shared_widgets/lib/src/footers/inherited_footer_guard.dart"
  "packages/shared_widgets/lib/src/loaders/loader.dart"
  "packages/shared_widgets/lib/src/buttons/filled_button.dart"
  "packages/shared_widgets/lib/src/buttons/submit_button.dart"
  "packages/shared_widgets/lib/src/buttons/text_button.dart"
  "packages/shared_widgets/lib/src/text_widgets/text_widget.dart"
  "packages/shared_core_modules/lib/src/form_fields/form_field_factory.dart"
  "packages/shared_core_modules/lib/src/form_fields/widgets/app_form_field.dart"
  "packages/shared_core_modules/lib/src/form_fields/widgets/password_visibility_icon.dart"
  "packages/shared_widgets/lib/src/bars/app_bar.dart"
  "packages/shared_widgets/lib/src/text_widgets/key_value_text_widget.dart"
)

# --- BUCKET 3: SM+INIT (per track & app) -------------------------------------
# SCSM Track — BLoC app
SCSM_SM_CB_FILES=(
  "apps/app_on_cubit/lib/features/auth/sign_in/cubit/form_fields_cubit.dart"
  "apps/app_on_cubit/lib/features/auth/sign_in/cubit/sign_in_cubit.dart"
  "apps/app_on_cubit/lib/features/auth/sign_up/cubit/form_fields_cubit.dart"
  "apps/app_on_cubit/lib/features/auth/sign_up/cubit/sign_up_cubit.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/change_password/cubit/change_password_cubit.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/change_password/cubit/form_fields_cubit.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/reset_password/cubits/form_fields_cubit.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/reset_password/cubits/reset_password_cubit.dart"
)
SCSM_INIT_CB_FILES=(
  "apps/app_on_cubit/lib/app_bootstrap/di_container/global_di_container.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/di_container_init.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/modules/password_module.dart"
)

# SCSM Track — Riverpod app
SCSM_SM_RP_FILES=(
  "apps/app_on_riverpod/lib/features/auth/sign_in/providers/input_form_fields_provider.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_in/providers/sign_in__provider.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_up/providers/input_form_fields_provider.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_up/providers/sign_up__provider.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/providers/change_password__provider.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/providers/input_fields_provider.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/providers/input_fields_provider.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/providers/reset_password__provider.dart"
)
SCSM_INIT_RP_FILES=(
  "apps/app_on_riverpod/lib/app_bootstrap/di_config_sync.dart"
  "packages/adapters_for_riverpod/lib/src/features/auth/data_layer_providers/data_layer_providers.dart"
  "packages/adapters_for_riverpod/lib/src/features/auth/domain_layer_providers/use_cases_providers.dart"
  "packages/adapters_for_riverpod/lib/src/features/password_changing_or_reset/data_layer_providers/data_layer_providers.dart"
  "packages/adapters_for_riverpod/lib/src/features/password_changing_or_reset/domain_layer_providers/use_cases_provider.dart"
)

# AVLSM Track — BLoC app
AVLSM_SM_CB_FILES=(
  "apps/app_on_cubit/lib/features/auth/sign_out/sign_out_cubit/sign_out_cubit.dart"
  "apps/app_on_cubit/lib/features/email_verification/email_verification_cubit/email_verification_cubit.dart"
  "apps/app_on_cubit/lib/features/profile/cubit/profile_page_cubit.dart"
)
AVLSM_INIT_CB_FILES=(
  "apps/app_on_cubit/lib/app_bootstrap/di_container/global_di_container.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/di_container_init.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/modules/email_verification.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/modules/profile_module.dart"
  "apps/app_on_cubit/lib/app_bootstrap/di_container/modules/warmup_module.dart"
)

# AVLSM Track — Riverpod app
AVLSM_SM_RP_FILES=(
  "apps/app_on_riverpod/lib/features/auth/sign_out/sign_out_provider.dart"
  "apps/app_on_riverpod/lib/features/email_verification/provider/email_verification_provider.dart"
  "apps/app_on_riverpod/lib/features/profile/providers/profile_page_provider.dart"
)
AVLSM_INIT_RP_FILES=(
  "apps/app_on_riverpod/lib/app_bootstrap/di_config_sync.dart"
  "packages/adapters_for_riverpod/lib/src/features/email_verification/data_layer_providers/data_layer_providers.dart"
  "packages/adapters_for_riverpod/lib/src/features/email_verification/domain_layer_providers/use_case_provider.dart"
  "packages/adapters_for_riverpod/lib/src/features/profile/data_layers_providers/data_layer_providers.dart"
  "packages/adapters_for_riverpod/lib/src/features/profile/domain_layer_providers/use_case_provider.dart"
)

# --- BUCKET 4: State Models --------------------------------------------------
# SCSM Track
SCSM_FORM_STATES=(
  "packages/shared_core_modules/lib/src/form_fields/shared_form_fields_states/sign_in.dart"
  "packages/shared_core_modules/lib/src/form_fields/shared_form_fields_states/sign_up.dart"
  "packages/shared_core_modules/lib/src/form_fields/shared_form_fields_states/reset_password.dart"
  "packages/shared_core_modules/lib/src/form_fields/shared_form_fields_states/change_password.dart"
)
SCSM_SUBMISSION_STATE="packages/shared_layers/lib/src/shared_presentation_layer/state_models/submission_state.dart"

# AVLSM Track
AVLSM_BASELINE_MODEL_CANDIDATES=(
  "packages/adapters_for_bloc/lib/src/presentation_shared/async_value_state_model/async_value_for_bloc.dart"
)

AVLSM_SHARED_MODEL="packages/adapters_for_bloc/lib/src/presentation_shared/async_value_state_model/async_value_for_bloc.dart"
AVLSM_SHARED_BASE_CUBIT="packages/adapters_for_bloc/lib/src/presentation_shared/async_value_state_model/cubits/async_state_base_cubit.dart"
AVLSM_SHARED_INTROSPECTION_BLOC="packages/adapters_for_bloc/lib/src/presentation_shared/async_value_state_model/async_state_introspection_bloc.dart"
AVLSM_SHARED_INTROSPECTION_RP="packages/adapters_for_riverpod/lib/src/shared_presentation/async_state_model/async_state_introspection.dart"

# --- BUCKET 5: Overhead ------------------------------------------------------
# AVLSM Track (one-time, round-trip)
AVLSM_OH_FILES=(
  "$AVLSM_SHARED_MODEL"
  "$AVLSM_SHARED_BASE_CUBIT"
  "$AVLSM_SHARED_INTROSPECTION_BLOC"
  "$AVLSM_SHARED_INTROSPECTION_RP"
  "packages/adapters_for_bloc/lib/src/presentation_shared/side_effects_listeners/adapter_for_async_value_flow.dart"
  "packages/adapters_for_riverpod/lib/src/shared_presentation/side_effects_listeners/adapter_for_async_value_flow.dart"
  "packages/adapters_for_bloc/lib/src/presentation_shared/general_shared_widgets/adapter_for_footer_guard.dart"
  "packages/adapters_for_bloc/lib/src/presentation_shared/general_shared_widgets/adapter_for_submit_button.dart"
  "packages/adapters_for_riverpod/lib/src/shared_presentation/widgets_shared/adapter_for_footer_guard.dart"
  "packages/adapters_for_riverpod/lib/src/shared_presentation/widgets_shared/adapter_for_submit_button.dart"
)

# SCSM Track (per-SM, Lazy Parity)
SCSM_OH_CB_FILES=(
  "packages/adapters_for_bloc/lib/src/presentation_shared/side_effects_listeners/adapter_for_submission_flow.dart"
  "packages/adapters_for_bloc/lib/src/presentation_shared/general_shared_widgets/adapter_for_footer_guard.dart"
  "packages/adapters_for_bloc/lib/src/presentation_shared/general_shared_widgets/adapter_for_submit_button.dart"
)
SCSM_OH_RP_FILES=(
  "packages/adapters_for_riverpod/lib/src/shared_presentation/side_effects_listeners/adapter_for_submission_flow.dart"
  "packages/adapters_for_riverpod/lib/src/shared_presentation/widgets_shared/adapter_for_footer_guard.dart"
  "packages/adapters_for_riverpod/lib/src/shared_presentation/widgets_shared/adapter_for_submit_button.dart"
)

# --- BUCKET 6: Presentation --------------------------------------------------
# SCSM Track — BLoC app
SCSM_PRESENTATION_CB_FILES=(
  "apps/app_on_cubit/lib/features/auth/sign_in/sign_in__page.dart"
  "apps/app_on_cubit/lib/features/auth/sign_in/widgets_for_sign_in_page.dart"
  "apps/app_on_cubit/lib/features/auth/sign_up/sign_up__page.dart"
  "apps/app_on_cubit/lib/features/auth/sign_up/sign_up_input_fields.dart"
  "apps/app_on_cubit/lib/features/auth/sign_up/widgets_for_sign_up_page.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/change_password/change_password_page.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/change_password/widgets_for_change_password.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/reset_password/reset_password__page.dart"
  "apps/app_on_cubit/lib/features/password_changing_or_reset/reset_password/widgets_for_reset_password_page.dart"
  "packages/shared_layers/lib/src/shared_presentation_layer/side_effects_listeneres/submission_side_effects_config.dart"
)

# SCSM Track — Riverpod app
SCSM_PRESENTATION_RP_FILES=(
  "apps/app_on_riverpod/lib/features/auth/sign_in/sign_in__page.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_in/widgets_for_sign_in_page.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_up/sign_up__page.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_up/sign_up_input_fields.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_up/widgets_for_sign_up_page.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/change_password_page.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/change_password/widgets_for_change_password.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/reset_password_page.dart"
  "apps/app_on_riverpod/lib/features/password_changing_or_reset/reset_password/widgets_for_reset_password_page.dart"
  "packages/shared_layers/lib/src/shared_presentation_layer/side_effects_listeneres/submission_side_effects_config.dart"
)

# AVLSM Track — BLoC app
AVLSM_PRESENTATION_CB_FILES=(
  "apps/app_on_cubit/lib/features/email_verification/email_verification_page.dart"
  "apps/app_on_cubit/lib/features/email_verification/widgets_for_email_verification_page.dart"
  "apps/app_on_cubit/lib/features/auth/sign_out/sign_out_widgets.dart"
  "apps/app_on_cubit/lib/features/profile/profile_page.dart"
  "apps/app_on_cubit/lib/features/profile/widgets_for_profile_page.dart"
)

# AVLSM Track — Riverpod app
AVLSM_PRESENTATION_RP_FILES=(
  "apps/app_on_riverpod/lib/features/email_verification/email_verification_page.dart"
  "apps/app_on_riverpod/lib/features/email_verification/widgets_for_email_verification_page.dart"
  "apps/app_on_riverpod/lib/features/auth/sign_out/sign_out_widgets.dart"
  "apps/app_on_riverpod/lib/features/profile/profile_page.dart"
  "apps/app_on_riverpod/lib/features/profile/widgets_for_profile_page.dart"
)

# =============================================================================
# COMPUTE LOCs
# =============================================================================

# --- BUCKET 2: Reused Core ---------------------------------------------------
SCSM_CORE=$(sum_files "${SCSM_CORE_FILES[@]}")
AVLSM_CORE=$(sum_files "${AVLSM_CORE_FILES[@]}")
SHARED_WIDGETS=$(sum_files "${SHARED_WIDGET_FILES[@]}")

# --- BUCKET 3: SM+INIT -------------------------------------------------------
SCSM_SM_CB=$(sum_files "${SCSM_SM_CB_FILES[@]}")
SCSM_INIT_CB=$(sum_files "${SCSM_INIT_CB_FILES[@]}")
SCSM_SM_RP=$(sum_files "${SCSM_SM_RP_FILES[@]}")
SCSM_INIT_RP=$(sum_files "${SCSM_INIT_RP_FILES[@]}")

AVLSM_SM_CB=$(sum_files "${AVLSM_SM_CB_FILES[@]}")
AVLSM_INIT_CB=$(sum_files "${AVLSM_INIT_CB_FILES[@]}")
AVLSM_SM_RP=$(sum_files "${AVLSM_SM_RP_FILES[@]}")
AVLSM_INIT_RP=$(sum_files "${AVLSM_INIT_RP_FILES[@]}")

# --- BUCKET 4: State Models --------------------------------------------------
SCSM_FORM_STATES_LOC=$(sum_files "${SCSM_FORM_STATES[@]}")
SCSM_SUBMISSION_STATE_LOC=$(count_file_code "$SCSM_SUBMISSION_STATE")
SCSM_MODELS_BASELINE_LOC=$(( SCSM_FORM_STATES_LOC + SCSM_SUBMISSION_STATE_LOC ))
SCSM_MODELS_SHARED_LOC=$(( SCSM_FORM_STATES_LOC + SCSM_SUBMISSION_STATE_LOC ))

AVLSM_MODEL_SINGLE_LOC=$(sum_files "${AVLSM_BASELINE_MODEL_CANDIDATES[@]}")
AVLSM_MODELS_BASELINE_LOC="$AVLSM_MODEL_SINGLE_LOC"
AVLSM_MODELS_SHARED_LOC=$(( $(count_file_code "$AVLSM_SHARED_BASE_CUBIT") + $(count_file_code "$AVLSM_SHARED_INTROSPECTION_BLOC") + $(count_file_code "$AVLSM_SHARED_INTROSPECTION_RP") ))

# --- BUCKET 5: Overhead ------------------------------------------------------
AVLSM_OH_ROUNDTRIP=$(sum_files "${AVLSM_OH_FILES[@]}")

SCSM_OH_CB=$(sum_files "${SCSM_OH_CB_FILES[@]}")
SCSM_OH_RP=$(sum_files "${SCSM_OH_RP_FILES[@]}")

# --- BUCKET 6: Presentation --------------------------------------------------
SCSM_PRESENTATION_CB=$(sum_files "${SCSM_PRESENTATION_CB_FILES[@]}")
SCSM_PRESENTATION_RP=$(sum_files "${SCSM_PRESENTATION_RP_FILES[@]}")
AVLSM_PRESENTATION_CB=$(sum_files "${AVLSM_PRESENTATION_CB_FILES[@]}")
AVLSM_PRESENTATION_RP=$(sum_files "${AVLSM_PRESENTATION_RP_FILES[@]}")

# =============================================================================
# BASELINE ROUND-TRIP (Clean Architecture, no symmetry)
# =============================================================================
BASE_SCSM_RP_TO_CB=$(( SCSM_PRESENTATION_CB + SCSM_SM_CB + SCSM_INIT_CB + SCSM_MODELS_BASELINE_LOC ))
BASE_SCSM_CB_TO_RP=$(( SCSM_PRESENTATION_RP + SCSM_SM_RP + SCSM_INIT_RP + SCSM_MODELS_BASELINE_LOC ))
ROUND_TRIP_BASE_SCSM=$(( BASE_SCSM_RP_TO_CB + BASE_SCSM_CB_TO_RP ))

BASE_AVLSM_RP_TO_CB=$(( AVLSM_PRESENTATION_CB + AVLSM_SM_CB + AVLSM_INIT_CB + AVLSM_MODELS_BASELINE_LOC ))
BASE_AVLSM_CB_TO_RP=$(( AVLSM_PRESENTATION_RP + AVLSM_SM_RP + AVLSM_INIT_RP + AVLSM_MODELS_BASELINE_LOC ))
ROUND_TRIP_BASE_AVLSM=$(( BASE_AVLSM_RP_TO_CB + BASE_AVLSM_CB_TO_RP ))

# =============================================================================
# SYMMETRIC ROUND-TRIP (CORRECTED for AVLSM)
# =============================================================================
# AVLSM: one-time OH distributed across both legs
AVLSM_OH_AVG=$(half_num "$AVLSM_OH_ROUNDTRIP")
AVLSM_SM_TOTAL_CB=$(( AVLSM_SM_CB + AVLSM_INIT_CB ))
AVLSM_SM_TOTAL_RP=$(( AVLSM_SM_RP + AVLSM_INIT_RP ))

# Per-leg costs WITH averaged overhead included
AVLSM_SM_RP_TO_CB=$(( AVLSM_SM_TOTAL_CB + AVLSM_OH_AVG ))
AVLSM_SM_CB_TO_RP=$(( AVLSM_SM_TOTAL_RP + AVLSM_OH_AVG ))
ROUND_TRIP_AVLSM=$(( AVLSM_SM_RP_TO_CB + AVLSM_SM_CB_TO_RP ))

# SCSM: per-SM OH (Lazy Parity)
SCSM_SM_RP_TO_CB=$(( SCSM_SM_CB + SCSM_INIT_CB + SCSM_OH_CB ))
SCSM_SM_CB_TO_RP=$(( SCSM_SM_RP + SCSM_INIT_RP + SCSM_OH_RP ))
ROUND_TRIP_SCSM=$(( SCSM_SM_RP_TO_CB + SCSM_SM_CB_TO_RP ))

# =============================================================================
# FEATURE TOTALS (для %Track)
# =============================================================================
SCSM_PRESENTATION_AVG=$(( (SCSM_PRESENTATION_CB + SCSM_PRESENTATION_RP) / 2 ))
AVLSM_PRESENTATION_AVG=$(( (AVLSM_PRESENTATION_CB + AVLSM_PRESENTATION_RP) / 2 ))

SCSM_FEATURE_TOTAL=$(( SCSM_CORE + SCSM_PRESENTATION_AVG + SHARED_WIDGETS + SCSM_MODELS_SHARED_LOC ))
AVLSM_FEATURE_TOTAL=$(( AVLSM_CORE + AVLSM_PRESENTATION_AVG + SHARED_WIDGETS + AVLSM_MODELS_SHARED_LOC ))

# Track metadata
SCSM_NUM_FEATURES=4
AVLSM_NUM_FEATURES=2

# =============================================================================
# AVERAGED METRICS (per migration leg = RoundTrip/2)
# =============================================================================
AVG_BASE_SCSM=$(half_num "$ROUND_TRIP_BASE_SCSM")
AVG_SYM_SCSM=$(half_num "$ROUND_TRIP_SCSM")
AVG_SAV_SCSM=$(( (ROUND_TRIP_BASE_SCSM - ROUND_TRIP_SCSM) / 2 ))

AVG_BASE_AVLSM=$(half_num "$ROUND_TRIP_BASE_AVLSM")
AVG_SYM_AVLSM=$(half_num "$ROUND_TRIP_AVLSM")
AVG_SAV_AVLSM=$(( (ROUND_TRIP_BASE_AVLSM - ROUND_TRIP_AVLSM) / 2 ))

SCSM_RATIO_BASE=$(pct "$AVG_BASE_SCSM" "$SCSM_FEATURE_TOTAL")
SCSM_RATIO_SYM=$(pct "$AVG_SYM_SCSM" "$SCSM_FEATURE_TOTAL")

AVLSM_RATIO_BASE=$(pct "$AVG_BASE_AVLSM" "$AVLSM_FEATURE_TOTAL")
AVLSM_RATIO_SYM=$(pct "$AVG_SYM_AVLSM" "$AVLSM_FEATURE_TOTAL")

# =============================================================================
# OVERHEAD METRICS (first adoption, averaged)
# =============================================================================
SCSM_OH_TOTAL=$(( SCSM_OH_CB + SCSM_OH_RP ))
SCSM_OH_AVG=$(half_num "$SCSM_OH_TOTAL")

# Per-feature savings (for amortization)
SCSM_SAVINGS_PER_FEATURE=$(( AVG_SAV_SCSM / SCSM_NUM_FEATURES ))
AVLSM_SAVINGS_PER_FEATURE=$(( AVG_SAV_AVLSM / AVLSM_NUM_FEATURES ))

# =============================================================================
# AMORTIZATION CALCULATIONS
# =============================================================================

# Helper: calculate break-even percentage
calc_breakeven() {
  local oh=$1
  local savings=$2
  if [ "$savings" -eq 0 ]; then echo "N/A"; return; fi
  awk "BEGIN { printf \"%.1f%%\", ($oh*100.0)/$savings }"
}

# SCSM Track amortization
calc_scsm_amortization() {
  local n=$1
  local oh_per_feat savings_accum

  oh_per_feat=$(awk "BEGIN { printf \"%d\", ($SCSM_OH_AVG/$n)+0.5 }")
  savings_accum=$(( SCSM_SAVINGS_PER_FEATURE * n ))

  local breakeven
  breakeven=$(calc_breakeven "$oh_per_feat" "$SCSM_SAVINGS_PER_FEATURE")

  echo "$oh_per_feat|$breakeven|$savings_accum"
}

# AVLSM Track amortization
calc_avlsm_amortization() {
  local n=$1
  local oh_per_feat savings_accum

  oh_per_feat=$(awk "BEGIN { printf \"%d\", ($AVLSM_OH_AVG/$n)+0.5 }")
  savings_accum=$(( AVLSM_SAVINGS_PER_FEATURE * n ))

  local breakeven
  breakeven=$(calc_breakeven "$oh_per_feat" "$AVLSM_SAVINGS_PER_FEATURE")

  echo "$oh_per_feat|$breakeven|$savings_accum"
}

# =============================================================================
# REPORTS
# =============================================================================

sec "SCSM Track (Shared Custom State Models) — Average Migration Cost (RoundTrip/2)"
echo "Features: Sign-In, Sign-Up, Change Password, Reset Password (N=4)"
echo
hdr5
row5 "Baseline (Clean)" "$BASE_SCSM_RP_TO_CB" "$BASE_SCSM_CB_TO_RP" "$AVG_BASE_SCSM" "$SCSM_RATIO_BASE"
row5 "Symmetric" "$SCSM_SM_RP_TO_CB" "$SCSM_SM_CB_TO_RP" "$AVG_SYM_SCSM" "$SCSM_RATIO_SYM"
echo
hdr_sav
row_sav "SAVINGS (per migration)" "$AVG_SAV_SCSM" "$(pct "$AVG_SAV_SCSM" "$SCSM_FEATURE_TOTAL")"
echo
row_sav "Overhead (1st feature)" "$SCSM_OH_AVG" "$(pct "$SCSM_OH_AVG" "$SCSM_FEATURE_TOTAL")"
row_sav "Savings per feature" "$SCSM_SAVINGS_PER_FEATURE" "$(pct "$SCSM_SAVINGS_PER_FEATURE" "$SCSM_FEATURE_TOTAL")"

sec "AVLSM Track (AsyncValue-Like State Models) — Average Migration Cost (RoundTrip/2)"
echo "Features: Profile, Email Verification (N=2)"
echo
hdr5
row5 "Baseline (Clean)" "$BASE_AVLSM_RP_TO_CB" "$BASE_AVLSM_CB_TO_RP" "$AVG_BASE_AVLSM" "$AVLSM_RATIO_BASE"
row5 "Symmetric" "$AVLSM_SM_RP_TO_CB" "$AVLSM_SM_CB_TO_RP" "$AVG_SYM_AVLSM" "$AVLSM_RATIO_SYM"
echo
hdr_sav
row_sav "SAVINGS (per migration)" "$AVG_SAV_AVLSM" "$(pct "$AVG_SAV_AVLSM" "$AVLSM_FEATURE_TOTAL")"
echo
row_sav "Overhead (1st feature)" "$AVLSM_OH_AVG" "$(pct "$AVLSM_OH_AVG" "$AVLSM_FEATURE_TOTAL")"
row_sav "Savings per feature" "$AVLSM_SAVINGS_PER_FEATURE" "$(pct "$AVLSM_SAVINGS_PER_FEATURE" "$AVLSM_FEATURE_TOTAL")"

sec "Summary: Overhead per track (first adoption)"
hdr_over
row_over "SCSM Track (Custom State Models)" "$SCSM_OH_AVG" "$(pct "$SCSM_OH_AVG" "$SCSM_FEATURE_TOTAL")"
row_over "AVLSM Track (AsyncValue-Like Models)" "$AVLSM_OH_AVG" "$(pct "$AVLSM_OH_AVG" "$AVLSM_FEATURE_TOTAL")"

sec "SCSM Track: Amortization Over N Features"
echo "Overhead amortizes as features reuse existing adapters."
echo "Break-Even R* = OH_per_feature / Savings_per_feature"
echo
hdr_amort

for n in 1 2 3 4 5 10 15 20; do
  result=$(calc_scsm_amortization $n)
  IFS='|' read -r oh be sav <<< "$result"
  row_amort "$n" "$(pct "$oh" "$SCSM_FEATURE_TOTAL")" "$be" "$sav LOC"
done

sec "AVLSM Track: Amortization Over N Features"
echo "Overhead amortizes as features reuse existing adapters."
echo "Break-Even R* = OH_per_feature / Savings_per_feature"
echo
hdr_amort

for n in 1 2 3 4 5 10 15 20 25 50 100; do
  result=$(calc_avlsm_amortization $n)
  IFS='|' read -r oh be sav <<< "$result"
  row_amort "$n" "$(pct "$oh" "$AVLSM_FEATURE_TOTAL")" "$be" "$sav LOC"
done

echo
sec "Bucket Breakdown for Validation"
echo "=== SCSM Track ==="
echo "Core (Domain+Data):                 $SCSM_CORE LOC"
echo "Presentation CB:                    $SCSM_PRESENTATION_CB LOC"
echo "Presentation RP:                    $SCSM_PRESENTATION_RP LOC"
echo "SM+INIT CB:                         $(( SCSM_SM_CB + SCSM_INIT_CB )) LOC"
echo "SM+INIT RP:                         $(( SCSM_SM_RP + SCSM_INIT_RP )) LOC"
echo "State Models (shared):              $SCSM_MODELS_SHARED_LOC LOC"
echo "State Models (baseline):            $SCSM_MODELS_BASELINE_LOC LOC"
echo "Overhead CB:                        $SCSM_OH_CB LOC"
echo "Overhead RP:                        $SCSM_OH_RP LOC"
echo "Overhead (averaged):                $SCSM_OH_AVG LOC"
echo "Shared Widgets:                     $SHARED_WIDGETS LOC"
echo "FEATURE TOTAL (for %):              $SCSM_FEATURE_TOTAL LOC"
echo "Number of features:                 $SCSM_NUM_FEATURES"
echo "Savings per feature:                $SCSM_SAVINGS_PER_FEATURE LOC"
echo
echo "=== AVLSM Track ==="
echo "Core (Domain+Data):                 $AVLSM_CORE LOC"
echo "Presentation CB:                    $AVLSM_PRESENTATION_CB LOC"
echo "Presentation RP:                    $AVLSM_PRESENTATION_RP LOC"
echo "SM+INIT CB (raw):                   $AVLSM_SM_TOTAL_CB LOC"
echo "SM+INIT RP (raw):                   $AVLSM_SM_TOTAL_RP LOC"
echo "State Models (shared):              $AVLSM_MODELS_SHARED_LOC LOC"
echo "State Models (baseline):            $AVLSM_MODELS_BASELINE_LOC LOC"
echo "Overhead (one-time, round-trip):    $AVLSM_OH_ROUNDTRIP LOC"
echo "Overhead (averaged):                $AVLSM_OH_AVG LOC"
echo "Shared Widgets:                     $SHARED_WIDGETS LOC"
echo "FEATURE TOTAL (for %):              $AVLSM_FEATURE_TOTAL LOC"
echo "Number of features:                 $AVLSM_NUM_FEATURES"
echo "Savings per feature:                $AVLSM_SAVINGS_PER_FEATURE LOC"

echo; hr; echo "Done."; hr
