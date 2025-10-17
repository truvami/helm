local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local truvami = import '../lib/truvami.libsonnet';

// Monitoring overview dashboard with dynamic panel generation
local services = [
  'truvami-api',
  'truvami-bridge',
  'truvami-gateway',
  'truvami-dashboard',
  'truvami-decoder',
  'truvami-siren'
];

// Generate service health overview panels dynamically using modern stat panels
local serviceHealthPanels = [
  {
    type: 'stat',
    title: service + ' Health',
    gridPos: truvami.utils.gridPos(4, 4, (i % 6) * 4, std.floor(i / 6) * 4),
    fieldConfig: {
      defaults: {
        mappings: [
          {
            type: 'value',
            options: {
              '0': {
                text: 'DOWN',
                index: 0
              },
              '1': {
                text: 'OK',
                index: 1
              }
            }
          }
        ],
        thresholds: {
          mode: 'absolute',
          steps: [
            {
              color: 'red',
              value: null
            },
            {
              color: 'green',
              value: 1
            }
          ]
        },
        unit: 'none'
      },
      overrides: []
    },
    targets: [
      {
        datasource: {
          uid: '${datasource}'
        },
        expr: 'min by(__name__) (up{container="' + service + '", namespace="$namespace"})',
        format: 'time_series',
        intervalFactor: 2,
        legendFormat: service,
        refId: 'A'
      }
    ],
    maxDataPoints: 100,
    datasource: {
      uid: '${datasource}'
    },
    options: {
      reduceOptions: {
        values: false,
        calcs: [
          'mean'
        ],
        fields: ''
      },
      orientation: 'horizontal',
      textMode: 'auto',
      wideLayout: true,
      colorMode: 'background',
      graphMode: 'none',
      justifyMode: 'auto',
      showPercentChange: false,
      percentChangeColorMode: 'standard'
    }
  }
  for i in std.range(0, std.length(services) - 1)
  for service in [services[i]]
];

// Generate device uplink rate panels - average per hour
local uplinkRatePanels = [
  graphPanel.new(
    title='Device Uplinks per Hour',
    datasource='${datasource}',
    format='short',
    legend_alignAsTable=true,
    legend_rightSide=true,
  ).addTargets([
    prometheus.target(
      'sum by(container) (rate(truvami_device_uplink_count{namespace="$namespace", container="truvami-bridge"}[$__rate_interval])) * 3600',
      legendFormat='{{container}} - Uplinks/hour',
    )
  ]) + { gridPos: truvami.utils.gridPos(8, 24, 0, 8) }
];

// Create the monitoring dashboard
dashboard.new(
  'Truvami Services Overview',
  uid='truvami-overview',
  tags=truvami.dashboardDefaults.tags + ['overview'],
  refresh=truvami.dashboardDefaults.refresh,
  time_from=truvami.dashboardDefaults.time.from,
  time_to=truvami.dashboardDefaults.time.to,
)
.addAnnotations(truvami.annotations)
.addTemplates([
  truvami.templates.datasource,
  truvami.templates.namespace,
])
.addPanels(
  serviceHealthPanels + uplinkRatePanels
)
