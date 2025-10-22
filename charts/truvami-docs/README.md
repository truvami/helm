# truvami-docs

![Version: 0.1.1](https://img.shields.io/badge/Version-0.1.1-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.0.0-rc1](https://img.shields.io/badge/AppVersion-v1.0.0--rc1-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| app.publicUrl | string | `"https://dashboard.truvami.com"` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| betterAuth.secret | string | `""` |  |
| database.url | string | `""` |  |
| fullnameOverride | string | `""` |  |
| httpRoute | object | `{"annotations":{},"enabled":false,"hostnames":["docs2.truvami.com"],"parentRefs":[{"name":"gateway","sectionName":"http"}],"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/headers"}}]}]}` | Expose the service via gateway-api HTTPRoute Requires Gateway API resources and suitable controller installed within the cluster (see: https://gateway-api.sigs.k8s.io/guides/) |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/truvami/docs-v2"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"docs2.truvami.com"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| keycloak.clientId | string | `"dashboard"` |  |
| keycloak.clientSecret | string | `""` |  |
| keycloak.discoveryUrl | string | `"https://sso.sbcdc.ch/auth/realms/truvami/.well-known/openid-configuration"` |  |
| livenessProbe.httpGet.path | string | `"/"` |  |
| livenessProbe.httpGet.port | string | `"http"` |  |
| migration.resources.limits.cpu | string | `"500m"` |  |
| migration.resources.limits.memory | string | `"512Mi"` |  |
| migration.resources.requests.cpu | string | `"100m"` |  |
| migration.resources.requests.memory | string | `"256Mi"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
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
| postgres.pooler.image.repository | string | `"pgbouncer/pgbouncer"` |  |
| postgres.pooler.image.tag | string | `"1.21.0"` |  |
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
| replicaCount | int | `2` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext | object | `{}` |  |
| service.port | int | `3000` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| tolerations | list | `[]` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
