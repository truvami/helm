# truvami-stream

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v0.1.0](https://img.shields.io/badge/AppVersion-v0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` | Pod affinity / anti-affinity rules |
| autoscaling | object | `{"enabled":false,"maxReplicas":10,"minReplicas":1,"targetCPUUtilizationPercentage":80}` | Horizontal Pod Autoscaler settings |
| database | object | `{"host":"truvami-stack-pooler-ro","name":"app","port":5432,"secretKey":"uri","secretName":"truvami-stack-app"}` | PostgreSQL read-only pooler connection settings. Credentials are sourced from the referenced Kubernetes Secret. |
| database.host | string | `"truvami-stack-pooler-ro"` | CNPG read-only connection pooler hostname |
| database.name | string | `"app"` | Database name |
| database.port | int | `5432` | PostgreSQL port |
| database.secretKey | string | `"uri"` | Key inside the Secret that holds the connection URI (fallback) |
| database.secretName | string | `"truvami-stack-app"` | Name of the Kubernetes Secret containing DB credentials |
| fullnameOverride | string | `""` | Override the full release name |
| httpRoute | object | `{"annotations":{},"enabled":false,"hostnames":["chart-example.local"],"parentRefs":[{"name":"gateway","sectionName":"http"}],"rules":[{"matches":[{"path":{"type":"PathPrefix","value":"/"}}]}]}` | Expose the service via gateway-api HTTPRoute Requires Gateway API resources and suitable controller installed within the cluster (see: https://gateway-api.sigs.k8s.io/guides/) |
| image | object | `{"pullPolicy":"IfNotPresent","repository":"ghcr.io/truvami/stream","tag":"v0.1.0"}` | Container image settings |
| image.pullPolicy | string | `"IfNotPresent"` | Image pull policy (IfNotPresent recommended with pinned tags) |
| image.repository | string | `"ghcr.io/truvami/stream"` | Image repository |
| image.tag | string | `"v0.1.0"` | Image tag; defaults to the chart appVersion if empty |
| imagePullSecrets | list | `[]` | Docker registry pull secrets |
| ingress | object | `{"annotations":{},"className":"","enabled":false,"hosts":[{"host":"chart-example.local","paths":[{"path":"/","pathType":"ImplementationSpecific"}]}],"tls":[]}` | Kubernetes Ingress configuration |
| livenessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/healthz","port":"metrics"},"initialDelaySeconds":15,"periodSeconds":10,"timeoutSeconds":5}` | Liveness probe configuration (port "metrics" = stream.metrics.port) |
| nameOverride | string | `""` | Override the chart name |
| networkPolicy | object | `{"enabled":false}` | Kubernetes NetworkPolicy |
| nodeSelector | object | `{}` | Node selector constraints |
| pdb.enabled | bool | `false` |  |
| pdb.minAvailable | int | `1` |  |
| podAnnotations | object | `{}` | Annotations added to every Pod |
| podLabels | object | `{}` | Labels added to every Pod |
| podSecurityContext | object | `{}` | Pod-level security context (merged with secure defaults in the template) |
| readinessProbe | object | `{"failureThreshold":3,"httpGet":{"path":"/readyz","port":"metrics"},"initialDelaySeconds":10,"periodSeconds":10,"successThreshold":1,"timeoutSeconds":5}` | Readiness probe configuration (port "metrics" = stream.metrics.port) |
| replicaCount | int | `1` | Number of pod replicas |
| resources | object | `{"limits":{"ephemeral-storage":"1Gi","memory":"128Mi"},"requests":{"cpu":"100m","ephemeral-storage":"512Mi","memory":"128Mi"}}` | Resource requests and limits. CPU limit is intentionally omitted to allow bursting; memory is capped. |
| securityContext | object | `{"capabilities":{"drop":["ALL"]},"readOnlyRootFilesystem":true,"runAsGroup":65534,"runAsNonRoot":true,"runAsUser":65534}` | Container-level security context (merged with secure defaults in the template) |
| serviceAccount | object | `{"annotations":{},"automount":false,"create":false,"name":""}` | Kubernetes ServiceAccount configuration |
| serviceAccount.annotations | object | `{}` | Annotations to add to the ServiceAccount |
| serviceAccount.automount | bool | `false` | Automount API credentials into pods (disable to reduce attack surface) |
| serviceAccount.create | bool | `false` | Whether to create a dedicated ServiceAccount |
| serviceAccount.name | string | `""` | Explicit ServiceAccount name; generated from fullname when empty |
| serviceMonitor | object | `{"enabled":false}` | Prometheus ServiceMonitor (requires stream.metrics.enabled) |
| stream | object | `{"auth":{"issuer":"https://sso.sbcdc.ch/auth/realms/truvami","jwksURL":"https://sso.sbcdc.ch/auth/realms/truvami/protocol/openid-connect/certs"},"database":{"connectionMaxIdleTime":"5m","connectionMaxLifetime":"30m","initializationTimeout":"15s"},"datasources":{"events":{"enabled":true,"max_items":1000,"min_live_interval_seconds":1},"max_live_interval_seconds":3600},"health":{"checkInterval":"10s","checkTimeout":"2s","maxUnhealthyDuration":"5m"},"logging":{"encoding":"json","level":"info","time-encoder":"rfc3339"},"metrics":{"enabled":true,"port":8891},"otel":{"enabled":false,"endpoint":"tempo.grafana-tempo.svc.cluster.local:4318"},"rate_limit":{"cache_miss":{"requests":15,"window":"15s"},"enabled":false},"server":{"cors":{"allowedOrigins":["http://localhost:3000","https://stream.truvami.com","https://stream.test.truvami.com"]},"port":8890},"valkey":{"host":"truvami-stack-valkey-primary:6379","stats":{"httpCache":{"bucketSize":"1m","keyPrefix":"stream:http:v1:stats","namespaceVersion":1}},"stream_prefix":"api","username":"default"}}` | Application configuration (mounted as stream.yaml ConfigMap). This block contains only non-sensitive settings; all secrets (DATABASE_URI, VALKEY_PASSWORD) are injected as env vars from Kubernetes Secrets — never place credentials here. |
| stream.auth.issuer | string | `"https://sso.sbcdc.ch/auth/realms/truvami"` | Expected JWT issuer claim |
| stream.auth.jwksURL | string | `"https://sso.sbcdc.ch/auth/realms/truvami/protocol/openid-connect/certs"` | JWKS endpoint URL for JWT validation |
| stream.database.connectionMaxIdleTime | string | `"5m"` | Maximum idle time before a connection is closed |
| stream.database.connectionMaxLifetime | string | `"30m"` | Maximum lifetime of a database connection (tune for PgBouncer) |
| stream.database.initializationTimeout | string | `"15s"` | Timeout for initial database connection |
| stream.datasources.events.enabled | bool | `true` | Enable or disable events datasource globally |
| stream.datasources.events.max_items | int | `1000` | Maximum number of items returned per query |
| stream.datasources.events.min_live_interval_seconds | int | `1` | Minimum SSE refresh interval in seconds (caps max update frequency) |
| stream.datasources.max_live_interval_seconds | int | `3600` | Global maximum SSE refresh interval in seconds |
| stream.health.checkInterval | string | `"10s"` | Interval between background health checks |
| stream.health.checkTimeout | string | `"2s"` | Timeout for each health check probe |
| stream.health.maxUnhealthyDuration | string | `"5m"` | Duration of continuous failures before liveness probe fails |
| stream.logging.encoding | string | `"json"` | Log encoding format (json, console) |
| stream.logging.level | string | `"info"` | Log level (debug, info, warn, error) |
| stream.logging.time-encoder | string | `"rfc3339"` | Timestamp encoder (rfc3339, iso8601, epoch) |
| stream.metrics.enabled | bool | `true` | Enable Prometheus metrics endpoint |
| stream.metrics.port | int | `8891` | Metrics server listen port |
| stream.otel.enabled | bool | `false` | Enable OpenTelemetry tracing |
| stream.otel.endpoint | string | `"tempo.grafana-tempo.svc.cluster.local:4318"` | OpenTelemetry collector OTLP endpoint |
| stream.rate_limit.cache_miss.requests | int | `15` | Number of cache-miss requests allowed per window (per user) |
| stream.rate_limit.cache_miss.window | string | `"15s"` | Sliding window duration (e.g. 15s, 1m, 5m) |
| stream.rate_limit.enabled | bool | `false` | Enable or disable rate limiting globally |
| stream.server.cors.allowedOrigins | list | `["http://localhost:3000","https://stream.truvami.com","https://stream.test.truvami.com"]` | Origins allowed for CORS requests |
| stream.server.port | int | `8890` | HTTP server listen port |
| stream.valkey.host | string | `"truvami-stack-valkey-primary:6379"` | Valkey (Redis-compatible) host:port address |
| stream.valkey.stats.httpCache.bucketSize | string | `"1m"` | Aggregation bucket size for stats |
| stream.valkey.stats.httpCache.keyPrefix | string | `"stream:http:v1:stats"` | Redis key prefix for stats cache entries |
| stream.valkey.stats.httpCache.namespaceVersion | int | `1` | Bump this when deploying breaking cache changes |
| stream.valkey.stream_prefix | string | `"api"` | Key prefix used when reading from Valkey streams |
| stream.valkey.username | string | `"default"` | Valkey authentication username |
| tolerations | list | `[]` | Pod tolerations |
| valkey | object | `{"secretKey":"valkey-password","secretName":"truvami-stack-valkey"}` | Valkey Secret reference for password injection |
| valkey.secretKey | string | `"valkey-password"` | Key inside the Secret that holds the password |
| valkey.secretName | string | `"truvami-stack-valkey"` | Name of the Kubernetes Secret containing the Valkey password |
| volumeMounts | list | `[]` | Additional volumeMounts on the container (config mount is added automatically) |
| volumes | list | `[]` | Additional volumes on the Deployment (config volume is added automatically) |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
