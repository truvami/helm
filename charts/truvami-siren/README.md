# truvami-siren

![Version: 0.2.11](https://img.shields.io/badge/Version-0.2.11-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: v1.1.0](https://img.shields.io/badge/AppVersion-v1.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| affinity | object | `{}` |  |
| autoscaling.enabled | bool | `false` |  |
| autoscaling.maxReplicas | int | `100` |  |
| autoscaling.minReplicas | int | `1` |  |
| autoscaling.targetCPUUtilizationPercentage | int | `80` |  |
| fullnameOverride | string | `""` |  |
| image.pullPolicy | string | `"Always"` |  |
| image.repository | string | `"ghcr.io/truvami/siren"` |  |
| image.tag | string | `""` |  |
| imagePullSecrets | list | `[]` |  |
| ingress.annotations | object | `{}` |  |
| ingress.className | string | `""` |  |
| ingress.enabled | bool | `false` |  |
| ingress.tls | list | `[]` |  |
| kafka.topic.config."retention.ms" | int | `2592000000` |  |
| kafka.topic.config."segment.bytes" | int | `1073741824` |  |
| kafka.topic.partitions | int | `12` |  |
| kafka.topic.replicas | int | `3` |  |
| livenessProbe.httpGet.path | string | `"/healthz"` |  |
| livenessProbe.httpGet.port | string | `"metrics"` |  |
| nameOverride | string | `""` |  |
| nodeSelector | object | `{}` |  |
| podAnnotations | object | `{}` |  |
| podLabels | object | `{}` |  |
| podSecurityContext | object | `{}` |  |
| readinessProbe.httpGet.path | string | `"/readyz"` |  |
| readinessProbe.httpGet.port | string | `"metrics"` |  |
| replicaCount | int | `1` |  |
| resources.limits.cpu | string | `"100m"` |  |
| resources.limits.memory | string | `"128Mi"` |  |
| resources.requests.cpu | string | `"100m"` |  |
| resources.requests.memory | string | `"128Mi"` |  |
| securityContext.capabilities.drop[0] | string | `"ALL"` |  |
| securityContext.readOnlyRootFilesystem | bool | `true` |  |
| securityContext.runAsNonRoot | bool | `true` |  |
| securityContext.runAsUser | int | `1000` |  |
| service.port | int | `8080` |  |
| service.type | string | `"ClusterIP"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `false` |  |
| serviceAccount.create | bool | `false` |  |
| serviceAccount.name | string | `""` |  |
| serviceMonitor.enabled | bool | `false` |  |
| siren.alerts.device-inactive.evaluation-interval | string | `"1m"` |  |
| siren.alerts.dispatcher.webhook.timeout | string | `"5s"` |  |
| siren.alerts.dispatcher.worker-pool.queue | int | `32` |  |
| siren.alerts.dispatcher.worker-pool.size | int | `8` |  |
| siren.cluster | string | `"truvami-stack"` |  |
| siren.grpc.server | string | `"truvami-stack-truvami-api:5001"` |  |
| siren.kafka."enable.ssl.certificate.verification" | bool | `false` |  |
| siren.kafka.alerts.dlq-topics.battery-statuses | string | `"alerts.battery-statuses-dlq"` |  |
| siren.kafka.alerts.dlq-topics.events | string | `"alerts.events-dlq"` |  |
| siren.kafka.alerts.dlq-topics.positions | string | `"alerts.positions-dlq"` |  |
| siren.kafka.alerts.dlq-topics.rotations | string | `"alerts.rotations-dlq"` |  |
| siren.kafka.alerts.dlq-topics.uplinks | string | `"alerts.uplinks-dlq"` |  |
| siren.kafka.alerts.poll-timeout | string | `"1s"` |  |
| siren.kafka.alerts.retry-topics.battery-statuses | string | `"alerts.battery-statuses-retry"` |  |
| siren.kafka.alerts.retry-topics.events | string | `"alerts.events-retry"` |  |
| siren.kafka.alerts.retry-topics.positions | string | `"alerts.positions-retry"` |  |
| siren.kafka.alerts.retry-topics.rotations | string | `"alerts.rotations-retry"` |  |
| siren.kafka.alerts.retry-topics.uplinks | string | `"alerts.uplinks-retry"` |  |
| siren.kafka.alerts.retry.first-retry | string | `"5s"` |  |
| siren.kafka.alerts.retry.second-retry | string | `"10m"` |  |
| siren.kafka.alerts.retry.third-retry | string | `"1h"` |  |
| siren.kafka.alerts.topics.battery-statuses | string | `"alerts.battery-statuses"` |  |
| siren.kafka.alerts.topics.events | string | `"alerts.events"` |  |
| siren.kafka.alerts.topics.positions | string | `"alerts.positions"` |  |
| siren.kafka.alerts.topics.rotations | string | `"alerts.rotations"` |  |
| siren.kafka.alerts.topics.uplinks | string | `"alerts.uplinks"` |  |
| siren.kafka.bootstrap.servers[0] | string | `"truvami-stack-kafka-bootstrap:9093"` |  |
| siren.kafka.group.id | string | `"siren"` |  |
| siren.kafka.security.protocol | string | `"SSL"` |  |
| siren.kafka.ssl.ca.location | string | `"/var/run/secrets/kafka/ca.crt"` |  |
| siren.metrics.port | int | `9090` |  |
| siren.otel.endpoint | string | `"tempo.grafana-tempo.svc.cluster.local:4318"` |  |
| siren.valkey.cache-ttl | string | `"15m"` |  |
| siren.valkey.host | string | `"truvami-stack-valkey-primary:6379"` |  |
| siren.valkey.key-prefix | string | `"siren"` |  |
| siren.valkey.username | string | `"default"` |  |
| tolerations | list | `[]` |  |
| valkey.secretKey | string | `"valkey-password"` |  |
| valkey.secretName | string | `"truvami-stack-valkey"` |  |
| volumeMounts[0].mountPath | string | `"/etc/truvami-siren"` |  |
| volumeMounts[0].name | string | `"config"` |  |
| volumeMounts[0].readOnly | bool | `true` |  |
| volumeMounts[1].mountPath | string | `"/var/run/secrets/kafka"` |  |
| volumeMounts[1].mountPropagation | string | `"None"` |  |
| volumeMounts[1].name | string | `"kafka-credentials"` |  |
| volumeMounts[1].readOnly | bool | `true` |  |
| volumes[0].configMap.defaultMode | int | `420` |  |
| volumes[0].configMap.items[0].key | string | `"config.yaml"` |  |
| volumes[0].configMap.items[0].path | string | `"config.yaml"` |  |
| volumes[0].configMap.items[1].key | string | `"set-env.sh"` |  |
| volumes[0].configMap.items[1].path | string | `"set-env.sh"` |  |
| volumes[0].configMap.name | string | `"siren-config"` |  |
| volumes[0].configMap.optional | bool | `false` |  |
| volumes[0].name | string | `"config"` |  |
| volumes[1].name | string | `"kafka-credentials"` |  |
| volumes[1].secret.defaultMode | int | `420` |  |
| volumes[1].secret.optional | bool | `false` |  |
| volumes[1].secret.secretName | string | `"truvami-siren-kafka"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
