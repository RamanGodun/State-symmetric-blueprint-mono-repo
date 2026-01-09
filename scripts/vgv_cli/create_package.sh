#!/bin/bash

# Script to create a new Flutter package using VeryGood CLI
# Usage: ./scripts/vgv_cli/create_package.sh --package_name <package_name>
# Or: ./scripts/vgv_cli/create_package.sh <package_name>

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}📦 VeryGood Flutter Package Creator${NC}"
echo ""

# Parse arguments
PACKAGE_NAME=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --package_name)
            PACKAGE_NAME="$2"
            shift 2
            ;;
        *)
            # Support positional argument as well
            if [ -z "$PACKAGE_NAME" ]; then
                PACKAGE_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Check if package name is provided
if [ -z "$PACKAGE_NAME" ]; then
    echo -e "${RED}❌ Error: Package name is required${NC}"
    echo "Usage: $0 --package_name <package_name>"
    echo "   or: $0 <package_name>"
    echo ""
    echo "Example: $0 --package_name my_new_package"
    echo "     or: $0 my_new_package"
    exit 1
fi
PACKAGES_DIR="$ROOT_DIR/packages"

echo -e "${YELLOW}🔨 Creating Flutter package: $PACKAGE_NAME${NC}"
echo "Target directory: $PACKAGES_DIR/$PACKAGE_NAME"
echo ""

# Check if package already exists
if [ -d "$PACKAGES_DIR/$PACKAGE_NAME" ]; then
    echo -e "${RED}❌ Error: Package '$PACKAGE_NAME' already exists in $PACKAGES_DIR${NC}"
    exit 1
fi

# Create the package
cd "$PACKAGES_DIR"
echo -e "${YELLOW}Running: very_good create flutter_package $PACKAGE_NAME${NC}"
very_good create flutter_package "$PACKAGE_NAME"

echo ""
echo -e "${GREEN}✅ Flutter package '$PACKAGE_NAME' created successfully!${NC}"
echo -e "${BLUE}📁 Location: $PACKAGES_DIR/$PACKAGE_NAME${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd packages/$PACKAGE_NAME"
echo "  2. flutter pub get"
echo "  3. Add the package to your app's pubspec.yaml"
