#!/bin/bash

# Dashboard Development Workflow Script
# Provides commands for developing Grafana dashboards with Jsonnet

set -e

DASHBOARDS_DIR="dashboards"
GENERATED_DIR="charts/truvami-monitoring/dashboards-generated"

show_help() {
    echo "Dashboard Development Workflow"
    echo "============================="
    echo ""
    echo "Usage: $0 <command> [options]"
    echo ""
    echo "Commands:"
    echo "  init           Initialize dashboard development environment"
    echo "  build          Build all dashboards from Jsonnet sources"
    echo "  build <name>   Build specific dashboard"
    echo "  validate       Validate all generated dashboards"
    echo "  watch          Watch for changes and auto-rebuild"
    echo "  preview <name> Preview dashboard JSON output"
    echo "  clean          Clean generated files"
    echo "  new <name>     Create new dashboard from template"
    echo ""
    echo "Examples:"
    echo "  $0 init                           # Setup environment"
    echo "  $0 build                          # Build all dashboards"
    echo "  $0 build service-truvami-api      # Build specific dashboard"
    echo "  $0 preview truvami-overview       # Preview dashboard"
    echo "  $0 new service-truvami-decoder    # Create new service dashboard"
}

init_environment() {
    echo "🔧 Initializing dashboard development environment..."

    # Check for required tools
    if ! command -v jsonnet >/dev/null 2>&1; then
        echo "❌ jsonnet not found. Installing..."
        make install-jsonnet
    fi

    if ! command -v jb >/dev/null 2>&1; then
        echo "❌ jsonnet-bundler (jb) not found. Installing..."
        make install-jsonnet
    fi

    # Install dependencies
    echo "📦 Installing dashboard dependencies..."
    cd "$DASHBOARDS_DIR"
    jb install
    cd ..

    echo "✅ Environment initialized"
}

build_dashboard() {
    local dashboard_name="$1"

    if [ -z "$dashboard_name" ]; then
        echo "🔨 Building all dashboards..."
        make build-dashboards
    else
        echo "🔨 Building dashboard: $dashboard_name..."

        local jsonnet_file="$DASHBOARDS_DIR/src/$dashboard_name.jsonnet"
        local output_file="$GENERATED_DIR/$dashboard_name.json"

        if [ ! -f "$jsonnet_file" ]; then
            echo "❌ Dashboard source not found: $jsonnet_file"
            exit 1
        fi

        mkdir -p "$GENERATED_DIR"
        jsonnet -J "$DASHBOARDS_DIR/vendor" -J "$DASHBOARDS_DIR/lib" "$jsonnet_file" > "$output_file"

        echo "✅ Dashboard built: $output_file"
    fi
}

validate_dashboards() {
    echo "🔍 Validating dashboards..."
    make validate-dashboards
}

watch_changes() {
    echo "👀 Watching for changes in $DASHBOARDS_DIR/src/..."
    echo "Press Ctrl+C to stop watching"

    if command -v fswatch >/dev/null 2>&1; then
        fswatch -o "$DASHBOARDS_DIR/src/" | while read; do
            echo "🔄 Changes detected, rebuilding..."
            build_dashboard
            echo "✅ Rebuild complete"
        done
    elif command -v inotifywait >/dev/null 2>&1; then
        while inotifywait -r -e modify,create,delete "$DASHBOARDS_DIR/src/" >/dev/null 2>&1; do
            echo "🔄 Changes detected, rebuilding..."
            build_dashboard
            echo "✅ Rebuild complete"
        done
    else
        echo "❌ No file watching tool found (fswatch/inotifywait)"
        echo "Install with: brew install fswatch (macOS) or apt-get install inotify-tools (Linux)"
        exit 1
    fi
}

preview_dashboard() {
    local dashboard_name="$1"

    if [ -z "$dashboard_name" ]; then
        echo "❌ Dashboard name required"
        echo "Usage: $0 preview <dashboard-name>"
        exit 1
    fi

    local output_file="$GENERATED_DIR/$dashboard_name.json"

    if [ ! -f "$output_file" ]; then
        echo "📄 Dashboard not built yet, building..."
        build_dashboard "$dashboard_name"
    fi

    echo "📖 Preview of $dashboard_name:"
    echo "================================"

    if command -v jq >/dev/null 2>&1; then
        jq . "$output_file"
    else
        cat "$output_file"
    fi
}

create_new_dashboard() {
    local dashboard_name="$1"

    if [ -z "$dashboard_name" ]; then
        echo "❌ Dashboard name required"
        echo "Usage: $0 new <dashboard-name>"
        exit 1
    fi

    local jsonnet_file="$DASHBOARDS_DIR/src/$dashboard_name.jsonnet"

    if [ -f "$jsonnet_file" ]; then
        echo "❌ Dashboard already exists: $jsonnet_file"
        exit 1
    fi

    echo "📄 Creating new dashboard: $dashboard_name"

    if [[ "$dashboard_name" == service-* ]]; then
        # Create service dashboard template
        local service_name=$(echo "$dashboard_name" | sed 's/service-//')

        cat > "$jsonnet_file" << EOF
local truvami = import '../lib/truvami.libsonnet';

local serviceName = '$service_name';

truvami.serviceDashboard(
  serviceName,
  panels=[
    truvami.panels.versionInfo(serviceName, truvami.utils.gridPos(8, 12, 0, 0)),
    truvami.panels.buildDateInfo(serviceName, truvami.utils.gridPos(8, 12, 12, 0)),
    truvami.panels.podStatus(serviceName, truvami.utils.gridPos(8, 12, 0, 8)),
    truvami.panels.memoryUsage(serviceName, truvami.utils.gridPos(8, 12, 12, 8)),
    truvami.panels.cpuUsage(serviceName, truvami.utils.gridPos(8, 12, 0, 16)),
    truvami.panels.requestRate(serviceName, truvami.utils.gridPos(8, 12, 12, 16)),
    truvami.panels.errorRate(serviceName, truvami.utils.gridPos(8, 24, 0, 24)),

    // Add custom panels here
  ]
)
EOF
    else
        # Create general dashboard template
        cat > "$jsonnet_file" << EOF
local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local truvami = import '../lib/truvami.libsonnet';

dashboard.new(
  '$dashboard_name',
  uid='$(echo "$dashboard_name" | tr '-' '_')',
  tags=truvami.dashboardDefaults.tags,
  refresh=truvami.dashboardDefaults.refresh,
  time_from=truvami.dashboardDefaults.time.from,
  time_to=truvami.dashboardDefaults.time.to,
)
.addAnnotations(truvami.annotations)
.addTemplates([
  truvami.templates.datasource,
  truvami.templates.namespace,
])
.addPanels([
  // Add your panels here
])
EOF
    fi

    echo "✅ Dashboard template created: $jsonnet_file"
    echo "💡 Edit the file and run '$0 build $dashboard_name' to generate"
}

clean_generated() {
    echo "🧹 Cleaning generated files..."
    make clean-dashboards
}

# Main command dispatcher
case "${1:-}" in
    "init")
        init_environment
        ;;
    "build")
        build_dashboard "$2"
        ;;
    "validate")
        validate_dashboards
        ;;
    "watch")
        watch_changes
        ;;
    "preview")
        preview_dashboard "$2"
        ;;
    "clean")
        clean_generated
        ;;
    "new")
        create_new_dashboard "$2"
        ;;
    "help"|"-h"|"--help"|"")
        show_help
        ;;
    *)
        echo "❌ Unknown command: $1"
        echo ""
        show_help
        exit 1
        ;;
esac
