# truvami-coverage

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.7.0](https://img.shields.io/badge/AppVersion-v0.7.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| challenge | object | `{"activeDeadlineSeconds":7200,"enabled":false,"failedJobsHistoryLimit":3,"resources":{"limits":{"cpu":"500m","ephemeral-storage":"2Gi","memory":"512Mi"},"requests":{"cpu":"250m","ephemeral-storage":"1Gi","memory":"256Mi"}},"schedule":"0 1 * * *","securityContext":{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534},"successfulJobsHistoryLimit":3}` | Challenge/Competition CronJob (disabled by default) |
| challenge.activeDeadlineSeconds | int | `7200` | Active deadline for the job in seconds (2 hours) |
| challenge.failedJobsHistoryLimit | int | `3` | Number of failed job runs to keep |
| challenge.schedule | string | `"0 1 * * *"` | Cron schedule (daily at 1am) |
| challenge.successfulJobsHistoryLimit | int | `3` | Number of successful job runs to keep |
| coverage | object | `{"activeDeadlineSeconds":7200,"failedJobsHistoryLimit":3,"resources":{"limits":{"cpu":"500m","ephemeral-storage":"2Gi","memory":"512Mi"},"requests":{"cpu":"250m","ephemeral-storage":"1Gi","memory":"256Mi"}},"schedule":"0 0 * * 0","securityContext":{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534},"successfulJobsHistoryLimit":3}` | Coverage CronJob scheduling |
| coverage.activeDeadlineSeconds | int | `7200` | Active deadline for the job in seconds (2 hours) |
| coverage.failedJobsHistoryLimit | int | `3` | Number of failed job runs to keep |
| coverage.schedule | string | `"0 0 * * 0"` | Cron schedule (weekly, Sunday midnight) |
| coverage.successfulJobsHistoryLimit | int | `3` | Number of successful job runs to keep |
| database | object | `{"host":"truvami-stack-pooler","name":"app","port":5432,"secretKey":"uri","secretName":"truvami-stack-app"}` | Database configuration (same pattern as truvami-api, used by tiler CronJobs) The database.url in the tiler TOML config is constructed from this secret. |
| fullnameOverride | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/health"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| nameOverride | string | `""` |  |
| networkPolicy.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `1` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.httpGet.path | string | `"/health"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{"limits":{"cpu":"100m","ephemeral-storage":"1Gi","memory":"128Mi"},"requests":{"cpu":"100m","ephemeral-storage":"512Mi","memory":"128Mi"}}` | Resources for the tiles server Deployment |
| s3 | object | `{"accessKeyIdKey":"access-key-id","bucketKey":"bucket","endpointKey":"endpoint","regionKey":"region","secretAccessKeyKey":"secret-access-key","secretName":"truvami-coverage-s3"}` | S3 configuration (references an existing secret) Used by both tile-server (via TRUVAMI_COVERAGE_TILER_ prefixed env vars) and coverage-tiler CronJobs (via env vars for bucket/region/endpoint/credentials) |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `65534` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65534` |  |
| serverImage | object | `{"pullPolicy":"Always","repository":"ghcr.io/truvami/tile-server","tag":""}` | Server image (Go, used by tiles server Deployment) |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| tiler | object | `{"competition":{"hexSizeMeters":250,"participants":[]},"computation":{"maxPositions":500000,"maxZoom":16,"minZoom":8,"periodDays":14,"workerThreads":4},"database":{"maxConnections":4},"logging":{"format":"json","level":"info","progressBar":false},"s3":{"forcePathStyle":false,"prefix":""}}` | Coverage-tiler (Rust) configuration These settings are rendered into a TOML ConfigMap for the tiler CronJobs. database.url and s3 credentials are injected via env vars at runtime. |
| tiler.competition.hexSizeMeters | float | `250` | Hex cell size in meters for competition mode |
| tiler.competition.participants | list | `[]` | Competition participants Each entry needs: name, devices (list of LoRaWAN device IDs), color (hex color) Optional: startDate (ISO 8601 date, e.g. "2026-03-25") A participant may carry multiple trackers — all devices' positions score for the same participant; the leaderboard shows the first device. |
| tiler.computation.maxPositions | int | `500000` | Per-customer position limit |
| tiler.computation.maxZoom | int | `16` | Maximum tile zoom level |
| tiler.computation.minZoom | int | `8` | Minimum tile zoom level |
| tiler.computation.periodDays | int | `14` | Lookback period in days |
| tiler.computation.workerThreads | int | `4` | Concurrent customer processing threads |
| tiler.database.maxConnections | int | `4` | Max database connections |
| tiler.logging.format | string | `"json"` | Log format ("json" for structured, anything else for plain text) |
| tiler.logging.level | string | `"info"` | Log level (trace/debug/info/warn/error) |
| tiler.logging.progressBar | bool | `false` | Show progress bar during processing |
| tiler.s3.forcePathStyle | bool | `false` | Use path-style S3 URLs (required for MinIO) |
| tiler.s3.prefix | string | `""` | S3 key prefix for tiles |
| tilerImage | object | `{"pullPolicy":"Always","repository":"ghcr.io/truvami/coverage-tiler","tag":""}` | Tiler image (Rust, used by CronJobs for tile generation) |
| tilesServer | object | `{"auth":{"audience":"coverage-tiler","devMode":false,"issuer":"https://sso.sbcdc.ch/auth/realms/truvami","jwksURL":"https://sso.sbcdc.ch/auth/realms/truvami/protocol/openid-connect/certs"},"logging":{"encoding":"json","level":"info"},"server":{"cors":{"allowedOrigins":["*"]},"port":8080}}` | Tiles server configuration (rendered as YAML in ConfigMap) The tile-server (Go) uses Viper with env prefix TRUVAMI_COVERAGE_TILER S3 credentials are injected via prefixed env vars, not the config file |
| tolerations | list | `[]` |  |
| volumeMounts[0].mountPath | string | `"/etc/tile-server"` |  |
| volumeMounts[0].name | string | `"config"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.name | string | `"config-coverage"` |  |
| volumes[0].configMap.optional | bool | `false` |  |
| volumes[0].name | string | `"config"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
