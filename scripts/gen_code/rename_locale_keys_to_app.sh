#!/bin/bash
# Script to rename LocaleKeys to AppLocaleKeys in generated file

FILE="lib/core/base_modules/localization/generated/app_locale_keys.g.dart"

# Replace both single and double space variants
sed -i.bak \
  -e 's/abstract class LocaleKeys {/abstract class AppLocaleKeys {/' \
  -e 's/abstract class  LocaleKeys {/abstract class AppLocaleKeys {/' \
  "$FILE"

# Remove backup file
rm -f "${FILE}.bak"

echo "✓ Renamed LocaleKeys -> AppLocaleKeys in $FILE"
