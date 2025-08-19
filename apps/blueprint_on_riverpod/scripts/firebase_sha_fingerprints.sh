#!/usr/bin/env bash
set -euo pipefail

# ------------------------------------------------------------
# Firebase SHA fingerprints printer for Android flavors
# Works without Gradle. Uses only keytool.
# ------------------------------------------------------------

# Colors
BOLD="\033[1m"; DIM="\033[2m"; GREEN="\033[32m"; YELLOW="\033[33m"; RED="\033[31m"; RESET="\033[0m"

# keytool presence
if ! command -v keytool >/dev/null 2>&1; then
  echo -e "${RED}✗ keytool не знайдено.${RESET} Встанови JDK (temurin/openjdk) і додай у PATH."
  echo "macOS (Homebrew): brew install --cask temurin"
  exit 1
fi

print_section() {
  echo -e "\n${BOLD}# $1${RESET}"
}

print_tip() {
  echo -e "${DIM}$1${RESET}"
}

# Pretty print SHA from keytool
# args: <title> <keystore> <alias> <storepass> <keypass>
print_sha() {
  local title="$1"; local ks="$2"; local alias="$3"; local sp="$4"; local kp="$5"
  if [[ ! -f "$ks" ]]; then
    echo -e "${YELLOW}⚠ Пропущено:$RESET $title — файл не знайдено: $ks"
    return
  fi

  echo -e "${GREEN}✓ $title${RESET}"
  # keytool -list can exit 0 even з попередженнями, тому явно фільтруємо
  local out
  if ! out=$(keytool -list -v -alias "$alias" -keystore "$ks" -storepass "$sp" -keypass "$kp" 2>/dev/null); then
    echo -e "${RED}✗ Помилка читання keystore для $title${RESET}"
    return
  fi

  local sha1 sha256
  sha1=$(echo "$out"   | sed -n 's/^.*SHA1:\s*//p'   | head -n1)
  sha256=$(echo "$out" | sed -n 's/^.*SHA256:\s*//p' | head -n1)

  if [[ -z "${sha1:-}" && -z "${sha256:-}" ]]; then
    echo -e "${RED}✗ Не знайдено SHA у виводі keytool (перевір паролі/alias).${RESET}"
    return
  fi

  echo "  SHA-1   : $sha1"
  echo "  SHA-256 : $sha256"
}

print_section "DEBUG (спільний debug.keystore)"
DEBUG_KS="${HOME}/.android/debug.keystore"
DEBUG_ALIAS="androiddebugkey"
DEBUG_PASS="android"

print_sha "Debug (усі флейволи, якщо не перевизначено)" "$DEBUG_KS" "$DEBUG_ALIAS" "$DEBUG_PASS" "$DEBUG_PASS"
print_tip "Додай цей Debug SHA-1 (і за бажанням SHA-256) у Firebase Console ➜ Project settings ➜ Your apps ➜ Android ➜ Add fingerprint (для DEV/STG/PROD Android-апок)."

print_section "RELEASE (за флейворами)"
# Можеш змінити дефолтні шляхи нижче або передати ENV-перемінними:
# DEV_KEYSTORE, DEV_KEY_ALIAS, DEV_STORE_PASSWORD, DEV_KEY_PASSWORD, тощо.

DEV_KEYSTORE="${DEV_KEYSTORE:-android/app/keystores/development.jks}"
DEV_KEY_ALIAS="${DEV_KEY_ALIAS:-development}"
DEV_STORE_PASSWORD="${DEV_STORE_PASSWORD:-changeit}"
DEV_KEY_PASSWORD="${DEV_KEY_PASSWORD:-$DEV_STORE_PASSWORD}"

STG_KEYSTORE="${STG_KEYSTORE:-android/app/keystores/staging.jks}"
STG_KEY_ALIAS="${STG_KEY_ALIAS:-staging}"
STG_STORE_PASSWORD="${STG_STORE_PASSWORD:-changeit}"
STG_KEY_PASSWORD="${STG_KEY_PASSWORD:-$STG_STORE_PASSWORD}"

PRD_KEYSTORE="${PRD_KEYSTORE:-android/app/keystores/production.jks}"
PRD_KEY_ALIAS="${PRD_KEY_ALIAS:-production}"
PRD_STORE_PASSWORD="${PRD_STORE_PASSWORD:-changeit}"
PRD_KEY_PASSWORD="${PRD_KEY_PASSWORD:-$PRD_STORE_PASSWORD}"

print_sha "Release • development" "$DEV_KEYSTORE" "$DEV_KEY_ALIAS" "$DEV_STORE_PASSWORD" "$DEV_KEY_PASSWORD"
print_sha "Release • staging"     "$STG_KEYSTORE" "$STG_KEY_ALIAS" "$STG_STORE_PASSWORD" "$STG_KEY_PASSWORD"
print_sha "Release • production"  "$PRD_KEYSTORE" "$PRD_KEY_ALIAS" "$PRD_STORE_PASSWORD" "$PRD_KEY_PASSWORD"

print_tip "Якщо якийсь .jks відсутній — скрипт просто пропустить його. Створи і повтори запуск."

echo -e "\n${BOLD}Куди саме вставляти в Firebase:${RESET}
  • Для кожного Android-додатку (DEV/STG/PROD) у Firebase Console ➜ Settings ➜ Your apps ➜ Android:
    – Додай Debug SHA-1 (той самий для всіх, якщо однаковий debug.keystore).
    – Додай Release SHA-1 для відповідного флейвора (якщо є релізний keystore)."