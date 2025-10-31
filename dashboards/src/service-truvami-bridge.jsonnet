local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Bridge-specific panels
local bridgePanels = {
  // LoRaWAN uplinks rate
  uplinkRate(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'Device Uplinks Rate',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum(rate(truvami_device_uplink_count{namespace="$namespace", container="truvami-bridge"}[5m])) * 60',
        legendFormat='Uplinks/min',
      ),
      prometheus.target(
        'sum by(spreadingFactor) (rate(truvami_device_uplink_count{namespace="$namespace", container="truvami-bridge"}[5m])) * 60',
        legendFormat='{{spreadingFactor}}',
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
            gradientMode: 'none',
          },
          unit: 'short',
        },
      },
      options: {
        legend: {
          calcs: ['lastNotNull', 'max'],
          displayMode: 'table',
          placement: 'bottom',
          showLegend: true,
        },
      },
      gridPos: gridPos,
    },

  // Device payload decoding errors
  decodingErrors(gridPos={ h: 8, w: 12, x: 12, y: 0 }):
    graphPanel.new(
      'Payload Decoding Issues',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'rate(truvami_failed_to_decode_payload_count{namespace="$namespace", container="truvami-bridge"}[5m]) * 60',
        legendFormat='Decode Failures/min',
      ),
      prometheus.target(
        'rate(truvami_uplink_created_but_decoder_err_count{namespace="$namespace", container="truvami-bridge"}[5m]) * 60',
        legendFormat='Decoder Errors/min',
      ),
      prometheus.target(
        'rate(truvami_uplink_created_but_decoder_warn_count{namespace="$namespace", container="truvami-bridge"}[5m]) * 60',
        legendFormat='Decoder Warnings/min',
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
              { color: 'yellow', value: 1 },
              { color: 'red', value: 10 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // LoRaCloud integration stats
  loracloudStats(gridPos={ h: 6, w: 8, x: 0, y: 8 }):
    stat.new(
      'LoRaCloud Position Success Rate',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        '(sum(rate(truvami_loracloud_position_estimate_valid_total{namespace="$namespace", container="truvami-bridge"}[5m])) / sum(rate(truvami_loracloud_v2_requests_total{namespace="$namespace", container="truvami-bridge"}[5m]))) * 100',
        legendFormat='Success %',
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

  // Gateway SNR issues
  gatewaySignalQuality(gridPos={ h: 6, w: 8, x: 8, y: 8 }):
    stat.new(
      'Gateway SNR Issues',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(ALERTS{namespace="$namespace", alertname="TruvamiGatewaySNRLow", alertstate="firing"})',
        legendFormat='SNR Alerts',
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
              { color: 'yellow', value: 5 },
              { color: 'red', value: 20 },
            ],
          },
          unit: 'short',
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

  // Device battery alerts
  deviceBatteryAlerts(gridPos={ h: 6, w: 8, x: 16, y: 8 }):
    stat.new(
      'Device Battery Alerts',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(ALERTS{namespace="$namespace", alertname="TruvamiDeviceHighBufferLevel", alertstate="firing"})',
        legendFormat='Buffer Level Issues',
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
              { color: 'yellow', value: 2 },
              { color: 'red', value: 10 },
            ],
          },
          unit: 'short',
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
};

// Build dashboard with service-specific panels
truvami.serviceDashboard('truvami-bridge', [
  // Bridge-specific section (after Go panels which end at y: 42)
  row.new('Bridge Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 43 }, collapsed: false },
  bridgePanels.uplinkRate({ h: 8, w: 12, x: 0, y: 44 }),
  bridgePanels.decodingErrors({ h: 8, w: 12, x: 12, y: 44 }),
  bridgePanels.loracloudStats({ h: 6, w: 8, x: 0, y: 52 }),
  bridgePanels.gatewaySignalQuality({ h: 6, w: 8, x: 8, y: 52 }),
  bridgePanels.deviceBatteryAlerts({ h: 6, w: 8, x: 16, y: 52 }),

])
