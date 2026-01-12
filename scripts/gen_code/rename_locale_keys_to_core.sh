#!/bin/bash
# Script to rename LocaleKeys to CoreLocaleKeys in generated file

FILE="lib/src/localization/generated/core_locale_keys.g.dart"

# Replace both single and double space variants
sed -i.bak \
  -e 's/abstract class LocaleKeys {/abstract class CoreLocaleKeys {/' \
  -e 's/abstract class  LocaleKeys {/abstract class CoreLocaleKeys {/' \
  "$FILE"

# Remove backup file
rm -f "${FILE}.bak"

echo "✓ Renamed LocaleKeys -> CoreLocaleKeys in $FILE"
