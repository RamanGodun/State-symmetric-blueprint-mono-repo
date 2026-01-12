#!/bin/bash

# Script to generate localization files for both apps
# Usage: ./scripts/generate_localizations.sh [cubit|riverpod|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${GREEN}🌍 Localization Generator${NC}"
echo "Root: $ROOT_DIR"
echo ""

# Function to generate localization for an app
generate_for_app() {
    local app_name=$1
    local app_dir="$ROOT_DIR/apps/$app_name"

    echo -e "${YELLOW}📱 Generating localization for: $app_name${NC}"

    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Error: App directory not found: $app_dir${NC}"
        exit 1
    fi

    if [ ! -d "$app_dir/assets/translations" ]; then
        echo -e "${RED}❌ Error: Translation assets not found: $app_dir/assets/translations${NC}"
        exit 1
    fi

    cd "$app_dir"

    echo "  🔧 Generating codegen_loader.g.dart..."
    dart run easy_localization:generate \
        -S assets/translations \
        -O lib/core/base_modules/localization/generated \
        -o codegen_loader.g.dart

    echo "  🔧 Generating locale_keys.g.dart..."
    dart run easy_localization:generate \
        -f keys \
        -S assets/translations \
        -O lib/core/base_modules/localization/generated \
        -o locale_keys.g.dart

    echo -e "${GREEN}  ✅ Done for $app_name${NC}"
    echo ""
}

# Parse arguments
TARGET="${1:-all}"

case $TARGET in
    cubit)
        generate_for_app "state_symmetric_on_cubit"
        ;;
    riverpod)
        generate_for_app "state_symmetric_on_riverpod"
        ;;
    all)
        generate_for_app "state_symmetric_on_cubit"
        generate_for_app "state_symmetric_on_riverpod"
        ;;
    *)
        echo -e "${RED}❌ Unknown target: $TARGET${NC}"
        echo "Usage: $0 [cubit|riverpod|all]"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Localization generation complete!${NC}"
echo ""
echo "Generated files:"
echo "  • apps/state_symmetric_on_cubit/lib/core/base_modules/localization/generated/codegen_loader.g.dart"
echo "  • apps/state_symmetric_on_cubit/lib/core/base_modules/localization/generated/locale_keys.g.dart"
echo "  • apps/state_symmetric_on_riverpod/lib/core/base_modules/localization/generated/codegen_loader.g.dart"
echo "  • apps/state_symmetric_on_riverpod/lib/core/base_modules/localization/generated/locale_keys.g.dart"
