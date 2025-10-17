#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# State-Symmetric LOC Cost Report (Average per migration = RoundTrip/2)
# - Skips generated (*.g.dart, *.freezed.dart, *.mocks.dart, *.gr.dart)
# - Skips comments
# - Aggregates by track: CSM (Custom State Models) and AVSM (AsyncValue)
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
row2(){ printf "| %-34s | %10s |\n" "$1" "$2"; }
hdr2(){ printf "| %-34s | %10s |\n" "Bucket" "LOC"; printf "|-%-34s-|-%10s-|\n" "----------------------------------" "----------"; }

# 5-column table: RP→CB | CB→RP | RoundTrip/2 | %Track
row5(){ printf "| %-22s | %10s | %10s | %12s | %8s |\n" "$1" "$2" "$3" "$4" "$5"; }
hdr5(){
  printf "| %-22s | %10s | %10s | %12s | %8s |\n" "Bucket" "RP→CB" "CB→RP" "RoundTrip/2" "%Track";
  printf "|-%-22s-|-%10s-|-%10s-|-%12s-|-%8s-|\n" "----------------------" "----------" "----------" "------------" "--------";
}

# Savings mini-table (LOC + % of track)
row_sav(){ printf "| %-34s | %10s | %8s |\n" "$1" "$2" "$3"; }
hdr_sav(){
  printf "| %-34s | %10s | %8s |\n" "Bucket" "LOC" "%Track";
  printf "|-%-34s-|-%10s-|-%8s-|\n" "----------------------------------" "----------" "--------";
}

# Overhead table (nice, explicit labels)
row_over(){ printf "| %-54s | %10s | %12s |\n" "$1" "$2" "$3"; }
hdr_over(){
  printf "| %-54s | %10s | %12s |\n" "Track (LOC & % of track codebase)" "LOC" "% of track";
  printf "|-%-54s-|-%10s-|-%12s-|\n" "------------------------------------------------------" "----------" "------------";
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

sum_dirs()  { local t=0; for p in "$@"; do [[ -n "${p:-}" ]] && t=$(( t + $(count_dir_code "$p") )); done; echo "$t"; }
sum_files() { local t=0; for f in "$@"; do [[ -n "${f:-}" ]] && t=$(( t + $(count_file_code "$f") )); done; echo "$t"; }

half_sum_files() { local s=$(sum_files "$@"); awk "BEGIN { printf \"%d\", ($s/2)+0.5 }"; }

avg_files() {
  # Average LOC across existing files (ceil). If none exist => 0.
  local total=0 count=0 loc
  for f in "$@"; do
    loc=$(count_file_code "$f")
    if [[ "$loc" -gt 0 ]]; then total=$((total+loc)); count=$((count+1)); fi
  done
  if [[ "$count" -eq 0 ]]; then echo 0; else awk "BEGIN { printf \"%d\", ($total/$count)+0.999 }"; fi
}

# Integer half (rounded)
half_num() { awk "BEGIN { printf \"%d\", ($1/2)+0.5 }"; }

# ---- Fast SM-lines counter (no file listing, uses ripgrep with globs) -------
# Counts non-comment code lines across files whose PATH matches provided scopes
# and NAME matches *cubit*|*bloc*|*notifier*|*provider*.
count_sm_code_scoped() {
  local dir="$1"; shift
  local scopes=("$@")
  [[ -d "$dir" ]] || { echo 0; return; }

  local args=( "${RG_EXCLUDES[@]}" -t dart -n '^\s*\S' "$dir" )
  # include only scoped subpaths
  for s in "${scopes[@]}"; do args+=( --glob "$s" ); done
  # include only SM file names
  args+=( --glob '**/*cubit*.dart' --glob '**/*bloc*.dart' --glob '**/*notifier*.dart' --glob '**/*provider*.dart' )
  # exclude comment lines
  rg "${args[@]}" \
    | cut -d: -f3 \
    | grep -Ev '^\s*//|^\s*/\*|^\s*\*|^\s*\*/' \
    | wc -l | tr -d ' ' || echo 0
}

# =============================================================================
# CONFIG
# =============================================================================

# --- Feature roots (domain+data) ---------------------------------------------
AUTH_ROOT="packages/features/lib/src/auth"
PROFILE_ROOT="packages/features/lib/src/profile"
EMAILV_ROOT="packages/features/lib/src/email_verification"  # goes into AVSM track

# --- CSM track state models (must be counted in Baseline) --------------------
CSM_MODELS_DIR="packages/core/lib/src/base_modules/form_fields/shared_form_fields_states"
CSM_SUBMISSION_STATE_FILE="packages/core/lib/src/shared_presentation_layer/shared_states/submission_state.dart"

# --- AVSM track "baseline model" candidates (take avg LOC for baseline) ------
AVSM_BASELINE_MODEL_CANDIDATES=(
  "packages/core/lib/src/shared_presentation_layer/async_state/async_state_view.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_state_view_for_riverpod.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_view_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart"
)

# --- App presentation roots (entire lib/features/* per app) -----------------
APP_BLOC_FEATURES_DIR="apps/app_on_bloc/lib/features"
APP_RP_FEATURES_DIR="apps/app_on_riverpod/lib/features"

# --- Scopes for SM_files_target ---------------------------------------------
CSM_SCOPES=('**/auth/**' '**/password**/**')
AVSM_SCOPES=('**/profile/**' '**/email_verification/**' '**/sign_out/**')

# --- Shared widgets (only to FEATURE TOTALS) ---------------------------------
SHARED_WIDGET_FILES=(
  "packages/core/lib/src/base_modules/localization/module_widgets/text_widget.dart"
  "packages/core/lib/src/base_modules/form_fields/form_field_factory.dart"
  "packages/core/lib/src/base_modules/form_fields/widgets/app_form_field.dart"
  "packages/core/lib/src/base_modules/form_fields/widgets/password_visibility_icon.dart"
  "packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/filled_button.dart"
  "packages/core/lib/src/shared_presentation_layer/widgets_shared/buttons/text_button.dart"
  "packages/core/lib/src/shared_presentation_layer/widgets_shared/app_bar.dart"
  "packages/core/lib/src/shared_presentation_layer/widgets_shared/loader.dart"
)

# --- INIT (per-track; CB = exact files you provided) -------------------------
INIT_CB_CSM_FILES=(
  "apps/app_on_bloc/lib/app_bootstrap/di_container/modules/auth_module.dart"
  "apps/app_on_bloc/lib/app_bootstrap/di_container/modules/password_module.dart"
)
INIT_CB_AVSM_FILES=(
  "apps/app_on_bloc/lib/app_bootstrap/di_container/modules/email_verification.dart"
  "apps/app_on_bloc/lib/app_bootstrap/di_container/modules/profile_module.dart"
)

# Riverpod providers per-feature (RP legs)
RP_PROVIDERS_AUTH=(
  "packages/riverpod_adapter/lib/src/features/features_providers/auth/domain_layer_providers/use_cases_providers.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/auth/data_layer_providers/data_layer_providers.dart"
)
RP_PROVIDERS_PROFILE_EMAILV=(
  "packages/riverpod_adapter/lib/src/features/features_providers/profile/domain_layer_providers/use_case_provider.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/profile/data_layers_providers/data_layer_providers.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/email_verification/domain_layer_providers/use_case_provider.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/email_verification/data_layer_providers/data_layer_providers.dart"
)

# --- AVSM track OVERHEAD (one-time, round-trip) ------------------------------
AVSM_OH_FILES=(
  "packages/core/lib/src/shared_presentation_layer/async_state/async_state_view.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_view_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/async_multi_errors_listener.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/async_multi_errors_listener.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/cubits/auth_cubit.dart"
)

# Shared button/footer → ½ в AVSM і ½ в CSM
HALF_SHARED_BLOC=(
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/form_submit_button.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/page_footer_guard.dart"
)
HALF_SHARED_RP=(
  "packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/form_submit_button.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/page_footer_guard.dart"
)

# --- CSM track OVERHEAD (per SM, Lazy Parity) --------------------------------
CSM_OH_CB_FILES=( # seam for CB (RP→CB leg)
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/side_effects_for_submission_state.dart"
)
CSM_OH_RP_FILES=( # seam for RP (CB→RP leg)
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/side_effect_listener_for_submission_state__x_on_ref.dart"
)

# =============================================================================
# CORE LOC (domain+data)
# =============================================================================
auth_domain=$(count_dir_code "$AUTH_ROOT/domain")
auth_data=$(count_dir_code "$AUTH_ROOT/data")
emailv_domain=$(count_dir_code "$EMAILV_ROOT/domain")
emailv_data=$(count_dir_code "$EMAILV_ROOT/data")
profile_domain=$(count_dir_code "$PROFILE_ROOT/domain")
profile_data=$(count_dir_code "$PROFILE_ROOT/data")

F_CSM_CORE=$((auth_domain + auth_data))                                # Custom track core
F_AVSM_CORE=$((profile_domain + profile_data + emailv_domain + emailv_data)) # AVSM track core

# =============================================================================
# APP PRESENTATION totals (entire lib/features per app) — чистий presentation
# =============================================================================
CSM_PRESENTATION_CB=$(count_dir_code "$APP_BLOC_FEATURES_DIR")
CSM_PRESENTATION_RP=$(count_dir_code "$APP_RP_FEATURES_DIR")
AVSM_PRESENTATION_CB=$CSM_PRESENTATION_CB
AVSM_PRESENTATION_RP=$CSM_PRESENTATION_RP

# =============================================================================
# INIT costs
# =============================================================================
INIT_CB_CSM=$(sum_files "${INIT_CB_CSM_FILES[@]}")
INIT_CB_AVSM=$(sum_files "${INIT_CB_AVSM_FILES[@]}")
INIT_RP_CSM=$(sum_files "${RP_PROVIDERS_AUTH[@]}")
INIT_RP_AVSM=$(sum_files "${RP_PROVIDERS_PROFILE_EMAILV[@]}")

# =============================================================================
# SM_files_target (per track & per app)
# =============================================================================
CSM_SM_CB=$(count_sm_code_scoped "$APP_BLOC_FEATURES_DIR" "${CSM_SCOPES[@]}")
CSM_SM_RP=$(count_sm_code_scoped "$APP_RP_FEATURES_DIR"   "${CSM_SCOPES[@]}")
AVSM_SM_CB=$(count_sm_code_scoped "$APP_BLOC_FEATURES_DIR" "${AVSM_SCOPES[@]}")
AVSM_SM_RP=$(count_sm_code_scoped "$APP_RP_FEATURES_DIR"   "${AVSM_SCOPES[@]}")

# =============================================================================
# BASELINE ROUND-TRIP (Clean, no symmetry)
# BASE_MIGRATION = P_full_under_target_SM + INIT_target + (state models for track)
# - AVSM: середній LOC моделі (avg з кандидатів) до КОЖНОГО плеча.
# - CSM: всі state-моделі (forms + submission_state) до КОЖНОГО плеча.
# =============================================================================
CSM_MODELS_BASELINE_LOC=$(( $(count_dir_code "$CSM_MODELS_DIR") + $(count_file_code "$CSM_SUBMISSION_STATE_FILE") ))
AVSM_MODEL_AVG_LOC=$(avg_files "${AVSM_BASELINE_MODEL_CANDIDATES[@]}")

BASE_CSM_RP_TO_CB=$(( CSM_PRESENTATION_CB + INIT_CB_CSM + CSM_MODELS_BASELINE_LOC ))
BASE_CSM_CB_TO_RP=$(( CSM_PRESENTATION_RP + INIT_RP_CSM + CSM_MODELS_BASELINE_LOC ))
ROUND_TRIP_BASE_CSM=$(( BASE_CSM_RP_TO_CB + BASE_CSM_CB_TO_RP ))

BASE_AVSM_RP_TO_CB=$(( AVSM_PRESENTATION_CB + INIT_CB_AVSM + AVSM_MODEL_AVG_LOC ))
BASE_AVSM_CB_TO_RP=$(( AVSM_PRESENTATION_RP + INIT_RP_AVSM + AVSM_MODEL_AVG_LOC ))
ROUND_TRIP_BASE_AVSM=$(( BASE_AVSM_RP_TO_CB + BASE_AVSM_CB_TO_RP ))

# =============================================================================
# SYMMETRIC ROUND-TRIP — AVSM (one-time OH; each leg: SM+INIT)
# =============================================================================
AVSM_OH_CORE=$(sum_files "${AVSM_OH_FILES[@]}")
AVSM_HALF_BLOC=$(half_sum_files "${HALF_SHARED_BLOC[@]}")
AVSM_HALF_RP=$(half_sum_files   "${HALF_SHARED_RP[@]}")
AVSM_OH_ROUNDTRIP=$(( AVSM_OH_CORE + AVSM_HALF_BLOC + AVSM_HALF_RP ))

AVSM_SM_RP_TO_CB=$(( AVSM_SM_CB + INIT_CB_AVSM ))
AVSM_SM_CB_TO_RP=$(( AVSM_SM_RP + INIT_RP_AVSM ))
ROUND_TRIP_AVSM=$(( AVSM_OH_ROUNDTRIP + AVSM_SM_RP_TO_CB + AVSM_SM_CB_TO_RP ))

# =============================================================================
# SYMMETRIC ROUND-TRIP — CSM (per-SM OH with Lazy Parity; each leg: SM+INIT+OH_target)
# =============================================================================
CSM_OH_CB_CORE=$(sum_files "${CSM_OH_CB_FILES[@]}")
CSM_OH_RP_CORE=$(sum_files "${CSM_OH_RP_FILES[@]}")
CSM_HALF_BLOC=$(half_sum_files "${HALF_SHARED_BLOC[@]}")
CSM_HALF_RP=$(half_sum_files   "${HALF_SHARED_RP[@]}")
CSM_OH_CB=$(( CSM_OH_CB_CORE + CSM_HALF_BLOC )) # RP→CB
CSM_OH_RP=$(( CSM_OH_RP_CORE + CSM_HALF_RP ))   # CB→RP

CSM_SM_RP_TO_CB=$(( CSM_SM_CB + INIT_CB_CSM + CSM_OH_CB ))
CSM_SM_CB_TO_RP=$(( CSM_SM_RP + INIT_RP_CSM + CSM_OH_RP ))
ROUND_TRIP_CSM=$(( CSM_SM_RP_TO_CB + CSM_SM_CB_TO_RP ))

# =============================================================================
# FEATURE TOTALS (для %Track): ядро + презентації + віджети + моделі
# =============================================================================
shared_widgets_loc=$(sum_files "${SHARED_WIDGET_FILES[@]}")

CSM_FEATURE_TOTAL=$(( F_CSM_CORE + CSM_PRESENTATION_CB + CSM_PRESENTATION_RP + shared_widgets_loc + CSM_MODELS_BASELINE_LOC ))
AVSM_FEATURE_TOTAL=$(( F_AVSM_CORE + AVSM_PRESENTATION_CB + AVSM_PRESENTATION_RP + shared_widgets_loc + AVSM_MODEL_AVG_LOC ))

# =============================================================================
# AVERAGED METRICS (per migration leg = RoundTrip/2) + ratios
# =============================================================================
AVG_BASE_CSM=$(half_num "$ROUND_TRIP_BASE_CSM")
AVG_SYM_CSM=$(half_num "$ROUND_TRIP_CSM")
AVG_SAV_CSM=$(( (ROUND_TRIP_BASE_CSM - ROUND_TRIP_CSM) / 2 ))

AVG_BASE_AVSM=$(half_num "$ROUND_TRIP_BASE_AVSM")
AVG_SYM_AVSM=$(half_num "$ROUND_TRIP_AVSM")
AVG_SAV_AVSM=$(( (ROUND_TRIP_BASE_AVSM - ROUND_TRIP_AVSM) / 2 ))

CSM_RATIO_BASE=$(pct "$AVG_BASE_CSM" "$CSM_FEATURE_TOTAL")
CSM_RATIO_SYM=$(pct "$AVG_SYM_CSM"   "$CSM_FEATURE_TOTAL")

AVSM_RATIO_BASE=$(pct "$AVG_BASE_AVSM" "$AVSM_FEATURE_TOTAL")
AVSM_RATIO_SYM=$(pct "$AVG_SYM_AVSM"   "$AVSM_FEATURE_TOTAL")

# =============================================================================
# REPORTS
# =============================================================================

sec "CSM Track (Custom State Models) — Average Migration (RoundTrip/2)"
hdr5
row5 "Baseline (Clean)" "$BASE_CSM_RP_TO_CB" "$BASE_CSM_CB_TO_RP" "$AVG_BASE_CSM" "$CSM_RATIO_BASE"
row5 "Symmetric"        "$CSM_SM_RP_TO_CB"   "$CSM_SM_CB_TO_RP"   "$AVG_SYM_CSM"  "$CSM_RATIO_SYM"
echo
hdr_sav
row_sav "SAVINGS (averaged)" "$AVG_SAV_CSM" "$(pct "$AVG_SAV_CSM" "$CSM_FEATURE_TOTAL")"

sec "AVSM Track (AsyncValue + EmailV + SignOut) — Average Migration (RoundTrip/2)"
hdr5
row5 "Baseline (Clean)" "$BASE_AVSM_RP_TO_CB" "$BASE_AVSM_CB_TO_RP" "$AVG_BASE_AVSM" "$AVSM_RATIO_BASE"
row5 "Symmetric"        "$AVSM_SM_RP_TO_CB"   "$AVSM_SM_CB_TO_RP"   "$AVG_SYM_AVSM"  "$AVSM_RATIO_SYM"
echo
hdr_sav
row_sav "SAVINGS (averaged)" "$AVG_SAV_AVSM" "$(pct "$AVG_SAV_AVSM" "$AVSM_FEATURE_TOTAL")"

# Overhead per track (first adoption, context) — pretty & explicit
sec "Overhead per track (first adoption, context)"
CSM_OH_PAID=$(( CSM_OH_CB + CSM_OH_RP ))
AVSM_OH_PAID=$(( AVSM_OH_ROUNDTRIP ))
hdr_over
row_over "CSM Track (LOC & % of track codebase)"  "$CSM_OH_PAID" "$(pct "$CSM_OH_PAID" "$CSM_FEATURE_TOTAL")"
row_over "AVSM Track (LOC & % of track codebase)" "$AVSM_OH_PAID" "$(pct "$AVSM_OH_PAID" "$AVSM_FEATURE_TOTAL")"

echo; hr; echo "Done."; hr
