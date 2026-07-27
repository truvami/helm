# truvami-pulse

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for truvami pulse - configuration campaign execution service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` | Image pull policy |
| image.repository | string | `"ghcr.io/truvami/pulse"` | Image repository |
| image.tag | string | `""` | Overrides the image tag whose default is the chart appVersion. |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"pulse.truvami.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| nameOverride | string | `""` |  |
| networkPolicy.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `1` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| pulse.downlink.http-timeout | string | `"30s"` | Timeout bounding a single AS-to-LRC ThingPark request |
| pulse.downlink.rate-limit.burst | int | `60` | Downlink request burst allowance |
| pulse.downlink.rate-limit.per-device-min-interval | string | `"0s"` | Minimum interval between downlinks to the same device (0s disables) |
| pulse.downlink.rate-limit.requests-per-second | int | `15` | Sustained downlink request rate |
| pulse.downlink.thingpark.allowed-hosts | list | `["proxy1.lpn.swisscom.ch"]` | Exact external LRC hosts pulse may reach. Must be non-empty whenever pulse.grpc.locksmith.address is set; hosts must resolve to public addresses, and redirects off this list are rejected. |
| pulse.grpc.api.address | string | `"truvami-stack-truvami-api:5001"` | truvami-api address exposing the configuration campaign execution-store RPCs. Required when pulse.worker.enabled is true. |
| pulse.grpc.api.insecure | bool | `false` | Use plaintext transport towards the API. TLS with server authentication is used when false. |
| pulse.grpc.listen.address | string | `":5002"` | Listen address of the pulse gRPC server (health, reflection, DownlinkService, CampaignExecutionControlService) |
| pulse.grpc.locksmith.address | string | `"truvami-stack-truvami-locksmith:5005"` | truvami-locksmith address used to resolve ThingPark downlink credentials by gateway API-key JTI. Leaving this empty disables the downlink sender entirely (DownlinkService is not registered and pulse.worker.enabled fails to start). |
| pulse.grpc.locksmith.insecure | bool | `false` | Use plaintext transport towards locksmith. Only set true inside a trusted service mesh with the restrictive locksmith NetworkPolicy on. |
| pulse.grpc.locksmith.request-timeout | string | `"5s"` | Timeout bounding a single credential-resolution RPC |
| pulse.logging.encoding | string | `"json"` | Log encoding (json, console) |
| pulse.logging.level | string | `"info"` | Log level (debug, info, warn, error) |
| pulse.logging.time-encoder | string | `"iso8601"` | Timestamp encoding (rfc3339, iso8601, epoch) |
| pulse.metrics.port | int | `7777` | Port serving /healthz, /readyz and /metrics |
| pulse.otel.enable | bool | `true` | Enable OpenTelemetry trace export |
| pulse.otel.endpoint | string | `"tempo.grafana-tempo.svc.cluster.local:4318"` | OTLP HTTP endpoint for trace export |
| pulse.worker.batch-size | int | `10` | Number of jobs claimed per poll |
| pulse.worker.claim-timeout | string | `"10s"` | Timeout for a single claim RPC |
| pulse.worker.enabled | bool | `false` | Enable campaign job polling and execution |
| pulse.worker.heartbeat-interval | string | `"15s"` | Interval between lease heartbeats |
| pulse.worker.lease-seconds | int | `60` | Job lease duration in seconds |
| pulse.worker.max-concurrency | int | `4` | Maximum number of jobs executed concurrently |
| pulse.worker.poll-interval | string | `"5s"` | Interval between claim attempts |
| readinessProbe.httpGet.path | string | `"/readyz"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| replicaCount | int | `1` | Number of replicas. Must be 1 while pulse.worker.enabled is true. |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.ephemeral-storage | string | `"512Mi"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext.allowPrivilegeEscalation | bool | `false` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `65534` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65534` |  |
| securityContext.seccompProfile.type | string | `"RuntimeDefault"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| terminationGracePeriodSeconds | int | `30` | Grace period for draining in-flight campaign jobs on shutdown |
| tolerations | list | `[]` |  |
| updateStrategy | object | `{}` | Deployment update strategy. Defaults to Recreate when pulse.worker.enabled is true so that a rollout never runs two campaign workers at once. |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
