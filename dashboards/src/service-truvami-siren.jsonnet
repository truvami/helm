local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Siren-specific panels
local sirenPanels = {
  // Kafka consumer lag and processing
  kafkaConsumerHealth(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'Kafka Consumer Health',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum by(topic) (rate(truvami_kafka_messages_consumed_count{namespace="$namespace", container="truvami-siren"}[5m])) * 60',
        legendFormat='{{topic}} Messages/min',
      ),
      prometheus.target(
        'sum(ALERTS{namespace="$namespace", alertname="SirenKafkaConsumerDown", alertstate="firing"})',
        legendFormat='Consumer Down Alerts',
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

  // Alert dispatch performance
  alertDispatchStats(gridPos={ h: 8, w: 12, x: 12, y: 0 }):
    graphPanel.new(
      'Alert Dispatch Performance',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum by(schema) (rate(truvami_alerts_dispatch_count{namespace="$namespace", container="truvami-siren"}[5m])) * 60',
        legendFormat='{{schema}} Dispatches/min',
      ),
      prometheus.target(
        'sum by(schema) (rate(truvami_alerts_dispatch_errors_count{namespace="$namespace", container="truvami-siren"}[5m])) * 60',
        legendFormat='{{schema}} Errors/min',
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

  // Alert processing by type
  alertProcessingByType(gridPos={ h: 6, w: 8, x: 0, y: 8 }):
    stat.new(
      'Battery Alerts Processed',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(rate(truvami_alerts_battery_statuses_processed_count{namespace="$namespace", container="truvami-siren"}[5m])) * 60',
        legendFormat='Battery Alerts/min',
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
              { color: 'yellow', value: 10 },
              { color: 'red', value: 50 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Position alerts processing
  positionAlertsProcessing(gridPos={ h: 6, w: 8, x: 8, y: 8 }):
    stat.new(
      'Position Alerts Processed',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(rate(truvami_alerts_positions_processed_count{namespace="$namespace", container="truvami-siren"}[5m])) * 60',
        legendFormat='Position Alerts/min',
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
              { color: 'yellow', value: 10 },
              { color: 'red', value: 50 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Dispatch stalled alerts
  dispatchStalledAlerts(gridPos={ h: 6, w: 8, x: 16, y: 8 }):
    stat.new(
      'Dispatch Stalled Alerts',
      datasource='${datasource}',
    )
    .addTarget(
      prometheus.target(
        'sum(ALERTS{namespace="$namespace", alertname="TruvamySirenAlertDispatchStalled", alertstate="firing"})',
        legendFormat='Stalled Dispatches',
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
              { color: 'red', value: 5 },
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
truvami.serviceDashboard('truvami-siren', [
  // Siren-specific section (after Go panels which end at y: 42)
  row.new('Alert Engine (Siren) Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 43 }, collapsed: false },
  sirenPanels.kafkaConsumerHealth({ h: 8, w: 12, x: 0, y: 44 }),
  sirenPanels.alertDispatchStats({ h: 8, w: 12, x: 12, y: 44 }),
  sirenPanels.alertProcessingByType({ h: 6, w: 8, x: 0, y: 52 }),
  sirenPanels.positionAlertsProcessing({ h: 6, w: 8, x: 8, y: 52 }),
  sirenPanels.dispatchStalledAlerts({ h: 6, w: 8, x: 16, y: 52 }),

])
