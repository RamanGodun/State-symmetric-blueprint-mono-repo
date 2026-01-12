#!/bin/bash

# Script to run build_runner code generation
# Usage: ./scripts/gen_codegen.sh [adapters|packages|apps|all]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
cd "$ROOT_DIR"

echo -e "${BLUE}🔧 Code Generation with build_runner${NC}"
echo ""

# Function to run melos command
run_melos() {
    local scope=$1
    local description=$2

    echo -e "${YELLOW}📦 $description${NC}"
    melos exec --scope="$scope" --concurrency=1 -- \
        dart run build_runner build --delete-conflicting-outputs || true
    echo ""
}

# Parse arguments
TARGET="${1:-all}"

case $TARGET in
    adapters)
        run_melos "adapters_for_riverpod" "Generating code for adapters..."
        ;;
    packages)
        run_melos "features_dd_layers" "Generating code for features_dd_layers..."
        run_melos "shared_layers" "Generating code for shared_layers..."
        run_melos "shared_core_modules" "Generating code for shared_core_modules..."
        ;;
    apps)
        run_melos "app_on_riverpod" "Generating code for app_on_riverpod..."
        run_melos "app_on_cubit" "Generating code for app_on_cubit..."
        ;;
    all)
        run_melos "adapters_for_riverpod" "Generating code for adapters..."
        run_melos "features_dd_layers" "Generating code for features_dd_layers..."
        run_melos "shared_layers" "Generating code for shared_layers..."
        run_melos "shared_core_modules" "Generating code for shared_core_modules..."
        run_melos "app_on_riverpod" "Generating code for app_on_riverpod..."
        run_melos "app_on_cubit" "Generating code for app_on_cubit..."
        ;;
    *)
        echo -e "${RED}❌ Unknown target: $TARGET${NC}"
        echo "Usage: $0 [adapters|packages|apps|all]"
        exit 1
        ;;
esac

echo -e "${GREEN}✅ Code generation complete!${NC}"
