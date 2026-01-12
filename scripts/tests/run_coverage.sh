#!/bin/bash

# Script to run tests with coverage and generate HTML report
# Usage: ./scripts/tests/run_coverage.sh [all|cubit|riverpod|<package_name>]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}📊 Flutter Coverage Generator${NC}"
echo ""

# Function to run coverage for a specific app/package
run_coverage() {
    local package_path=$1
    local package_name=$(basename "$package_path")

    echo -e "${YELLOW}📊 Generating coverage for $package_name...${NC}"
    cd "$package_path"

    # Run tests with coverage
    flutter test --coverage --no-pub

    if [ $? -ne 0 ]; then
        echo -e "${RED}  ❌ Tests failed for $package_name${NC}"
        return 1
    fi

    # Generate HTML report if lcov.info exists
    if [ -f "coverage/lcov.info" ]; then
        echo -e "${BLUE}  🔧 Generating HTML coverage report...${NC}"
        genhtml coverage/lcov.info -o coverage/html --quiet

        echo -e "${GREEN}  ✅ Coverage report generated for $package_name${NC}"
        echo -e "${BLUE}  📁 Report location: $package_path/coverage/html/index.html${NC}"

        # Open in browser (cross-platform)
        if command -v open &> /dev/null; then
            open coverage/html/index.html
        elif command -v xdg-open &> /dev/null; then
            xdg-open coverage/html/index.html
        elif command -v start &> /dev/null; then
            start coverage\\html\\index.html
        fi
    else
        echo -e "${YELLOW}  ⚠️  No coverage data found for $package_name${NC}"
    fi

    echo ""
    cd "$ROOT_DIR"
}

# Parse arguments
TARGET="${1:-all}"

# Route to appropriate action
case $TARGET in
    all)
        echo -e "${YELLOW}Generating coverage for all apps...${NC}"
        echo ""

        # Generate coverage for all apps only
        for app in "$ROOT_DIR"/apps/*; do
            if [ -d "$app" ]; then
                run_coverage "$app"
            fi
        done
        ;;

    cubit|state_symmetric_on_cubit)
        run_coverage "$ROOT_DIR/apps/state_symmetric_on_cubit"
        ;;

    riverpod|state_symmetric_on_riverpod)
        run_coverage "$ROOT_DIR/apps/state_symmetric_on_riverpod"
        ;;

    *)
        # Try to find package/app by name
        if [ -d "$ROOT_DIR/packages/$TARGET" ]; then
            run_coverage "$ROOT_DIR/packages/$TARGET"
        elif [ -d "$ROOT_DIR/apps/$TARGET" ]; then
            run_coverage "$ROOT_DIR/apps/$TARGET"
        else
            echo -e "${RED}❌ Unknown target: $TARGET${NC}"
            echo "Usage: $0 [all|cubit|riverpod|<package_name>]"
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

echo -e "${GREEN}🎉 Coverage generation complete!${NC}"
