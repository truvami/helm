local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Device-specific panels using library functions
local devicePanels = {
  // Uplinks Analysis panels
  uplinksByDevicesTimeseries: truvami.panels.uplinksByDevicesTimeseries({ h: 10, w: 18, x: 0, y: 20 }),
  uplinksByDevicesPie: truvami.panels.uplinksByDevicesPie({ h: 10, w: 6, x: 18, y: 20 }),

  uplinksByPortsTimeseries: truvami.panels.uplinksByPortsTimeseries({ h: 10, w: 18, x: 0, y: 30 }),
  uplinksByPortsPie: truvami.panels.uplinksByPortsPie({ h: 10, w: 6, x: 18, y: 30 }),

  uplinksBySpreadingFactorsTimeseries: truvami.panels.uplinksBySpreadingFactorsTimeseries({ h: 10, w: 18, x: 0, y: 40 }),
  uplinksBySpreadingFactorsPie: truvami.panels.uplinksBySpreadingFactorsPie({ h: 10, w: 6, x: 18, y: 40 }),

  uplinksRate: truvami.panels.uplinksRate({ h: 10, w: 6, x: 0, y: 50 }),
  uplinksPerHour: truvami.panels.uplinksPerHour({ h: 10, w: 6, x: 6, y: 50 }),
  uplinkSequence: truvami.panels.uplinkSequence({ h: 10, w: 12, x: 12, y: 50 }),

  // Device Status panels
  batteryByDevices: truvami.panels.batteryByDevices({ h: 10, w: 12, x: 0, y: 61 }),
  bufferLevelByDevices: truvami.panels.bufferLevelByDevices({ h: 10, w: 12, x: 12, y: 61 }),

  // Decode Error panels
  decodeErrorRate: truvami.panels.decodeErrorRate({ h: 10, w: 6, x: 0, y: 72 }),
  decodeErrorsByDevicesTimeseries: truvami.panels.decodeErrorsByDevicesTimeseries({ h: 10, w: 18, x: 6, y: 72 }),
  decodeErrorsByDevicesPie: truvami.panels.decodeErrorsByDevicesPie({ h: 10, w: 12, x: 0, y: 82 }),
  decodeErrorsByPortsPie: truvami.panels.decodeErrorsByPortsPie({ h: 10, w: 12, x: 12, y: 82 }),
};

// Build dashboard with device-specific panels
truvami.deviceDashboard('truvami-device', [
  // Uplinks Analysis section (after Alarms which end at y: 18)
  row.new('Uplinks Analysis') + { gridPos: { h: 1, w: 24, x: 0, y: 19 }, collapsed: false },
  devicePanels.uplinksByDevicesTimeseries,
  devicePanels.uplinksByDevicesPie,
  devicePanels.uplinksByPortsTimeseries,
  devicePanels.uplinksByPortsPie,
  devicePanels.uplinksBySpreadingFactorsTimeseries,
  devicePanels.uplinksBySpreadingFactorsPie,
  devicePanels.uplinksRate,
  devicePanels.uplinksPerHour,
  devicePanels.uplinkSequence,

  // Device Status section
  row.new('Device Status') + { gridPos: { h: 1, w: 24, x: 0, y: 60 }, collapsed: false },
  devicePanels.batteryByDevices,
  devicePanels.bufferLevelByDevices,

  // Decode Errors section
  row.new('Decode Errors & Quality') + { gridPos: { h: 1, w: 24, x: 0, y: 71 }, collapsed: false },
  devicePanels.decodeErrorRate,
  devicePanels.decodeErrorsByDevicesTimeseries,
  devicePanels.decodeErrorsByDevicesPie,
  devicePanels.decodeErrorsByPortsPie,
])
