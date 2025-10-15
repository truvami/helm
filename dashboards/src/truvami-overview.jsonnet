local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local singlestat = grafana.singlestat;
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

// Generate service health overview panels dynamically
local serviceHealthPanels = [
  singlestat.new(
    title=service + ' Health',
    datasource='${datasource}',
    colorBackground=true,
    thresholds='0,1',
    colors=['red', 'green']
  ).addTarget(
    prometheus.target(
      'up{container="' + service + '",namespace="$namespace"}',
      legendFormat=service,
    )
  ) + { gridPos: truvami.utils.gridPos(4, 4, (i % 6) * 4, std.floor(i / 6) * 4) }
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
