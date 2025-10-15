local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Gateway-specific panels
local gatewayPanels = {
  // Wi-Fi solver performance
  wifiSolverStats(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'Wi-Fi Solver Performance',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum(rate(truvami_wifi_solver_success_count{namespace="$namespace", container="truvami-gateway"}[5m])) * 60',
        legendFormat='Success/min',
      ),
      prometheus.target(
        'sum(rate(truvami_wifi_solver_error_count{namespace="$namespace", container="truvami-gateway"}[5m])) * 60',
        legendFormat='Errors/min',
      ),
      prometheus.target(
        'sum(rate(truvami_wifi_solver_requests_count{namespace="$namespace", container="truvami-gateway"}[5m])) * 60',
        legendFormat='Total Requests/min',
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
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Wi-Fi solver success rate
  wifiSolverSuccessRate(gridPos={ h: 6, w: 8, x: 12, y: 0 }):
    stat.new(
      'Wi-Fi Solver Success Rate',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        '(sum(rate(truvami_wifi_solver_success_count{namespace="$namespace", container="truvami-gateway"}[5m])) / sum(rate(truvami_wifi_solver_requests_count{namespace="$namespace", container="truvami-gateway"}[5m]))) * 100',
        legendFormat='Success Rate %',
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
              { color: 'yellow', value: 70 },
              { color: 'green', value: 90 },
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

  // Zero position count (potential issue indicator)
  zeroPositionCount(gridPos={ h: 6, w: 8, x: 20, y: 0 }):
    stat.new(
      'Zero Position Issues',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(rate(truvami_wifi_zero_position_count{namespace="$namespace", container="truvami-gateway"}[5m])) * 60',
        legendFormat='Zero Positions/min',
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
};

// Build dashboard with service-specific panels
truvami.serviceDashboard('truvami-gateway', [
  // Gateway-specific section (after Go panels which end at y: 42)
  row.new('Wi-Fi Gateway Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 43 }, collapsed: false },
  gatewayPanels.wifiSolverStats({ h: 8, w: 12, x: 0, y: 44 }),
  gatewayPanels.wifiSolverSuccessRate({ h: 8, w: 12, x: 12, y: 44 }),
  gatewayPanels.zeroPositionCount({ h: 6, w: 24, x: 0, y: 52 }),
])
