#!/bin/bash

# Script to create a new Flutter app using VeryGood CLI
# Usage: ./scripts/vgv_cli/create_app.sh --app_name <app_name>
# Or: ./scripts/vgv_cli/create_app.sh <app_name>

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

echo -e "${BLUE}📱 VeryGood Flutter App Creator${NC}"
echo ""

# Parse arguments
APP_NAME=""
while [[ $# -gt 0 ]]; do
    case $1 in
        --app_name)
            APP_NAME="$2"
            shift 2
            ;;
        *)
            # Support positional argument as well
            if [ -z "$APP_NAME" ]; then
                APP_NAME="$1"
            fi
            shift
            ;;
    esac
done

# Check if app name is provided
if [ -z "$APP_NAME" ]; then
    echo -e "${RED}❌ Error: App name is required${NC}"
    echo "Usage: $0 --app_name <app_name>"
    echo "   or: $0 <app_name>"
    echo ""
    echo "Example: $0 --app_name my_new_app"
    echo "     or: $0 my_new_app"
    exit 1
fi
APPS_DIR="$ROOT_DIR/apps"

echo -e "${YELLOW}🔨 Creating Flutter app: $APP_NAME${NC}"
echo "Target directory: $APPS_DIR/$APP_NAME"
echo ""

# Check if app already exists
if [ -d "$APPS_DIR/$APP_NAME" ]; then
    echo -e "${RED}❌ Error: App '$APP_NAME' already exists in $APPS_DIR${NC}"
    exit 1
fi

# Create the app
cd "$APPS_DIR"
echo -e "${YELLOW}Running: very_good create flutter_app $APP_NAME${NC}"
very_good create flutter_app "$APP_NAME"

echo ""
echo -e "${GREEN}✅ Flutter app '$APP_NAME' created successfully!${NC}"
echo -e "${BLUE}📁 Location: $APPS_DIR/$APP_NAME${NC}"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "  1. cd apps/$APP_NAME"
echo "  2. flutter pub get"
echo "  3. flutter run"
