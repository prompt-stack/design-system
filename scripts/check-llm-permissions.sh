#!/bin/bash

# @script llm-safe-edit
# @purpose Check LLM edit permissions before modifying files
# @output console

# This script demonstrates how tools would respect LLM directives

check_edit_permission() {
    local file=$1
    local action=$2
    
    # Extract LLM directives from file header
    local llm_write=$(head -20 "$file" 2>/dev/null | grep "@llm-write" | sed 's/.*@llm-write //' | awk '{print $1}')
    
    # Default to unknown if not found
    if [ -z "$llm_write" ]; then
        llm_write="unknown"
    fi
    
    # Colors
    local GREEN='\033[0;32m'
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m'
    
    echo "File: $file"
    echo "Requested action: $action"
    echo "Permission level: @llm-write $llm_write"
    echo ""
    
    case "$llm_write" in
        "full-edit")
            echo -e "${GREEN}✅ ALLOWED${NC}: File has full-edit permission"
            return 0
            ;;
            
        "suggest-only")
            echo -e "${YELLOW}⚠️  CAUTION${NC}: This file requires careful review"
            echo "Reasons this might be suggest-only:"
            echo "- Entry point file (pages, routes, App.tsx)"
            echo "- Configuration file"
            echo "- Critical path component"
            echo ""
            echo "Recommendation: Create a suggestion comment instead of direct edit"
            return 1
            ;;
            
        "read-only")
            echo -e "${RED}❌ BLOCKED${NC}: This file is read-only"
            echo "Reasons this might be read-only:"
            echo "- API/Service file with external dependencies"
            echo "- Authentication/Security critical code"
            echo "- Generated file"
            echo "- Database models"
            echo ""
            echo "Recommendation: Discuss changes with team first"
            return 2
            ;;
            
        "unknown")
            echo -e "${YELLOW}⚠️  WARNING${NC}: No LLM directives found"
            echo "This file hasn't been tagged with permissions yet."
            echo "Run: ./add-llm-directives.sh '$file' to add directives"
            echo ""
            echo "Proceeding with caution..."
            return 0
            ;;
    esac
}

# Simulate edit scenarios
if [ "$1" = "--demo" ]; then
    echo "=== LLM Edit Permission Demo ==="
    echo ""
    
    # Test different file types
    echo "1. Trying to edit a component:"
    echo "------------------------------"
    check_edit_permission "src/components/Button.tsx" "Add new variant"
    echo ""
    
    echo "2. Trying to edit a page:"
    echo "-------------------------"
    check_edit_permission "src/pages/InboxPage.tsx" "Restructure layout"
    echo ""
    
    echo "3. Trying to edit an API service:"
    echo "----------------------------------"
    check_edit_permission "src/api/ContentInboxApi.ts" "Change endpoint"
    echo ""
    
elif [ "$1" = "--help" ]; then
    echo "Usage: $0 [--demo|--help|<file> <action>]"
    echo ""
    echo "Check if LLM can edit a file based on @llm-write directive"
    echo ""
    echo "Options:"
    echo "  --demo              Show demo with different file types"
    echo "  --help              Show this help"
    echo "  <file> <action>     Check specific file and action"
    echo ""
    echo "Exit codes:"
    echo "  0 - Edit allowed (full-edit)"
    echo "  1 - Caution required (suggest-only)"
    echo "  2 - Edit blocked (read-only)"
    
else
    if [ -z "$1" ] || [ -z "$2" ]; then
        echo "Error: Please provide file and action"
        echo "Usage: $0 <file> <action>"
        exit 1
    fi
    
    check_edit_permission "$1" "$2"
fi