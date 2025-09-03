# iOS Flavors з Fastlane — продакшн‑ready

> **Принцип:** одна схема `Runner`, один білд через `gym`, відмінності середовищ — через `.xcconfig` + копіювання потрібного `GoogleService-Info.plist` у lane. **Без відкриття Xcode.**

## 1) Мінімальна структура

```
ios/
  Flutter/
    Dev.xcconfig
    Stg.xcconfig
    Prod.xcconfig
  Runner/
    Assets.xcassets/
      AppIcon.appiconset        # PROD
      AppIcon-dev.appiconset    # DEV
      AppIcon-stg.appiconset    # STG
    GoogleService-Info-dev.plist
    GoogleService-Info-stg.plist
    GoogleService-Info-prod.plist
    Info.plist                  # один для всіх (див. нижче)
  fastlane/
    Fastfile
    Appfile
```

### Info.plist (разово)

- `CFBundleDisplayName` → `$(PRODUCT_NAME)`
- Додай **усі три** URL‑схеми (reversed client id для dev/stg/prod), щоб не редагувати під час збірки.

## 2) `.xcconfig` (приклади)

```xcconfig
// Flutter/Dev.xcconfig
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.example.app.dev
PRODUCT_NAME = App Dev
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-dev
```

```xcconfig
// Flutter/Stg.xcconfig
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.example.app.stg
PRODUCT_NAME = App Staging
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon-stg
```

```xcconfig
// Flutter/Prod.xcconfig
#include "Generated.xcconfig"
PRODUCT_BUNDLE_IDENTIFIER = com.example.app
PRODUCT_NAME = App
ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon
```

## 3) Fastlane (ключові lane)

> Один білд через `gym`; перед білдів копіюємо відповідний `GoogleService-Info-*.plist` у `Runner/GoogleService-Info.plist`.

```ruby
# ios/fastlane/Appfile
apple_id("your-apple-id@example.com")
team_id("YOUR_TEAM_ID")
itc_team_id("YOUR_ITC_TEAM_ID")
```

```ruby
# ios/fastlane/Fastfile
default_platform(:ios)

FLAVORS = {
  dev:  { xcconfig: "Flutter/Dev.xcconfig",  plist: "Runner/GoogleService-Info-dev.plist",  dart: "lib/main_development.dart" },
  stg:  { xcconfig: "Flutter/Stg.xcconfig",  plist: "Runner/GoogleService-Info-stg.plist",  dart: "lib/main_staging.dart" },
  prod: { xcconfig: "Flutter/Prod.xcconfig", plist: "Runner/GoogleService-Info-prod.plist", dart: "lib/main_production.dart" }
}

platform :ios do
  before_all { ensure_bundle_exec }

  desc "DEV (Simulator, Debug)"
  lane :dev do
    build_sim(:dev)
  end

  desc "STG (Simulator, Debug)"
  lane :stg do
    build_sim(:stg)
  end

  desc "PROD archive (Release, App Store)"
  lane :prod_archive do
    flavor = FLAVORS[:prod]
    copy_firebase(flavor[:plist])
    build_ios_app(
      scheme: "Runner",
      xcconfig: flavor[:xcconfig],
      configuration: "Release",
      clean: true,
      export_method: "app-store"
    )
  end

  private_lane :build_sim do |key|
    flavor = FLAVORS[key]
    copy_firebase(flavor[:plist])

    # опційно: синхронізація залежностей Dart
    Dir.chdir("../..") { sh("flutter pub get") }

    build_ios_app(
      scheme: "Runner",
      xcconfig: flavor[:xcconfig],
      sdk: "iphonesimulator",
      destination: "platform=iOS Simulator,name=iPhone 15",
      configuration: "Debug",
      skip_archive: true,
      skip_codesigning: true,
      clean: true
    )

    UI.message("▶️ Запуск (debug attach): flutter run --target #{flavor[:dart]}")
  end

  private_lane :copy_firebase do |from|
    source = from
    target = "Runner/GoogleService-Info.plist"
    UI.user_error!("Missing Firebase plist: #{source}") unless File.exist?(source)
    FileUtils.cp(source, target)
    UI.message("📋 Copied #{source} -> #{target}")
  end
end
```

## 4) Використання

```bash
cd ios
bundle exec fastlane ios dev        # Debug + симулятор (DEV)
bundle exec fastlane ios stg        # Debug + симулятор (STG)
bundle exec fastlane ios prod_archive  # Release + archive (PROD)

# Запуск dev із Dart‑таргетом (без схем у Xcode)
flutter run --target lib/main_development.dart
```

## 5) Що отримуємо автоматично

- **Bundle ID / App Name / App Icon** → з відповідного `.xcconfig`.
- **Firebase** → через скопійований `GoogleService-Info.plist` перед білдів.
- **URL‑schemes** → наперед додані в `Info.plist` (жодних правок під час збірки).
- **Без Xcode** → одна схема `Runner`, усе керується конфіг‑файлами.

## 6) Примітки та типові нюанси

- Для TestFlight/AppStore завжди збирай `Release` + `export_method: "app-store"` (див. `prod_archive`).
- Якщо потрібно саме підміняти URL‑scheme динамічно — краще додати всі три в `Info.plist` і нічого не міняти на льоту.
- Іконка не міняється? Перевір ім’я `ASSETCATALOG_COMPILER_APPICON_NAME` і наявність `appiconset`.
- Перевір, що в `Info.plist` **немає** жорсткого `CFBundleIdentifier`; він має братися з Build Settings → `.xcconfig`.

## 7) Чому краще за «схеми під кожен flavor»

- Менше рухомих частин (немає нових схем/конфігів у Xcode).
- Відтворюваність у CI: усе у файлах, що версіонуються.
- Немає дублювання білдів (`flutter build ios` + `gym`). Один стабільний шлях через `gym`.
