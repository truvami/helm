local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Port categorization for pricing
local wifiPorts = '5|7|50|51|105|107|151|197|198|200|201';
local expensiveGnssPorts = '192|193|194|195';

// Uplinks pricing dashboard panels
local pricingPanels = {
  // Overview stats for all uplinks - aggregate totals
  totalUplinksPerHour: {
    type: 'stat',
    title: 'Total Uplinks per Hour (All Customers)',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 6, x: 0, y: 0 },
    targets: [{
      expr: 'sum (rate(truvami_device_uplink_count{namespace="$namespace"}[1h]) * 3600)',
      legendFormat: 'Total',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 1000 },
            { color: 'red', value: 5000 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  totalUplinksPerDay: {
    type: 'stat',
    title: 'Total Uplinks per Day (All Customers)',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 6, x: 6, y: 0 },
    targets: [{
      expr: 'sum (rate(truvami_device_uplink_count{namespace="$namespace"}[1d]) * 86400)',
      legendFormat: 'Total',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 10000 },
            { color: 'red', value: 50000 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  totalUplinksPerWeek: {
    type: 'stat',
    title: 'Total Uplinks per Week (All Customers)',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 6, x: 12, y: 0 },
    targets: [{
      expr: 'sum (rate(truvami_device_uplink_count{namespace="$namespace"}[7d]) * 604800)',
      legendFormat: 'Total',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 70000 },
            { color: 'red', value: 350000 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  totalUplinksPerMonth: {
    type: 'stat',
    title: 'Total Uplinks per Month (All Customers)',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 6, x: 18, y: 0 },
    targets: [{
      expr: 'sum (rate(truvami_device_uplink_count{namespace="$namespace"}[30d]) * 2592000)',
      legendFormat: 'Total',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 300000 },
            { color: 'red', value: 1500000 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  // Additional overview stats
  activeCustomers: {
    type: 'stat',
    title: 'Active Customers (Last 24h)',
    datasource: '${datasource}',
    gridPos: { h: 4, w: 6, x: 0, y: 8 },
    targets: [{
      expr: 'count by(__name__) (count by(customer) (increase(truvami_device_uplink_count{namespace="$namespace"}[24h]) > 0))',
      legendFormat: 'Customers',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 10 },
            { color: 'red', value: 50 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  expensiveUplinksPercentage: {
    type: 'stat',
    title: 'Expensive Uplinks % (Last 24h)',
    datasource: '${datasource}',
    gridPos: { h: 4, w: 6, x: 6, y: 8 },
    targets: [{
      expr: '(sum (increase(truvami_device_uplink_count{port=~"' + wifiPorts + '|' + expensiveGnssPorts + '", namespace="$namespace"}[24h])) / sum (increase(truvami_device_uplink_count{namespace="$namespace"}[24h]))) * 100',
      legendFormat: 'Expensive %',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 5 },
            { color: 'red', value: 15 },
          ],
        },
        unit: 'percent',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  wifiUplinksPercentage: {
    type: 'stat',
    title: 'Wi-Fi Uplinks % (Last 24h)',
    datasource: '${datasource}',
    gridPos: { h: 4, w: 6, x: 12, y: 8 },
    targets: [{
      expr: '(sum (increase(truvami_device_uplink_count{port=~"' + wifiPorts + '", namespace="$namespace"}[24h])) / sum (increase(truvami_device_uplink_count{namespace="$namespace"}[24h]))) * 100',
      legendFormat: 'Wi-Fi %',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 3 },
            { color: 'red', value: 10 },
          ],
        },
        unit: 'percent',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  gnssUplinksPercentage: {
    type: 'stat',
    title: 'GNSS Uplinks % (Last 24h)',
    datasource: '${datasource}',
    gridPos: { h: 4, w: 6, x: 18, y: 8 },
    targets: [{
      expr: '(sum (increase(truvami_device_uplink_count{port=~"' + expensiveGnssPorts + '", namespace="$namespace"}[24h])) / sum (increase(truvami_device_uplink_count{namespace="$namespace"}[24h]))) * 100',
      legendFormat: 'GNSS %',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 2 },
            { color: 'red', value: 5 },
          ],
        },
        unit: 'percent',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'auto',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'auto',
    },
  },

  // Uplinks by customer over time - different intervals
  uplinksPerHourByCustomer: {
    type: 'timeseries',
    title: 'Uplinks per Hour by Customer',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 0, y: 14 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", namespace="$namespace"}[1h]) * 3600)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: [], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'single', sort: 'none' },
    },
  },

  uplinksPerDayByCustomer: {
    type: 'timeseries',
    title: 'Uplinks per Day by Customer',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 12, y: 14 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", namespace="$namespace"}[1d]) * 86400)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: [], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'single', sort: 'none' },
    },
  },

  uplinksPerWeekByCustomer: {
    type: 'timeseries',
    title: 'Uplinks per Week by Customer',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 0, y: 24 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", namespace="$namespace"}[7d]) * 604800)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: [], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'single', sort: 'none' },
    },
  },

  uplinksPerMonthByCustomer: {
    type: 'timeseries',
    title: 'Uplinks per Month by Customer',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 12, y: 24 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", namespace="$namespace"}[30d]) * 2592000)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 1,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: [], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'single', sort: 'none' },
    },
  },

  // Wi-Fi uplinks (expensive) - hourly stats
  wifiUplinksPerHourByCustomer: {
    type: 'stat',
    title: 'Wi-Fi Uplinks per Hour by Customer (Ports: ' + wifiPorts + ')',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 12, x: 0, y: 36 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", port=~"' + wifiPorts + '", namespace="$namespace"}[1h]) * 3600)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 50 },
            { color: 'red', value: 200 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'center',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'value_and_name',
    },
  },

  // Expensive passive GNSS uplinks - hourly stats
  expensiveGnssUplinksPerHourByCustomer: {
    type: 'stat',
    title: 'Expensive Passive GNSS Uplinks per Hour by Customer (Ports: ' + expensiveGnssPorts + ')',
    datasource: '${datasource}',
    gridPos: { h: 8, w: 12, x: 12, y: 36 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", port=~"' + expensiveGnssPorts + '", namespace="$namespace"}[1h]) * 3600)',
      legendFormat: '{{customer}}',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 25 },
            { color: 'red', value: 100 },
          ],
        },
        unit: 'short',
      },
      overrides: [],
    },
    options: {
      colorMode: 'value',
      graphMode: 'area',
      justifyMode: 'center',
      orientation: 'auto',
      reduceOptions: {
        values: false,
        calcs: ['lastNotNull'],
        fields: '',
      },
      textMode: 'value_and_name',
    },
  },

  // Wi-Fi uplinks timeseries
  wifiUplinksTimeseriesByCustomer: {
    type: 'timeseries',
    title: 'Wi-Fi Uplinks by Customer Over Time (Ports: ' + wifiPorts + ')',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 0, y: 46 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", port=~"' + wifiPorts + '", namespace="$namespace"}[$interval]) * 3600)',
      legendFormat: '{{customer}} (Wi-Fi)',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 2,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short/h',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: ['mean', 'max'], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'multi', sort: 'desc' },
    },
  },

  // Expensive GNSS uplinks timeseries
  expensiveGnssUplinksTimeseriesByCustomer: {
    type: 'timeseries',
    title: 'Expensive Passive GNSS Uplinks by Customer Over Time (Ports: ' + expensiveGnssPorts + ')',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 12, x: 12, y: 46 },
    targets: [{
      expr: 'sum by(customer) (rate(truvami_device_uplink_count{customer=~"$customers", port=~"' + expensiveGnssPorts + '", namespace="$namespace"}[$interval]) * 3600)',
      legendFormat: '{{customer}} (GNSS)',
      refId: 'A',
    }],
    fieldConfig: {
      defaults: {
        color: { mode: 'palette-classic' },
        custom: {
          axisLabel: '',
          axisPlacement: 'auto',
          barAlignment: 0,
          drawStyle: 'line',
          fillOpacity: 10,
          gradientMode: 'none',
          hideFrom: { legend: false, tooltip: false, vis: false },
          lineInterpolation: 'linear',
          lineWidth: 2,
          pointSize: 5,
          scaleDistribution: { type: 'linear' },
          showPoints: 'never',
          spanNulls: false,
          stacking: { group: 'A', mode: 'none' },
          thresholdsStyle: { mode: 'off' },
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'red', value: 80 },
          ],
        },
        unit: 'short/h',
      },
      overrides: [],
    },
    options: {
      legend: { calcs: ['mean', 'max'], displayMode: 'list', placement: 'bottom' },
      tooltip: { mode: 'multi', sort: 'desc' },
    },
  },

  // Table view with pricing breakdown by customer
  pricingBreakdownTable: {
    type: 'table',
    title: 'Uplinks Pricing Breakdown by Customer (Last 24h)',
    datasource: '${datasource}',
    gridPos: { h: 10, w: 24, x: 0, y: 58 },
    targets: [
      {
        expr: 'sum by(customer) (increase(truvami_device_uplink_count{customer=~"$customers", namespace="$namespace"}[24h]))',
        legendFormat: 'Total',
        refId: 'A',
        format: 'table',
        instant: true,
      },
      {
        expr: 'sum by(customer) (increase(truvami_device_uplink_count{customer=~"$customers", port=~"' + wifiPorts + '", namespace="$namespace"}[24h]))',
        legendFormat: 'Wi-Fi',
        refId: 'B',
        format: 'table',
        instant: true,
      },
      {
        expr: 'sum by(customer) (increase(truvami_device_uplink_count{customer=~"$customers", port=~"' + expensiveGnssPorts + '", namespace="$namespace"}[24h]))',
        legendFormat: 'Expensive GNSS',
        refId: 'C',
        format: 'table',
        instant: true,
      },
      {
        expr: 'sum by(customer) (increase(truvami_device_uplink_count{customer=~"$customers", port!~"' + wifiPorts + '|' + expensiveGnssPorts + '", namespace="$namespace"}[24h]))',
        legendFormat: 'Standard',
        refId: 'D',
        format: 'table',
        instant: true,
      }
    ],
    fieldConfig: {
      defaults: {
        color: { mode: 'thresholds' },
        custom: {
          align: 'auto',
          displayMode: 'auto',
          filterable: false,
          inspect: false,
        },
        mappings: [],
        thresholds: {
          mode: 'absolute',
          steps: [
            { color: 'green', value: null },
            { color: 'yellow', value: 1000 },
            { color: 'red', value: 5000 },
          ],
        },
        unit: 'short',
      },
      overrides: [
        {
          matcher: { id: 'byName', options: 'customer' },
          properties: [
            { id: 'custom.width', value: 200 },
            { id: 'displayName', value: 'Customer' },
          ],
        },
        {
          matcher: { id: 'byName', options: 'Value #A' },
          properties: [{ id: 'displayName', value: 'Total Uplinks (24h)' }],
        },
        {
          matcher: { id: 'byName', options: 'Value #B' },
          properties: [{ id: 'displayName', value: 'Wi-Fi Uplinks (24h)' }],
        },
        {
          matcher: { id: 'byName', options: 'Value #C' },
          properties: [{ id: 'displayName', value: 'Expensive GNSS Uplinks (24h)' }],
        },
        {
          matcher: { id: 'byName', options: 'Value #D' },
          properties: [{ id: 'displayName', value: 'Standard Uplinks (24h)' }],
        },
      ],
    },
    options: {
      showHeader: true,
      sortBy: [{ desc: true, displayName: 'Total Uplinks (24h)' }],
    },
    transformations: [
      {
        id: 'merge',
        options: {},
      },
      {
        id: 'organize',
        options: {
          excludeByName: { Time: true },
          indexByName: {},
          renameByName: {},
        },
      },
    ],
  },
};

// Build the uplinks pricing dashboard
dashboard.new(
  'Truvami Uplinks Pricing',
  tags=['truvami', 'uplinks', 'pricing', 'customer'],
  time_from='now-7d',
  time_to='now',
  refresh='30s',
  schemaVersion=36,
  uid='truvami-uplinks-pricing',
)
.addAnnotations(truvami.annotations)
.addTemplates([
  truvami.templates.datasource,
  truvami.templates.namespace,
  // Customers template variable
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
  // Add custom interval variable for this dashboard
  {
    auto: false,
    auto_count: 30,
    auto_min: '10s',
    current: { text: '5m', value: '5m' },
    description: 'Time interval for rate calculations',
    label: 'Interval',
    name: 'interval',
    options: [
      { selected: false, text: '1m', value: '1m' },
      { selected: true, text: '5m', value: '5m' },
      { selected: false, text: '10m', value: '10m' },
      { selected: false, text: '30m', value: '30m' },
      { selected: false, text: '1h', value: '1h' },
      { selected: false, text: '6h', value: '6h' },
      { selected: false, text: '12h', value: '12h' },
    ],
    query: '1m,5m,10m,30m,1h,6h,12h',
    refresh: 2,
    type: 'interval',
  },
])
.addPanels([
  // Overview section - aggregate totals
  row.new('Platform Overview - Aggregate Totals') + { gridPos: { h: 1, w: 24, x: 0, y: 0 }, collapsed: false },
  pricingPanels.totalUplinksPerHour,
  pricingPanels.totalUplinksPerDay,
  pricingPanels.totalUplinksPerWeek,
  pricingPanels.totalUplinksPerMonth,
  pricingPanels.activeCustomers,
  pricingPanels.expensiveUplinksPercentage,
  pricingPanels.wifiUplinksPercentage,
  pricingPanels.gnssUplinksPercentage,

  // Uplinks by customer over time
  row.new('Uplinks by Customer Over Time') + { gridPos: { h: 1, w: 24, x: 0, y: 13 }, collapsed: false },
  pricingPanels.uplinksPerHourByCustomer,
  pricingPanels.uplinksPerDayByCustomer,
  pricingPanels.uplinksPerWeekByCustomer,
  pricingPanels.uplinksPerMonthByCustomer,

  // Expensive uplinks by type
  row.new('Expensive Uplinks by Port Type') + { gridPos: { h: 1, w: 24, x: 0, y: 35 }, collapsed: false },
  pricingPanels.wifiUplinksPerHourByCustomer,
  pricingPanels.expensiveGnssUplinksPerHourByCustomer,

  // Timeseries for expensive uplinks
  row.new('Expensive Uplinks Timeseries') + { gridPos: { h: 1, w: 24, x: 0, y: 45 }, collapsed: false },
  pricingPanels.wifiUplinksTimeseriesByCustomer,
  pricingPanels.expensiveGnssUplinksTimeseriesByCustomer,

  // Pricing breakdown table
  row.new('Pricing Breakdown') + { gridPos: { h: 1, w: 24, x: 0, y: 57 }, collapsed: false },
  pricingPanels.pricingBreakdownTable,
])
