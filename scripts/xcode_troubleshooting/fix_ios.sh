#!/bin/bash

# Quick fix for iOS concurrent build errors
# Kills xcodebuild and cleans current directory
# Usage: ./scripts/xcode_troubleshooting/fix_ios.sh

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🔧 Quick iOS build fix...${NC}"
echo ""

# Kill xcodebuild processes
echo -e "${YELLOW}🔫 Killing xcodebuild processes...${NC}"
killall xcodebuild 2>/dev/null || true
echo ""

# Run flutter clean in current directory
echo -e "${YELLOW}🧹 Running flutter clean in current directory...${NC}"
flutter clean

echo ""
echo -e "${GREEN}✅ iOS build fix complete!${NC}"
echo -e "${GREEN}   You can now try building again.${NC}"
