#!/bin/bash

# Script to generate asset paths using Spider
# Usage: ./scripts/gen_spider.sh [cubit|riverpod|all] [images|icons|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}🕷️  Spider Asset Path Generator${NC}"
echo ""

# Ensure spider is available in PATH
export PATH="$PATH:$HOME/.pub-cache/bin"

# Function to generate spider paths for an app
generate_spider() {
    local app_name=$1
    local asset_type=$2  # images or icons
    local app_dir="$ROOT_DIR/apps/$app_name"
    local spider_config="lib/core/shared_presentation_layer/utils/spider/${asset_type}_paths/spider.yaml"

    echo -e "${YELLOW}📱 Generating ${asset_type} paths for: $app_name${NC}"

    if [ ! -d "$app_dir" ]; then
        echo -e "${RED}❌ Error: App directory not found: $app_dir${NC}"
        exit 1
    fi

    if [ ! -f "$app_dir/$spider_config" ]; then
        echo -e "${YELLOW}⚠️  Warning: Spider config not found: $spider_config${NC}"
        return 0
    fi

    cd "$app_dir"
    spider -p "$spider_config" build
    echo -e "${GREEN}  ✅ Done${NC}"
    echo ""
}

# Parse arguments
APP_TARGET="${1:-all}"
ASSET_TARGET="${2:-all}"

# Generate based on targets
case $APP_TARGET in
    cubit)
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "images" ]; then
            generate_spider "state_symmetric_on_cubit" "images"
        fi
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "icons" ]; then
            generate_spider "state_symmetric_on_cubit" "icons"
        fi
        ;;
    riverpod)
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "images" ]; then
            generate_spider "state_symmetric_on_riverpod" "images"
        fi
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "icons" ]; then
            generate_spider "state_symmetric_on_riverpod" "icons"
        fi
        ;;
    all)
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "images" ]; then
            generate_spider "state_symmetric_on_cubit" "images"
            generate_spider "state_symmetric_on_riverpod" "images"
        fi
        if [ "$ASSET_TARGET" = "all" ] || [ "$ASSET_TARGET" = "icons" ]; then
            generate_spider "state_symmetric_on_cubit" "icons"
            generate_spider "state_symmetric_on_riverpod" "icons"
        fi
        ;;
    *)
        echo -e "${RED}❌ Unknown app target: $APP_TARGET${NC}"
        echo "Usage: $0 [cubit|riverpod|all] [images|icons|all]"
        exit 1
        ;;
esac

echo -e "${GREEN}🎉 Spider generation complete!${NC}"
