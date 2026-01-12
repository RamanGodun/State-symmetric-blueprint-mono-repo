#!/bin/bash

# Script to clean iOS build artifacts for specific app
# Usage: ./scripts/xcode_troubleshooting/clean_ios.sh [riverpod|cubit]

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Parse arguments
APP="${1:-}"

if [ -z "$APP" ]; then
    echo -e "${RED}❌ Error: Please specify app (riverpod or cubit)${NC}"
    echo "Usage: $0 [riverpod|cubit]"
    exit 1
fi

# Map app to full package name
case $APP in
    riverpod)
        PACKAGE_NAME="state_symmetric_on_riverpod"
        ;;
    cubit)
        PACKAGE_NAME="state_symmetric_on_cubit"
        ;;
    *)
        echo -e "${RED}❌ Error: Invalid app '$APP'. Must be 'riverpod' or 'cubit'${NC}"
        exit 1
        ;;
esac

echo -e "${BLUE}🧹 Cleaning iOS build for $PACKAGE_NAME...${NC}"
echo ""

# Kill xcodebuild processes
echo -e "${YELLOW}🔫 Killing xcodebuild processes...${NC}"
killall xcodebuild 2>/dev/null || true
echo ""

# Run flutter clean
echo -e "${YELLOW}🧹 Running flutter clean...${NC}"
cd "$ROOT_DIR"
melos exec --scope="$PACKAGE_NAME" --concurrency=1 -- "flutter clean"

echo ""
echo -e "${GREEN}✅ iOS build cleaned for $PACKAGE_NAME!${NC}"
