#!/usr/bin/env bash
set -euo pipefail

APP_DIR="${1:-.}"

need_cmd() { command -v "$1" >/dev/null 2>&1 || { echo "❌ Need '$1' in PATH"; exit 1; }; }
need_cmd gcloud; need_cmd firebase; need_cmd jq; need_cmd plutil

# --- config ---
DEV_ID="${DEV_ID:-blueprint-on-riverpod-dev}"
STG_ID="${STG_ID:-blueprint-on-riverpod-stg}"

IOS_BUNDLE_DEV="${IOS_BUNDLE_DEV:-com.romangodun.blueprint-on-riverpod.dev}"
IOS_BUNDLE_STG="${IOS_BUNDLE_STG:-com.romangodun.blueprint-on-riverpod.stg}"

AND_PKG_DEV="${AND_PKG_DEV:-com.romangodun.blueprint_on_riverpod.dev}"
AND_PKG_STG="${AND_PKG_STG:-com.romangodun.blueprint_on_riverpod.stg}"

echo "🛠 Creating GCP projects (if not exist)"
gcloud projects create "$DEV_ID" --name="Blueprint on Riverpod (Dev)" || true
gcloud projects create "$STG_ID" --name="Blueprint on Riverpod (Staging)" || true

if [[ -z "${BILLING:-}" ]]; then
  gcloud billing accounts list
  read -r -p "Enter BILLING_ACCOUNT_ID: " BILLING
fi

echo "🔗 Linking billing"
gcloud billing projects link "$DEV_ID" --billing-account="$BILLING" || true
gcloud billing projects link "$STG_ID" --billing-account="$BILLING" || true

gcloud services enable firebase.googleapis.com --project="$DEV_ID" || true
gcloud services enable firebase.googleapis.com --project="$STG_ID" || true

echo "➕ Add Firebase"
firebase projects:addfirebase "$DEV_ID" || true
firebase projects:addfirebase "$STG_ID" || true

echo "📱 Create apps"
firebase apps:create IOS "$IOS_BUNDLE_DEV" --project="$DEV_ID" --json > ios_dev.json
firebase apps:create ANDROID "$AND_PKG_DEV" --project="$DEV_ID" --json > and_dev.json
firebase apps:create IOS "$IOS_BUNDLE_STG" --project="$STG_ID" --json > ios_stg.json
firebase apps:create ANDROID "$AND_PKG_STG" --project="$STG_ID" --json > and_stg.json

IOS_DEV_APP_ID=$(jq -r '.result.appId' ios_dev.json)
AND_DEV_APP_ID=$(jq -r '.result.appId' and_dev.json)
IOS_STG_APP_ID=$(jq -r '.result.appId' ios_stg.json)
AND_STG_APP_ID=$(jq -r '.result.appId' and_stg.json)

firebase apps:sdkconfig IOS "$IOS_DEV_APP_ID" --project="$DEV_ID" > ios_dev.plist
firebase apps:sdkconfig ANDROID "$AND_DEV_APP_ID" --project="$DEV_ID" > and_dev.json
firebase apps:sdkconfig IOS "$IOS_STG_APP_ID" --project="$STG_ID" > ios_stg.plist
firebase apps:sdkconfig ANDROID "$AND_STG_APP_ID" --project="$STG_ID" > and_stg.json

AND_DEV_API_KEY=$(jq -r '.client[0].api_key[0].current_key' and_dev.json)
AND_DEV_APP_ID_VAL=$(jq -r '.client[0].client_info.mobilesdk_app_id' and_dev.json)
AND_DEV_PROJECT_ID=$(jq -r '.project_info.project_id' and_dev.json)
AND_DEV_SENDER_ID=$(jq -r '.project_info.project_number' and_dev.json)
AND_DEV_BUCKET=$(jq -r '.project_info.storage_bucket' and_dev.json)

AND_STG_API_KEY=$(jq -r '.client[0].api_key[0].current_key' and_stg.json)
AND_STG_APP_ID_VAL=$(jq -r '.client[0].client_info.mobilesdk_app_id' and_stg.json)
AND_STG_PROJECT_ID=$(jq -r '.project_info.project_id' and_stg.json)
AND_STG_SENDER_ID=$(jq -r '.project_info.project_number' and_stg.json)
AND_STG_BUCKET=$(jq -r '.project_info.storage_bucket' and_stg.json)

IOS_DEV_API_KEY=$(plutil -extract API_KEY raw -o - ios_dev.plist)
IOS_DEV_GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - ios_dev.plist)
IOS_STG_API_KEY=$(plutil -extract API_KEY raw -o - ios_stg.plist)
IOS_STG_GOOGLE_APP_ID=$(plutil -extract GOOGLE_APP_ID raw -o - ios_stg.plist)

cat > "$APP_DIR/.env.dev" <<EOF
FIREBASE_PROJECT_ID=$AND_DEV_PROJECT_ID
FIREBASE_MESSAGING_SENDER_ID=$AND_DEV_SENDER_ID
FIREBASE_STORAGE_BUCKET=$AND_DEV_BUCKET
FIREBASE_API_KEY_IOS=$IOS_DEV_API_KEY
FIREBASE_APP_ID_IOS=$IOS_DEV_GOOGLE_APP_ID
FIREBASE_IOS_BUNDLE_ID=$IOS_BUNDLE_DEV
FIREBASE_API_KEY_ANDROID=$AND_DEV_API_KEY
FIREBASE_APP_ID_ANDROID=$AND_DEV_APP_ID_VAL
EOF

cat > "$APP_DIR/.env.staging" <<EOF
FIREBASE_PROJECT_ID=$AND_STG_PROJECT_ID
FIREBASE_MESSAGING_SENDER_ID=$AND_STG_SENDER_ID
FIREBASE_STORAGE_BUCKET=$AND_STG_BUCKET
FIREBASE_API_KEY_IOS=$IOS_STG_API_KEY
FIREBASE_APP_ID_IOS=$IOS_STG_GOOGLE_APP_ID
FIREBASE_IOS_BUNDLE_ID=$IOS_BUNDLE_STG
FIREBASE_API_KEY_ANDROID=$AND_STG_API_KEY
FIREBASE_APP_ID_ANDROID=$AND_STG_APP_ID_VAL
EOF

echo "✅ .env.dev / .env.staging created in $APP_DIR"