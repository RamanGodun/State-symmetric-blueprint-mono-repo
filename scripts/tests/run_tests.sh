#!/bin/bash

# Script to run tests in Flutter packages/apps
# Usage: ./scripts/tests/run_tests.sh [all|apps|packages|<package_name>]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}🧪 Flutter Test Runner${NC}"
echo ""

# Parse arguments
TARGET="${1:-all}"

# Function to run tests for a specific app/package
run_tests() {
    local package_path=$1
    local package_name=$(basename "$package_path")

    echo -e "${YELLOW}🧪 Running tests for $package_name...${NC}"
    cd "$package_path"

    flutter test --no-pub --concurrency=4

    if [ $? -eq 0 ]; then
        echo -e "${GREEN}  ✅ Tests passed for $package_name${NC}"
    else
        echo -e "${RED}  ❌ Tests failed for $package_name${NC}"
        return 1
    fi

    echo ""
    cd "$ROOT_DIR"
}

# Route to appropriate action
case $TARGET in
    all)
        echo -e "${YELLOW}Running tests for all packages and apps...${NC}"
        echo ""

        # Test all packages
        for pkg in "$ROOT_DIR"/packages/*; do
            if [ -d "$pkg" ]; then
                run_tests "$pkg"
            fi
        done

        # Test all apps
        for app in "$ROOT_DIR"/apps/*; do
            if [ -d "$app" ]; then
                run_tests "$app"
            fi
        done
        ;;

    apps)
        echo -e "${YELLOW}Running tests for all apps...${NC}"
        echo ""

        for app in "$ROOT_DIR"/apps/*; do
            if [ -d "$app" ]; then
                run_tests "$app"
            fi
        done
        ;;

    packages)
        echo -e "${YELLOW}Running tests for all packages...${NC}"
        echo ""

        for pkg in "$ROOT_DIR"/packages/*; do
            if [ -d "$pkg" ]; then
                run_tests "$pkg"
            fi
        done
        ;;

    state_symmetric_on_cubit|cubit)
        run_tests "$ROOT_DIR/apps/state_symmetric_on_cubit"
        ;;

    state_symmetric_on_riverpod|riverpod)
        run_tests "$ROOT_DIR/apps/state_symmetric_on_riverpod"
        ;;

    *)
        # Try to find package/app by name
        if [ -d "$ROOT_DIR/packages/$TARGET" ]; then
            run_tests "$ROOT_DIR/packages/$TARGET"
        elif [ -d "$ROOT_DIR/apps/$TARGET" ]; then
            run_tests "$ROOT_DIR/apps/$TARGET"
        else
            echo -e "${RED}❌ Unknown target: $TARGET${NC}"
            echo "Usage: $0 [all|apps|packages|cubit|riverpod|<package_name>]"
            echo ""
            echo "Available apps:"
            echo "  - state_symmetric_on_cubit (or 'cubit')"
            echo "  - state_symmetric_on_riverpod (or 'riverpod')"
            echo ""
            echo "Available packages:"
            for pkg in "$ROOT_DIR"/packages/*; do
                if [ -d "$pkg" ]; then
                    echo "  - $(basename "$pkg")"
                fi
            done
            exit 1
        fi
        ;;
esac

echo -e "${GREEN}🎉 Test execution complete!${NC}"
