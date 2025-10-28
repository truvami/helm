local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local graphPanel = grafana.graphPanel;
local stat = grafana.statPanel;
local prometheus = grafana.prometheus;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Quality Thresholds Configuration
local qualityThresholds = {
  // LoRaWAN Quality
  uplinkSuccessRate: 95,      // % minimum uplink success rate
  rssiThreshold: -110,        // dBm minimum RSSI
  snrThreshold: 0,            // dB minimum SNR

  // GPS Quality
  gpsMinSatellites: 8,        // minimum satellite count
  gpsMaxPdop: 3.0,           // maximum PDOP for good accuracy
  gpsMaxTimeToFix: 60,       // seconds maximum time to first fix

  // Battery & Device Health
  batteryMinVoltage: 4.0,    // V minimum battery voltage
  maxResetsPer1h: 0,         // maximum device resets per hour
  maxBufferLevel: 5,         // maximum buffer level

  // Error Rates
  maxDecoderErrorRate: 0.1,  // errors per minute
  maxDutyCycleRate: 30,      // duty cycle hits per minute

  // Uplink Rate Quality
  minUplinksPerHour: 12,     // minimum uplinks per hour (1 every 5 min)
  maxUplinksPerHour: 3600,   // maximum uplinks per hour (1 per second max)

  // LoRaWAN Airtime & Duty Cycle (EU regulations)
  maxDutyCyclePercent: 1.0,  // Maximum 1% duty cycle (EU fair use policy)
  avgPacketSize: 51,         // Average packet size in bytes for airtime calculation
  bandwidth: 125000,         // LoRaWAN bandwidth in Hz (125 kHz standard)
  codingRate: 5,             // Coding rate 4/5
  preambleLength: 8,         // Standard preamble length
  explicitHeader: true,      // Explicit header mode
  lowDataRateOptimize: false, // Low data rate optimization
};

// Fixed colors for spreading factors
local spreadingFactorColors = {
  SF7: 'green',
  SF8: 'light-green',
  SF9: 'yellow',
  SF10: 'orange',
  SF11: 'light-red',
  SF12: 'red',
};

// Device Quality Dashboard Panels
local deviceQualityPanels = {
  // Quality Gates Configuration Table
  qualityGatesTable(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    {
      type: 'table',
      title: 'Quality Gates Configuration',
      datasource: null,
      gridPos: gridPos,
      targets: [],
      transformations: [
        {
          id: 'createDataset',
          options: {
            data: [
              { 'Quality Criteria': 'L2: Uplink Success Rate', 'Threshold': qualityThresholds.uplinkSuccessRate + '%', 'Category': 'LoRaWAN' },
              { 'Quality Criteria': 'L4: RSSI Signal Quality', 'Threshold': '>' + qualityThresholds.rssiThreshold + ' dBm', 'Category': 'LoRaWAN' },
              { 'Quality Criteria': 'L4: SNR Signal Quality', 'Threshold': '>' + qualityThresholds.snrThreshold + ' dB', 'Category': 'LoRaWAN' },
              { 'Quality Criteria': 'G1: GPS Satellites', 'Threshold': '≥' + qualityThresholds.gpsMinSatellites, 'Category': 'GPS' },
              { 'Quality Criteria': 'G1: GPS PDOP', 'Threshold': '<' + qualityThresholds.gpsMaxPdop, 'Category': 'GPS' },
              { 'Quality Criteria': 'G1: GPS Time to Fix', 'Threshold': '<' + qualityThresholds.gpsMaxTimeToFix + 's', 'Category': 'GPS' },
              { 'Quality Criteria': 'B1: Battery Level', 'Threshold': '>' + qualityThresholds.batteryMinVoltage + 'V', 'Category': 'Device Health' },
              { 'Quality Criteria': 'S1: Device Stability', 'Threshold': '≤' + qualityThresholds.maxResetsPer1h + ' resets/h', 'Category': 'Device Health' },
              { 'Quality Criteria': 'Buffer Level', 'Threshold': '<' + qualityThresholds.maxBufferLevel, 'Category': 'Device Health' },
              { 'Quality Criteria': 'C1: Decoder Error Rate', 'Threshold': '<' + qualityThresholds.maxDecoderErrorRate + '/min', 'Category': 'Cloud Processing' },
              { 'Quality Criteria': 'Uplink Rate Range', 'Threshold': qualityThresholds.minUplinksPerHour + '-' + qualityThresholds.maxUplinksPerHour + '/h', 'Category': 'Uplink Quality' },
              { 'Quality Criteria': 'LoRaWAN Duty Cycle', 'Threshold': '<' + qualityThresholds.maxDutyCyclePercent + '%', 'Category': 'LoRaWAN Compliance' },
            ],
          },
        },
      ],
      fieldConfig: {
        defaults: {
          custom: {
            align: 'auto',
            cellOptions: {
              type: 'auto',
            },
            inspect: false,
          },
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
            ],
          },
          color: {
            mode: 'thresholds',
          },
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Category',
            },
            properties: [
              {
                id: 'custom.width',
                value: 150,
              },
            ],
          },
        ],
      },
      options: {
        showHeader: true,
        cellHeight: 'sm',
        footer: {
          show: false,
          reducer: ['sum'],
          countRows: false,
        },
      },
    },

  // Quality Criteria Summary Table (Updated with configurable thresholds)
  qualityCriteriaTable(gridPos={ h: 12, w: 12, x: 12, y: 0 }):
    {
      type: 'table',
      title: 'Device Quality Criteria Status',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [
        // L2. Uplink Success Rate
        {
          expr: 'clamp_max(sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[5m])) * 100, 100) >= ' + qualityThresholds.uplinkSuccessRate,
          legendFormat: 'L2_Uplink_Success',
          refId: 'A',
          instant: true,
        },
        // L4. Signal Quality - RSSI
        {
          expr: 'avg by(devEui) (truvami_gateway_uplink_rssi{namespace="$namespace", devEui=~"$devices"}) > ' + qualityThresholds.rssiThreshold,
          legendFormat: 'L4_Signal_Quality_RSSI',
          refId: 'B',
          instant: true,
        },
        // L4. Signal Quality - SNR
        {
          expr: 'avg by(devEui) (truvami_gateway_uplink_snr{namespace="$namespace", devEui=~"$devices"}) > ' + qualityThresholds.snrThreshold,
          legendFormat: 'L4_Signal_Quality_SNR',
          refId: 'C',
          instant: true,
        },
        // G1. GPS Satellites
        {
          expr: 'avg by(devEui) (truvami_device_gnss_satellites_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) >= ' + qualityThresholds.gpsMinSatellites,
          legendFormat: 'G1_GPS_Satellites',
          refId: 'D',
          instant: true,
        },
        // G1. GPS PDOP
        {
          expr: 'avg by(devEui) (truvami_device_gnss_pdop_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < ' + qualityThresholds.gpsMaxPdop,
          legendFormat: 'G1_GPS_PDOP',
          refId: 'E',
          instant: true,
        },
        // G1. GPS Time to Fix
        {
          expr: 'avg by(devEui) (truvami_device_gnss_time_to_first_fix_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < ' + qualityThresholds.gpsMaxTimeToFix,
          legendFormat: 'G1_GPS_Time_To_Fix',
          refId: 'F',
          instant: true,
        },
        // B1. Battery Level
        {
          expr: 'avg by(devEui) (truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) > ' + qualityThresholds.batteryMinVoltage,
          legendFormat: 'B1_Battery_Level',
          refId: 'G',
          instant: true,
        },
        // S1. Device Stability
        {
          expr: 'sum by(devEui) (increase(truvami_device_reset_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h])) <= ' + qualityThresholds.maxResetsPer1h,
          legendFormat: 'S1_Device_Stability',
          refId: 'H',
          instant: true,
        },
        // C1. Decoder Error Rate
        {
          expr: 'rate(truvami_uplink_created_but_decoder_err_count{namespace="$namespace"}[5m]) * 60 < ' + qualityThresholds.maxDecoderErrorRate,
          legendFormat: 'C1_Decoder_Errors',
          refId: 'I',
          instant: true,
        },
        // Buffer Level
        {
          expr: 'avg by(devEui) (truvami_device_buffer_level{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < ' + qualityThresholds.maxBufferLevel,
          legendFormat: 'Buffer_Level',
          refId: 'J',
          instant: true,
        },
        // Uplink Rate Quality (within range)
        {
          expr: '(sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h])) * 3600 >= ' + qualityThresholds.minUplinksPerHour + ') and (sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h])) * 3600 <= ' + qualityThresholds.maxUplinksPerHour + ')',
          legendFormat: 'Uplink_Rate_Range',
          refId: 'K',
          instant: true,
        },
        // LoRaWAN Duty Cycle Compliance
        {
          expr: '(' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF7"}[1h]) * 3600 * 61.696 + ' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF8"}[1h]) * 3600 * 113.408 + ' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF9"}[1h]) * 3600 * 205.824 + ' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF10"}[1h]) * 3600 * 371.712 + ' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF11"}[1h]) * 3600 * 659.456 + ' +
            'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF12"}[1h]) * 3600 * 1318.912' +
            ') / 3600000 * 100 < ' + qualityThresholds.maxDutyCyclePercent,
          legendFormat: 'LoRaWAN_Duty_Cycle',
          refId: 'L',
          instant: true,
        },
      ],
      transformations: [
        {
          id: 'seriesToColumns',
          options: {
            byField: 'devEui',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              'Time': true,
            },
            indexByName: {
              'devEui': 0,
              'L2_Uplink_Success': 1,
              'L4_Signal_Quality_RSSI': 2,
              'L4_Signal_Quality_SNR': 3,
              'G1_GPS_Satellites': 4,
              'G1_GPS_PDOP': 5,
              'G1_GPS_Time_To_Fix': 6,
              'B1_Battery_Level': 7,
              'S1_Device_Stability': 8,
              'C1_Decoder_Errors': 9,
              'Buffer_Level': 10,
              'Uplink_Rate_Range': 11,
              'LoRaWAN_Duty_Cycle': 12,
            },
            renameByName: {
              'devEui': 'Device EUI',
              'L2_Uplink_Success': 'L2: Uplink Success (>' + qualityThresholds.uplinkSuccessRate + '%)',
              'L4_Signal_Quality_RSSI': 'L4: RSSI (>' + qualityThresholds.rssiThreshold + 'dBm)',
              'L4_Signal_Quality_SNR': 'L4: SNR (>' + qualityThresholds.snrThreshold + 'dB)',
              'G1_GPS_Satellites': 'G1: GPS Sats (≥' + qualityThresholds.gpsMinSatellites + ')',
              'G1_GPS_PDOP': 'G1: GPS PDOP (<' + qualityThresholds.gpsMaxPdop + ')',
              'G1_GPS_Time_To_Fix': 'G1: GPS TTFF (<' + qualityThresholds.gpsMaxTimeToFix + 's)',
              'B1_Battery_Level': 'B1: Battery (>' + qualityThresholds.batteryMinVoltage + 'V)',
              'S1_Device_Stability': 'S1: Stability (≤' + qualityThresholds.maxResetsPer1h + ' resets/h)',
              'C1_Decoder_Errors': 'C1: Decoder Errors (<' + qualityThresholds.maxDecoderErrorRate + '/min)',
              'Buffer_Level': 'Buffer Level (<' + qualityThresholds.maxBufferLevel + ')',
              'Uplink_Rate_Range': 'Uplink Rate (' + qualityThresholds.minUplinksPerHour + '-' + qualityThresholds.maxUplinksPerHour + '/h)',
              'LoRaWAN_Duty_Cycle': 'LoRaWAN Duty Cycle (<' + qualityThresholds.maxDutyCyclePercent + '%)',
            },
          },
        },
      ],
      fieldConfig: {
        defaults: {
          custom: {
            align: 'center',
            cellOptions: {
              type: 'color-background',
            },
            inspect: false,
          },
          mappings: [
            {
              options: {
                '0': {
                  color: 'red',
                  index: 0,
                  text: 'FAIL',
                },
                '1': {
                  color: 'green',
                  index: 1,
                  text: 'PASS',
                },
              },
              type: 'value',
            },
          ],
          color: {
            mode: 'thresholds',
          },
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: 0,
              },
              {
                color: 'green',
                value: 1,
              },
            ],
          },
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Device EUI',
            },
            properties: [
              {
                id: 'custom.cellOptions',
                value: {
                  type: 'auto',
                },
              },
              {
                id: 'color',
                value: {
                  mode: 'fixed',
                  fixedColor: 'transparent',
                },
              },
            ],
          },
        ],
      },
      options: {
        showHeader: true,
        cellHeight: 'sm',
        footer: {
          show: false,
          reducer: ['sum'],
          countRows: false,
        },
      },
    },

  // Overall Quality Score for selected devices
  overallQualityScore(gridPos={ h: 8, w: 8, x: 0, y: 12 }):
    {
      type: 'stat',
      title: 'Overall Quality Score',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [
        {
          expr: '(\n  (\n    (sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[5m])) * 100 >= 95) +\n    (avg by(devEui) (truvami_gateway_uplink_rssi{namespace="$namespace", devEui=~"$devices"}) > -110) +\n    (avg by(devEui) (truvami_gateway_uplink_snr{namespace="$namespace", devEui=~"$devices"}) > 0) +\n    (avg by(devEui) (truvami_device_gnss_satellites_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) >= 8) +\n    (avg by(devEui) (truvami_device_gnss_pdop_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < 3.0) +\n    (avg by(devEui) (truvami_device_gnss_time_to_first_fix_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < 60) +\n    (avg by(devEui) (truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) > 4.0) +\n    (sum by(devEui) (increase(truvami_device_reset_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h])) == 0) +\n    (avg by(devEui) (truvami_device_buffer_level{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}) < 5)\n  ) / 9\n) * 100',
          legendFormat: 'Quality Score %',
          refId: 'A',
        },
      ],
      fieldConfig: {
        defaults: {
          color: {
            mode: 'thresholds',
          },
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'red',
                value: 0,
              },
              {
                color: 'yellow',
                value: 70,
              },
              {
                color: 'green',
                value: 90,
              },
            ],
          },
          unit: 'percent',
          min: 0,
          max: 100,
        },
      },
      options: {
        reduceOptions: {
          values: false,
          calcs: ['lastNotNull'],
          fields: '',
        },
        orientation: 'auto',
        textMode: 'auto',
        colorMode: 'value',
        graphMode: 'area',
        justifyMode: 'auto',
      },
    },

  // Device Selection Helper
  deviceSelector(gridPos={ h: 8, w: 8, x: 8, y: 12 }):
    {
      type: 'stat',
      title: 'Selected Devices',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [
        {
          expr: 'count(count by(devEui) (truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}))',
          legendFormat: 'Device Count',
          refId: 'A',
        },
      ],
      fieldConfig: {
        defaults: {
          color: {
            mode: 'palette-classic',
          },
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: 0,
              },
            ],
          },
          unit: 'short',
        },
      },
      options: {
        reduceOptions: {
          values: false,
          calcs: ['lastNotNull'],
          fields: '',
        },
        orientation: 'auto',
        textMode: 'auto',
        colorMode: 'none',
        graphMode: 'none',
        justifyMode: 'center',
      },
    },

  // Quality Legend
  qualityLegend(gridPos={ h: 8, w: 8, x: 16, y: 12 }):
    {
      type: 'text',
      title: 'Quality Criteria Legend',
      gridPos: gridPos,
      options: {
        mode: 'markdown',
        content: '## Quality Criteria\n\n' +
                 '**L2**: Uplink Success Rate > ' + qualityThresholds.uplinkSuccessRate + '%\n' +
                 '**L4**: Signal Quality (RSSI > ' + qualityThresholds.rssiThreshold + 'dBm, SNR > ' + qualityThresholds.snrThreshold + 'dB)\n' +
                 '**G1**: GPS Quality (≥' + qualityThresholds.gpsMinSatellites + ' sats, PDOP < ' + qualityThresholds.gpsMaxPdop + ', TTFF < ' + qualityThresholds.gpsMaxTimeToFix + 's)\n' +
                 '**B1**: Battery Level > ' + qualityThresholds.batteryMinVoltage + 'V\n' +
                 '**S1**: Device Stability (≤' + qualityThresholds.maxResetsPer1h + ' resets/h)\n' +
                 '**C1**: Decoder Error Rate < ' + qualityThresholds.maxDecoderErrorRate + '/min\n\n' +
                 '**Uplink Rate**: ' + qualityThresholds.minUplinksPerHour + '-' + qualityThresholds.maxUplinksPerHour + ' uplinks/hour\n' +
                 '**LoRaWAN Duty Cycle**: <' + qualityThresholds.maxDutyCyclePercent + '% (EU fair use policy)\n\n' +
                 '### Status Colors:\n' +
                 '🟢 **PASS** - Meets criteria\n' +
                 '🔴 **FAIL** - Below threshold\n\n' +
                 '*Use device filter above to test specific devices*',
      },
    },

  // Uplink Rate Quality Monitoring
  uplinkRateQuality(gridPos={ h: 8, w: 12, x: 0, y: 20 }):
    graphPanel.new(
      'Uplink Rate Quality (Expected: ' + qualityThresholds.minUplinksPerHour + '-' + qualityThresholds.maxUplinksPerHour + '/h)',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h])) * 3600',
        legendFormat='Uplinks/hour',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'red', value: 0 },
              { color: 'red', value: qualityThresholds.minUplinksPerHour },
              { color: 'green', value: qualityThresholds.minUplinksPerHour },
              { color: 'green', value: qualityThresholds.maxUplinksPerHour },
              { color: 'red', value: qualityThresholds.maxUplinksPerHour },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Uplink Port Distribution
  uplinkPortDistribution(gridPos={ h: 8, w: 12, x: 12, y: 20 }):
    {
      type: 'piechart',
      title: 'Uplink Port Distribution',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [{
        expr: 'sum by(port, devEui) (increase(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[$__range]))',
        legendFormat: 'Port {{port}}',
        refId: 'A',
      }],
      options: {
        reduceOptions: {
          values: false,
          calcs: ['lastNotNull'],
          fields: '',
        },
        pieType: 'pie',
        tooltip: { mode: 'single', sort: 'none' },
        legend: {
          displayMode: 'table',
          placement: 'right',
          values: ['value', 'percent'],
        },
        displayLabels: ['name', 'percent'],
      },
    },

  // Active Ports List
  activePortsList(gridPos={ h: 8, w: 24, x: 0, y: 28 }):
    {
      type: 'table',
      title: 'Active Uplink Ports Summary',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [
        {
          expr: 'sum by(port, devEui) (increase(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h]))',
          legendFormat: 'Port {{port}}',
          refId: 'A',
          instant: true,
        },
      ],
      transformations: [
        {
          id: 'seriesToColumns',
          options: {
            byField: 'port',
          },
        },
        {
          id: 'organize',
          options: {
            excludeByName: {
              'Time': true,
            },
            indexByName: {
              'devEui': 0,
              'port': 1,
              'Value': 2,
            },
            renameByName: {
              'devEui': 'Device EUI',
              'port': 'Port',
              'Value': 'Uplinks (Last Hour)',
            },
          },
        },
        {
          id: 'sortBy',
          options: {
            fields: {},
            sort: [
              {
                field: 'Port',
                desc: false,
              },
            ],
          },
        },
      ],
      fieldConfig: {
        defaults: {
          custom: {
            align: 'auto',
            cellOptions: {
              type: 'auto',
            },
            inspect: false,
          },
          mappings: [],
          thresholds: {
            mode: 'absolute',
            steps: [
              {
                color: 'green',
                value: null,
              },
              {
                color: 'red',
                value: 80,
              },
            ],
          },
          color: {
            mode: 'thresholds',
          },
        },
        overrides: [
          {
            matcher: {
              id: 'byName',
              options: 'Port',
            },
            properties: [
              {
                id: 'custom.width',
                value: 100,
              },
            ],
          },
        ],
      },
      options: {
        showHeader: true,
        cellHeight: 'sm',
        footer: {
          show: false,
          reducer: ['sum'],
          countRows: false,
        },
      },
    },
  // LoRaWAN Quality Metrics (L1, L2, L4)

  // L2. Uplink message success rate
  uplinkSuccessRate(gridPos={ h: 8, w: 12, x: 0, y: 0 }):
    graphPanel.new(
      'Uplink Rate per Device',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum by(devEui) (rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[5m])) * 60',
        legendFormat='Uplinks/min',
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
          min: 0,
        },
      },
      gridPos: gridPos,
    },

  // Total uplinks stat panel
  totalUplinks(gridPos={ h: 8, w: 6, x: 12, y: 0 }):
    stat.new(
      'Total Uplinks',
      datasource='${datasource}',
    )
    .addTargets([
      prometheus.target(
        'sum by(devEui) (increase(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[$__range]))',
        legendFormat='Total',
      ),
    ])
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'thresholds' },
          unit: 'short',
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'red', value: 0 },
              { color: 'yellow', value: 100 },
              { color: 'green', value: 1000 },
            ],
          },
        },
      },
      gridPos: gridPos,
    },

  // L3. ADR behaviour - SF distribution
  spreadingFactorDistribution(gridPos={ h: 8, w: 6, x: 18, y: 0 }):
    {
      type: 'piechart',
      title: 'Spreading Factor Distribution (ADR Behaviour)',
      datasource: '${datasource}',
      gridPos: gridPos,
      targets: [{
        expr: 'sum by(spreadingFactor, devEui) (increase(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[$__range]))',
        legendFormat: '{{spreadingFactor}}',
        refId: 'A',
      }],
      fieldConfig: {
        defaults: {
          color: { mode: 'fixed' },
        },
        overrides: [
          { matcher: { id: 'byName', options: 'SF7' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF7 } }] },
          { matcher: { id: 'byName', options: 'SF8' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF8 } }] },
          { matcher: { id: 'byName', options: 'SF9' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF9 } }] },
          { matcher: { id: 'byName', options: 'SF10' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF10 } }] },
          { matcher: { id: 'byName', options: 'SF11' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF11 } }] },
          { matcher: { id: 'byName', options: 'SF12' }, properties: [{ id: 'color', value: { mode: 'fixed', fixedColor: spreadingFactorColors.SF12 } }] },
        ],
      },
      options: {
        reduceOptions: {
          values: false,
          calcs: ['lastNotNull'],
          fields: '',
        },
        pieType: 'pie',
        tooltip: { mode: 'single', sort: 'none' },
        legend: {
          displayMode: 'table',
          placement: 'right',
          values: ['value', 'percent'],
        },
        displayLabels: ['name', 'percent'],
      },
    },

  // Signal Quality - RSSI and SNR
  signalQuality(gridPos={ h: 8, w: 24, x: 0, y: 8 }):
    graphPanel.new(
      'Signal Quality (RSSI & SNR)',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'avg by(devEui) (truvami_gateway_uplink_rssi{namespace="$namespace", devEui=~"$devices"})',
        legendFormat='RSSI (dBm)',
      ),
      prometheus.target(
        'avg by(devEui) (truvami_gateway_uplink_snr{namespace="$namespace", devEui=~"$devices"})',
        legendFormat='SNR (dB)',
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
        },
        overrides: [
          {
            matcher: { id: 'byRegexp', options: '.*RSSI.*' },
            properties: [
              { id: 'unit', value: 'short' },
              { id: 'thresholds', value: {
                mode: 'absolute',
                steps: [
                  { color: 'red', value: -120 },
                  { color: 'yellow', value: -100 },
                  { color: 'green', value: -80 },
                ],
              }},
            ],
          },
          {
            matcher: { id: 'byRegexp', options: '.*SNR.*' },
            properties: [
              { id: 'unit', value: 'short' },
              { id: 'thresholds', value: {
                mode: 'absolute',
                steps: [
                  { color: 'red', value: -10 },
                  { color: 'yellow', value: 0 },
                  { color: 'green', value: 10 },
                ],
              }},
            ],
          },
        ],
      },
      gridPos: gridPos,
    },

  // G1. GPS Quality Metrics
  gpsQuality(gridPos={ h: 8, w: 12, x: 0, y: 16 }):
    graphPanel.new(
      'GPS Quality Metrics',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'avg by(devEui) (truvami_device_gnss_satellites_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
        legendFormat='Satellites',
      ),
      prometheus.target(
        'avg by(devEui) (truvami_device_gnss_pdop_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
        legendFormat='PDOP',
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
        },
        overrides: [
          {
            matcher: { id: 'byRegexp', options: '.*Satellites.*' },
            properties: [
              { id: 'thresholds', value: {
                mode: 'absolute',
                steps: [
                  { color: 'red', value: 0 },
                  { color: 'yellow', value: 4 },
                  { color: 'green', value: 8 },
                ],
              }},
            ],
          },
          {
            matcher: { id: 'byRegexp', options: '.*PDOP.*' },
            properties: [
              { id: 'thresholds', value: {
                mode: 'absolute',
                steps: [
                  { color: 'green', value: 0 },
                  { color: 'yellow', value: 3 },
                  { color: 'red', value: 6 },
                ],
              }},
            ],
          },
        ],
      },
      gridPos: gridPos,
    },

  // GPS Time to First Fix
  gpsTimeToFix(gridPos={ h: 8, w: 12, x: 12, y: 16 }):
    graphPanel.new(
      'GPS Time to First Fix',
      datasource='${datasource}',
      format='s',
    )
    .addTargets([
      prometheus.target(
        'avg by(devEui) (truvami_device_gnss_time_to_first_fix_value{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
        legendFormat='Time to Fix (s)',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 60 },
              { color: 'red', value: 120 },
            ],
          },
          unit: 's',
        },
      },
      gridPos: gridPos,
    },

  // B1. Battery Status
  batteryStatus(gridPos={ h: 8, w: 12, x: 0, y: 24 }):
    graphPanel.new(
      'Battery Status by Device',
      datasource='${datasource}',
      format='volt',
    )
    .addTargets([
      prometheus.target(
        'avg by(devEui) (truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
        legendFormat='Battery (V)',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'red', value: 0 },
              { color: 'yellow', value: 3.5 },
              { color: 'green', value: 4.0 },
            ],
          },
          unit: 'volt',
          min: 3.0,
          max: 4.5,
        },
      },
      gridPos: gridPos,
    },

  // S1. Device Reset Monitoring (Stability)
  deviceResets(gridPos={ h: 8, w: 12, x: 12, y: 24 }):
    graphPanel.new(
      'Device Reset Count (Stability)',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'sum by(devEui) (increase(truvami_device_reset_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[1h]))',
        legendFormat='Resets/hour',
      ),
    ])
    + {
      fieldConfig: {
        defaults: {
          color: { mode: 'palette-classic' },
          custom: {
            drawStyle: 'bars',
            lineInterpolation: 'linear',
            lineWidth: 2,
            fillOpacity: 80,
          },
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 1 },
              { color: 'red', value: 3 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // C1 & C2. Decoder Errors and Warnings
  decoderIssues(gridPos={ h: 8, w: 12, x: 0, y: 32 }):
    graphPanel.new(
      'Decoder Errors & Warnings',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'rate(truvami_uplink_created_but_decoder_err_count{namespace="$namespace"}[5m]) * 60',
        legendFormat='Decoder Errors/min',
      ),
      prometheus.target(
        'rate(truvami_uplink_created_but_decoder_warn_count{namespace="$namespace"}[5m]) * 60',
        legendFormat='Decoder Warnings/min',
      ),
      prometheus.target(
        'rate(truvami_smartlabel_v1_decoder_solver_failed_total{namespace="$namespace"}[5m]) * 60',
        legendFormat='SmartLabel Decoder Failures/min',
      ),
      prometheus.target(
        'rate(truvami_tagxl_v1_decoder_solver_failed_total{namespace="$namespace"}[5m]) * 60',
        legendFormat='TagXL Decoder Failures/min',
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

  // WiFi AP Scanning Quality (Note: Individual AP metrics not available in current setup)
  wifiApScanningQuality(gridPos={ h: 8, w: 12, x: 12, y: 32 }):
    graphPanel.new(
      'WiFi Positioning Quality',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'rate(truvami_wifi_solver_success_count{namespace="$namespace"}[5m]) * 60',
        legendFormat='WiFi Solver Success/min',
      ),
      prometheus.target(
        'rate(truvami_wifi_solver_error_count{namespace="$namespace"}[5m]) * 60',
        legendFormat='WiFi Solver Errors/min',
      ),
      prometheus.target(
        'rate(truvami_failed_to_create_wifi_access_point_through_grpc_count{namespace="$namespace"}[5m]) * 60',
        legendFormat='AP Creation Failures/min',
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
        },
        overrides: [
          {
            matcher: { id: 'byRegexp', options: '.*Success.*' },
            properties: [
              { id: 'color', value: { mode: 'fixed', fixedColor: 'green' } },
            ],
          },
          {
            matcher: { id: 'byRegexp', options: '.*Error.*|.*Failure.*' },
            properties: [
              { id: 'color', value: { mode: 'fixed', fixedColor: 'red' } },
            ],
          },
        ],
      },
      gridPos: gridPos,
    },

  // Buffer Level Quality
  bufferLevel(gridPos={ h: 8, w: 12, x: 0, y: 40 }):
    graphPanel.new(
      'Device Buffer Level',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'avg by(devEui) (truvami_device_buffer_level{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
        legendFormat='Buffer Level',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 5 },
              { color: 'red', value: 10 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // Duty Cycle Count
  dutyCycle(gridPos={ h: 8, w: 12, x: 12, y: 40 }):
    graphPanel.new(
      'Duty Cycle Count',
      datasource='${datasource}',
      format='short',
    )
    .addTargets([
      prometheus.target(
        'rate(truvami_device_duty_cycle_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[5m]) * 60',
        legendFormat='Duty Cycle Hits/min',
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
              { color: 'yellow', value: 10 },
              { color: 'red', value: 30 },
            ],
          },
          unit: 'short',
        },
      },
      gridPos: gridPos,
    },

  // LoRaWAN Airtime Monitoring
  airtimeMonitoring(gridPos={ h: 8, w: 12, x: 0, y: 48 }):
    graphPanel.new(
      'LoRaWAN Airtime per Device (1h rolling)',
      datasource='${datasource}',
      format='ms',
    )
    .addTargets([
      prometheus.target(
        // Calculate airtime using spreading factor and uplink rate - simplified calculation
        'sum by(devEui) (' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF7"}[1h]) * 3600 * 61.696 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF8"}[1h]) * 3600 * 113.408 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF9"}[1h]) * 3600 * 205.824 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF10"}[1h]) * 3600 * 371.712 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF11"}[1h]) * 3600 * 659.456 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF12"}[1h]) * 3600 * 1318.912' +
        ')',
        legendFormat='Airtime (ms/h)',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 30000 }, // 30 seconds (0.83% duty cycle)
              { color: 'red', value: 36000 },    // 36 seconds (1% duty cycle)
            ],
          },
          unit: 'ms',
          noValue: '0 ms/h',  // Show this when no data
        },
      },
      gridPos: gridPos,
    },

  // Duty Cycle Percentage
  dutyCyclePercentage(gridPos={ h: 8, w: 12, x: 12, y: 48 }):
    graphPanel.new(
      'Duty Cycle Percentage (EU Limit: <' + qualityThresholds.maxDutyCyclePercent + '%)',
      datasource='${datasource}',
      format='percent',
    )
    .addTargets([
      prometheus.target(
        // Convert airtime (ms/h) to duty cycle percentage - simplified calculation
        'sum by(devEui) (' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF7"}[1h]) * 3600 * 61.696 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF8"}[1h]) * 3600 * 113.408 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF9"}[1h]) * 3600 * 205.824 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF10"}[1h]) * 3600 * 371.712 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF11"}[1h]) * 3600 * 659.456 + ' +
        'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF12"}[1h]) * 3600 * 1318.912' +
        ') / 3600000 * 100', // Convert ms to % of hour
        legendFormat='Duty Cycle %',
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
          thresholds: {
            mode: 'absolute',
            steps: [
              { color: 'green', value: 0 },
              { color: 'yellow', value: 0.8 },
              { color: 'red', value: qualityThresholds.maxDutyCyclePercent },
            ],
          },
          unit: 'percent',
          max: 2.0, // Show up to 2% for visibility
          noValue: '0%',  // Show this when no data
        },
      },
      gridPos: gridPos,
    },

  // Summary Stats Row
  summaryStats: {
    // Overall device health score (based on battery, signal quality, and error rates)
    deviceHealthScore(gridPos={ h: 6, w: 6, x: 0, y: 97 }):
      stat.new(
        'Device Health Score',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          // Simplified health score based on battery > 3.8V, RSSI > -110, and low errors
          '((count(truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"} > 3.8) / count(truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})) + (count(avg by(devEui) (truvami_gateway_uplink_rssi{namespace="$namespace", devEui=~"$devices"}) > -110) / count(avg by(devEui) (truvami_gateway_uplink_rssi{namespace="$namespace", devEui=~"$devices"})))) / 2 * 100',
          legendFormat='Health Score',
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

    // Active devices count
    activeDevices(gridPos={ h: 6, w: 6, x: 6, y: 97 }):
      stat.new(
        'Active Devices',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count(count by(devEui) (increase(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers"}[5m]) > 0))',
          legendFormat='Active',
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
                { color: 'green', value: 5 },
              ],
            },
            unit: 'short',
          },
        },
        options: {
          colorMode: 'value',
          graphMode: 'none',
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

    // Average battery level
    avgBattery(gridPos={ h: 6, w: 6, x: 12, y: 97 }):
      stat.new(
        'Average Battery Level',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'avg(truvami_device_battery_status{namespace="$namespace", devEui=~"$devices", customer=~"$customers"})',
          legendFormat='Avg Battery',
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
                { color: 'yellow', value: 3.5 },
                { color: 'green', value: 4.0 },
              ],
            },
            unit: 'volt',
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

    // Error rate
    errorRate(gridPos={ h: 6, w: 6, x: 18, y: 97 }):
      stat.new(
        'Overall Error Rate',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'rate(truvami_uplink_created_but_decoder_err_count{namespace="$namespace"}[5m]) * 60',
          legendFormat='Errors/min',
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
                { color: 'yellow', value: 0.1 },
                { color: 'red', value: 1 },
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
  },
};

// Define spreading factor colors for consistency
local spreadingFactorColors = {
  SF7: 'green',
  SF8: 'light-green',
  SF9: 'yellow',
  SF10: 'orange',
  SF11: 'light-red',
  SF12: 'red',
};

// Custom device dashboard without alerts and with single device selection
local customDeviceDashboard(serviceName='device-quality-monitoring', extraPanels=[]) =
  local deviceTemplates = [
    truvami.templates.datasource,
    truvami.templates.namespace,
    truvami.templates.service(serviceName),
    {
      allowCustomValue: false,
      current: { text: ['All'], value: ['$__all'] },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(truvami_device_uplink_count,customer)',
      description: '',
      includeAll: true,
      label: 'Customers',
      multi: true,
      name: 'customers',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(truvami_device_uplink_count,customer)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 1,
      regex: '',
      sort: 1,
      type: 'query',
    },
    // Modified to allow only single device selection
    {
      allowCustomValue: true,
      current: { text: 'Select device', value: '' },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(truvami_device_uplink_count{namespace="$namespace"},devEui)',
      description: 'Select a single device for monitoring',
      includeAll: false,  // Changed: no "All" option
      label: 'Device',
      multi: false,       // Changed: single selection only
      name: 'devices',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(truvami_device_uplink_count{namespace="$namespace"},devEui)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 2,
      regex: '',
      sort: 1,
      type: 'query',
    },
    {
      current: { text: ['All'], value: ['$__all'] },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(truvami_device_uplink_count,port)',
      description: '',
      includeAll: true,
      label: 'Ports',
      multi: true,
      name: 'ports',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(truvami_device_uplink_count,port)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 1,
      regex: '',
      sort: 3,
      type: 'query',
    },
    {
      current: { text: ['All'], value: ['$__all'] },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(truvami_device_uplink_count,spreadingFactor)',
      includeAll: true,
      label: 'Spreading Factors',
      multi: true,
      name: 'spreadingFactors',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(truvami_device_uplink_count,spreadingFactor)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 1,
      regex: '',
      type: 'query',
    },
    {
      auto: false,
      auto_count: 30,
      auto_min: '10s',
      current: { text: '1h', value: '1h' },
      description: '',
      label: 'Interval',
      name: 'interval',
      options: [
        { selected: false, text: '1m', value: '1m' },
        { selected: false, text: '10m', value: '10m' },
        { selected: false, text: '30m', value: '30m' },
        { selected: true, text: '1h', value: '1h' },
        { selected: false, text: '6h', value: '6h' },
        { selected: false, text: '12h', value: '12h' },
        { selected: false, text: '1d', value: '1d' },
        { selected: false, text: '7d', value: '7d' },
        { selected: false, text: '14d', value: '14d' },
        { selected: false, text: '30d', value: '30d' },
      ],
      query: '1m,10m,30m,1h,6h,12h,1d,7d,14d,30d',
      refresh: 2,
      type: 'interval',
    },
  ];

  // No alert panels - start directly with quality panels
  dashboard.new(
    serviceName,
    uid=serviceName,
    time_from='now-6h',
    time_to='now',
    refresh='',
    tags=[],
    editable=true,
  )
  .addAnnotation({
    datasource: '${datasource}',
    enable: true,
    expr: 'changes(truvami_device_uplink_count{namespace="$namespace", devEui="$devices", customer=~"$customers"}[1m]) > 0',
    iconColor: 'rgba(0, 211, 255, 1)',
    name: 'Uplinks Received',
    step: '1m',
    textFormat: 'Uplink received',
    titleFormat: 'Uplink',
    type: 'prometheus',
  })
  .addTemplates(deviceTemplates)
  .addPanels(extraPanels)
  + {
    fiscalYearStartMonth: 0,
    graphTooltip: 1,
    links: [],
    preload: true,
    timezone: 'browser',
    timepicker: {},
  };

// Build device quality dashboard without alerts
customDeviceDashboard('device-quality-monitoring', [
  // Quality Configuration & Criteria Overview section
  row.new('Quality Gates Configuration & Status') + { gridPos: { h: 1, w: 24, x: 0, y: 0 }, collapsed: false },
  deviceQualityPanels.qualityGatesTable({ h: 8, w: 12, x: 0, y: 1 }),
  deviceQualityPanels.qualityCriteriaTable({ h: 12, w: 12, x: 12, y: 1 }),
  deviceQualityPanels.overallQualityScore({ h: 8, w: 8, x: 0, y: 9 }),
  deviceQualityPanels.deviceSelector({ h: 8, w: 8, x: 8, y: 9 }),
  deviceQualityPanels.qualityLegend({ h: 8, w: 8, x: 16, y: 9 }),

  // Uplink Quality section
  row.new('Uplink Quality Monitoring') + { gridPos: { h: 1, w: 24, x: 0, y: 17 }, collapsed: false },
  deviceQualityPanels.uplinkRateQuality({ h: 8, w: 12, x: 0, y: 18 }),
  deviceQualityPanels.uplinkPortDistribution({ h: 8, w: 12, x: 12, y: 18 }),
  deviceQualityPanels.activePortsList({ h: 8, w: 24, x: 0, y: 26 }),

  // LoRaWAN Quality section
  row.new('LoRaWAN Quality') + { gridPos: { h: 1, w: 24, x: 0, y: 34 }, collapsed: false },
  deviceQualityPanels.uplinkSuccessRate({ h: 8, w: 12, x: 0, y: 35 }),
  deviceQualityPanels.totalUplinks({ h: 8, w: 6, x: 12, y: 35 }),
  deviceQualityPanels.spreadingFactorDistribution({ h: 8, w: 6, x: 18, y: 35 }),
  deviceQualityPanels.signalQuality({ h: 8, w: 24, x: 0, y: 43 }),

  // GPS Quality section
  row.new('GPS Quality') + { gridPos: { h: 1, w: 24, x: 0, y: 51 }, collapsed: false },
  deviceQualityPanels.gpsQuality({ h: 8, w: 12, x: 0, y: 52 }),
  deviceQualityPanels.gpsTimeToFix({ h: 8, w: 12, x: 12, y: 52 }),

  // Device Health section
  row.new('Device Health') + { gridPos: { h: 1, w: 24, x: 0, y: 60 }, collapsed: false },
  deviceQualityPanels.batteryStatus({ h: 8, w: 12, x: 0, y: 61 }),
  deviceQualityPanels.deviceResets({ h: 8, w: 12, x: 12, y: 61 }),

  // Cloud Processing Quality section
  row.new('Cloud Processing Quality') + { gridPos: { h: 1, w: 24, x: 0, y: 69 }, collapsed: false },
  deviceQualityPanels.decoderIssues({ h: 8, w: 12, x: 0, y: 70 }),
  deviceQualityPanels.wifiApScanningQuality({ h: 8, w: 12, x: 12, y: 70 }),

  // System Performance section
  row.new('System Performance') + { gridPos: { h: 1, w: 24, x: 0, y: 78 }, collapsed: false },
  deviceQualityPanels.bufferLevel({ h: 8, w: 12, x: 0, y: 79 }),
  deviceQualityPanels.dutyCycle({ h: 8, w: 12, x: 12, y: 79 }),

  // LoRaWAN Airtime & Duty Cycle Compliance section
  row.new('LoRaWAN Airtime & Duty Cycle Compliance') + { gridPos: { h: 1, w: 24, x: 0, y: 87 }, collapsed: false },
  deviceQualityPanels.airtimeMonitoring({ h: 8, w: 12, x: 0, y: 88 }),
  deviceQualityPanels.dutyCyclePercentage({ h: 8, w: 12, x: 12, y: 88 }),

  // Summary section
  row.new('Quality Summary') + { gridPos: { h: 1, w: 24, x: 0, y: 96 }, collapsed: false },
  deviceQualityPanels.summaryStats.deviceHealthScore({ h: 6, w: 6, x: 0, y: 97 }),
  deviceQualityPanels.summaryStats.activeDevices({ h: 6, w: 6, x: 6, y: 97 }),
  deviceQualityPanels.summaryStats.avgBattery({ h: 6, w: 4, x: 12, y: 97 }),
  deviceQualityPanels.summaryStats.errorRate({ h: 6, w: 4, x: 16, y: 97 }),
  // Add duty cycle compliance summary
  {
    type: 'stat',
    title: 'Duty Cycle Compliance',
    datasource: '${datasource}',
    gridPos: { h: 6, w: 4, x: 20, y: 97 },
    targets: [
      {
        expr: 'count((' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF7"}[1h]) * 3600 * 61.696 + ' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF8"}[1h]) * 3600 * 113.408 + ' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF9"}[1h]) * 3600 * 205.824 + ' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF10"}[1h]) * 3600 * 371.712 + ' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF11"}[1h]) * 3600 * 659.456 + ' +
          'rate(truvami_device_uplink_count{namespace="$namespace", devEui=~"$devices", customer=~"$customers", spreadingFactor="SF12"}[1h]) * 3600 * 1318.912' +
          ') / 3600000 * 100 < ' + qualityThresholds.maxDutyCyclePercent + ')',
        legendFormat: 'Compliant Devices',
        refId: 'A',
      },
    ],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'red', value: 0 },
            { color: 'yellow', value: 1 },
            { color: 'green', value: 5 },
          ],
        },
        unit: 'short',
      },
    },
    options: {
      colorMode: 'value',
      graphMode: 'none',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        calcs: ['lastNotNull'],
        fields: '',
        values: false,
      },
      textMode: 'auto',
    },
  },
])
