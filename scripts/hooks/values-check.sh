#!/bin/bash

# Pre-commit hook for values.yaml validation

set -e

echo "🔍 Validating values.yaml files..."

# Get changed values.yaml files
changed_values=$(git diff --cached --name-only | grep "values\.yaml$")

if [ -z "$changed_values" ]; then
    echo "✅ No values.yaml changes detected"
    exit 0
fi

for values_file in $changed_values; do
    echo "Validating: $values_file"

    # Check YAML syntax
    if ! yq eval '.' "$values_file" > /dev/null 2>&1; then
        echo "❌ Invalid YAML syntax in $values_file"
        exit 1
    fi

    # Check for required sections in chart values.yaml (not for root values.yaml)
    if [[ "$values_file" == charts/*/values.yaml ]]; then
        chart_dir=$(dirname "$values_file")
        chart_name=$(basename "$chart_dir")

        # Skip truvami-stack as it's an umbrella chart
        if [ "$chart_name" != "truvami-stack" ]; then
            # Check for basic structure
            if ! yq eval '.image' "$values_file" > /dev/null 2>&1; then
                echo "⚠️  Missing .image section in $values_file"
            fi

            if ! yq eval '.replicaCount' "$values_file" > /dev/null 2>&1; then
                echo "⚠️  Missing .replicaCount in $values_file"
            fi
        fi
    fi
done

echo "✅ All values.yaml files are valid"
