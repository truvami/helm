local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local template = grafana.template;
local prometheus = grafana.prometheus;
local graphPanel = grafana.graphPanel;
local pieChart = grafana.pieChartPanel;
local singlestat = grafana.singlestat;
local stat = grafana.statPanel;
local annotation = grafana.annotation;
local alertList = grafana.alertlist;
local row = grafana.row;

// Common Truvami dashboard configurations
{
  // Standard annotations for all dashboards (matching bridge dashboard)
  annotations:: [
    // Built-in Grafana annotations
    {
      builtIn: 1,
      datasource: { type: 'grafana', uid: '-- Grafana --' },
      enable: true,
      hide: true,
      iconColor: 'rgba(0, 211, 255, 1)',
      name: 'Annotations & Alerts',
      type: 'dashboard',
    },
    // Alert annotations
    {
      datasource: { type: 'prometheus', uid: '${datasource}' },
      enable: true,
      hide: false,
      iconColor: 'red',
      name: 'Critical Alerts',
      target: {
        expr: 'count by (alertname) (ALERTS{alertstate="firing",service="$service",namespace="$namespace",severity="critical"})',
        interval: '',
        refId: 'Anno',
      },
      titleFormat: '{{alertname}}',
    },
    {
      datasource: { type: 'prometheus', uid: '${datasource}' },
      enable: true,
      hide: false,
      iconColor: 'orange',
      name: 'Major Alerts',
      target: {
        expr: 'count by (alertname) (ALERTS{alertstate="firing",service="$service",namespace="$namespace",severity="major"})',
        interval: '',
        refId: 'Anno',
      },
      titleFormat: '{{alertname}}',
    },
    {
      datasource: { type: 'prometheus', uid: '${datasource}' },
      enable: true,
      hide: false,
      iconColor: 'light-orange',
      name: 'Minor Alerts',
      target: {
        expr: 'count by (alertname) (ALERTS{alertstate="firing",service="$service",namespace="$namespace",severity="minor"})',
        interval: '',
        refId: 'Anno',
      },
      titleFormat: '{{alertname}}',
    },
    {
      datasource: { type: 'prometheus', uid: '${datasource}' },
      enable: true,
      hide: false,
      iconColor: 'yellow',
      name: 'Warning Alerts',
      target: {
        expr: 'count by (alertname) (ALERTS{alertstate="firing",service="$service",namespace="$namespace",severity="warning"})',
        interval: '',
        refId: 'Anno',
      },
      textFormat: '',
      titleFormat: '{{alertname}}',
    },
    {
      datasource: { type: 'prometheus', uid: '${datasource}' },
      enable: true,
      hide: false,
      iconColor: 'purple',
      name: 'Intermediate Alerts',
      target: {
        expr: 'count by (alertname) (ALERTS{alertstate="firing",service="$service",namespace="$namespace",severity="intermediate"})',
        interval: '',
        refId: 'Anno',
      },
      textFormat: '',
      titleFormat: '{{alertname}}',
    },
  ],

    // Standard templates/variables
  templates:: {
    // Datasource template
    datasource: {
      allowCustomValue: false,
      current: { text: 'Prometheus', value: '${datasource}' },
      label: 'Datasource',
      name: 'datasource',
      options: [],
      query: 'prometheus',
      refresh: 1,
      regex: '',
      type: 'datasource',
    },

    // Namespace selector
    namespace: {
      allowCustomValue: false,
      current: { text: 'truvami-dev', value: 'truvami-dev' },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(up,namespace)',
      description: '',
      label: 'Namespace',
      name: 'namespace',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(up,namespace)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 1,
      regex: '',
      sort: 1,
      type: 'query',
    },

    // Service selector for service-specific dashboards
    service(serviceName): {
      current: { text: serviceName, value: serviceName },
      hide: 2,
      name: 'service',
      query: serviceName,
      skipUrlSync: true,
      type: 'constant',
    },

    // DevEui selector for device-specific dashboards
    devEui: {
      allowCustomValue: false,
      current: { text: 'All', value: '.*' },
      datasource: { type: 'prometheus', uid: '${datasource}' },
      definition: 'label_values(device_info{namespace="$namespace"},devEui)',
      description: '',
      includeAll: true,
      allValue: '.*',
      label: 'DevEui',
      multi: false,
      name: 'devEui',
      options: [],
      query: {
        qryType: 1,
        query: 'label_values(device_info{namespace="$namespace"},devEui)',
        refId: 'PrometheusVariableQueryEditor-VariableQuery',
      },
      refresh: 1,
      regex: '',
      sort: 1,
      type: 'query',
    },
  },

  // Common dashboard settings
  dashboardDefaults:: {
    schemaVersion: 41,
    tags: [],
    timezone: 'browser',
    refresh: '',
    time: { from: 'now-6h', to: 'now' },
    timepicker: {},
    editable: true,
    fiscalYearStartMonth: 0,
    graphTooltip: 1,
    links: [],
    preload: true,
  },

  // Service dashboard builder
  serviceDashboard(serviceName, extraPanels=[], devEuiFilter=false)::
    local alertFilter = if devEuiFilter then
      '{namespace="$namespace", service="$service", devEui=~"$devEui"}'
    else
      '{namespace="$namespace", service="$service"}';

    local standardPanels = [
      $.panels.serviceInfo(serviceName),
      $.panels.versionInfo(serviceName),
      $.panels.buildDateInfo(serviceName),
      $.panels.alarmsRow(),
      $.panels.criticalAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="critical"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.majorAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="major"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.minorAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="minor"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.warningAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="warning"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.intermediateAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="intermediate"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.infoAlerts() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(severity) (ALERTS' + alertFilter + '{severity="info"})',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.alertsList() + (if devEuiFilter then {
        options+: { alertInstanceLabelFilter: alertFilter }
      } else {}),
      $.panels.alertsPie() + (if devEuiFilter then {
        targets: [{
          expr: 'count by(alertname) (ALERTS' + alertFilter + ')',
          legendFormat: '__auto',
        }]
      } else {}),
      $.panels.goRow(),
      $.panels.goVersion(serviceName),
      $.panels.goHeap(serviceName),
      $.panels.goThreads(serviceName),
    ];

    local allTemplates = [
      $.templates.datasource,
      $.templates.namespace,
      $.templates.service(serviceName),
    ] + (if devEuiFilter then [$.templates.devEui] else []);

    dashboard.new(
      'Service - ' + serviceName,
      uid=std.strReplace(serviceName, '-', ''),
      tags=$.dashboardDefaults.tags,
      refresh=$.dashboardDefaults.refresh,
      time_from=$.dashboardDefaults.time.from,
      time_to=$.dashboardDefaults.time.to,
      schemaVersion=$.dashboardDefaults.schemaVersion,
      editable=$.dashboardDefaults.editable,
    )
    .addAnnotations($.annotations)
    .addTemplates(allTemplates)
    .addPanels(standardPanels + extraPanels)
    + {
      fiscalYearStartMonth: $.dashboardDefaults.fiscalYearStartMonth,
      graphTooltip: $.dashboardDefaults.graphTooltip,
      links: $.dashboardDefaults.links,
      preload: $.dashboardDefaults.preload,
      timezone: $.dashboardDefaults.timezone,
      timepicker: $.dashboardDefaults.timepicker,
    },

  // Device dashboard builder (based on truvami-device.json reference)
  deviceDashboard(serviceName='truvami-device')::
    local deviceTemplates = [
      $.templates.datasource,
      $.templates.namespace,
      $.templates.service(serviceName),
      {
        allowCustomValue: true,
        current: { text: ['All'], value: ['$__all'] },
        datasource: { type: 'prometheus', uid: '${datasource}' },
        definition: 'label_values(truvami_device_uplink_count{namespace="$namespace"},devEui)',
        description: '',
        includeAll: true,
        label: 'Devices',
        multi: true,
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
    ];

    local devicePanels = [
      // Alarms row
      row.new('Alarms') + { gridPos: { h: 1, w: 24, x: 0, y: 0 }, collapsed: false },

      // Alert stat panels with devEui filtering
      $.panels.criticalAlerts() + {
        gridPos: { h: 3, w: 4, x: 0, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", devEui=~"$devices", severity="critical"})',
          legendFormat: '__auto',
        }],
      },
      $.panels.majorAlerts() + {
        gridPos: { h: 3, w: 4, x: 4, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", devEui=~"$devices", severity="major"})',
          legendFormat: '__auto',
        }],
      },
      $.panels.minorAlerts() + {
        gridPos: { h: 3, w: 4, x: 8, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", devEui=~"$devices", severity="minor"})',
          legendFormat: '__auto',
        }],
      },
      $.panels.warningAlerts() + {
        gridPos: { h: 3, w: 4, x: 12, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", devEui=~"$devices", severity="warning"})',
          legendFormat: '__auto',
        }],
      },
      $.panels.intermediateAlerts() + {
        gridPos: { h: 3, w: 4, x: 16, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", devEui=~"$devices", severity="intermediate"})',
          legendFormat: '__auto',
        }],
      },
      $.panels.infoAlerts() + {
        gridPos: { h: 3, w: 4, x: 20, y: 1 },
        targets: [{
          expr: 'count by(severity) (ALERTS{namespace="$namespace", service=~"$devices", severity="info"})',
          legendFormat: '__auto',
        }],
      },

      // Alert list and pie chart
      $.panels.alertsList({ h: 15, w: 18, x: 0, y: 4 }) + {
        options+: {
          alertInstanceLabelFilter: '{service="$service",namespace="$namespace"}',
        },
      },
      $.panels.alertsPie({ h: 15, w: 6, x: 18, y: 4 }) + {
        targets: [{
          expr: 'count by(alertname) (ALERTS{namespace="$namespace", devEui=~"$devices"})',
          legendFormat: '__auto',
          refId: 'A',
        }],
      },

      // Uplinks row
      row.new('Uplinks') + { gridPos: { h: 1, w: 24, x: 0, y: 19 }, collapsed: false },

      // Uplinks per hour graph
      {
        type: 'timeseries',
        title: 'Uplinks per hour',
        datasource: '${datasource}',
        gridPos: { h: 10, w: 24, x: 0, y: 20 },
        targets: [{
          expr: 'avg by(devEui) (rate(truvami_device_uplink_count{devEui=~"$devices"}[1h])) * 60 * 60',
          legendFormat: '__auto',
          refId: 'A',
        }],
        fieldConfig: {
          defaults: {
            color: { mode: 'palette-classic' },
            custom: {
              axisBorderShow: false,
              axisCenteredZero: false,
              axisColorMode: 'text',
              axisLabel: '',
              axisPlacement: 'auto',
              barAlignment: 0,
              barWidthFactor: 0.6,
              drawStyle: 'line',
              fillOpacity: 0,
              gradientMode: 'none',
              hideFrom: { legend: false, tooltip: false, viz: false },
              insertNulls: false,
              lineInterpolation: 'linear',
              lineWidth: 1,
              pointSize: 5,
              scaleDistribution: { type: 'linear' },
              showPoints: 'auto',
              spanNulls: false,
              stacking: { group: 'A', mode: 'none' },
              thresholdsStyle: { mode: 'off' },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'green', value: 0 }],
            },
            unit: 'uplinks/h',
          },
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: {
            hideZeros: false,
            mode: 'single',
            sort: 'none',
          },
        },
      },
    ];

    grafana.dashboard.new(
      serviceName,
      uid=serviceName,
      time_from=$.dashboardDefaults.time.from,
      time_to=$.dashboardDefaults.time.to,
      refresh=$.dashboardDefaults.refresh,
      tags=$.dashboardDefaults.tags,
      editable=$.dashboardDefaults.editable,
    )
    .addAnnotations($.annotations)
    .addTemplates(deviceTemplates)
    .addPanels(devicePanels)
    + {
      fiscalYearStartMonth: $.dashboardDefaults.fiscalYearStartMonth,
      graphTooltip: $.dashboardDefaults.graphTooltip,
      links: $.dashboardDefaults.links,
      preload: $.dashboardDefaults.preload,
      timezone: $.dashboardDefaults.timezone,
      timepicker: $.dashboardDefaults.timepicker,
    },

  // Standard service info panels
  panels:: {
    // Service stat panel
    serviceInfo(serviceName, gridPos={ h: 3, w: 8, x: 0, y: 0 }):
      stat.new(
        'Service',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(service) (ALERTS{namespace="$namespace", service="$service"})',
          legendFormat='{{service}}',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'text', value: 0 }],
            },
          },
          overrides: [],
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
          textMode: 'name',
        },
        gridPos: gridPos,
      },

    // Version stat panel
    versionInfo(serviceName, gridPos={ h: 3, w: 8, x: 8, y: 0 }):
      stat.new(
        'Version',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(version) (' + std.strReplace(serviceName, '-', '_') + '_info{namespace="$namespace"})',
          legendFormat='{{version}}',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'text', value: 0 }],
            },
          },
          overrides: [],
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
          textMode: 'name',
        },
        gridPos: gridPos,
      },

    // Build date stat panel
    buildDateInfo(serviceName, gridPos={ h: 3, w: 8, x: 16, y: 0 }):
      stat.new(
        'Build Date',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(build_date) (' + std.strReplace(serviceName, '-', '_') + '_info{namespace="$namespace"})',
          legendFormat='{{build_date}}',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'text', value: 0 }],
            },
          },
          overrides: [],
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
          textMode: 'name',
        },
        gridPos: gridPos,
      },

    // Alarms row
    alarmsRow(gridPos={ h: 1, w: 24, x: 0, y: 3 }):
      row.new('Alarms') + { gridPos: gridPos, collapsed: false },

    // Critical alerts panel
    criticalAlerts(gridPos={ h: 3, w: 4, x: 0, y: 4 }):
      stat.new(
        'Critical',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="critical"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'dark-red', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Major alerts panel
    majorAlerts(gridPos={ h: 3, w: 4, x: 4, y: 4 }):
      stat.new(
        'Major',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="major"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'orange', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Minor alerts panel
    minorAlerts(gridPos={ h: 3, w: 4, x: 8, y: 4 }):
      stat.new(
        'Minor',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="minor"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'light-orange', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Warning alerts panel
    warningAlerts(gridPos={ h: 3, w: 4, x: 12, y: 4 }):
      stat.new(
        'Warning',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="warning"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'yellow', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Intermediate alerts panel
    intermediateAlerts(gridPos={ h: 3, w: 4, x: 16, y: 4 }):
      stat.new(
        'Intermediate',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="intermediate"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'purple', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Info alerts panel
    infoAlerts(gridPos={ h: 3, w: 4, x: 20, y: 4 }):
      stat.new(
        'Info',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(severity) (ALERTS{namespace="$namespace", service="$service", severity="info"})',
          legendFormat='__auto',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            noValue: '0',
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'text', value: 0 },
                { color: 'blue', value: 1 },
              ],
            },
          },
          overrides: [],
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

    // Alert list panel
    alertsList(gridPos={ h: 15, w: 18, x: 0, y: 7 }):
      alertList.new(
        'List',
      )
      + {
        options: {
          alertInstanceLabelFilter: '{service="$service",namespace="$namespace"}',
          alertName: '',
          dashboardAlerts: false,
          groupBy: [],
          groupMode: 'default',
          maxItems: 20,
          showInactiveAlerts: false,
          sortOrder: 3,
          stateFilter: {
            'error': true,
            firing: true,
            noData: true,
            normal: false,
            pending: true,
            recovering: true,
          },
          viewMode: 'list',
        },
        gridPos: gridPos,
      },

    // Alerts pie chart
    alertsPie(gridPos={ h: 15, w: 6, x: 18, y: 7 }):
      pieChart.new(
        'Alerts',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(alertname) (ALERTS{namespace="$namespace", service="$service"})',
          legendFormat='__auto',
        )
      )
      + {
        options: {
          legend: {
            displayMode: 'list',
            placement: 'bottom',
            showLegend: true,
          },
          pieType: 'pie',
          reduceOptions: {
            calcs: ['lastNotNull'],
            fields: '',
            values: false,
          },
          tooltip: {
            hideZeros: false,
            mode: 'single',
            sort: 'none',
          },
        },
        gridPos: gridPos,
      },

    // Go row
    goRow(gridPos={ h: 1, w: 24, x: 0, y: 22 }):
      row.new('Go') + { gridPos: gridPos, collapsed: false },

    // Go version panel
    goVersion(serviceName, gridPos={ h: 3, w: 6, x: 0, y: 23 }):
      stat.new(
        'Version',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'count by(version) (go_info{namespace="$namespace", container="$service"})',
          legendFormat='{{version}}',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'text', value: 0 }],
            },
          },
          overrides: [],
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
          textMode: 'name',
        },
        gridPos: gridPos,
      },

    // Go heap memory
    goHeap(serviceName, gridPos={ h: 7, w: 18, x: 6, y: 23 }):
      graphPanel.new(
        'Heap',
        datasource='${datasource}',
        format='decbytes',
      )
      .addTarget(
        prometheus.target(
          'avg_over_time(go_memstats_heap_alloc_bytes{namespace="$namespace", container="$service"}[$__interval])',
          legendFormat='Heap',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { fixedColor: 'blue', mode: 'fixed' },
            custom: {
              drawStyle: 'line',
              lineInterpolation: 'linear',
              lineWidth: 2,
              fillOpacity: 10,
              gradientMode: 'none',
              spanNulls: false,
              insertNulls: false,
              showPoints: 'auto',
              pointSize: 5,
              stacking: { group: 'A', mode: 'none' },
              axisPlacement: 'auto',
              axisLabel: '',
              axisColorMode: 'text',
              axisBorderShow: false,
              scaleDistribution: { type: 'linear' },
              axisCenteredZero: false,
              hideFrom: { legend: false, tooltip: false, viz: false },
              thresholdsStyle: { mode: 'off' },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'text', value: 0 }],
            },
            unit: 'decbytes',
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'bottom',
            showLegend: false,
          },
          tooltip: { mode: 'single', sort: 'none' },
        },
        gridPos: gridPos,
      },

    // Go threads
    goThreads(serviceName, gridPos={ h: 4, w: 6, x: 0, y: 26 }):
      graphPanel.new(
        'Threads',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'avg_over_time(go_threads{namespace="$namespace", container="$service"}[$__interval])',
          legendFormat='Threads',
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
              fillOpacity: 10,
              gradientMode: 'none',
              spanNulls: false,
              insertNulls: false,
              showPoints: 'auto',
              pointSize: 5,
              stacking: { group: 'A', mode: 'none' },
              axisPlacement: 'auto',
              axisLabel: '',
              axisColorMode: 'text',
              axisBorderShow: false,
              scaleDistribution: { type: 'linear' },
              axisCenteredZero: false,
              hideFrom: { legend: false, tooltip: false, viz: false },
              thresholdsStyle: { mode: 'off' },
            },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [{ color: 'green', value: 0 }],
            },
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'bottom',
            showLegend: false,
          },
          tooltip: { mode: 'single', sort: 'none' },
        },
        gridPos: gridPos,
      },

    // Pod status
    podStatus(serviceName, gridPos={ h: 8, w: 12, x: 0, y: 8 }):
      graphPanel.new(
        'Pod Status',
        datasource='${datasource}',
        format='short',
        stack=true,
      ).addTargets([
        prometheus.target(
          'sum by(phase) (kube_pod_status_phase{namespace="$namespace",pod=~"' + serviceName + '-.*"})',
          legendFormat='{{phase}}',
        ),
      ]) + { gridPos: gridPos },

    // Memory usage
    memoryUsage(serviceName, gridPos={ h: 8, w: 12, x: 12, y: 8 }):
      graphPanel.new(
        'Memory Usage',
        datasource='${datasource}',
        format='bytes',
      ).addTargets([
        prometheus.target(
          'sum(container_memory_usage_bytes{namespace="$namespace",pod=~"' + serviceName + '-.*",container!="POD",container!=""})',
          legendFormat='Usage',
        ),
        prometheus.target(
          'sum(container_spec_memory_limit_bytes{namespace="$namespace",pod=~"' + serviceName + '-.*",container!="POD",container!=""})',
          legendFormat='Limit',
        ),
      ]) + { gridPos: gridPos },

    // CPU usage
    cpuUsage(serviceName, gridPos={ h: 8, w: 12, x: 0, y: 16 }):
      graphPanel.new(
        'CPU Usage',
        datasource='${datasource}',
        format='percent',
      ).addTargets([
        prometheus.target(
          'sum(rate(container_cpu_usage_seconds_total{namespace="$namespace",pod=~"' + serviceName + '-.*",container!="POD",container!=""}[5m])) * 100',
          legendFormat='Usage %',
        ),
      ]) + { gridPos: gridPos },

    // Request rate
    requestRate(serviceName, gridPos={ h: 8, w: 12, x: 12, y: 16 }):
      graphPanel.new(
        'Request Rate',
        datasource='${datasource}',
        format='reqps',
      ).addTargets([
        prometheus.target(
          'sum(rate(http_requests_total{service="' + serviceName + '",namespace="$namespace"}[5m]))',
          legendFormat='Requests/sec',
        ),
      ]) + { gridPos: gridPos },

    // Error rate
    errorRate(serviceName, gridPos={ h: 8, w: 24, x: 0, y: 24 }):
      graphPanel.new(
        'Error Rate',
        datasource='${datasource}',
        format='percent',
        min=0,
        max=100,
      ).addTargets([
        prometheus.target(
          'sum(rate(http_requests_total{service="' + serviceName + '",namespace="$namespace",code=~"5.."}[5m])) / sum(rate(http_requests_total{service="' + serviceName + '",namespace="$namespace"}[5m])) * 100',
          legendFormat='Error Rate %',
        ),
      ]) + { gridPos: gridPos },
  },

  // Utility functions
  utils:: {
    // Generate grid position
    gridPos(h, w, x, y): { h: h, w: w, x: x, y: y },

    // Standard panel sizes
    fullWidth: { h: 8, w: 24, x: 0 },
    halfWidth: { h: 8, w: 12, x: 0 },
    quarterWidth: { h: 8, w: 6, x: 0 },
  },
}
