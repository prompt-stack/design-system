#!/bin/bash

# @script audit-database-naming
# @purpose Check SQL files and database objects follow naming conventions
# @output console
# @llm-read true
# @llm-write full-edit
# @llm-role utility

# Colors
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🗄️  Database Naming Audit${NC}"
echo "========================="
echo ""

ISSUES=0

# Check for SQL files
echo -e "${BLUE}=== SQL File Naming ===${NC}"

# Check migrations
if [ -d "database/migrations" ] || [ -d "migrations" ]; then
    echo "Checking migration files..."
    find . -path "*/migrations/*.sql" -o -path "*/migrations/*.ts" | while read file; do
        filename=$(basename "$file")
        
        # Should match pattern: {timestamp}_{action}_{target}
        if ! echo "$filename" | grep -qE '^[0-9]{8,14}_[a-z]+_[a-z_]+\.(sql|ts)$'; then
            echo -e "${RED}❌ $filename${NC} - should be {timestamp}_{action}_{target}"
            echo "   Example: 20240121_create_users_table.sql"
            ISSUES=$((ISSUES + 1))
        else
            echo -e "${GREEN}✓ $filename${NC}"
        fi
    done
else
    echo -e "${YELLOW}No migrations directory found${NC}"
fi

# Check for table naming in SQL files
echo -e "\n${BLUE}=== Table Naming in SQL ===${NC}"
find . -name "*.sql" -not -path "./node_modules/*" | while read file; do
    # Look for CREATE TABLE statements
    grep -iE "CREATE TABLE" "$file" | while read line; do
        if echo "$line" | grep -iE "CREATE TABLE.*[A-Z]" | grep -v "IF NOT EXISTS"; then
            echo -e "${RED}❌ Found uppercase in table name:${NC}"
            echo "   File: $file"
            echo "   Line: $line"
            echo "   Tables should be plural_snake_case"
            ISSUES=$((ISSUES + 1))
        fi
    done
done

# Check Prisma schema if exists
if [ -f "prisma/schema.prisma" ]; then
    echo -e "\n${BLUE}=== Prisma Model Naming ===${NC}"
    grep -E "^model " prisma/schema.prisma | while read line; do
        model_name=$(echo "$line" | awk '{print $2}')
        
        # Models should be singular PascalCase
        if ! echo "$model_name" | grep -qE '^[A-Z][a-zA-Z0-9]+$'; then
            echo -e "${RED}❌ Model '$model_name'${NC} - should be singular PascalCase"
            ISSUES=$((ISSUES + 1))
        else
            echo -e "${GREEN}✓ Model '$model_name'${NC}"
        fi
    done
fi

# Check for common SQL anti-patterns
echo -e "\n${BLUE}=== SQL Anti-patterns ===${NC}"
find . -name "*.sql" -not -path "./node_modules/*" | while read file; do
    # Check for camelCase in SQL
    if grep -qE "(CREATE|ALTER).*[a-z][A-Z]" "$file"; then
        echo -e "${YELLOW}⚠ Possible camelCase in SQL:${NC} $file"
        echo "   SQL should use snake_case"
    fi
    
    # Check for missing timestamps
    if grep -iE "CREATE TABLE" "$file" > /dev/null; then
        if ! grep -iE "(created_at|updated_at)" "$file" > /dev/null; then
            echo -e "${YELLOW}⚠ Missing timestamps:${NC} $file"
            echo "   Consider adding created_at, updated_at"
        fi
    fi
done

# Check repository method naming
echo -e "\n${BLUE}=== Repository Method Naming ===${NC}"
find . -name "*Repository.ts" -o -name "*Repository.js" | while read file; do
    echo "Checking: $file"
    
    # Check for standard repository methods
    for method in "findById" "findAll" "create" "update" "delete"; do
        if grep -q "function $method\|$method.*=\|$method(" "$file"; then
            echo -e "${GREEN}  ✓ Has standard method: $method${NC}"
        fi
    done
    
    # Check for non-standard patterns
    if grep -qE "(get[A-Z]|fetch[A-Z])" "$file"; then
        echo -e "${YELLOW}  ⚠ Uses get/fetch instead of find${NC}"
        echo "     Repository pattern prefers: findBy*, findAll"
    fi
done

# Summary
echo -e "\n${BLUE}=== Summary ===${NC}"
echo "Database Naming Conventions:"
echo "- Tables: plural_snake_case (users, user_profiles)"
echo "- Columns: snake_case (user_id, email_address)"
echo "- Primary keys: {table_singular}_id"
echo "- Foreign keys: {related_table_singular}_id"
echo "- Indexes: idx_{table}_{columns}"
echo "- Migrations: {timestamp}_{action}_{target}.sql"

if [ $ISSUES -eq 0 ]; then
    echo -e "\n${GREEN}✅ All database naming follows conventions!${NC}"
else
    echo -e "\n${RED}❌ Found $ISSUES naming issues${NC}"
fi

exit $ISSUES