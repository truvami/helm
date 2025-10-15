#!/usr/bin/env bash
set -euo pipefail

# Changelog generation script using git-cliff
# Usage: ./scripts/changelog.sh [--tag TAG] [--unreleased] [--output FILE]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default values
OUTPUT_FILE="CHANGELOG.md"
TAG=""
UNRELEASED=false
HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --tag)
            TAG="$2"
            shift 2
            ;;
        --unreleased)
            UNRELEASED=true
            shift
            ;;
        --output)
            OUTPUT_FILE="$2"
            shift 2
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            echo "Unknown option: $1"
            exit 1
            ;;
    esac
done

if [[ "$HELP" == "true" ]]; then
    cat << EOF
Changelog Generation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --tag TAG       Generate changelog for specific tag/version
    --unreleased    Generate changelog for unreleased changes
    --output FILE   Output file (default: CHANGELOG.md)
    --help, -h      Show this help message

EXAMPLES:
    # Generate full changelog
    $0

    # Generate changelog for specific version
    $0 --tag v1.2.0

    # Generate unreleased changes only
    $0 --unreleased

    # Output to custom file
    $0 --output docs/CHANGELOG.md

REQUIREMENTS:
    - git-cliff must be installed: cargo install git-cliff
    - Or via package manager: brew install git-cliff

EOF
    exit 0
fi

# Check if git-cliff is installed
if ! command -v git-cliff &> /dev/null; then
    echo "❌ git-cliff is not installed!"
    echo "Install with:"
    echo "  cargo install git-cliff"
    echo "  # or"
    echo "  brew install git-cliff"
    exit 1
fi

cd "$PROJECT_ROOT"

echo "🔍 Generating changelog..."

# Build git-cliff command
CLIFF_CMD="git-cliff"

if [[ -n "$TAG" ]]; then
    CLIFF_CMD="$CLIFF_CMD --tag $TAG"
elif [[ "$UNRELEASED" == "true" ]]; then
    CLIFF_CMD="$CLIFF_CMD --unreleased"
fi

CLIFF_CMD="$CLIFF_CMD --output $OUTPUT_FILE"

echo "📝 Running: $CLIFF_CMD"
eval "$CLIFF_CMD"

echo "✅ Changelog generated: $OUTPUT_FILE"

# Show a preview of the generated content
if [[ "$OUTPUT_FILE" == "CHANGELOG.md" && -f "$OUTPUT_FILE" ]]; then
    echo ""
    echo "📋 Preview (first 20 lines):"
    echo "================================"
    head -20 "$OUTPUT_FILE"

    if [[ $(wc -l < "$OUTPUT_FILE") -gt 20 ]]; then
        echo "..."
        echo "📄 Full changelog: $OUTPUT_FILE"
    fi
fi
