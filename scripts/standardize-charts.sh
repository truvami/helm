#!/bin/bash

# Chart Standardization Script
# Ensures all charts follow consistent patterns and best practices

set -e

CHARTS_DIR="charts"
TEMPLATE_DIR="scripts/templates"

echo "🔧 Chart Standardization Script"
echo "==============================="

# Create templates directory if it doesn't exist
mkdir -p "$TEMPLATE_DIR"

# Standard _helpers.tpl content
cat > "$TEMPLATE_DIR/_helpers.tpl" << 'EOF'
{{/*
Expand the name of the chart.
*/}}
{{- define "CHART_NAME.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "CHART_NAME.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "CHART_NAME.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "CHART_NAME.labels" -}}
helm.sh/chart: {{ include "CHART_NAME.chart" . }}
{{ include "CHART_NAME.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "CHART_NAME.selectorLabels" -}}
app.kubernetes.io/name: {{ include "CHART_NAME.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "CHART_NAME.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "CHART_NAME.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Common annotations
*/}}
{{- define "CHART_NAME.annotations" -}}
{{- with .Values.podAnnotations }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Security Context
*/}}
{{- define "CHART_NAME.securityContext" -}}
{{- with .Values.securityContext }}
{{- toYaml . }}
{{- end }}
{{- end }}

{{/*
Pod Security Context
*/}}
{{- define "CHART_NAME.podSecurityContext" -}}
{{- with .Values.podSecurityContext }}
{{- toYaml . }}
{{- end }}
{{- end }}
EOF

# Function to standardize a chart
standardize_chart() {
    local chart_name=$1
    local chart_path="$CHARTS_DIR/$chart_name"

    if [ ! -d "$chart_path" ]; then
        echo "❌ Chart not found: $chart_name"
        return 1
    fi

    echo "🔧 Standardizing chart: $chart_name"

    # Ensure templates directory exists
    mkdir -p "$chart_path/templates"

    # Update _helpers.tpl with standardized version
    if [ -f "$chart_path/templates/_helpers.tpl" ]; then
        echo "  📝 Updating _helpers.tpl"
        sed "s/CHART_NAME/$chart_name/g" "$TEMPLATE_DIR/_helpers.tpl" > "$chart_path/templates/_helpers.tpl"
    else
        echo "  📝 Creating _helpers.tpl"
        sed "s/CHART_NAME/$chart_name/g" "$TEMPLATE_DIR/_helpers.tpl" > "$chart_path/templates/_helpers.tpl"
    fi

    # Ensure Chart.yaml has required fields
    if [ -f "$chart_path/Chart.yaml" ]; then
        echo "  📋 Validating Chart.yaml"

        # Check for required fields
        if ! yq eval '.description' "$chart_path/Chart.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding missing description"
            yq eval '.description = "Truvami '"$chart_name"' service"' -i "$chart_path/Chart.yaml"
        fi

        if ! yq eval '.type' "$chart_path/Chart.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding missing type"
            yq eval '.type = "application"' -i "$chart_path/Chart.yaml"
        fi

        if ! yq eval '.home' "$chart_path/Chart.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding missing home URL"
            yq eval '.home = "https://github.com/truvami/helm"' -i "$chart_path/Chart.yaml"
        fi

        if ! yq eval '.maintainers' "$chart_path/Chart.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding maintainers"
            yq eval '.maintainers = [{"name": "Truvami Team", "email": "dev@truvami.com"}]' -i "$chart_path/Chart.yaml"
        fi
    fi

    # Ensure values.yaml has common structure
    if [ -f "$chart_path/values.yaml" ]; then
        echo "  📊 Validating values.yaml structure"

        # Check for common sections and add if missing
        if ! yq eval '.replicaCount' "$chart_path/values.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding replicaCount"
            yq eval '.replicaCount = 1' -i "$chart_path/values.yaml"
        fi

        if ! yq eval '.image' "$chart_path/values.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding image section"
            yq eval '.image.repository = "'"$chart_name"'" | .image.pullPolicy = "IfNotPresent" | .image.tag = ""' -i "$chart_path/values.yaml"
        fi

        if ! yq eval '.resources' "$chart_path/values.yaml" > /dev/null 2>&1; then
            echo "    ⚠️  Adding resources section"
            yq eval '.resources = {}' -i "$chart_path/values.yaml"
        fi
    fi

    echo "  ✅ Chart $chart_name standardized"
}

# Process all charts or specific chart if provided
if [ $# -eq 0 ]; then
    # Process all charts
    for chart in $(ls "$CHARTS_DIR"); do
        if [ -d "$CHARTS_DIR/$chart" ]; then
            standardize_chart "$chart"
        fi
    done
else
    # Process specific chart
    standardize_chart "$1"
fi

echo ""
echo "✅ Chart standardization complete!"
echo ""
echo "📋 Next steps:"
echo "1. Review the changes with: git diff"
echo "2. Test charts with: make lint test"
echo "3. Generate documentation: make docs"
echo "4. Commit the standardized charts"
