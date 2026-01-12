#!/usr/bin/env bash
set -euo pipefail

# Usage:
#   bash scripts/generate_android_icons.sh apps/app_on_riverpod
#   bash scripts/generate_android_icons.sh apps/app_on_cubit
#
# Працює ТІЛЬКИ для ANDROID. iOS не чіпає взагалі.
# Алгоритм:
#  - генерує іконки в src/main для DEV (з тимчасовим yaml з ios:false)
#  - копіює їх у src/development
#  - генерує іконки в src/main для STG (тимчасовий yaml з ios:false)
#  - копіює їх у src/staging
#  - НА КІНЕЦЬ ще раз генерує DEV, щоб у src/main залишилися dev-іконки (зручно для локалки)

APP_DIR="${1:-apps/app_on_riverpod}"

if [[ ! -d "$APP_DIR" ]]; then
  echo "✗ APP_DIR not found: $APP_DIR"
  exit 1
fi

pushd "$APP_DIR" >/dev/null

# Перевірка наявності іконок
if [[ ! -f "assets/icons/dev_icon.png" ]]; then
  echo "✗ Missing assets/icons/dev_icon.png in $APP_DIR"
  exit 1
fi
if [[ ! -f "assets/icons/stg_icon.png" ]]; then
  echo "✗ Missing assets/icons/stg_icon.png in $APP_DIR"
  exit 1
fi

echo "→ flutter pub get"
flutter pub get

# Готуємо тимчасові yaml (force: android:true, ios:false), щоб не чіпати iOS
TMP_DEV="$(mktemp)"
TMP_STG="$(mktemp)"

# Нормалізуємо ключі android/ios у тимчасових файлах
# - ставимо android: true
# - ставимо ios: false
# ПРИМІТКА: без зміни вихідних yaml у репозиторії
sed -E '
  s/^[[:space:]]*android:[[:space:]]*(true|false)/  android: true/;
  s/^[[:space:]]*ios:[[:space:]]*(true|false)/  ios: false/
' pubspec_dev.yaml > "$TMP_DEV"

sed -E '
  s/^[[:space:]]*android:[[:space:]]*(true|false)/  android: true/;
  s/^[[:space:]]*ios:[[:space:]]*(true|false)/  ios: false/
' pubspec_stg.yaml > "$TMP_STG"

copy_from_main_to_flavor () {
  local FLAVOR_DIR="$1" # development | staging
  pushd android/app >/dev/null

  cp -f src/main/ic_launcher-playstore.png "src/$FLAVOR_DIR/ic_launcher-playstore.png" || true

  mkdir -p "src/$FLAVOR_DIR/res/mipmap-anydpi-v26"
  cp -f src/main/res/mipmap-anydpi-v26/ic_launcher.xml       "src/$FLAVOR_DIR/res/mipmap-anydpi-v26/ic_launcher.xml"
  cp -f src/main/res/mipmap-anydpi-v26/ic_launcher_round.xml "src/$FLAVOR_DIR/res/mipmap-anydpi-v26/ic_launcher_round.xml"

  for d in mipmap-mdpi mipmap-hdpi mipmap-xhdpi mipmap-xxhdpi mipmap-xxxhdpi; do
    mkdir -p "src/$FLAVOR_DIR/res/$d"
    cp -f "src/main/res/$d/ic_launcher.png"        "src/$FLAVOR_DIR/res/$d/ic_launcher.png"
    cp -f "src/main/res/$d/ic_launcher_round.png"  "src/$FLAVOR_DIR/res/$d/ic_launcher_round.png"
  done

  for d in drawable-mdpi drawable-hdpi drawable-xhdpi drawable-xxhdpi drawable-xxxhdpi; do
    if [[ -f "src/main/res/$d/ic_launcher_foreground.png" ]]; then
      mkdir -p "src/$FLAVOR_DIR/res/$d"
      cp -f "src/main/res/$d/ic_launcher_foreground.png" "src/$FLAVOR_DIR/res/$d/ic_launcher_foreground.png"
    fi
  done

  mkdir -p "src/$FLAVOR_DIR/res/values"
  if [[ -f src/main/res/values/ic_launcher_background.xml ]]; then
    cp -f src/main/res/values/ic_launcher_background.xml "src/$FLAVOR_DIR/res/values/ic_launcher_background.xml"
  fi

  popd >/dev/null
}

# DEV → генеруємо в main → копіюємо у development
echo "→ Generate DEV icons (android only, iOS untouched)"
dart run flutter_launcher_icons -f "$TMP_DEV"
copy_from_main_to_flavor "development"

# STG → генеруємо в main → копіюємо у staging
echo "→ Generate STG icons (android only, iOS untouched)"
dart run flutter_launcher_icons -f "$TMP_STG"
copy_from_main_to_flavor "staging"

# Фінально повернемо main до DEV (зручно мати dev-іконки в лаунчері за замовченням)
echo "→ Restore main icons to DEV for local convenience"
dart run flutter_launcher_icons -f "$TMP_DEV"

echo "✓ Done. Android icons updated for DEV & STG flavors in:"
echo "  $APP_DIR/android/app/src/development/res/*"
echo "  $APP_DIR/android/app/src/staging/res/*"

popd >/dev/null
