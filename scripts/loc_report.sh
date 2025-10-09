#!/usr/bin/env bash
set -euo pipefail

# --- deps ---
command -v rg     >/dev/null 2>&1 || { echo "Please: brew install ripgrep"; exit 1; }
command -v tokei  >/dev/null 2>&1 || { echo "Please: brew install tokei";  exit 1; }

# --- excludes (no generated) ---
EXCLUDES=('!**/*.g.dart' '!**/*.freezed.dart' '!**/*.mocks.dart' '!**/*.gr.dart')
RG_EXCLUDES=(); for e in "${EXCLUDES[@]}"; do RG_EXCLUDES+=(--glob "$e"); done

hr()  { printf '%*s\n' "$(tput cols 2>/dev/null || echo 80)" '' | tr ' ' '='; }
sec() { echo; hr; echo "# $*"; hr; echo; }
row() { printf "| %-28s | %6s |\n" "$1" "$2"; }
hdr() { printf "| %-28s | %6s |\n" "Bucket" "LOC"; printf "|-%-28s-|-%6s-|\n" "----------------------------" "------"; }

count_dir() {
  local dir="$1"
  [[ -d "$dir" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -t dart -n '\S' "$dir" | wc -l | tr -d ' '
}

count_file() {
  local f="$1"
  [[ -f "$f" ]] || { echo 0; return; }
  rg "${RG_EXCLUDES[@]}" -n '\S' "$f" | wc -l | tr -d ' '
}

sum_paths() {
  local total=0
  for p in "$@"; do
    [[ -n "${p:-}" ]] || continue
    total=$(( total + $(count_dir "$p") ))
  done
  echo "$total"
}

sum_files() {
  local total=0
  for f in "$@"; do
    [[ -n "${f:-}" ]] || continue
    total=$(( total + $(count_file "$f") ))
  done
  echo "$total"
}

pct() {
  local num=${1:-0} den=${2:-0}
  if [ "$den" -eq 0 ]; then echo "0.0%"; return; fi
  printf "%.1f%%" "$(awk "BEGIN {print ($num*100.0)/$den}")"
}

# ---------- feature roots (без інфри) ----------
AUTH_ROOT="packages/features/lib/src/auth"
PROFILE_ROOT="packages/features/lib/src/profile"
EMAILV_ROOT="packages/features/lib/src/email_verification"

# Якщо є presentation усередині features-пакетів — додай тут (поки порожньо)
AUTH_PRESENTATION_DIRS=()
PROFILE_PRESENTATION_DIRS=()

# ---------- feature LOC (domain+data+feature-presentation) ----------
auth_domain=$(count_dir "$AUTH_ROOT/domain")
auth_data=$(count_dir "$AUTH_ROOT/data")
auth_presentation=$(sum_paths ${AUTH_PRESENTATION_DIRS[@]+"${AUTH_PRESENTATION_DIRS[@]}"})
F_AUTH=$((auth_domain + auth_data + auth_presentation))

emailv_domain=$(count_dir "$EMAILV_ROOT/domain")
emailv_data=$(count_dir "$EMAILV_ROOT/data")
emailv_presentation=0
F_EMAILV=$((emailv_domain + emailv_data + emailv_presentation))

profile_domain=$(count_dir "$PROFILE_ROOT/domain")
profile_data=$(count_dir "$PROFILE_ROOT/data")
profile_presentation=$(sum_paths ${PROFILE_PRESENTATION_DIRS[@]+"${PROFILE_PRESENTATION_DIRS[@]}"})
F_PROFILE=$((profile_domain + profile_data + profile_presentation))

# Email Verification НЕ входить до AUTH, але входить до Profile-групи:
F_PROFILE_PLUS_EMAILV=$((F_PROFILE + F_EMAILV))

sec "FEATURES (чисті LOC: domain+data+(feature-presentation), без інфри)"
echo "## Auth (БЕЗ email_verification)"
hdr
row "domain" "$auth_domain"
row "data" "$auth_data"
row "presentation (feature)" "$auth_presentation"
row "TOTAL Auth (core)" "$F_AUTH"

echo
echo "## EmailVerification (окрема фіча, не входить до Auth)"
hdr
row "domain" "$emailv_domain"
row "data" "$emailv_data"
row "presentation (feature)" "$emailv_presentation"
row "TOTAL EmailVerification" "$F_EMAILV"

echo
echo "## Profile (поки без EmailVerification)"
hdr
row "domain" "$profile_domain"
row "data" "$profile_data"
row "presentation (feature)" "$profile_presentation"
row "TOTAL Profile" "$F_PROFILE"

echo
echo "## Profile + EmailVerification (для наступного кроку)"
hdr
row "TOTAL (Profile + EmailV)" "$F_PROFILE_PLUS_EMAILV"

# ---------- ADAPTER OVERHEAD WHITELIST: AUTH ----------
# (тільки ті файли, що реально юзає AUTH)
AUTH_BLOC_FILES=(
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/side_effects_for_submission_state.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/form_submit_button.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/widgets_shared/page_footer_guard.dart"
)
AUTH_RP_FILES=(
  "packages/riverpod_adapter/lib/src/core/shared_presentation/shared_widgets/form_submit_button.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/side_effect_listener_for_submission_state__x_on_ref.dart"
)
auth_bloc_overhead=$(sum_files ${AUTH_BLOC_FILES[@]+"${AUTH_BLOC_FILES[@]}"})
auth_rp_overhead=$(sum_files   ${AUTH_RP_FILES[@]+"${AUTH_RP_FILES[@]}"})

sec "АДАПТЕРИ ДЛЯ AUTH (тільки whitelist-файли)"
hdr
row "AUTH adapter (BLoC, whitelist)"        "$auth_bloc_overhead"
row "AUTH adapter (Riverpod, whitelist)"     "$auth_rp_overhead"

sec "ПІДСУМКИ ДЛЯ AUTH (оверход відносно чистої фічі AUTH)"
printf "| %-28s | %8s | %8s | %8s |\n" "Metric" "F_LOC" "A_LOC" "o(%)"
printf "|-%-28s-|-%8s-|-%8s-|-%8s-|\n" "----------------------------" "--------" "--------" "--------"
printf "| %-28s | %8s | %8s | %8s |\n" "AUTH + BLoC adapter"     "$F_AUTH" "$auth_bloc_overhead" "$(pct $auth_bloc_overhead $F_AUTH)"
printf "| %-28s | %8s | %8s | %8s |\n" "AUTH + Riverpod adapter" "$F_AUTH" "$auth_rp_overhead"   "$(pct $auth_rp_overhead   $F_AUTH)"

# ---------- ADAPTER OVERHEAD WHITELIST: PROFILE + EMAILV ----------
# (тільки ті файли, що ти надіслав як реально використані)
PROFILE_BLOC_FILES=(
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_value_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/async_state/async_state_view_for_bloc.dart"
  "packages/bloc_adapter/lib/src/core/presentation_shared/side_effects_listeners/async_multi_errors_listener.dart"
)
PROFILE_RP_FILES=(
  "packages/riverpod_adapter/lib/src/core/shared_presentation/async_state/async_state_view_for_riverpod.dart"
  "packages/riverpod_adapter/lib/src/core/shared_presentation/side_effects_listeners/async_multi_errors_listener.dart"
)

profile_bloc_overhead=$(sum_files ${PROFILE_BLOC_FILES[@]+"${PROFILE_BLOC_FILES[@]}"})
profile_rp_overhead=$(sum_files   ${PROFILE_RP_FILES[@]+"${PROFILE_RP_FILES[@]}"})

sec "АДАПТЕРИ ДЛЯ PROFILE + EMAILV (тільки whitelist-файли)"
hdr
row "PROFILE+EmailV adapter (BLoC)"          "$profile_bloc_overhead"
row "PROFILE+EmailV adapter (Riverpod)"      "$profile_rp_overhead"

sec "ПІДСУМКИ ДЛЯ PROFILE + EMAILV (оверход відносно F_PROFILE+EMAILV)"
printf "| %-28s | %8s | %8s | %8s |\n" "Metric" "F_LOC" "A_LOC" "o(%)"
printf "|-%-28s-|-%8s-|-%8s-|-%8s-|\n" "----------------------------" "--------" "--------" "--------"
printf "| %-28s | %8s | %8s | %8s |\n" "PROFILE+EmailV + BLoC"     "$F_PROFILE_PLUS_EMAILV" "$profile_bloc_overhead" "$(pct $profile_bloc_overhead $F_PROFILE_PLUS_EMAILV)"
printf "| %-28s | %8s | %8s | %8s |\n" "PROFILE+EmailV + Riverpod" "$F_PROFILE_PLUS_EMAILV" "$profile_rp_overhead"   "$(pct $profile_rp_overhead   $F_PROFILE_PLUS_EMAILV)"

# ---------- sanity (повні пакети адаптерів) ----------
sec "SANITY CHECK: повні пакети адаптерів (усе, без зген.)"
tokei "packages/bloc_adapter/lib"     -e "**/*.g.dart" -e "**/*.freezed.dart" -e "**/*.mocks.dart" -e "**/*.gr.dart" || true
echo
tokei "packages/riverpod_adapter/lib" -e "**/*.g.dart" -e "**/*.freezed.dart" -e "**/*.mocks.dart" -e "**/*.gr.dart" || true

echo; hr; echo "Готово. Запусти ще раз — отримаєш AUTH окремо та PROFILE+EmailV разом."; hr
