#!/bin/bash

# Pre-commit hook for chart version validation

set -e

echo "🔍 Checking chart version increments..."

# Get changed Chart.yaml files
changed_charts=$(git diff --cached --name-only | grep "Chart\.yaml$" | sed 's|/Chart\.yaml||' | sed 's|charts/||')

if [ -z "$changed_charts" ]; then
    echo "✅ No Chart.yaml changes detected"
    exit 0
fi

for chart_path in $changed_charts; do
    chart_name=$(basename "$chart_path")
    chart_file="charts/$chart_path/Chart.yaml"

    if [ ! -f "$chart_file" ]; then
        continue
    fi

    echo "Checking version for: $chart_name"

    # Get current version
    current_version=$(yq eval '.version' "$chart_file")

    # Get version from HEAD (if exists)
    if git show HEAD:"$chart_file" > /dev/null 2>&1; then
        head_version=$(git show HEAD:"$chart_file" | yq eval '.version' -)

        if [ "$current_version" = "$head_version" ]; then
            echo "❌ Chart version not bumped for $chart_name (still $current_version)"
            echo "   Please increment the version in $chart_file"
            exit 1
        fi

        echo "  Version updated: $head_version → $current_version"
    else
        echo "  New chart with version: $current_version"
    fi
done

echo "✅ All chart versions are properly incremented"
