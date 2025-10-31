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

    // Logs datasource template
    logsDatasource: {
      allowCustomValue: false,
      current: { text: 'Loki', value: '${logs_datasource}' },
      label: 'Logs Datasource',
      name: 'logs_datasource',
      options: [],
      query: 'loki',
      refresh: 1,
      regex: '',
      type: 'datasource',
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
      $.panels.serviceLogsPanel() + (if devEuiFilter then {
        targets: [{
          expr: '{namespace="$namespace", service="$service", devEui=~"$devEui"} |~ "devEui"',
          refId: 'A',
        }]
      } else {}),
      $.panels.goRow(),
      $.panels.goVersion(serviceName),
      $.panels.goGoroutines(serviceName),
      $.panels.goMaxProcs(serviceName),
      $.panels.goGCRate(serviceName),
      $.panels.goHeapCurrent(serviceName),
      $.panels.goNextGC(serviceName),
      $.panels.goHeapTimeseries(serviceName),
      $.panels.goRuntimeTimeseries(serviceName),
      $.panels.goGCDuration(serviceName),
      $.panels.goMemoryAllocationRate(serviceName),
    ];

    local allTemplates = [
      $.templates.datasource,
      $.templates.namespace,
      $.templates.service(serviceName),
      $.templates.logsDatasource,
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

  // Device dashboard builder (enhanced with uplinks.json panels)
  deviceDashboard(serviceName='truvami-device', extraPanels=[])::
    local deviceTemplates = [
      $.templates.datasource,
      $.templates.namespace,
      $.templates.service(serviceName),
      $.templates.logsDatasource,
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
      {
        allowCustomValue: true,
        current: { text: 'All', value: '$__all' },
        datasource: { type: 'prometheus', uid: '${datasource}' },
        definition: 'label_values(truvami_device_uplink_count{namespace="$namespace"},devEui)',
        description: '',
        includeAll: true,
        label: 'Devices',
        multi: false,
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

    local standardPanels = [
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

      // Alert list and device logs
      $.panels.alertsList({ h: 15, w: 8, x: 0, y: 4 }) + {
        options+: {
          alertInstanceLabelFilter: '{devEui=~"$devices",namespace="$namespace"}',
        },
      },
      $.panels.deviceLogsPanel({ h: 15, w: 16, x: 8, y: 4 }),
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
    .addPanels(standardPanels + extraPanels)
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

    // Alert list panel (1/3 width)
    alertsList(gridPos={ h: 15, w: 8, x: 0, y: 7 }):
      alertList.new(
        'Alerts List',
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

    // Service logs panel (2/3 width) - replaces alerts pie chart
    serviceLogsPanel(gridPos={ h: 15, w: 16, x: 8, y: 7 }):
      {
        type: 'logs',
        title: 'Service Logs',
        datasource: '${logs_datasource}',
        gridPos: gridPos,
        targets: [{
          expr: '{namespace="$namespace", service_name="$service"}',
          refId: 'A',
        }],
        options: {
          showTime: false,
          showLabels: false,
          showCommonLabels: false,
          wrapLogMessage: false,
          prettifyLogMessage: false,
          enableLogDetails: true,
          dedupStrategy: 'signature',
          sortOrder: 'Descending',
        },
        fieldConfig: {
          defaults: {
            custom: {
              align: 'auto',
              cellOptions: { type: 'auto' },
              inspect: false,
            },
          },
          overrides: [],
        },
      },

    // Device logs panel for searching devEui across all services
    deviceLogsPanel(gridPos={ h: 10, w: 24, x: 0, y: 22 }):
      {
        type: 'logs',
        title: 'Device Logs (DevEui Search)',
        datasource: '${logs_datasource}',
        gridPos: gridPos,
        targets: [{
          expr: '{namespace="$namespace", service_name=~"truvami-.*"} |~ "devEui"',
          refId: 'A',
        }],
        options: {
          showTime: false,
          showLabels: false,
          showCommonLabels: false,
          wrapLogMessage: false,
          prettifyLogMessage: false,
          enableLogDetails: true,
          dedupStrategy: 'signature',
          sortOrder: 'Descending',
        },
        fieldConfig: {
          defaults: {
            custom: {
              align: 'auto',
              cellOptions: { type: 'auto' },
              inspect: false,
            },
          },
          overrides: [],
        },
      },

    // Go row
    goRow(gridPos={ h: 1, w: 24, x: 0, y: 22 }):
      row.new('Go Runtime Metrics') + { gridPos: gridPos, collapsed: false },

    // Go version panel - more compact
    goVersion(serviceName, gridPos={ h: 3, w: 4, x: 0, y: 23 }):
      stat.new(
        'Go Version',
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

    // Goroutines count stat
    goGoroutines(serviceName, gridPos={ h: 3, w: 4, x: 4, y: 23 }):
      stat.new(
        'Goroutines',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'sum(go_goroutines{namespace="$namespace", container="$service"})',
          legendFormat='Active',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'green', value: 0 },
                { color: 'yellow', value: 100 },
                { color: 'red', value: 500 }
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
            calcs: ['lastNotNull'],
            fields: '',
            values: false,
          },
          textMode: 'auto',
        },
        gridPos: gridPos,
      },

    // GOMAXPROCS stat
    goMaxProcs(serviceName, gridPos={ h: 3, w: 4, x: 8, y: 23 }):
      stat.new(
        'GOMAXPROCS',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'max(go_sched_gomaxprocs_threads{namespace="$namespace", container="$service"})',
          legendFormat='Max Procs',
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
            unit: 'short',
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

    // GC rate stat
    goGCRate(serviceName, gridPos={ h: 3, w: 4, x: 12, y: 23 }):
      stat.new(
        'GC Rate',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'rate(go_gc_duration_seconds_count{namespace="$namespace", container="$service"}[5m]) * 60',
          legendFormat='GC/min',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'green', value: 0 },
                { color: 'yellow', value: 10 },
                { color: 'red', value: 30 }
              ],
            },
            unit: 'short',
            decimals: 2,
          },
          overrides: [],
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

    // Current heap usage stat
    goHeapCurrent(serviceName, gridPos={ h: 3, w: 4, x: 16, y: 23 }):
      stat.new(
        'Heap Usage',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'sum(go_memstats_heap_alloc_bytes{namespace="$namespace", container="$service"})',
          legendFormat='Allocated',
        )
      )
      + {
        fieldConfig: {
          defaults: {
            color: { mode: 'thresholds' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'green', value: 0 },
                { color: 'yellow', value: 50000000 },  // 50MB
                { color: 'red', value: 200000000 }     // 200MB
              ],
            },
            unit: 'decbytes',
          },
          overrides: [],
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

    // Next GC threshold
    goNextGC(serviceName, gridPos={ h: 3, w: 4, x: 20, y: 23 }):
      stat.new(
        'Next GC',
        datasource='${datasource}',
      )
      .addTarget(
        prometheus.target(
          'sum(go_memstats_next_gc_bytes{namespace="$namespace", container="$service"})',
          legendFormat='Threshold',
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
            unit: 'decbytes',
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

    // Memory allocation over time
    goHeapTimeseries(serviceName, gridPos={ h: 8, w: 12, x: 0, y: 26 }):
      graphPanel.new(
        'Go Memory Usage Over Time',
        datasource='${datasource}',
        format='decbytes',
      )
      .addTargets([
        prometheus.target(
          'go_memstats_heap_alloc_bytes{namespace="$namespace", container="$service"}',
          legendFormat='Heap Allocated',
        ),
        prometheus.target(
          'go_memstats_heap_inuse_bytes{namespace="$namespace", container="$service"}',
          legendFormat='Heap In Use',
        ),
        prometheus.target(
          'go_memstats_heap_sys_bytes{namespace="$namespace", container="$service"}',
          legendFormat='Heap System',
        ),
        prometheus.target(
          'go_memstats_stack_inuse_bytes{namespace="$namespace", container="$service"}',
          legendFormat='Stack In Use',
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
              gradientMode: 'none',
              spanNulls: false,
              insertNulls: false,
              showPoints: 'never',
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
            unit: 'decbytes',
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: ['lastNotNull', 'max'],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: { mode: 'multi', sort: 'desc' },
        },
        gridPos: gridPos,
      },

    // Goroutines and GC metrics over time
    goRuntimeTimeseries(serviceName, gridPos={ h: 8, w: 12, x: 12, y: 26 }):
      graphPanel.new(
        'Go Runtime Metrics Over Time',
        datasource='${datasource}',
        format='short',
      )
      .addTargets([
        prometheus.target(
          'go_goroutines{namespace="$namespace", container="$service"}',
          legendFormat='Goroutines',
        ),
        prometheus.target(
          'go_threads{namespace="$namespace", container="$service"}',
          legendFormat='OS Threads',
        ),
        prometheus.target(
          'rate(go_gc_duration_seconds_count{namespace="$namespace", container="$service"}[5m]) * 60',
          legendFormat='GC Rate (per min)',
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
              gradientMode: 'none',
              spanNulls: false,
              insertNulls: false,
              showPoints: 'never',
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
          overrides: [
            {
              matcher: { id: 'byName', options: 'GC Rate (per min)' },
              properties: [{ id: 'unit', value: 'short' }],
            },
          ],
        },
        options: {
          legend: {
            calcs: ['lastNotNull', 'max', 'mean'],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: { mode: 'multi', sort: 'desc' },
        },
        gridPos: gridPos,
      },

    // GC duration heatmap
    goGCDuration(serviceName, gridPos={ h: 8, w: 12, x: 0, y: 34 }):
      graphPanel.new(
        'GC Duration Percentiles',
        datasource='${datasource}',
        format='s',
      )
      .addTargets([
        prometheus.target(
          'go_gc_duration_seconds{quantile="0",namespace="$namespace", container="$service"}',
          legendFormat='p0 (min)',
        ),
        prometheus.target(
          'go_gc_duration_seconds{quantile="0.25",namespace="$namespace", container="$service"}',
          legendFormat='p25',
        ),
        prometheus.target(
          'go_gc_duration_seconds{quantile="0.5",namespace="$namespace", container="$service"}',
          legendFormat='p50 (median)',
        ),
        prometheus.target(
          'go_gc_duration_seconds{quantile="0.75",namespace="$namespace", container="$service"}',
          legendFormat='p75',
        ),
        prometheus.target(
          'go_gc_duration_seconds{quantile="1",namespace="$namespace", container="$service"}',
          legendFormat='p100 (max)',
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
              spanNulls: false,
              insertNulls: false,
              showPoints: 'never',
              pointSize: 5,
              stacking: { group: 'A', mode: 'none' },
              axisPlacement: 'auto',
              axisLabel: 'Duration',
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
              steps: [
                { color: 'green', value: 0 },
                { color: 'yellow', value: 0.001 },  // 1ms
                { color: 'red', value: 0.01 }       // 10ms
              ],
            },
            unit: 's',
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: ['lastNotNull', 'max'],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: { mode: 'multi', sort: 'desc' },
        },
        gridPos: gridPos,
      },

    // Memory allocation rate and GC efficiency
    goMemoryAllocationRate(serviceName, gridPos={ h: 8, w: 12, x: 12, y: 34 }):
      graphPanel.new(
        'Memory Allocation & GC Efficiency',
        datasource='${datasource}',
        format='binBps',
      )
      .addTargets([
        prometheus.target(
          'rate(go_memstats_alloc_bytes_total{namespace="$namespace", container="$service"}[5m])',
          legendFormat='Allocation Rate',
        ),
        prometheus.target(
          'rate(go_memstats_frees_total{namespace="$namespace", container="$service"}[5m])',
          legendFormat='Object Frees/sec',
        ),
        prometheus.target(
          'rate(go_memstats_mallocs_total{namespace="$namespace", container="$service"}[5m])',
          legendFormat='Object Mallocs/sec',
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
              gradientMode: 'none',
              spanNulls: false,
              insertNulls: false,
              showPoints: 'never',
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
          overrides: [
            {
              matcher: { id: 'byRegexp', options: '.*Frees.*|.*Mallocs.*' },
              properties: [{ id: 'unit', value: 'ops' }],
            },
          ],
        },
        options: {
          legend: {
            calcs: ['lastNotNull', 'max', 'mean'],
            displayMode: 'table',
            placement: 'bottom',
            showLegend: true,
          },
          tooltip: { mode: 'multi', sort: 'desc' },
        },
        gridPos: gridPos,
      },

    // Device-specific panels for uplinks monitoring
    uplinksByDevicesTimeseries(gridPos={ h: 10, w: 18, x: 0, y: 0 }):
      {
        type: 'timeseries',
        title: 'Uplinks by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(devEui) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$interval]))',
          legendFormat: '{{devEui}}',
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
              fillOpacity: 10,
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
              steps: [{ color: 'green' }],
            },
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'right',
            showLegend: true,
          },
          tooltip: {
            hideZeros: false,
            mode: 'single',
            sort: 'none',
          },
        },
      },

    uplinksByDevicesPie(gridPos={ h: 10, w: 6, x: 18, y: 0 }):
      {
        type: 'piechart',
        title: 'Uplinks by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(devEui) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$__range]))',
          legendFormat: '{{devEui}}',
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
            displayMode: 'visible',
            placement: 'bottom',
          },
          displayLabels: ['name'],
        },
      },

    uplinksByPortsTimeseries(gridPos={ h: 10, w: 18, x: 0, y: 10 }):
      {
        type: 'timeseries',
        title: 'Uplinks by ports',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(port) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$interval]))',
          legendFormat: 'Port {{port}}',
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
              fillOpacity: 10,
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
              steps: [{ color: 'green' }],
            },
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'right',
            showLegend: true,
          },
          tooltip: {
            hideZeros: false,
            mode: 'single',
            sort: 'none',
          },
        },
      },

    uplinksByPortsPie(gridPos={ h: 10, w: 6, x: 18, y: 10 }):
      {
        type: 'piechart',
        title: 'Uplinks by ports',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(port) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$__range]))',
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
            displayMode: 'visible',
            placement: 'bottom',
          },
          displayLabels: ['name'],
        },
      },

    uplinksBySpreadingFactorsTimeseries(gridPos={ h: 10, w: 18, x: 0, y: 20 }):
      {
        type: 'timeseries',
        title: 'Uplinks by spreading factors',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(spreadingFactor) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$interval]))',
          legendFormat: '{{spreadingFactor}}',
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
              fillOpacity: 10,
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
              steps: [{ color: 'green' }],
            },
          },
          overrides: [],
        },
        options: {
          legend: {
            calcs: [],
            displayMode: 'list',
            placement: 'right',
            showLegend: true,
          },
          tooltip: {
            hideZeros: false,
            mode: 'single',
            sort: 'none',
          },
        },
      },

    uplinksBySpreadingFactorsPie(gridPos={ h: 10, w: 6, x: 18, y: 20 }):
      {
        type: 'piechart',
        title: 'Uplinks by spreading factors',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(spreadingFactor) (increase(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$__range]))',
          legendFormat: '{{spreadingFactor}}',
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
            displayMode: 'visible',
            placement: 'bottom',
          },
          displayLabels: ['name'],
        },
      },

    uplinksRate(gridPos={ h: 10, w: 6, x: 0, y: 30 }):
      {
        type: 'stat',
        title: 'Uplinks',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(__name__) (rate(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$interval]))',
          legendFormat: '__auto',
          refId: 'A',
        }],
        fieldConfig: {
          defaults: {
            color: { mode: 'palette-classic' },
            mappings: [],
            thresholds: {
              mode: 'absolute',
              steps: [
                { color: 'green', value: null },
                { color: 'red', value: 80 },
              ],
            },
          },
          overrides: [],
        },
        options: {
          colorMode: 'none',
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

    uplinksPerHour(gridPos={ h: 10, w: 6, x: 6, y: 30 }):
      {
        type: 'stat',
        title: 'Uplinks per hour',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(__name__) (rate(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[1h]) * 3600)',
          legendFormat: '__auto',
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
                { color: 'yellow', value: 100 },
                { color: 'red', value: 500 },
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

    uplinkSequence(gridPos={ h: 10, w: 18, x: 12, y: 30 }):
      {
        type: 'timeseries',
        title: 'Uplink sequence',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'avg by(devEui) (truvami_device_uplink_frame_counter{customer=~"$customers", devEui=~"$devices", port=~"$ports", namespace="$namespace"})',
          legendFormat: '{{devEui}}',
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
              steps: [{ color: 'green' }],
            },
          },
          overrides: [],
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

    // Device status panels
    batteryByDevices(gridPos={ h: 10, w: 12, x: 0, y: 40 }):
      {
        type: 'timeseries',
        title: 'Battery by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'avg by(devEui) (truvami_device_battery_status{customer=~"$customers", devEui=~"$devices", namespace="$namespace"})',
          legendFormat: '{{devEui}}',
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
              steps: [
                { color: 'red', value: 0 },
                { color: 'yellow', value: 3.5 },
                { color: 'green', value: 4.0 },
              ],
            },
            unit: 'volt',
          },
          overrides: [],
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

    bufferLevelByDevices(gridPos={ h: 10, w: 12, x: 12, y: 40 }):
      {
        type: 'timeseries',
        title: 'Buffer level by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'avg by(devEui) (truvami_device_buffer_level{customer=~"$customers", devEui=~"$devices", namespace="$namespace"})',
          legendFormat: '{{devEui}}',
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
              steps: [
                { color: 'green', value: 0 },
                { color: 'yellow', value: 5 },
                { color: 'red', value: 10 },
              ],
            },
          },
          overrides: [],
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

    // Decode error monitoring panels
    decodeErrorRate(gridPos={ h: 10, w: 6, x: 0, y: 50 }):
      {
        type: 'stat',
        title: 'Decode error rate',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum(rate(truvami_failed_to_decode_payload_count{devEui=~"$devices", port=~"$ports", namespace="$namespace"}[$interval])) / sum(rate(truvami_device_uplink_count{customer=~"$customers", devEui=~"$devices", port=~"$ports", spreadingFactor=~"$spreadingFactors", namespace="$namespace"}[$interval]))',
          legendFormat: '__auto',
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
                { color: 'yellow', value: 0.05 },
                { color: 'red', value: 0.1 },
              ],
            },
            unit: 'percentunit',
            min: 0,
            max: 1,
          },
          overrides: [],
        },
        options: {
          colorMode: 'background',
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

    decodeErrorsByDevicesTimeseries(gridPos={ h: 10, w: 18, x: 6, y: 50 }):
      {
        type: 'timeseries',
        title: 'Decode errors by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(devEui) (increase(truvami_failed_to_decode_payload_count{devEui=~"$devices", port=~"$ports", namespace="$namespace"}[$interval]))',
          legendFormat: '{{devEui}}',
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
              fillOpacity: 10,
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
              steps: [{ color: 'green' }],
            },
          },
          overrides: [],
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

    decodeErrorsByDevicesPie(gridPos={ h: 10, w: 12, x: 0, y: 60 }):
      {
        type: 'piechart',
        title: 'Decode errors by devices',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(devEui) (increase(truvami_failed_to_decode_payload_count{devEui=~"$devices", port=~"$ports", namespace="$namespace"}[$__range]))',
          legendFormat: '{{devEui}}',
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
            displayMode: 'visible',
            placement: 'bottom',
          },
          displayLabels: ['name'],
        },
      },

    decodeErrorsByPortsPie(gridPos={ h: 10, w: 12, x: 12, y: 60 }):
      {
        type: 'piechart',
        title: 'Decode errors by ports',
        datasource: '${datasource}',
        gridPos: gridPos,
        targets: [{
          expr: 'sum by(port) (increase(truvami_failed_to_decode_payload_count{devEui=~"$devices", port=~"$ports", namespace="$namespace"}[$__range]))',
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
            displayMode: 'visible',
            placement: 'bottom',
          },
          displayLabels: ['name'],
        },
      },

    // Logs panel for service monitoring
    serviceLogs(serviceName, gridPos={ h: 10, w: 24, x: 0, y: 0 }):
      {
        type: 'logs',
        title: serviceName + ' Logs',
        datasource: '${logs_datasource}',
        gridPos: gridPos,
        targets: [{
          expr: '{app="' + serviceName + '", namespace="$namespace"}',
          refId: 'A',
        }],
        options: {
          showTime: true,
          showLabels: false,
          showCommonLabels: false,
          wrapLogMessage: false,
          prettifyLogMessage: false,
          enableLogDetails: true,
          dedupStrategy: 'none',
          sortOrder: 'Descending',
        },
        fieldConfig: {
          defaults: {
            custom: {
              align: 'auto',
              cellOptions: { type: 'auto' },
              inspect: false,
            },
          },
          overrides: [],
        },
      },


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
