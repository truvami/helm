#!/usr/bin/env bash
set -euo pipefail

# Release automation script
# Usage: ./scripts/release.sh [--version VERSION] [--dry-run] [--help]

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default values
VERSION=""
DRY_RUN=false
HELP=false

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        --version)
            VERSION="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
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
Release Automation Script

USAGE:
    $0 [OPTIONS]

OPTIONS:
    --version VERSION   Specify release version (e.g., v1.2.0)
    --dry-run          Show what would be done without making changes
    --help, -h         Show this help message

EXAMPLES:
    # Interactive release (will prompt for version)
    $0

    # Specify version directly
    $0 --version v1.2.0

    # Dry run to see what would happen
    $0 --version v1.2.0 --dry-run

WHAT IT DOES:
    1. Validates git state (clean working directory)
    2. Updates changelog with git-cliff
    3. Creates git tag
    4. Pushes tag to origin (triggers CI release)

REQUIREMENTS:
    - git-cliff must be installed
    - Clean git working directory
    - Push access to origin

EOF
    exit 0
fi

cd "$PROJECT_ROOT"

# Check dependencies
if ! command -v git-cliff &> /dev/null; then
    echo "❌ git-cliff is not installed!"
    echo "Install with: cargo install git-cliff"
    exit 1
fi

# Check git status
if [[ -n "$(git status --porcelain)" ]]; then
    echo "❌ Working directory is not clean!"
    echo "Please commit or stash your changes first."
    git status --short
    exit 1
fi

# Check for Chart.yaml version updates
echo "🔍 Checking if chart versions have been updated..."
CHARTS_WITH_CHANGES=()
for chart_dir in charts/*/; do
    chart_name=$(basename "$chart_dir")
    if [[ -f "$chart_dir/Chart.yaml" ]]; then
        # Check if chart has uncommitted changes or was recently modified
        last_repo_tag=$(git tag --sort=-version:refname | head -1 || echo "")

        if [[ -n "$last_repo_tag" ]]; then
            # Check if chart was modified since last tag
            if git diff --quiet "$last_repo_tag" HEAD -- "$chart_dir/Chart.yaml" 2>/dev/null; then
                # No changes since last tag
                continue
            else
                CHARTS_WITH_CHANGES+=("$chart_name")
            fi
        else
            # No previous tags, assume all charts are new
            CHARTS_WITH_CHANGES+=("$chart_name")
        fi
    fi
done

if [[ ${#CHARTS_WITH_CHANGES[@]} -gt 0 ]]; then
    echo "📊 Charts with version changes detected:"
    for chart in "${CHARTS_WITH_CHANGES[@]}"; do
        chart_version=$(grep '^version:' "charts/$chart/Chart.yaml" | awk '{print $2}' | tr -d '"'"'"'')
        echo "   - $chart: $chart_version"
    done
    echo "✅ Helm chart-releaser will publish these charts"
else
    echo "⚠️  No chart version changes detected since last tag."
    echo "   Helm chart-releaser may not publish any charts."
    echo "   Consider updating chart versions in Chart.yaml files if needed."
fi

# Ensure we're on main branch
CURRENT_BRANCH=$(git rev-parse --abbrev-ref HEAD)
if [[ "$CURRENT_BRANCH" != "main" ]]; then
    echo "❌ Not on main branch (currently on: $CURRENT_BRANCH)"
    echo "Please checkout main branch first."
    exit 1
fi

# Pull latest changes
echo "🔄 Pulling latest changes..."
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would run: git pull origin main"
else
    git pull origin main
fi

# Get version if not provided
if [[ -z "$VERSION" ]]; then
    echo "🏷️  Current tags:"
    git tag --sort=-version:refname | head -5
    echo ""
    read -p "Enter new version (e.g., v1.2.0): " VERSION
fi

# Validate version format
if [[ ! "$VERSION" =~ ^v[0-9]+\.[0-9]+\.[0-9]+(-rc[0-9]+)?$ ]]; then
    echo "❌ Invalid version format: $VERSION"
    echo "Expected format: v1.2.0 or v1.2.0-rc1"
    exit 1
fi

# Check if tag already exists
if git rev-parse "$VERSION" >/dev/null 2>&1; then
    echo "❌ Tag $VERSION already exists!"
    exit 1
fi

echo "🚀 Preparing release: $VERSION"
echo ""

# Generate changelog
echo "📝 Updating changelog..."
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would run: git-cliff --tag $VERSION --output CHANGELOG.md"
else
    git-cliff --tag "$VERSION" --output CHANGELOG.md
fi

# Show what will be in the release
echo ""
echo "📋 Release notes for $VERSION:"
echo "================================"
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would show git-cliff --tag $VERSION --unreleased --strip all"
else
    git-cliff --tag "$VERSION" --unreleased --strip all
fi
echo ""

# Confirm release
if [[ "$DRY_RUN" == "false" ]]; then
    read -p "🤔 Proceed with release? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "❌ Release cancelled."
        exit 1
    fi
fi

# Commit changelog if it was modified
if [[ "$DRY_RUN" == "true" ]]; then
    echo "[DRY RUN] Would commit changelog and create tag"
else
    if [[ -n "$(git status --porcelain CHANGELOG.md)" ]]; then
        echo "📝 Committing changelog..."
        git add CHANGELOG.md
        git commit -m "chore(release): update changelog for $VERSION"
    fi

    # Create and push tag
    echo "🏷️  Creating tag: $VERSION"
    git tag -a "$VERSION" -m "Release $VERSION"

    echo "📤 Pushing tag to origin..."
    git push origin "$VERSION"
    git push origin main
fi

echo ""
echo "✅ Release $VERSION completed!"
echo ""
echo "🔗 Monitor the release at:"
echo "   https://github.com/truvami/helm/releases/tag/$VERSION"
echo ""
echo "🚀 CI will automatically:"
echo "   1. Generate changelog and create GitHub release"
echo "   2. Build and publish Helm charts with chart-releaser"
echo ""
echo "📝 Note: Individual chart versions should be updated manually in Chart.yaml files"
echo "   before running this release script to ensure chart-releaser can detect changes."
