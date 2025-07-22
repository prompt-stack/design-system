#!/bin/bash

# @script update-paths
# @purpose Update all design-system references to grammar-ops
# @output console

echo "Updating all design-system references to grammar-ops..."

# Update in all shell scripts
find grammar-ops/scripts -name "*.sh" -type f | while read file; do
    echo "Updating $file"
    sed -i '' 's/design-system\/scripts/grammar-ops\/scripts/g' "$file"
    sed -i '' 's/design-system\/docs/grammar-ops\/docs/g' "$file"
    sed -i '' 's/design-system\/config/grammar-ops\/config/g' "$file"
    sed -i '' 's/design-system\/script-registry/grammar-ops\/script-registry/g' "$file"
    sed -i '' 's/design-system\/audit-/grammar-ops\/audit-/g' "$file"
done

# Update in JavaScript files
find grammar-ops/scripts -name "*.js" -type f | while read file; do
    echo "Updating $file"
    sed -i '' 's/design-system/grammar-ops/g' "$file"
done

# Update in config files
find grammar-ops/config -name "*.json" -type f | while read file; do
    echo "Updating $file"
    sed -i '' 's/design-system/grammar-ops/g' "$file"
done

# Update in markdown docs
find grammar-ops/docs -name "*.md" -type f | while read file; do
    echo "Updating $file"
    sed -i '' 's/design-system/grammar-ops/g' "$file"
done

# Update in root config files
find config -name "*.ts" -name "*.js" -type f | while read file; do
    echo "Updating $file"
    sed -i '' 's/@design-system/@grammar-ops/g' "$file"
    sed -i '' 's/design-system/grammar-ops/g' "$file"
done

echo "✅ Path updates complete!"