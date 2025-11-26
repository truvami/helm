# truvami-dashboard

![Version: 1.0.11](https://img.shields.io/badge/Version-1.0.11-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v2.8.0-rc13](https://img.shields.io/badge/AppVersion-v2.8.0--rc13-informational?style=flat-square)

Truvami Dashboard Helm chart with Better Auth integration

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| api.internalUrl | string | `"http://truvami-stack-truvami-api:8888"` |  |
| api.publicUrl | string | `"https://api.truvami.com"` |  |
| app.publicUrl | string | `"https://dashboard.truvami.com"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| betterAuth.existingSecret | string | `""` |  |
| betterAuth.existingSecretKey | string | `"better-auth-secret"` |  |
| betterAuth.secret | string | `""` |  |
| database.existingSecret | string | `""` |  |
| database.existingSecretKey | string | `"jdbc-uri"` |  |
| database.url | string | `""` |  |
| fullnameOverride | string | `""` |  |
| hostAliases | list | `[]` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/truvami/dashboard"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"dashboard.truvami.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| keycloak.clientId | string | `"dashboard"` |  |
| keycloak.clientSecret | string | `""` |  |
| keycloak.discoveryUrl | string | `"https://sso.sbcdc.ch/auth/realms/truvami/.well-known/openid-configuration"` |  |
| keycloak.existingSecret | string | `""` |  |
| keycloak.existingSecretKey | string | `"client-secret"` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| migration.resources.limits.cpu | string | `"500m"` |  |
| migration.resources.limits.memory | string | `"512Mi"` |  |
| migration.resources.requests.cpu | string | `"100m"` |  |
| migration.resources.requests.memory | string | `"256Mi"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| openTelemetry.environment | string | development | OPTIONAL: Environment name (automatically set to NODE_ENV if not provided) |
| openTelemetry.exporter.endpoint | string | `""` | OTEL_EXPORTER_OTLP_ENDPOINT (if different from tempoEndpoint) |
| openTelemetry.exporter.headers | string | `""` | OTEL_EXPORTER_OTLP_HEADERS (e.g., "api-key=your-api-key") |
| openTelemetry.resourceAttributes | string | `""` | OTEL_RESOURCE_ATTRIBUTES (additional resource attributes) |
| openTelemetry.serviceName | string | truvami-dashboard | OPTIONAL: Service name for traces |
| openTelemetry.serviceVersion | string | 0.1.0 | OPTIONAL: Service version for traces (automatically uses NEXT_PUBLIC_VERSION from Docker build if available) |
| openTelemetry.tempoEndpoint | string | http://tempo:4318 | REQUIRED: Tempo/OTEL endpoint for trace export |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgres.backup.barmanObjectStore | object | `{}` |  |
| postgres.backup.enable | bool | `false` |  |
| postgres.backup.retentionPolicy | string | `"30d"` |  |
| postgres.enabled | bool | `true` |  |
| postgres.external.database | string | `"dashboard"` |  |
| postgres.external.existingSecret | string | `""` |  |
| postgres.external.host | string | `""` |  |
| postgres.external.password | string | `""` |  |
| postgres.external.port | int | `5432` |  |
| postgres.external.username | string | `"dashboard"` |  |
| postgres.image.repository | string | `"ghcr.io/cloudnative-pg/postgresql"` |  |
| postgres.image.tag | string | `"18"` |  |
| postgres.pooler.affinity | object | `{}` |  |
| postgres.pooler.defaultPoolSize | string | `"15"` |  |
| postgres.pooler.image.repository | string | `"ghcr.io/cloudnative-pg/pgbouncer"` |  |
| postgres.pooler.image.tag | string | `"1.24.1-23"` |  |
| postgres.pooler.instances | int | `1` |  |
| postgres.pooler.maxClientConn | string | `"100"` |  |
| postgres.pooler.monitoring.enabled | bool | `true` |  |
| postgres.pooler.monitoring.podMonitorLabels | object | `{}` |  |
| postgres.pooler.nodeSelector | object | `{}` |  |
| postgres.pooler.parameters | object | `{}` |  |
| postgres.pooler.poolMode | string | `"session"` |  |
| postgres.pooler.resources.limits.cpu | string | `"100m"` |  |
| postgres.pooler.resources.limits.memory | string | `"128Mi"` |  |
| postgres.pooler.resources.requests.cpu | string | `"50m"` |  |
| postgres.pooler.resources.requests.memory | string | `"64Mi"` |  |
| postgres.pooler.tolerations | list | `[]` |  |
| postgres.pooler.type | string | `"rw"` |  |
| postgres.replicaCount | int | `1` |  |
| postgres.resources.limits.cpu | string | `"500m"` |  |
| postgres.resources.limits.memory | string | `"1Gi"` |  |
| postgres.resources.requests.cpu | string | `"100m"` |  |
| postgres.resources.requests.memory | string | `"256Mi"` |  |
| postgres.sharedBuffers | string | `"256MB"` |  |
| postgres.storage.size | string | `"1Gi"` |  |
| postgres.storage.storageClass | string | `""` |  |
| readinessProbe.httpGet.path | string | `"/"` |  |
| readinessProbe.httpGet.port | string | `"http"` |  |
| replicaCount | int | `1` |  |
| resources | object | `{}` |  |
| securityContext | object | `{}` |  |
| service.port | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

