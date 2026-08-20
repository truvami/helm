# truvami-seedbox

![Version: 0.8.0](https://img.shields.io/badge/Version-0.8.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity / anti-affinity rules |
| autoscaling | object | `{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler settings |
| fullnameOverride | string | `""` | Override the full release name |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/truvami/seedbox","tag":"v0.1.0"}` | Container image settings |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy (IfNotPresent recommended with pinned tags) |
| image.repository | string | `"ghcr.io/truvami/seedbox"` | Image repository |
| image.tag | string | `"v0.1.0"` | Image tag; defaults to the chart appVersion if empty |
| imagePullSecrets | list | `[]` | Docker registry pull secrets |
| livenessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/metrics","port":"metrics"},"initialDelaySeconds":15,"periodSeconds":10,"timeoutSeconds":5}` | Liveness probe configuration (port "metrics" = seedbox.metrics.port) |
| maps | object | `{"customerUUID":"","data":{},"enabled":false,"existingConfigMap":"","mountPath":"/maps"}` | Customer route preset maps (ConfigMap + volume mount) |
| maps.customerUUID | string | `""` | Customer UUID subdirectory under the maps mount (e.g. maps/<uuid>/preset.yaml) |
| maps.data | object | `{}` | Inline map files for chart-managed maps (must include preset.yaml) |
| maps.enabled | bool | `false` | Mount customer preset maps |
| maps.existingConfigMap | string | `""` | Existing ConfigMap whose keys are map filenames. Set podAnnotations to roll pods when its content changes. |
| maps.mountPath | string | `"/maps"` | Root path inside the container; must match seedbox.producer.maps.path |
| nameOverride | string | `""` | Override the chart name |
| networkPolicy | object | `{"enabled":false}` | Kubernetes NetworkPolicy |
| nodeSelector | object | `{}` | Node selector constraints |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `1` |  |
| podAnnotations | object | `{}` | Annotations added to every Pod |
| podLabels | object | `{}` | Labels added to every Pod |
| podSecurityContext | object | `{}` | Pod-level security context (merged with secure defaults in the template) |
| readinessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/metrics","port":"metrics"},"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Readiness probe configuration (port "metrics" = seedbox.metrics.port) |
| replicaCount | int | `1` | Number of pod replicas |
| resources | object | `{"limits":{"ephemeral-storage":"1Gi","memory":"128Mi"},"requests":{"cpu":"100m","ephemeral-storage":"512Mi","memory":"128Mi"}}` | Resource requests and limits. |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | Container-level security context (merged with secure defaults in the template) |
| seedbox | object | `{"metrics":{"port":7070},"otel":{"enabled":false,"endpoint":"tempo.grafana-tempo.svc.cluster.local:4318"},"producer":{"backfill":{"startDates":{}},"batteryStatus":{"dropDuration":{"max":"2h","min":"1h"},"holdDuration":{"max":"24h","min":"12h"},"maxVoltage":4.5,"minVoltage":1.5},"customerDevices":{},"interval":"2m","intervalJitter":"0s","maps":{"path":"/maps"},"position":{"maxAltitude":8848,"maxLatitude":90,"maxLongitude":180,"minAltitude":0,"minLatitude":-90,"minLongitude":-180,"noiseRadiusMeters":0,"randomizeBetweenWaypoints":false},"uplink":{"maxAverageRssi":-10,"maxAverageSnr":15,"minAverageRssi":-128,"minAverageSnr":-20},"weights":{"batteryStatus":5,"event":3,"position":10}},"relay":{"channelsCapacity":10,"grpc":"truvami-stack-truvami-api:5001"},"valkey":{"batteryKeyPrefix":"seedbox:battery:v1","cursorKeyPrefix":"seedbox:cursor:v1","enabled":false,"host":"redis-leader:6379","routeKeyPrefix":"seedbox:route:v1","username":"default"}}` | Application configuration (mounted as seedbox.yaml ConfigMap). This block contains only non-sensitive settings. |
| seedbox.metrics.port | int | `7070` | Prometheus metrics endpoint listen port |
| seedbox.otel.enabled | bool | `false` | Enable OpenTelemetry tracing |
| seedbox.otel.endpoint | string | `"tempo.grafana-tempo.svc.cluster.local:4318"` | OpenTelemetry collector OTLP endpoint |
| seedbox.producer.backfill.startDates | object | `{}` | Per-device historical replay start dates (devEUI -> RFC3339 or YYYY-MM-DD) |
| seedbox.producer.batteryStatus.dropDuration.max | string | `"2h"` | Maximum time for the battery voltage drop |
| seedbox.producer.batteryStatus.dropDuration.min | string | `"1h"` | Minimum time for the battery voltage drop |
| seedbox.producer.batteryStatus.holdDuration.max | string | `"24h"` | Maximum time to hold battery voltage constant |
| seedbox.producer.batteryStatus.holdDuration.min | string | `"12h"` | Minimum time to hold battery voltage constant |
| seedbox.producer.batteryStatus.maxVoltage | float | `4.5` | Maximum battery voltage |
| seedbox.producer.batteryStatus.minVoltage | float | `1.5` | Minimum battery voltage |
| seedbox.producer.customerDevices | object | `{}` | Map of customer ID to device EUIs (populated per-environment) |
| seedbox.producer.interval | string | `"2m"` | Interval between synthetic data productions |
| seedbox.producer.intervalJitter | string | `"0s"` | Symmetric per-device variation around interval (0 disables jitter) |
| seedbox.producer.maps.path | string | `"/maps"` | Path to customer preset directories inside the container |
| seedbox.producer.position.maxAltitude | int | `8848` | Maximum altitude in meters |
| seedbox.producer.position.maxLatitude | int | `90` | Maximum latitude |
| seedbox.producer.position.maxLongitude | int | `180` | Maximum longitude |
| seedbox.producer.position.minAltitude | int | `0` | Minimum altitude in meters |
| seedbox.producer.position.minLatitude | int | `-90` | Minimum latitude |
| seedbox.producer.position.minLongitude | int | `-180` | Minimum longitude |
| seedbox.producer.position.noiseRadiusMeters | int | `0` | Uniform positional noise radius in meters (0 keeps exact route coordinates) |
| seedbox.producer.position.randomizeBetweenWaypoints | bool | `false` | Emit one random interior point per template segment instead of exact waypoints |
| seedbox.producer.uplink.maxAverageRssi | int | `-10` | Maximum average RSSI value |
| seedbox.producer.uplink.maxAverageSnr | int | `15` | Maximum average SNR value |
| seedbox.producer.uplink.minAverageRssi | int | `-128` | Minimum average RSSI value |
| seedbox.producer.uplink.minAverageSnr | int | `-20` | Minimum average SNR value |
| seedbox.producer.weights.batteryStatus | int | `5` | Relative weight for battery status messages |
| seedbox.producer.weights.event | int | `3` | Relative weight for event messages |
| seedbox.producer.weights.position | int | `10` | Relative weight for position messages |
| seedbox.relay.channelsCapacity | int | `10` | Capacity of internal relay channels |
| seedbox.relay.grpc | string | `"truvami-stack-truvami-api:5001"` | gRPC target for the truvami API |
| seedbox.valkey.batteryKeyPrefix | string | `"seedbox:battery:v1"` | Battery checkpoint key prefix |
| seedbox.valkey.cursorKeyPrefix | string | `"seedbox:cursor:v1"` | Backfill cursor key prefix |
| seedbox.valkey.enabled | bool | `false` | Persist route and battery checkpoints in Valkey |
| seedbox.valkey.host | string | `"redis-leader:6379"` | Valkey host:port address |
| seedbox.valkey.routeKeyPrefix | string | `"seedbox:route:v1"` | Route checkpoint key prefix |
| seedbox.valkey.username | string | `"default"` | Valkey authentication username |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":false,"name":""}` | Kubernetes ServiceAccount configuration |
| serviceAccount.annotations | object | `{}` | Annotations to add to the ServiceAccount |
| serviceAccount.automount | bool | `false` | Automount API credentials into pods (disable to reduce attack surface) |
| serviceAccount.create | bool | `false` | Whether to create a dedicated ServiceAccount |
| serviceAccount.name | string | `""` | Explicit ServiceAccount name; generated from fullname when empty |
| serviceMonitor | object | `{"enabled":false}` | Prometheus ServiceMonitor |
| tolerations | list | `[]` | Pod tolerations |
| valkey | object | `{"secretKey":"password","secretName":""}` | Valkey secret injection for simulation-state persistence |
| volumeMounts | list | `[]` | Additional volumeMounts on the container |
| volumes | list | `[]` | Additional volumes on the Deployment |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
