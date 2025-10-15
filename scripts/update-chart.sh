#!/usr/bin/env bash
set -euo pipefail

# Chart version management script
# Usage: ./scripts/update-chart.sh [CHART_NAME] [NEW_VERSION] [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default values
CHART_NAME=""
NEW_VERSION=""
DRY_RUN=false
HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --help|-h)
            HELP=true
            shift
            ;;
        *)
            if [[ -z "$CHART_NAME" ]]; then
                CHART_NAME="$1"
            elif [[ -z "$NEW_VERSION" ]]; then
                NEW_VERSION="$1"
            else
                echo "Unknown option: $1"
                exit 1
            fi
            shift
            ;;
    esac
done

if [[ "$HELP" == "true" ]]; then
    cat << EOF
Chart Version Management Script

USAGE:
    $0 CHART_NAME NEW_VERSION [OPTIONS]

ARGUMENTS:
    CHART_NAME     Name of the chart to update (e.g., truvami-api)
    NEW_VERSION    New version for the chart (e.g., 0.0.28)

OPTIONS:
    --dry-run      Show what would be done without making changes
    --help, -h     Show this help message

EXAMPLES:
    # Update truvami-api chart to version 0.0.28
    $0 truvami-api 0.0.28

    # Dry run to see what would be updated
    $0 truvami-api 0.0.28 --dry-run

DESCRIPTION:
    This script updates the version of a specific chart and automatically
    updates any references to it in the stack chart's dependencies.

    It performs the following actions:
    1. Updates the version in the chart's Chart.yaml
    2. Updates the dependency version in truvami-stack/Chart.yaml
    3. Updates the dependency lock in truvami-stack/Chart.lock

EOF
    exit 0
fi

# Validate arguments
if [[ -z "$CHART_NAME" || -z "$NEW_VERSION" ]]; then
    echo "❌ Error: Both CHART_NAME and NEW_VERSION are required"
    echo "Usage: $0 CHART_NAME NEW_VERSION [--dry-run]"
    echo "Run '$0 --help' for more information"
    exit 1
fi

# Validate version format
if [[ ! "$NEW_VERSION" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    echo "❌ Error: Version must be in format X.Y.Z (e.g., 0.0.28)"
    exit 1
fi

# Validate chart exists
CHART_DIR="$PROJECT_ROOT/charts/$CHART_NAME"
if [[ ! -d "$CHART_DIR" ]]; then
    echo "❌ Error: Chart directory not found: $CHART_DIR"
    echo "Available charts:"
    ls -1 "$PROJECT_ROOT/charts/" | grep -E "^truvami-" || true
    exit 1
fi

CHART_YAML="$CHART_DIR/Chart.yaml"
if [[ ! -f "$CHART_YAML" ]]; then
    echo "❌ Error: Chart.yaml not found: $CHART_YAML"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep '^version:' "$CHART_YAML" | awk '{print $2}' | tr -d '"'"'"'' || "")
if [[ -z "$CURRENT_VERSION" ]]; then
    echo "❌ Error: Could not read current version from $CHART_YAML"
    exit 1
fi

echo "📊 Chart Update Summary:"
echo "   Chart: $CHART_NAME"
echo "   Current: $CURRENT_VERSION"
echo "   New: $NEW_VERSION"

if [[ "$CURRENT_VERSION" == "$NEW_VERSION" ]]; then
    echo "⚠️  Version unchanged, nothing to do"
    exit 0
fi

# Update chart version
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would update $CHART_YAML version: $CURRENT_VERSION -> $NEW_VERSION"
else
    echo "📝 Updating chart version..."
    # Use portable sed command that works on both macOS and Linux
    if sed --version >/dev/null 2>&1; then
        # GNU sed
        sed -i "s/^version: .*/version: $NEW_VERSION/" "$CHART_YAML"
    else
        # BSD sed (macOS)
        sed -i '' "s/^version: .*/version: $NEW_VERSION/" "$CHART_YAML"
    fi
    echo "   ✅ Updated $CHART_NAME version to $NEW_VERSION"
fi

# Check if this chart is a dependency of truvami-stack
STACK_CHART_YAML="$PROJECT_ROOT/charts/truvami-stack/Chart.yaml"
if grep -q "name: $CHART_NAME" "$STACK_CHART_YAML" 2>/dev/null; then
    if [[ "$DRY_RUN" == "true" ]]; then
        echo "[DRY RUN] Would update stack dependency for $CHART_NAME to $NEW_VERSION"
    else
        echo "📦 Updating stack chart dependency..."
        # Update dependency version in stack Chart.yaml
        # Find the line with "name: CHART_NAME" and update the next line with "version:"
        if sed --version >/dev/null 2>&1; then
            # GNU sed
            sed -i "/name: $CHART_NAME/,/version:/ s/version: .*/version: $NEW_VERSION/" "$STACK_CHART_YAML"
        else
            # BSD sed (macOS)
            sed -i '' "/name: $CHART_NAME/,/version:/ s/version: .*/version: $NEW_VERSION/" "$STACK_CHART_YAML"
        fi
        echo "   ✅ Updated stack dependency version"

        # Update Chart.lock by rebuilding dependencies
        echo "📦 Rebuilding stack dependencies..."
        cd "$PROJECT_ROOT"
        if command -v helm >/dev/null 2>&1; then
            helm dependency update ./charts/truvami-stack
            echo "   ✅ Updated Chart.lock"
        else
            echo "   ⚠️  Helm not found, please run 'helm dependency update ./charts/truvami-stack' manually"
        fi
    fi
else
    echo "   ℹ️  Chart $CHART_NAME is not a dependency of truvami-stack"
fi

echo ""
echo "✅ Chart version update completed!"

if [[ "$DRY_RUN" == "false" ]]; then
    echo ""
    echo "📝 Next steps:"
    echo "   1. Review the changes: git diff"
    echo "   2. Commit the changes: git add -A && git commit -m 'feat($CHART_NAME): bump version to $NEW_VERSION'"
    echo "   3. Create release: make release"
fi
