#!/bin/bash

# Grammar-Ops Quick Start Script
# This script helps you get started with Grammar-Ops

set -e

GRAMMAR_OPS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="${1:-$(pwd)}"

echo "🚀 Grammar-Ops Quick Start"
echo "========================="
echo ""
echo "Grammar-Ops Directory: $GRAMMAR_OPS_DIR"
echo "Project Directory: $PROJECT_DIR"
echo ""

# Add to PATH temporarily
export PATH="$GRAMMAR_OPS_DIR/bin:$PATH"

# Step 1: Detect frameworks
echo "📍 Step 1: Detecting frameworks..."
echo "---------------------------------"
grammar-ops detect "$PROJECT_DIR"
echo ""

# Step 2: Learn from code
echo "📚 Step 2: Learning from your code..."
echo "------------------------------------"
grammar-ops learn "$PROJECT_DIR" -o "$PROJECT_DIR/.grammarops.learned.json"
echo ""

# Step 3: Analyze
echo "🔍 Step 3: Analyzing code..."
echo "---------------------------"
grammar-ops analyze "$PROJECT_DIR"
echo ""

# Show next steps
echo "✅ Quick Start Complete!"
echo ""
echo "📋 Next Steps:"
echo "-------------"
echo "1. Review generated config:"
echo "   cat $PROJECT_DIR/.grammarops.learned.json"
echo ""
echo "2. Customize and save as .grammarops.config.json:"
echo "   cp $PROJECT_DIR/.grammarops.learned.json $PROJECT_DIR/.grammarops.config.json"
echo ""
echo "3. See detailed issues:"
echo "   grammar-ops analyze $PROJECT_DIR --verbose"
echo ""
echo "4. Try interactive migration:"
echo "   grammar-ops migrate $PROJECT_DIR --dry-run"
echo ""
echo "5. Add to PATH permanently:"
echo "   echo 'export PATH=\"$GRAMMAR_OPS_DIR/bin:\$PATH\"' >> ~/.bashrc"
echo ""
echo "📚 For more info: cat $GRAMMAR_OPS_DIR/docs/GETTING_STARTED.md"