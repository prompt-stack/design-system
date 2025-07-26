#!/bin/bash
# @script reorganize-scripts
# @purpose Reorganize scripts directory into logical subdirectories
# @usage ./reorganize-scripts.sh
# @description Creates organized directory structure and moves scripts to appropriate locations

set -e  # Exit on error

echo "🔧 Grammar Ops Scripts Reorganization"
echo "===================================="

# Save current directory
SCRIPTS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPTS_DIR"

# Create new directory structure
echo "📁 Creating directory structure..."
mkdir -p metadata/{add,update}
mkdir -p audit/{naming,components,compliance,meta,tests,reports}
mkdir -p validation
mkdir -p generation
mkdir -p utilities
mkdir -p lib

# Move metadata scripts
echo "📦 Moving metadata scripts..."
# Add metadata scripts
for script in add-*-metadata.sh add-llm-directives.sh add-universal-metadata.sh; do
    if [ -f "$script" ]; then
        mv "$script" metadata/add/
        echo "  ✓ Moved $script to metadata/add/"
    fi
done

# Update metadata scripts
for script in migrate-metadata.sh update-metadata-*.sh; do
    if [ -f "$script" ]; then
        mv "$script" metadata/update/
        echo "  ✓ Moved $script to metadata/update/"
    fi
done

# Scan metadata script
if [ -f "scan-metadata.sh" ]; then
    mv scan-metadata.sh metadata/
    echo "  ✓ Moved scan-metadata.sh to metadata/"
fi

# Move audit scripts
echo "📊 Moving audit scripts..."
# Naming audits
for script in audit-naming.sh audit-*-naming.sh audit-css-naming.js; do
    if [ -f "$script" ] && [[ ! "$script" =~ "compliance" ]]; then
        mv "$script" audit/naming/
        echo "  ✓ Moved $script to audit/naming/"
    fi
done

# Component audits
for script in audit-component.sh audit-all-components.sh audit-css.sh; do
    if [ -f "$script" ]; then
        mv "$script" audit/components/
        echo "  ✓ Moved $script to audit/components/"
    fi
done

# Compliance audits
for script in audit-all.sh audit-naming-compliance.sh audit-spacing-fixes.sh; do
    if [ -f "$script" ]; then
        mv "$script" audit/compliance/
        echo "  ✓ Moved $script to audit/compliance/"
    fi
done

# Meta audits
if [ -f "audit-audit-scripts.sh" ]; then
    mv audit-audit-scripts.sh audit/meta/
    echo "  ✓ Moved audit-audit-scripts.sh to audit/meta/"
fi

# Test audits
if [ -f "audit-tests.sh" ]; then
    mv audit-tests.sh audit/tests/
    echo "  ✓ Moved audit-tests.sh to audit/tests/"
fi

# Audit reports
if [ -f "AUDIT_COMPLIANCE_REPORT.md" ]; then
    mv AUDIT_COMPLIANCE_REPORT.md audit/reports/
    echo "  ✓ Moved AUDIT_COMPLIANCE_REPORT.md to audit/reports/"
fi

# Move validation scripts
echo "✅ Moving validation scripts..."
for script in validate-*.* check-*.sh find-*.sh; do
    if [ -f "$script" ]; then
        mv "$script" validation/
        echo "  ✓ Moved $script to validation/"
    fi
done

# Move generation scripts
echo "🏗️ Moving generation scripts..."
for script in generate-*.*; do
    if [ -f "$script" ]; then
        mv "$script" generation/
        echo "  ✓ Moved $script to generation/"
    fi
done

# Move utility scripts
echo "🔧 Moving utility scripts..."
for script in build-script-registry.sh rename-scripts.sh update-paths.sh; do
    if [ -f "$script" ]; then
        mv "$script" utilities/
        echo "  ✓ Moved $script to utilities/"
    fi
done

# Don't move this script itself
if [ -f "utilities/reorganize-scripts.sh" ]; then
    mv utilities/reorganize-scripts.sh .
    echo "  ✓ Kept reorganize-scripts.sh in root"
fi

echo ""
echo "✨ Reorganization complete!"
echo ""
echo "📋 New structure:"
echo "scripts/"
echo "├── metadata/"
echo "│   ├── add/         ($(ls -1 metadata/add 2>/dev/null | wc -l) scripts)"
echo "│   └── update/      ($(ls -1 metadata/update 2>/dev/null | wc -l) scripts)"
echo "├── audit/"
echo "│   ├── naming/      ($(ls -1 audit/naming 2>/dev/null | wc -l) scripts)"
echo "│   ├── components/  ($(ls -1 audit/components 2>/dev/null | wc -l) scripts)"
echo "│   ├── compliance/  ($(ls -1 audit/compliance 2>/dev/null | wc -l) scripts)"
echo "│   ├── meta/        ($(ls -1 audit/meta 2>/dev/null | wc -l) scripts)"
echo "│   ├── tests/       ($(ls -1 audit/tests 2>/dev/null | wc -l) scripts)"
echo "│   └── reports/     ($(ls -1 audit/reports 2>/dev/null | wc -l) files)"
echo "├── validation/      ($(ls -1 validation 2>/dev/null | wc -l) scripts)"
echo "├── generation/      ($(ls -1 generation 2>/dev/null | wc -l) scripts)"
echo "├── utilities/       ($(ls -1 utilities 2>/dev/null | wc -l) scripts)"
echo "└── lib/            ($(ls -1 lib 2>/dev/null | wc -l) files)"
echo ""
echo "💡 Next steps:"
echo "1. Review the new organization"
echo "2. Update any scripts that reference other scripts with new paths"
echo "3. Create README files in each directory"
echo "4. Consider creating shared functions in lib/"