#!/bin/bash

# Script to generate app icons using flutter_launcher_icons
# Usage: ./scripts/gen_icons.sh [cubit|riverpod|all] [dev|stg|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}🎨 App Icon Generator${NC}"
echo ""

# Function to generate icons for an app
generate_icons() {
    local app_name=$1
    local flavor=$2
    local app_dir="$ROOT_DIR/apps/$app_name"
    local pubspec_file="pubspec_${flavor}.yaml"

    echo -e "${YELLOW}📱 Generating icons for: $app_name ($flavor)${NC}"

    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Error: App directory not found: $app_dir${NC}"
        exit 1
    fi

    if [ ! -f "$app_dir/$pubspec_file" ]; then
        echo -e "${YELLOW}⚠️  Warning: Pubspec not found: $pubspec_file${NC}"
        return 0
    fi

    cd "$app_dir"
    flutter pub run flutter_launcher_icons -f "$pubspec_file"

    echo -e "${GREEN}  ✅ Done${NC}"
    echo ""
}

# Parse arguments
APP_TARGET="${1:-all}"
FLAVOR_TARGET="${2:-all}"

# Generate based on targets
case $APP_TARGET in
    cubit)
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "dev" ]; then
            generate_icons "state_symmetric_on_cubit" "dev"
        fi
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "stg" ]; then
            generate_icons "state_symmetric_on_cubit" "stg"
        fi
        ;;
    riverpod)
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "dev" ]; then
            generate_icons "state_symmetric_on_riverpod" "dev"
        fi
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "stg" ]; then
            generate_icons "state_symmetric_on_riverpod" "stg"
        fi
        ;;
    all)
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "dev" ]; then
            generate_icons "state_symmetric_on_cubit" "dev"
            generate_icons "state_symmetric_on_riverpod" "dev"
        fi
        if [ "$FLAVOR_TARGET" = "all" ] || [ "$FLAVOR_TARGET" = "stg" ]; then
            generate_icons "state_symmetric_on_cubit" "stg"
            generate_icons "state_symmetric_on_riverpod" "stg"
        fi
        ;;
    *)
        echo -e "${RED}❌ Unknown app target: $APP_TARGET${NC}"
        echo "Usage: $0 [cubit|riverpod|all] [dev|stg|all]"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Icon generation complete!${NC}"
