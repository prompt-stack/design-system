#!/bin/bash

# Add Test Metadata Script
# Adds test-related metadata to source files

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Function to determine test coverage target based on file type
get_coverage_target() {
    local file=$1
    
    # Critical components get higher coverage targets
    if [[ "$file" == *"/hooks/"* ]]; then
        echo "90"
    elif [[ "$file" == *"/services/"* ]] || [[ "$file" == *"/utils/"* ]]; then
        echo "95"
    elif [[ "$file" == *"/components/"* ]]; then
        echo "80"
    else
        echo "70"
    fi
}

# Function to get test file name
get_test_file() {
    local file=$1
    local base="${file%.*}"
    local ext="${file##*.}"
    
    if [[ "$ext" == "tsx" ]] || [[ "$ext" == "ts" ]]; then
        echo "${base}.test.${ext}"
    else
        echo ""
    fi
}

# Function to check if test file exists
test_exists() {
    local test_file=$1
    [[ -f "$test_file" ]]
}

# Function to add test metadata to a file
add_test_metadata() {
    local file=$1
    
    # Skip test files themselves
    if [[ "$file" == *.test.* ]] || [[ "$file" == *.spec.* ]]; then
        return
    fi
    
    # Skip if file doesn't exist
    if [[ ! -f "$file" ]]; then
        echo -e "${RED}File not found: $file${NC}"
        return 1
    fi
    
    # Check if test metadata already exists
    if grep -q "@test-coverage\|@test-file" "$file" 2>/dev/null; then
        echo -e "${YELLOW}Test metadata already exists in $file${NC}"
        return 0
    fi
    
    # Get metadata values
    local coverage_target=$(get_coverage_target "$file")
    local test_file=$(get_test_file "$file")
    local test_status="missing"
    
    if [[ -n "$test_file" ]] && test_exists "$test_file"; then
        test_status="exists"
    fi
    
    # Create temporary file
    local temp_file=$(mktemp)
    
    # Process the file
    local in_header=false
    local header_ended=false
    local metadata_added=false
    
    while IFS= read -r line; do
        if [[ "$line" == "/**" ]] && [[ "$header_ended" == false ]]; then
            in_header=true
            echo "$line" >> "$temp_file"
        elif [[ "$line" == " */" ]] && [[ "$in_header" == true ]]; then
            # Add test metadata before closing comment
            if [[ "$metadata_added" == false ]]; then
                if [[ -n "$test_file" ]]; then
                    echo " * @test-coverage $coverage_target" >> "$temp_file"
                    echo " * @test-file $(basename "$test_file")" >> "$temp_file"
                    echo " * @test-status $test_status" >> "$temp_file"
                fi
                metadata_added=true
            fi
            echo "$line" >> "$temp_file"
            in_header=false
            header_ended=true
        else
            echo "$line" >> "$temp_file"
        fi
    done < "$file"
    
    # If no header found, add one
    if [[ "$metadata_added" == false ]] && [[ -n "$test_file" ]]; then
        # Create new header
        {
            echo "/**"
            echo " * @test-coverage $coverage_target"
            echo " * @test-file $(basename "$test_file")"
            echo " * @test-status $test_status"
            echo " */"
            echo ""
            cat "$file"
        } > "$temp_file"
    fi
    
    # Replace original file
    mv "$temp_file" "$file"
    
    if [[ "$test_status" == "exists" ]]; then
        echo -e "${GREEN}✓${NC} Added test metadata to $file (test exists)"
    else
        echo -e "${YELLOW}✓${NC} Added test metadata to $file (test missing)"
    fi
}

# Main execution
if [[ $# -eq 0 ]]; then
    echo "Usage: $0 <file|directory>"
    echo "Examples:"
    echo "  $0 src/components/Button.tsx"
    echo "  $0 src/components/"
    echo "  $0 src/"
    exit 1
fi

target=$1

if [[ -f "$target" ]]; then
    # Single file
    add_test_metadata "$target"
elif [[ -d "$target" ]]; then
    # Directory - process all TypeScript files
    echo "Processing directory: $target"
    
    file_count=0
    updated_count=0
    
    while IFS= read -r file; do
        ((file_count++))
        if add_test_metadata "$file"; then
            ((updated_count++))
        fi
    done < <(find "$target" -name "*.ts" -o -name "*.tsx" | grep -v node_modules | grep -v ".test." | grep -v ".spec.")
    
    echo
    echo "Summary:"
    echo "Files processed: $file_count"
    echo "Files updated: $updated_count"
else
    echo -e "${RED}Error: $target is neither a file nor a directory${NC}"
    exit 1
fi