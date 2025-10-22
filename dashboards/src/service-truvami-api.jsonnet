local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// API-specific panels
local apiPanels = {
  // Request rate and errors
  requestMetrics(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'API Request Metrics',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum(rate(truvami_customer_requests_total{namespace="$namespace", container="truvami-api"}[5m])) * 60',
        legendFormat='Customer Requests/min',
      ),
    ])
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'line',
            lineInterpolation: 'linear',
            lineWidth: 2,
            fillOpacity: 10,
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Database errors
  databaseErrors(gridPos={ h: 8, w: 12, x: 12, y: 0 }):
    graphPanel.new(
      'Database Integrity Errors',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum(rate(truvami_api_db_error_integrity_constraint_violation_total{namespace="$namespace", container="truvami-api"}[5m])) * 60',
        legendFormat='DB Constraint Violations/min',
      ),
      prometheus.target(
        'sum(rate(truvami_grpc_db_error_integrity_constraint_violation_total{namespace="$namespace", container="truvami-api"}[5m])) * 60',
        legendFormat='gRPC DB Errors/min',
      ),
    ])
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'line',
            lineInterpolation: 'linear',
            lineWidth: 2,
            fillOpacity: 0,
          },
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 0.1 },
              { color: 'red', value: 1 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // API key cache performance
  apiKeyCacheStats(gridPos={ h: 6, w: 8, x: 0, y: 8 }):
    stat.new(
      'API Key Cache Hit Rate',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        '(sum(rate(truvami_api_key_cache_hit_total{namespace="$namespace", container="truvami-api"}[5m])) / (sum(rate(truvami_api_key_cache_hit_total{namespace="$namespace", container="truvami-api"}[5m])) + sum(rate(truvami_api_key_cache_miss_total{namespace="$namespace", container="truvami-api"}[5m])))) * 100',
        legendFormat='Hit Rate %',
      )
    )
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'thresholds' },
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'red', value: 0 },
              { color: 'yellow', value: 80 },
              { color: 'green', value: 95 },
            ],
          },
          unit: 'percent',
          max: 100,
          min: 0,
        },
      },
      options: {
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
        orientation: 'auto',
        reduceOptions: {
          calcs: ['lastNotNull'],
          fields: '',
          values: false,
        },
        textMode: 'auto',
      },
      gridPos: gridPos,
    },

  // OAuth2 token validation
  oauth2Stats(gridPos={ h: 6, w: 8, x: 8, y: 8 }):
    stat.new(
      'OAuth2 Token Issues',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(rate(truvami_oauth2_token_expired_total{namespace="$namespace", container="truvami-api"}[5m]) + rate(truvami_oauth2_token_invalid_issuer_total{namespace="$namespace", container="truvami-api"}[5m])) * 60',
        legendFormat='Token Issues/min',
      )
    )
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'thresholds' },
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 1 },
              { color: 'red', value: 10 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Health check duration
  healthCheckDuration(gridPos={ h: 6, w: 8, x: 16, y: 8 }):
    stat.new(
      'Avg Health Check Duration',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'avg(rate(truvami_health_check_duration_milliseconds_sum{namespace="$namespace", container="truvami-api"}[5m]) / rate(truvami_health_check_duration_milliseconds_count{namespace="$namespace", container="truvami-api"}[5m]))',
        legendFormat='Avg Duration',
      )
    )
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'thresholds' },
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 100 },
              { color: 'red', value: 500 },
            ],
          },
          unit: 'ms',
        },
      },
      gridPos: gridPos,
    },
};

// Build dashboard with service-specific panels
truvami.serviceDashboard('truvami-api', [
  // API-specific section (after Go panels which end at y: 42)
  row.new('API Service Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 43 }, collapsed: false },
  apiPanels.requestMetrics({ h: 8, w: 12, x: 0, y: 44 }),
  apiPanels.databaseErrors({ h: 8, w: 12, x: 12, y: 44 }),
  apiPanels.apiKeyCacheStats({ h: 6, w: 8, x: 0, y: 52 }),
  apiPanels.oauth2Stats({ h: 6, w: 8, x: 8, y: 52 }),
  apiPanels.healthCheckDuration({ h: 6, w: 8, x: 16, y: 52 }),

  // Logs section
  row.new('Logs') + { gridPos: { h: 1, w: 24, x: 0, y: 58 }, collapsed: false },
  truvami.panels.serviceLogs('truvami-api', { h: 10, w: 24, x: 0, y: 59 }),
])
