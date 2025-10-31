local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Gateway-specific panels
local gatewayPanels = {
  // LoRaWAN Gateway Signal Strength (RSSI)
  gatewayRssi(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'LoRaWAN Gateway Signal Strength (RSSI)',
      datasource='${datasource}',
      format='dBm',
    )
    .addTarget(
      prometheus.target(
        'truvami_gateway_uplink_rssi{namespace="$namespace"}',
        legendFormat='Gateway {{gatewayId}} - Device {{devEui}}',
      )
    )
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'line',
            lineInterpolation: 'linear',
            lineWidth: 2,
            fillOpacity: 0,
            axisLabel: 'Signal Strength (dBm)',
          },
          unit: 'dBm',
        },
      },
      gridPos: gridPos,
    },

  // LoRaWAN Gateway Signal Quality (SNR)
  gatewaySNR(gridPos={ h: 8, w: 12, x: 12, y: 0 }):
    graphPanel.new(
      'LoRaWAN Gateway Signal Quality (SNR)',
      datasource='${datasource}',
      format='dB',
    )
    .addTarget(
      prometheus.target(
        'truvami_gateway_uplink_snr{namespace="$namespace"}',
        legendFormat='Gateway {{gatewayId}} - Device {{devEui}}',
      )
    )
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'line',
            lineInterpolation: 'linear',
            lineWidth: 2,
            fillOpacity: 0,
            axisLabel: 'Signal-to-Noise Ratio (dB)',
          },
          unit: 'dB',
        },
      },
      gridPos: gridPos,
    },

  // Gateway Activity Count
  gatewayActivity(gridPos={ h: 6, w: 12, x: 0, y: 8 }):
    stat.new(
      'Active Gateways',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'count(count by (gatewayId) (truvami_gateway_uplink_rssi{namespace="$namespace"}))',
        legendFormat='Active Gateways',
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
              { color: 'yellow', value: 1 },
              { color: 'green', value: 3 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Average Signal Quality by Gateway
  averageSignalQuality(gridPos={ h: 6, w: 12, x: 12, y: 8 }):
    graphPanel.new(
      'Average Signal Quality by Gateway',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'avg by (gatewayId) (truvami_gateway_uplink_rssi{namespace="$namespace"})',
        legendFormat='Avg RSSI - Gateway {{gatewayId}}',
      ),
      prometheus.target(
        'avg by (gatewayId) (truvami_gateway_uplink_snr{namespace="$namespace"})',
        legendFormat='Avg SNR - Gateway {{gatewayId}}',
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
};

// Build dashboard with service-specific panels
truvami.serviceDashboard('truvami-gateway', [
  // Gateway-specific section (after Go panels which end at y: 42)
  row.new('LoRaWAN Gateway Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 43 }, collapsed: false },
  gatewayPanels.gatewayRssi({ h: 8, w: 12, x: 0, y: 44 }),
  gatewayPanels.gatewaySNR({ h: 8, w: 12, x: 12, y: 44 }),
  gatewayPanels.gatewayActivity({ h: 6, w: 12, x: 0, y: 52 }),
  gatewayPanels.averageSignalQuality({ h: 6, w: 12, x: 12, y: 52 }),

])
