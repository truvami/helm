# truvami-stream

![Version: 0.1.0](https://img.shields.io/badge/Version-0.1.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `10` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| database.host | string | `"truvami-stack-pooler-ro"` |  |
| database.name | string | `"app"` |  |
| database.port | int | `5432` |  |
| database.secretKey | string | `"uri"` |  |
| database.secretName | string | `"truvami-stack-app"` |  |
| fullnameOverride | string | `""` |  |
| httpRoute | object | `{"annotations":{},"enabled":false,"hostnames":["chart-example.local"],"parentRefs":[{"name":"gateway","sectionName":"http"}],"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/headers"}}]}]}` | Expose the service via gateway-api HTTPRoute Requires Gateway API resources and suitable controller installed within the cluster (see: https://gateway-api.sigs.k8s.io/guides/) |
| image.pullPolicy | string | `"IfNotPresent"` |  |
| image.repository | string | `"ghcr.io/truvami/stream"` |  |
| image.tag | string | `"v0.1.0"` |  |
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
| stream.auth.issuer | string | `"https://sso.sbcdc.ch/auth/realms/truvami"` |  |
| stream.auth.jwksURL | string | `"https://sso.sbcdc.ch/auth/realms/truvami/protocol/openid-connect/certs"` |  |
| stream.database.connectionMaxIdleTime | string | `"5m"` |  |
| stream.database.connectionMaxLifetime | string | `"30m"` |  |
| stream.database.initializationTimeout | string | `"15s"` |  |
| stream.datasources.events.enabled | bool | `true` |  |
| stream.datasources.events.max_items | int | `1000` |  |
| stream.datasources.events.min_live_interval_seconds | int | `1` |  |
| stream.datasources.max_live_interval_seconds | int | `3600` |  |
| stream.health.checkInterval | string | `"10s"` |  |
| stream.health.checkTimeout | string | `"2s"` |  |
| stream.health.maxUnhealthyDuration | string | `"5m"` |  |
| stream.logging.encoding | string | `"json"` |  |
| stream.logging.level | string | `"info"` |  |
| stream.logging.time-encoder | string | `"rfc3339"` |  |
| stream.metrics.enabled | bool | `true` |  |
| stream.metrics.port | int | `8891` |  |
| stream.otel.enabled | bool | `false` |  |
| stream.otel.endpoint | string | `"tempo.grafana-tempo.svc.cluster.local:4318"` |  |
| stream.server.cors.allowedOrigins[0] | string | `"http://localhost:3000"` |  |
| stream.server.cors.allowedOrigins[1] | string | `"https://stream.truvami.com"` |  |
| stream.server.cors.allowedOrigins[2] | string | `"https://stream.test.truvami.com"` |  |
| stream.server.port | int | `8890` |  |
| stream.valkey.host | string | `"truvami-stack-valkey-primary:6379"` |  |
| stream.valkey.stats.httpCache.bucketSize | string | `"1m"` |  |
| stream.valkey.stats.httpCache.keyPrefix | string | `"stream:http:v1:stats"` |  |
| stream.valkey.stats.httpCache.namespaceVersion | int | `1` |  |
| stream.valkey.stream_prefix | string | `"api"` |  |
| stream.valkey.username | string | `"default"` |  |
| tolerations | list | `[]` |  |
| valkey.secretKey | string | `"valkey-password"` |  |
| valkey.secretName | string | `"truvami-stack-valkey"` |  |
| volumeMounts | list | `[]` |  |
| volumes | list | `[]` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
