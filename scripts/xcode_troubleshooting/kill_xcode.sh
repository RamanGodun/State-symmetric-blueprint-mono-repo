#!/bin/bash

# Script to kill all xcodebuild processes
# Usage: ./scripts/xcode_troubleshooting/kill_xcode.sh

# Colors for output
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo -e "${YELLOW}🔫 Killing all xcodebuild processes...${NC}"

killall xcodebuild 2>/dev/null || true

if [ $? -eq 0 ]; then
    echo -e "${GREEN}✅ All xcodebuild processes killed${NC}"
else
    echo -e "${GREEN}✅ No xcodebuild processes were running${NC}"
fi
