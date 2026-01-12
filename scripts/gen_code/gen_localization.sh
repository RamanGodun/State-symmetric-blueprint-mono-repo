#!/bin/bash

# Script to generate localization files
# Usage: ./scripts/gen_localization.sh [core|cubit|riverpod|apps|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}🌍 Localization Generator${NC}"
echo ""

# Function to generate core localization
generate_core() {
    echo -e "${YELLOW}📦 Generating CoreLocaleKeys for shared_core_modules...${NC}"

    local pkg_dir="$ROOT_DIR/packages/shared_core_modules"

    if [ ! -d "$pkg_dir" ]; then
        echo -e "${RED}❌ Error: Package directory not found: $pkg_dir${NC}"
        exit 1
    fi

    cd "$pkg_dir"

    echo "  🔧 Generating codegen_loader.g.dart..."
    dart run easy_localization:generate \
        -S assets/translations \
        -O lib/src/localization/generated \
        -o codegen_loader.g.dart

    echo "  🔧 Generating core_locale_keys.g.dart..."
    dart run easy_localization:generate \
        -f keys \
        -S assets/translations \
        -O lib/src/localization/generated \
        -o core_locale_keys.g.dart

    # Rename LocaleKeys to CoreLocaleKeys
    bash "$ROOT_DIR/scripts/gen_code/rename_locale_keys_to_core.sh"

    echo -e "${GREEN}  ✅ CoreLocaleKeys generated successfully!${NC}"
    echo ""
}

# Function to generate app localization
generate_app() {
    local app_name=$1
    local app_dir="$ROOT_DIR/apps/$app_name"

    echo -e "${YELLOW}📱 Generating AppLocaleKeys for $app_name...${NC}"

    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Error: App directory not found: $app_dir${NC}"
        exit 1
    fi

    if [ ! -d "$app_dir/assets/translations" ]; then
        echo -e "${YELLOW}⚠️  Warning: No translations found for $app_name${NC}"
        return 0
    fi

    cd "$app_dir"

    echo "  🔧 Generating codegen_loader.g.dart..."
    dart run easy_localization:generate \
        -S assets/translations \
        -O lib/core/base_modules/localization/generated \
        -o codegen_loader.g.dart

    echo "  🔧 Generating app_locale_keys.g.dart..."
    dart run easy_localization:generate \
        -f keys \
        -S assets/translations \
        -O lib/core/base_modules/localization/generated \
        -o app_locale_keys.g.dart

    # Rename LocaleKeys to AppLocaleKeys
    bash "$ROOT_DIR/scripts/gen_code/rename_locale_keys_to_app.sh"

    echo -e "${GREEN}  ✅ AppLocaleKeys for $app_name generated successfully!${NC}"
    echo ""
}

# Parse arguments
TARGET="${1:-all}"

case $TARGET in
    core)
        generate_core
        ;;
    cubit)
        generate_app "state_symmetric_on_cubit"
        ;;
    riverpod)
        generate_app "state_symmetric_on_riverpod"
        ;;
    apps)
        generate_app "state_symmetric_on_cubit"
        generate_app "state_symmetric_on_riverpod"
        ;;
    all)
        generate_core
        generate_app "state_symmetric_on_cubit"
        generate_app "state_symmetric_on_riverpod"
        ;;
    *)
        echo -e "${RED}❌ Unknown target: $TARGET${NC}"
        echo "Usage: $0 [core|cubit|riverpod|apps|all]"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Localization generation complete!${NC}"
