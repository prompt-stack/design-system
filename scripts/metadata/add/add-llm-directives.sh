#!/bin/bash

# @script add-llm-directives
# @purpose Add LLM navigation directives to file metadata
# @output console

# Script to add @llm-read, @llm-write, and @llm-role to files

determine_write_permission() {
    local file=$1
    
    # Read-only patterns
    if [[ $file =~ (api/|services/|auth/|\.generated\.|\.config\.) ]]; then
        echo "read-only"
    # Suggest-only patterns
    elif [[ $file =~ (pages/|routes/|App\.tsx|main\.tsx|index\.tsx) ]]; then
        echo "suggest-only"
    # Full edit for everything else
    else
        echo "full-edit"
    fi
}

determine_role() {
    local file=$1
    
    # Async service patterns
    if [[ $file =~ (api/|services/|Service\.ts|Api\.ts) ]]; then
        echo "async-service"
    # Entry point patterns
    elif [[ $file =~ (pages/|routes/|App\.tsx|main\.tsx|index\.tsx) ]]; then
        echo "entrypoint"
    # Pure view patterns
    elif [[ $file =~ (Display|View|List|Table)\.tsx$ ]]; then
        echo "pure-view"
    # Default to utility
    else
        echo "utility"
    fi
}

should_read_file() {
    local file=$1
    
    # Skip patterns
    if [[ $file =~ (node_modules/|dist/|build/|\.min\.|bundle\.|vendor/) ]]; then
        echo "false"
    else
        echo "true"
    fi
}

add_directives_to_file() {
    local file=$1
    
    # Skip if already has LLM directives
    if grep -q "@llm-read" "$file" 2>/dev/null; then
        echo "✓ Already has LLM directives: $file"
        return
    fi
    
    # Skip if no metadata block exists
    if ! head -20 "$file" | grep -q "^ \* @" 2>/dev/null; then
        echo "⚠ No metadata block found: $file"
        return
    fi
    
    # Determine directives
    local llm_read=$(should_read_file "$file")
    local llm_write=$(determine_write_permission "$file")
    local llm_role=$(determine_role "$file")
    
    # Find the last @ metadata line
    local last_meta_line=$(grep -n "^ \* @" "$file" | tail -1 | cut -d: -f1)
    
    if [ -z "$last_meta_line" ]; then
        echo "⚠ Could not find metadata lines: $file"
        return
    fi
    
    # Insert LLM directives after the last metadata line
    local directives=" * @llm-read $llm_read\n * @llm-write $llm_write\n * @llm-role $llm_role"
    
    # Use sed to insert the directives
    sed -i.bak "${last_meta_line}a\\
$directives" "$file"
    
    # Remove backup
    rm -f "${file}.bak"
    
    echo "✅ Added LLM directives to: $file"
    echo "   @llm-read: $llm_read"
    echo "   @llm-write: $llm_write"
    echo "   @llm-role: $llm_role"
}

# Demo mode - show what would be added
demo_mode() {
    local file=$1
    
    echo "File: $file"
    echo "  @llm-read: $(should_read_file "$file")"
    echo "  @llm-write: $(determine_write_permission "$file")"
    echo "  @llm-role: $(determine_role "$file")"
    echo ""
}

# Main execution
if [ "$1" = "--demo" ]; then
    echo "=== LLM Directives Demo ==="
    echo ""
    
    # Show examples for different file types
    demo_mode "src/components/Button.tsx"
    demo_mode "src/pages/InboxPage.tsx"
    demo_mode "src/api/ContentInboxApi.ts"
    demo_mode "src/features/content-inbox/ContentInbox.tsx"
    demo_mode "src/hooks/useContentQueue.ts"
    demo_mode "src/auth/TokenValidator.ts"
    demo_mode "src/components/ListView.tsx"
    
elif [ "$1" = "--help" ]; then
    echo "Usage: $0 [--demo|--help|<file>]"
    echo ""
    echo "Add LLM directives to file metadata"
    echo ""
    echo "Options:"
    echo "  --demo    Show what directives would be added to example files"
    echo "  --help    Show this help"
    echo "  <file>    Add directives to specific file"
    echo ""
    echo "Example:"
    echo "  $0 src/components/Button.tsx"
    echo "  find src -name '*.tsx' -exec $0 {} \;"
    
else
    if [ -z "$1" ]; then
        echo "Error: Please provide a file path or use --demo/--help"
        exit 1
    fi
    
    add_directives_to_file "$1"
fi