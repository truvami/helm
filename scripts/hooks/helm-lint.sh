#!/bin/bash

# Pre-commit hook for Helm linting

set -e

echo "🔍 Running Helm lint checks..."

# Get list of changed charts
changed_charts=$(git diff --cached --name-only | grep "^charts/" | cut -d'/' -f2 | sort -u)

if [ -z "$changed_charts" ]; then
    echo "✅ No chart changes detected"
    exit 0
fi

failed_charts=()

for chart in $changed_charts; do
    if [ -d "charts/$chart" ] && [ -f "charts/$chart/Chart.yaml" ]; then
        echo "Linting chart: $chart"
        if ! helm lint "charts/$chart" --quiet; then
            failed_charts+=("$chart")
        fi
    fi
done

if [ ${#failed_charts[@]} -ne 0 ]; then
    echo "❌ Helm lint failed for charts: ${failed_charts[*]}"
    echo "Run 'helm lint charts/CHART_NAME' for details"
    exit 1
fi

echo "✅ All charts passed Helm lint"
