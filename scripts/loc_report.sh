#!/usr/bin/env bash
set -euo pipefail

# ===== Dependencies =====
command -v rg     >/dev/null 2>&1 || { echo "Please: brew install ripgrep"; exit 1; }
command -v tokei  >/dev/null 2>&1 || { echo "Please: brew install tokei";  exit 1; }

# ===== Excludes (no generated) =====
EXCLUDES=('!**/*.g.dart' '!**/*.freezed.dart' '!**/*.mocks.dart' '!**/*.gr.dart')
RG_EXCLUDES=(); for e in "${EXCLUDES[@]}"; do RG_EXCLUDES+=(--glob "$e"); done

hr()  { printf '%*s\n' "$(tput cols 2>/dev/null || echo 100)" '' | tr ' ' '='; }
sec() { echo; hr; echo "# $*"; hr; echo; }
row2(){ printf "| %-36s | %10s |\n" "$1" "$2"; }
hdr2(){ printf "| %-36s | %10s |\n" "Bucket" "LOC"; printf "|-%-36s-|-%10s-|\n" "------------------------------------" "----------"; }
trio(){ printf "| %-26s | %10s | %10s | %10s |\n" "$1" "$2" "$3" "$4"; }
hdr3(){ printf "| %-26s | %10s | %10s | %10s |\n" "Bucket" "BLoC" "Riverpod" "Total"; printf "|-%-26s-|-%10s-|-%10s-|-%10s-|\n" "--------------------------" "----------" "----------" "----------"; }
pct() {
  local num=${1:-0} den=${2:-0}
  if [ "$den" -eq 0 ]; then echo "0.0%"; return; fi
  printf "%.1f%%" "$(awk "BEGIN {print ($num*100.0)/$den}")"
}

# ===== Code counters (skip comments) =====
#  - drops // lines
#  - drops /**/, *, */ lines (approx; good enough for docs-style blocks)
count_dir_code() {
  local dir="$1"
  [[ -d "$dir" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -t dart -n '^\s*\S' "$dir" \
    | cut -d: -f1-3 \
    | awk -F: '{print $3}' \
    | grep -Ev '^\s*//|^\s*/\*|^\s*\*|^\s*\*/' \
    | wc -l | tr -d ' '
}

count_file_code() {
  local f="$1"
  [[ -f "$f" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -n '^\s*\S' "$f" \
    | cut -d: -f3 \
    | grep -Ev '^\s*//|^\s*/\*|^\s*\*|^\s*\*/' \
    | wc -l | tr -d ' '
}

sum_dirs() {
  local total=0
  for p in "$@"; do [[ -n "${p:-}" ]] && total=$(( total + $(count_dir_code "$p") )); done
  echo "$total"
}

sum_files() {
  local total=0
  for f in "$@"; do [[ -n "${f:-}" ]] && total=$(( total + $(count_file_code "$f") )); done
  echo "$total"
}

# ===== Feature roots (core: domain+data) =====
AUTH_ROOT="packages/features/lib/src/auth"
PROFILE_ROOT="packages/features/lib/src/profile"
EMAILV_ROOT="packages/features/lib/src/email_verification"   # counts into Profile-group

# >>> NEW: feature-owned shared bits that must count into features (NOT adapters)
AUTH_SHARED_FORM_STATES_DIR="packages/core/lib/src/base_modules/form_fields/shared_form_fields_states"
SHARED_SUBMISSION_STATE_FILE="packages/core/lib/src/shared_presentation_layer/shared_states/submission_state.dart"

# ===== App-level presentation (feature UIs, wrappers) =====
AUTH_APP_BLOC_DIRS=( "apps/app_on_bloc/lib/features_presentation/auth" )
AUTH_APP_RP_DIRS=(   "apps/app_on_riverpod/lib/features_presentation/auth" )

PROFILE_APP_BLOC_DIRS=( "apps/app_on_bloc/lib/features_presentation/profile" )
PROFILE_APP_RP_DIRS=(   "apps/app_on_riverpod/lib/features_presentation/profile" )

# ===== Overhead definition (facade-adapters only!) =====
# — BLoC Auth overhead (3 files): side-effects, footer-guard, submit-button
AUTH_BLOC_OVERHEAD_FILES=(
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/side_effects_for_submission_state.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/page_footer_guard.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/form_submit_button.dart"
)
# — Riverpod Auth overhead (3 files): side-effects, footer-guard, submit-button
AUTH_RP_OVERHEAD_FILES=(
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/side_effect_listener_for_submission_state__x_on_ref.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/page_footer_guard.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/form_submit_button.dart"
)

# — Providers needed to wire Auth on Riverpod (cost to add 2nd SM)
AUTH_RP_PROVIDERS_FILES=(
  "packages/riverpod_adapter/lib/src/features/features_providers/auth/domain_layer_providers/use_cases_providers.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/auth/data_layer_providers/data_layer_providers.dart"
)

# ===== Async/Profile overhead (shared facades for async parity) =====
PROFILE_BLOC_OVERHEAD_FILES=(
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/async_multi_errors_listener.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_view_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart"
)
PROFILE_RP_OVERHEAD_FILES=(
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/async_multi_errors_listener.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_state_view_for_riverpod.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_value_match_x.dart"
)

# — Providers needed to wire Profile (+ EmailV) on Riverpod
PROFILE_RP_PROVIDERS_FILES=(
  "packages/riverpod_adapter/lib/src/features/features_providers/profile/domain_layer_providers/use_case_provider.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/profile/data_layers_providers/data_layer_providers.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/email_verification/domain_layer_providers/use_case_provider.dart"
  "packages/riverpod_adapter/lib/src/features/features_providers/email_verification/data_layer_providers/data_layer_providers.dart"
)

# ===== CORE LOC (domain+data) =====
auth_domain=$(count_dir_code "$AUTH_ROOT/domain")
auth_data=$(count_dir_code "$AUTH_ROOT/data")
F_AUTH_CORE=$((auth_domain + auth_data))

# >>> NEW: count shared form-field states as part of AUTH core
auth_shared_form_states=$(count_dir_code "$AUTH_SHARED_FORM_STATES_DIR")
F_AUTH_CORE=$((F_AUTH_CORE + auth_shared_form_states))

emailv_domain=$(count_dir_code "$EMAILV_ROOT/domain")
emailv_data=$(count_dir_code "$EMAILV_ROOT/data")
F_EMAILV_CORE=$((emailv_domain + emailv_data))

profile_domain=$(count_dir_code "$PROFILE_ROOT/domain")
profile_data=$(count_dir_code "$PROFILE_ROOT/data")
F_PROFILE_CORE=$((profile_domain + profile_data))

F_PROFILE_PLUS_EMAILV_CORE=$((F_PROFILE_CORE + F_EMAILV_CORE))

# ===== APP PRESENTATION LOC =====
auth_bloc_presentation=$(sum_dirs "${AUTH_APP_BLOC_DIRS[@]}")
auth_rp_presentation=$(sum_dirs "${AUTH_APP_RP_DIRS[@]}")
profile_bloc_presentation=$(sum_dirs "${PROFILE_APP_BLOC_DIRS[@]}")
profile_rp_presentation=$(sum_dirs "${PROFILE_APP_RP_DIRS[@]}")

# >>> NEW: submission_state.dart is a feature-owned shared presentation state.
submission_state_loc=$(count_file_code "$SHARED_SUBMISSION_STATE_FILE")
# include it into both AUTH and PROFILE app-level presentation (for parity per app)
auth_bloc_presentation=$((auth_bloc_presentation + submission_state_loc))
auth_rp_presentation=$((auth_rp_presentation + submission_state_loc))
profile_bloc_presentation=$((profile_bloc_presentation + submission_state_loc))
profile_rp_presentation=$((profile_rp_presentation + submission_state_loc))

# ===== OVERHEAD (facade-adapters only) =====
auth_bloc_overhead=$(sum_files "${AUTH_BLOC_OVERHEAD_FILES[@]}")
auth_rp_overhead=$(sum_files "${AUTH_RP_OVERHEAD_FILES[@]}")

profile_bloc_overhead=$(sum_files "${PROFILE_BLOC_OVERHEAD_FILES[@]}")
profile_rp_overhead=$(sum_files "${PROFILE_RP_OVERHEAD_FILES[@]}")

# ===== PROVIDERS cost (Riverpod only) =====
auth_rp_providers=$(sum_files "${AUTH_RP_PROVIDERS_FILES[@]}")
profile_rp_providers=$(sum_files "${PROFILE_RP_PROVIDERS_FILES[@]}")

# ===== AGGREGATES =====
# Auth totals per app (one SM)
F_AUTH_BLOC_APP=$((F_AUTH_CORE + auth_bloc_presentation))
F_AUTH_RP_APP=$((F_AUTH_CORE + auth_rp_presentation))

# Profile(+EmailV) totals per app (one SM)
F_PROFILE_BLOC_APP=$((F_PROFILE_PLUS_EMAILV_CORE + profile_bloc_presentation))
F_PROFILE_RP_APP=$((F_PROFILE_PLUS_EMAILV_CORE + profile_rp_presentation))

# ===== Reports =====

sec "FEATURE: AUTH (Sign-In/Up) — core (domain+data) + app-level presentation (NO adapters)"
hdr3
trio "Core (domain+data)"         "$F_AUTH_CORE" "$F_AUTH_CORE" "$F_AUTH_CORE"
trio "App presentation (per app)" "$auth_bloc_presentation" "$auth_rp_presentation" $((auth_bloc_presentation+auth_rp_presentation))
trio "TOTAL per app (no adapters)" "$F_AUTH_BLOC_APP" "$F_AUTH_RP_APP" "-"
echo

sec "AUTH Overhead (thin facade-adapters ONLY)"
hdr3
trio "Side-effects/submit/footer" "$auth_bloc_overhead" "$auth_rp_overhead" $((auth_bloc_overhead+auth_rp_overhead))

echo
sec "COST to add the SECOND SM for AUTH (State-Symmetric vs Baseline)"
# If we ship BLoC first:
auth_add_rp_cost=$((auth_rp_overhead + auth_rp_providers))   # adapters + providers
auth_baseline_rp_cost=$((F_AUTH_RP_APP - F_AUTH_CORE))        # rewrite whole RP presentation without adapters
echo "Assume BLoC-first:"
hdr2
row2 "Add Riverpod (Adapters + Providers)" "$auth_add_rp_cost"
row2 "Baseline: rewrite RP presentation"   "$auth_baseline_rp_cost"
row2 "Savings vs baseline"                 $((auth_baseline_rp_cost - auth_add_rp_cost))
echo
# If we ship Riverpod first:
auth_add_bloc_cost=$((auth_bloc_overhead))                   # adapters only (no providers on BLoC)
auth_baseline_bloc_cost=$((F_AUTH_BLOC_APP - F_AUTH_CORE))   # rewrite whole BLoC presentation without adapters
echo "Assume Riverpod-first:"
hdr2
row2 "Add BLoC (Adapters only)"            "$auth_add_bloc_cost"
row2 "Baseline: rewrite BLoC presentation" "$auth_baseline_bloc_cost"
row2 "Savings vs baseline"                 $((auth_baseline_bloc_cost - auth_add_bloc_cost))

# ===== PROFILE (+ EmailVerification) =====
echo
sec "FEATURE: PROFILE (+ Email Verification) — core (domain+data) + app-level presentation (NO adapters)"
hdr3
trio "Core (domain+data)"         "$F_PROFILE_PLUS_EMAILV_CORE" "$F_PROFILE_PLUS_EMAILV_CORE" "$F_PROFILE_PLUS_EMAILV_CORE"
trio "App presentation (per app)" "$profile_bloc_presentation" "$profile_rp_presentation" $((profile_bloc_presentation+profile_rp_presentation))
trio "TOTAL per app (no adapters)" "$F_PROFILE_BLOC_APP" "$F_PROFILE_RP_APP" "-"
echo

sec "PROFILE Overhead (thin facade-adapters ONLY)"
hdr3
trio "Async facades + errors listener" "$profile_bloc_overhead" "$profile_rp_overhead" $((profile_bloc_overhead+profile_rp_overhead))
echo

sec "COST to add the SECOND SM for PROFILE (+ EmailV)"
# BLoC-first:
profile_add_rp_cost=$((profile_rp_overhead + profile_rp_providers))
profile_baseline_rp_cost=$((F_PROFILE_RP_APP - F_PROFILE_PLUS_EMAILV_CORE))
echo "Assume BLoC-first:"
hdr2
row2 "Add Riverpod (Adapters + Providers)" "$profile_add_rp_cost"
row2 "Baseline: rewrite RP presentation"   "$profile_baseline_rp_cost"
row2 "Savings vs baseline"                 $((profile_baseline_rp_cost - profile_add_rp_cost))
echo
# Riverpod-first:
profile_add_bloc_cost=$((profile_bloc_overhead))
profile_baseline_bloc_cost=$((F_PROFILE_BLOC_APP - F_PROFILE_PLUS_EMAILV_CORE))
echo "Assume Riverpod-first:"
hdr2
row2 "Add BLoC (Adapters only)"            "$profile_add_bloc_cost"
row2 "Baseline: rewrite BLoC presentation" "$profile_baseline_bloc_cost"
row2 "Savings vs baseline"                 $((profile_baseline_bloc_cost - profile_add_bloc_cost))

# ===== Sanity (optional: entire adapter packages, for context only) =====
echo
sec "SANITY CHECK: whole adapter packages (non-generated)"
tokei "packages/bloc_adapter/lib"     -e "**/*.g.dart" -e "**/*.freezed.dart" -e "**/*.mocks.dart" -e "**/*.gr.dart" || true
echo
tokei "packages/riverpod_adapter/lib" -e "**/*.g.dart" -e "**/*.freezed.dart" -e "**/*.mocks.dart" -e "**/*.gr.dart" || true

echo; hr; echo "Done."; hr
