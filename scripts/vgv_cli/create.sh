#!/bin/bash

# Script to create Flutter app or package using VeryGood CLI
# Usage: ./scripts/vgv_cli/create.sh app --my_new_app
# Usage: ./scripts/vgv_cli/create.sh pkg --my_new_package

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Root directory
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Check if type is provided
if [ -z "$1" ]; then
    echo -e "${RED}❌ Error: Type is required (app or pkg)${NC}"
    echo "Usage: $0 <app|pkg> <--name|name>"
    echo ""
    echo "Examples:"
    echo "  $0 app --my_new_app"
    echo "  $0 pkg --my_new_package"
    exit 1
fi

TYPE="$1"
shift

# Parse name from arguments
NAME=""
for arg in "$@"; do
    if [[ $arg == --* ]]; then
        # Remove leading --
        NAME="${arg#--}"
    else
        NAME="$arg"
    fi
done

# Check if name is provided
if [ -z "$NAME" ]; then
    echo -e "${RED}❌ Error: Name is required${NC}"
    echo "Usage: $0 <app|pkg> <--name|name>"
    echo ""
    echo "Examples:"
    echo "  $0 app --my_new_app"
    echo "  $0 pkg --my_new_package"
    exit 1
fi

# Route to appropriate script
case $TYPE in
    app)
        bash "$ROOT_DIR/scripts/vgv_cli/create_app.sh" "$NAME"
        ;;
    pkg|package)
        bash "$ROOT_DIR/scripts/vgv_cli/create_package.sh" "$NAME"
        ;;
    *)
        echo -e "${RED}❌ Error: Invalid type '$TYPE'${NC}"
        echo "Usage: $0 <app|pkg> <--name|name>"
        echo ""
        echo "Valid types: app, pkg"
        exit 1
        ;;
esac
