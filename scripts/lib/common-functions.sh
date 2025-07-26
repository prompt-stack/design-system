#!/bin/bash
# Common functions for Grammar Ops scripts
# Source this file in scripts: source "$(dirname "$0")/../lib/common-functions.sh"

# Color codes for output
readonly COLOR_RED='\033[0;31m'
readonly COLOR_GREEN='\033[0;32m'
readonly COLOR_YELLOW='\033[0;33m'
readonly COLOR_BLUE='\033[0;34m'
readonly COLOR_RESET='\033[0m'

# Unicode symbols
readonly SYMBOL_SUCCESS="✅"
readonly SYMBOL_ERROR="❌"
readonly SYMBOL_WARNING="⚠️"
readonly SYMBOL_INFO="ℹ️"

# Common paths
readonly GRAMMAR_OPS_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
readonly SCRIPTS_DIR="$GRAMMAR_OPS_ROOT/scripts"
readonly CONFIG_FILE="$GRAMMAR_OPS_ROOT/.grammarops.config.json"

# Logging functions
log_info() {
    echo -e "${COLOR_BLUE}${SYMBOL_INFO}${COLOR_RESET} $*"
}

log_success() {
    echo -e "${COLOR_GREEN}${SYMBOL_SUCCESS}${COLOR_RESET} $*"
}

log_error() {
    echo -e "${COLOR_RED}${SYMBOL_ERROR}${COLOR_RESET} $*" >&2
}

log_warning() {
    echo -e "${COLOR_YELLOW}${SYMBOL_WARNING}${COLOR_RESET} $*"
}

# Check if required commands exist
check_dependencies() {
    local deps=("$@")
    local missing=()
    
    for cmd in "${deps[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            missing+=("$cmd")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log_error "Missing required dependencies: ${missing[*]}"
        log_info "Install with: brew install ${missing[*]} (macOS) or apt-get install ${missing[*]} (Linux)"
        return 1
    fi
    
    return 0
}

# Load Grammar Ops configuration
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        echo "$(cat "$CONFIG_FILE")"
    else
        echo "{}"
    fi
}

# Get config value using jq
get_config_value() {
    local key="$1"
    local default="${2:-}"
    local config=$(load_config)
    
    local value=$(echo "$config" | jq -r "$key // empty" 2>/dev/null)
    
    if [ -z "$value" ]; then
        echo "$default"
    else
        echo "$value"
    fi
}

# Check if file should be processed
should_process_file() {
    local file="$1"
    local exclude_patterns=(
        "node_modules/"
        "vendor/"
        "build/"
        "dist/"
        ".git/"
        "*.min.js"
        "*.bundle.js"
        "*.generated.*"
    )
    
    # Check against exclude patterns
    for pattern in "${exclude_patterns[@]}"; do
        if [[ "$file" == *"$pattern"* ]]; then
            return 1
        fi
    done
    
    # Check against config excludes
    local config_excludes=$(get_config_value '.exclude[]' | tr '\n' ' ')
    for pattern in $config_excludes; do
        if [[ "$file" == *"$pattern"* ]]; then
            return 1
        fi
    done
    
    return 0
}

# Get file type for metadata
get_file_type() {
    local file="$1"
    local filename=$(basename "$file")
    local ext="${filename##*.}"
    
    case "$ext" in
        js|jsx) echo "javascript" ;;
        ts|tsx) echo "typescript" ;;
        py) echo "python" ;;
        sh|bash) echo "shell" ;;
        css|scss|sass) echo "styles" ;;
        html) echo "markup" ;;
        json) echo "config" ;;
        md) echo "documentation" ;;
        *) echo "unknown" ;;
    esac
}

# Extract metadata from file
extract_metadata() {
    local file="$1"
    local field="$2"
    
    # Try different comment styles
    local metadata=$(head -20 "$file" | grep -E "@$field" | head -1)
    
    if [ -n "$metadata" ]; then
        # Extract value after field name
        echo "$metadata" | sed -E "s/.*@$field[[:space:]]+//" | sed 's/[[:space:]]*$//'
    fi
}

# Check if file has metadata
has_metadata() {
    local file="$1"
    local metadata=$(head -20 "$file" | grep -E "@(file|purpose|layer|deps)")
    
    if [ -n "$metadata" ]; then
        return 0
    else
        return 1
    fi
}

# Get appropriate comment style for file
get_comment_style() {
    local file="$1"
    local ext="${file##*.}"
    
    case "$ext" in
        js|jsx|ts|tsx|css|scss|sass)
            echo "/* */"
            ;;
        py|sh|bash|yml|yaml)
            echo "#"
            ;;
        html|xml)
            echo "<!-- -->"
            ;;
        *)
            echo "//"
            ;;
    esac
}

# Count files in directory
count_files() {
    local dir="$1"
    local pattern="${2:-*}"
    
    find "$dir" -type f -name "$pattern" 2>/dev/null | wc -l | tr -d ' '
}

# Create backup of file
backup_file() {
    local file="$1"
    local backup_dir="${2:-.grammar-ops-backup}"
    
    mkdir -p "$backup_dir"
    cp "$file" "$backup_dir/$(basename "$file").$(date +%Y%m%d_%H%M%S).bak"
}

# Run command with progress indicator
with_progress() {
    local message="$1"
    shift
    
    echo -n "$message"
    
    # Run command in background
    "$@" &
    local pid=$!
    
    # Show spinner
    local spin='-\|/'
    local i=0
    while kill -0 $pid 2>/dev/null; do
        i=$(( (i+1) %4 ))
        printf "\r$message ${spin:$i:1}"
        sleep .1
    done
    
    wait $pid
    local result=$?
    
    # Clear spinner and show result
    if [ $result -eq 0 ]; then
        printf "\r$message ✅\n"
    else
        printf "\r$message ❌\n"
    fi
    
    return $result
}

# Parse command line options
parse_options() {
    local -n opts=$1
    shift
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --dry-run)
                opts[dry_run]=true
                shift
                ;;
            --verbose|-v)
                opts[verbose]=true
                shift
                ;;
            --strict)
                opts[strict]=true
                shift
                ;;
            --format)
                opts[format]="$2"
                shift 2
                ;;
            --exclude)
                opts[exclude]="$2"
                shift 2
                ;;
            --help|-h)
                opts[help]=true
                shift
                ;;
            *)
                opts[args]+="$1 "
                shift
                ;;
        esac
    done
}

# Generate summary report
generate_summary() {
    local title="$1"
    local passed="$2"
    local failed="$3"
    local total=$((passed + failed))
    local percentage=0
    
    if [ $total -gt 0 ]; then
        percentage=$(( (passed * 100) / total ))
    fi
    
    echo ""
    echo "═══════════════════════════════════════"
    echo " $title"
    echo "═══════════════════════════════════════"
    echo ""
    
    if [ $percentage -ge 90 ]; then
        echo -e "${COLOR_GREEN}Overall Score: $percentage% ($passed/$total)${COLOR_RESET}"
    elif [ $percentage -ge 70 ]; then
        echo -e "${COLOR_YELLOW}Overall Score: $percentage% ($passed/$total)${COLOR_RESET}"
    else
        echo -e "${COLOR_RED}Overall Score: $percentage% ($passed/$total)${COLOR_RESET}"
    fi
    
    echo ""
    echo "✅ Passed: $passed"
    echo "❌ Failed: $failed"
    echo ""
}

# Export all functions
export -f log_info log_success log_error log_warning
export -f check_dependencies load_config get_config_value
export -f should_process_file get_file_type
export -f extract_metadata has_metadata get_comment_style
export -f count_files backup_file with_progress
export -f parse_options generate_summary