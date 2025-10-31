local grafana = import 'grafonnet/grafana.libsonnet';
local dashboard = grafana.dashboard;
local row = grafana.row;
local truvami = import '../lib/truvami.libsonnet';

// Device-specific panels using library functions
local devicePanels = {
  // Uplinks Analysis panels
  uplinksByDevicesTimeseries: truvami.panels.uplinksByDevicesTimeseries(),
  uplinksByDevicesPie: truvami.panels.uplinksByDevicesPie(),

  uplinksByPortsTimeseries: truvami.panels.uplinksByPortsTimeseries(),
  uplinksByPortsPie: truvami.panels.uplinksByPortsPie(),

  uplinksBySpreadingFactorsTimeseries: truvami.panels.uplinksBySpreadingFactorsTimeseries(),
  uplinksBySpreadingFactorsPie: truvami.panels.uplinksBySpreadingFactorsPie(),

  uplinksRate: truvami.panels.uplinksRate(),
  uplinksPerHour: truvami.panels.uplinksPerHour(),
  uplinkSequence: truvami.panels.uplinkSequence(),

  // Device Status panels
  batteryByDevices: truvami.panels.batteryByDevices(),
  bufferLevelByDevices: truvami.panels.bufferLevelByDevices(),

  // Decode Error panels
  decodeErrorRate: truvami.panels.decodeErrorRate(),
  decodeErrorsByDevicesTimeseries: truvami.panels.decodeErrorsByDevicesTimeseries(),
  decodeErrorsByDevicesPie: truvami.panels.decodeErrorsByDevicesPie(),
  decodeErrorsByPortsPie: truvami.panels.decodeErrorsByPortsPie(),
};

// Build dashboard with device-specific panels
truvami.deviceDashboard('truvami-device', [
  // Uplinks Analysis section (after Alarms and Device Logs which end at y: 29)
  row.new('Uplinks Analysis') + { gridPos: { h: 1, w: 24, x: 0, y: 30 }, collapsed: false },
  devicePanels.uplinksByDevicesTimeseries + { gridPos: { h: 10, w: 18, x: 0, y: 31 } },
  devicePanels.uplinksByDevicesPie + { gridPos: { h: 10, w: 6, x: 18, y: 31 } },
  devicePanels.uplinksByPortsTimeseries + { gridPos: { h: 10, w: 18, x: 0, y: 41 } },
  devicePanels.uplinksByPortsPie + { gridPos: { h: 10, w: 6, x: 18, y: 41 } },
  devicePanels.uplinksBySpreadingFactorsTimeseries + { gridPos: { h: 10, w: 18, x: 0, y: 51 } },
  devicePanels.uplinksBySpreadingFactorsPie + { gridPos: { h: 10, w: 6, x: 18, y: 51 } },
  devicePanels.uplinksRate + { gridPos: { h: 10, w: 6, x: 0, y: 61 } },
  devicePanels.uplinksPerHour + { gridPos: { h: 10, w: 6, x: 6, y: 61 } },
  devicePanels.uplinkSequence + { gridPos: { h: 10, w: 12, x: 12, y: 61 } },

  // Device Status section
  row.new('Device Status') + { gridPos: { h: 1, w: 24, x: 0, y: 71 }, collapsed: false },
  devicePanels.batteryByDevices + { gridPos: { h: 10, w: 12, x: 0, y: 72 } },
  devicePanels.bufferLevelByDevices + { gridPos: { h: 10, w: 12, x: 12, y: 72 } },

  // Decode Errors section
  row.new('Decode Errors & Quality') + { gridPos: { h: 1, w: 24, x: 0, y: 82 }, collapsed: false },
  devicePanels.decodeErrorRate + { gridPos: { h: 10, w: 6, x: 0, y: 83 } },
  devicePanels.decodeErrorsByDevicesTimeseries + { gridPos: { h: 10, w: 18, x: 6, y: 83 } },
  devicePanels.decodeErrorsByDevicesPie + { gridPos: { h: 10, w: 12, x: 0, y: 93 } },
  devicePanels.decodeErrorsByPortsPie + { gridPos: { h: 10, w: 12, x: 12, y: 93 } },
])
