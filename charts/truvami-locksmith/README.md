# truvami-locksmith

![Version: 0.0.1](https://img.shields.io/badge/Version-0.0.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for truvami locksmith - API key management service

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| database.host | string | `"truvami-stack-pooler"` |  |
| database.name | string | `"locksmith"` |  |
| database.port | int | `5432` |  |
| database.secretKey | string | `"uri"` |  |
| database.secretName | string | `"truvami-stack-app"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/truvami/locksmith"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"locksmith.truvami.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| locksmith.database.connectionMaxIdleTime | string | `"5m"` |  |
| locksmith.database.connectionMaxLifetime | string | `"30m"` |  |
| locksmith.database.initializationTimeout | string | `"15s"` |  |
| locksmith.database.migrateTimeout | string | `"1m"` |  |
| locksmith.grpc.host | string | `"0.0.0.0"` |  |
| locksmith.grpc.port | int | `5005` |  |
| locksmith.health.checkInterval | string | `"10s"` |  |
| locksmith.health.checkTimeout | string | `"2s"` |  |
| locksmith.health.maxUnhealthyDuration | string | `"5m"` |  |
| locksmith.jwks.location | string | `"/var/run/secrets/locksmith/public/jwks.json"` |  |
| locksmith.logging.encoding | string | `"json"` |  |
| locksmith.logging.level | string | `"info"` |  |
| locksmith.logging.time-encoder | string | `"rfc3339"` |  |
| locksmith.metrics.enabled | bool | `true` |  |
| locksmith.metrics.port | int | `8899` |  |
| locksmith.otel.enabled | bool | `false` |  |
| locksmith.otel.endpoint | string | `"localhost:4318"` |  |
| locksmith.signingKey.location | string | `"/var/run/secrets/locksmith/private/private.json"` |  |
| locksmith.signingMaterial.reloadInterval | string | `"5s"` |  |
| locksmith.valkey.host | string | `"truvami-stack-valkey-primary:6379"` |  |
| locksmith.valkey.username | string | `"default"` |  |
| migration.resources.limits.cpu | string | `"100m"` |  |
| migration.resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| migration.resources.limits.memory | string | `"128Mi"` |  |
| migration.resources.requests.cpu | string | `"100m"` |  |
| migration.resources.requests.ephemeral-storage | string | `"512Mi"` |  |
| migration.resources.requests.memory | string | `"128Mi"` |  |
| migration.securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| migration.securityContext.readOnlyRootFilesystem | bool | `true` |  |
| migration.securityContext.runAsGroup | int | `65534` |  |
| migration.securityContext.runAsNonRoot | bool | `true` |  |
| migration.securityContext.runAsUser | int | `65534` |  |
| nameOverride | string | `""` |  |
| networkPolicy.enabled | bool | `false` |  |
| nodeSelector | object | `{}` |  |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `1` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| postgres.backup.barmanObjectStore | object | `{}` |  |
| postgres.backup.enable | bool | `false` |  |
| postgres.backup.retentionPolicy | string | `"30d"` |  |
| postgres.enabled | bool | `false` |  |
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
| postgres.pooler.resources.limits.cpu | string | `"200m"` |  |
| postgres.pooler.resources.limits.memory | string | `"256Mi"` |  |
| postgres.pooler.resources.requests.cpu | string | `"100m"` |  |
| postgres.pooler.resources.requests.memory | string | `"128Mi"` |  |
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
| readinessProbe.httpGet.path | string | `"/readyz"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.ephemeral-storage | string | `"1Gi"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.ephemeral-storage | string | `"512Mi"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsGroup | int | `65534` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `65534` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| signingKeys.private.key | string | `"private.json"` |  |
| signingKeys.private.secretName | string | `"locksmith-signing-private"` |  |
| signingKeys.public.key | string | `"jwks.json"` |  |
| signingKeys.public.secretName | string | `"locksmith-jwks-public"` |  |
| tolerations | list | `[]` |  |
| valkey.secretKey | string | `"valkey-password"` |  |
| valkey.secretName | string | `"truvami-stack-valkey"` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
