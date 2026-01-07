# truvami-api

![Version: 0.0.33](https://img.shields.io/badge/Version-0.0.33-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.10.0](https://img.shields.io/badge/AppVersion-v0.10.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| api.auth.issuer | string | `"https://sso.sbcdc.ch/auth/realms/truvami"` |  |
| api.auth.jwksURL | string | `"https://sso.sbcdc.ch/auth/realms/truvami/protocol/openid-connect/certs"` |  |
| api.database.initializationTimeout | string | `"15s"` |  |
| api.database.migrateTimeout | string | `"1m"` |  |
| api.grpc.host | string | `"0.0.0.0"` |  |
| api.grpc.port | int | `5001` |  |
| api.metrics.enabled | bool | `true` |  |
| api.metrics.port | int | `8889` |  |
| api.otel.enabled | bool | `false` |  |
| api.otel.endpoint | string | `"localhost:4318"` |  |
| api.server.cors.allowedOrigins[0] | string | `"http://localhost:3000"` |  |
| api.server.cors.allowedOrigins[1] | string | `"http://api.truvami.com"` |  |
| api.server.cors.allowedOrigins[2] | string | `"http://api.test.truvami.com"` |  |
| api.server.port | int | `8888` |  |
| api.thingpark.asId | string | `"TWA_xxxxxxxxx.xxxxx.AS"` |  |
| api.thingpark.host | string | `"proxy1.lpn.swisscom.ch"` |  |
| api.valkey.configDispatch.defaultTimeout | string | `"60s"` |  |
| api.valkey.configDispatch.keyPrefix | string | `"config_dispatch"` |  |
| api.valkey.host | string | `"truvami-stack-valkey-primary:6379"` |  |
| api.valkey.username | string | `"default"` |  |
| api.webhook.initializationTimeout | string | `"15s"` |  |
| api.webhook.postRequestTimeout | string | `"5s"` |  |
| api.webhook.response.storedMaxBodySize | int | `512` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| database.host | string | `"truvami-stack-pooler"` |  |
| database.name | string | `"app"` |  |
| database.port | int | `5432` |  |
| database.secretKey | string | `"uri"` |  |
| database.secretName | string | `"truvami-stack-app"` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/truvami/api"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.hosts[0].host | string | `"chart-example.local"` |  |
| ingress.hosts[0].paths[0].path | string | `"/"` |  |
| ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| ingress.tls | list | `[]` |  |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| metrics.enabled | bool | `true` |  |
| metrics.port | int | `9090` |  |
| metrics.serviceMonitor.additionalLabels | object | `{}` |  |
| metrics.serviceMonitor.enabled | bool | `false` |  |
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
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
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
| tolerations | list | `[]` |  |
| valkey.secretKey | string | `"valkey-password"` |  |
| valkey.secretName | string | `"truvami-stack-valkey"` |  |
| volumeMounts[0].mountPath | string | `"/etc/truvami-api"` |  |
| volumeMounts[0].name | string | `"config"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.name | string | `"config-api"` |  |
| volumes[0].configMap.optional | bool | `false` |  |
| volumes[0].name | string | `"config"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
