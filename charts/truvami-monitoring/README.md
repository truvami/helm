# truvami-monitoring

![Version: 0.1.91](https://img.shields.io/badge/Version-0.1.91-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

This chart contains all CRD's for the truvami-stack monitoring and alerting.

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| alertDefaults.severityLevels.critical | string | `"critical"` |  |
| alertDefaults.severityLevels.info | string | `"info"` |  |
| alertDefaults.severityLevels.major | string | `"major"` |  |
| alertDefaults.severityLevels.minor | string | `"minor"` |  |
| alertDefaults.severityLevels.warning | string | `"warning"` |  |
| alertLabels.altravis_prod | string | `"false"` |  |
| alertLabels.altravis_test | string | `"true"` |  |
| alertLabels.code | string | `"SBCC"` |  |
| alertLabels.customer | string | `"truvami"` |  |
| alertmanager.enabled | bool | `true` |  |
| alertmanager.receivers.email.enabled | bool | `false` |  |
| alertmanager.receivers.email.to | string | `"alerts@truvami.com"` |  |
| alertmanager.receivers.slack.channel | string | `"#alerts"` |  |
| alertmanager.receivers.slack.enabled | bool | `false` |  |
| alertmanager.receivers.slack.webhook_url | string | `""` |  |
| alertmanager.resources.limits.cpu | string | `"500m"` |  |
| alertmanager.resources.limits.memory | string | `"512Mi"` |  |
| alertmanager.resources.requests.cpu | string | `"50m"` |  |
| alertmanager.resources.requests.memory | string | `"128Mi"` |  |
| alertmanager.smtp.from | string | `"alertmanager@truvami.com"` |  |
| alertmanager.smtp.smarthost | string | `"localhost:587"` |  |
| alerts.api.authErrors.duration | string | `"2m"` |  |
| alerts.api.authErrors.enabled | bool | `true` |  |
| alerts.api.authErrors.severity | string | `"major"` |  |
| alerts.api.deviceNotFoundErrors.duration | string | `"2m"` |  |
| alerts.api.deviceNotFoundErrors.enabled | bool | `true` |  |
| alerts.api.deviceNotFoundErrors.severity | string | `"major"` |  |
| alerts.api.deviceNotFoundErrors.threshold | float | `0.1` |  |
| alerts.api.enabled | bool | `true` |  |
| alerts.api.grpcValidationErrors.duration | string | `"2m"` |  |
| alerts.api.grpcValidationErrors.enabled | bool | `true` |  |
| alerts.api.grpcValidationErrors.severity | string | `"major"` |  |
| alerts.api.grpcValidationErrors.threshold | float | `0.1` |  |
| alerts.api.performanceIssues.duration | string | `"5m"` |  |
| alerts.api.performanceIssues.enabled | bool | `true` |  |
| alerts.api.performanceIssues.severity | string | `"minor"` |  |
| alerts.api.securityErrors.duration | string | `"1m"` |  |
| alerts.api.securityErrors.enabled | bool | `true` |  |
| alerts.api.securityErrors.severity | string | `"major"` |  |
| alerts.api.securityErrors.threshold | float | `0.5` |  |
| alerts.api.webhookErrors.duration | string | `"2m"` |  |
| alerts.api.webhookErrors.enabled | bool | `true` |  |
| alerts.api.webhookErrors.severity | string | `"major"` |  |
| alerts.api.webhookErrors.threshold | float | `0.1` |  |
| alerts.authentication.enabled | bool | `true` |  |
| alerts.bridgeConsumer.enabled | bool | `true` |  |
| alerts.database.enabled | bool | `true` |  |
| alerts.deploymentVersions.enabled | bool | `true` |  |
| alerts.deploymentVersions.longRunningMismatch.duration | string | `"15m"` |  |
| alerts.deploymentVersions.longRunningMismatch.enabled | bool | `true` |  |
| alerts.deploymentVersions.longRunningMismatch.severity | string | `"critical"` |  |
| alerts.deploymentVersions.multipleVersions.duration | string | `"5m"` |  |
| alerts.deploymentVersions.multipleVersions.enabled | bool | `true` |  |
| alerts.deploymentVersions.multipleVersions.severity | string | `"warning"` |  |
| alerts.deploymentVersions.serviceVersionInfo.duration | string | `"1m"` |  |
| alerts.deploymentVersions.serviceVersionInfo.enabled | bool | `true` |  |
| alerts.deploymentVersions.serviceVersionInfo.severity | string | `"info"` |  |
| alerts.deviceBattery.criticallyLow.duration | string | `"1m"` |  |
| alerts.deviceBattery.criticallyLow.enabled | bool | `true` |  |
| alerts.deviceBattery.criticallyLow.severity | string | `"minor"` |  |
| alerts.deviceBattery.criticallyLow.threshold | float | `2.5` |  |
| alerts.deviceBattery.enabled | bool | `true` |  |
| alerts.deviceBattery.veryLow.duration | string | `"5m"` |  |
| alerts.deviceBattery.veryLow.enabled | bool | `true` |  |
| alerts.deviceBattery.veryLow.severity | string | `"warning"` |  |
| alerts.deviceBattery.veryLow.threshold | float | `2.8` |  |
| alerts.deviceDutyCycle.enabled | bool | `true` |  |
| alerts.deviceDutyCycle.excessiveDutyCycle.duration | string | `"1h"` |  |
| alerts.deviceDutyCycle.excessiveDutyCycle.enabled | bool | `true` |  |
| alerts.deviceDutyCycle.excessiveDutyCycle.severity | string | `"critical"` |  |
| alerts.deviceDutyCycle.excessiveDutyCycle.threshold | int | `20` |  |
| alerts.deviceDutyCycle.highDutyCycle.duration | string | `"1h"` |  |
| alerts.deviceDutyCycle.highDutyCycle.enabled | bool | `true` |  |
| alerts.deviceDutyCycle.highDutyCycle.severity | string | `"warning"` |  |
| alerts.deviceDutyCycle.highDutyCycle.threshold | int | `10` |  |
| alerts.deviceHealth.enabled | bool | `true` |  |
| alerts.gateway.enabled | bool | `true` |  |
| alerts.integration.enabled | bool | `true` |  |
| alerts.kafka.enabled | bool | `true` |  |
| alerts.serviceHealth.bridgeDown.duration | string | `"1m"` |  |
| alerts.serviceHealth.bridgeDown.enabled | bool | `true` |  |
| alerts.serviceHealth.bridgeDown.severity | string | `"critical"` |  |
| alerts.serviceHealth.bridgeHighErrorRate.duration | string | `"2m"` |  |
| alerts.serviceHealth.bridgeHighErrorRate.enabled | bool | `true` |  |
| alerts.serviceHealth.bridgeHighErrorRate.severity | string | `"major"` |  |
| alerts.serviceHealth.bridgeHighErrorRate.threshold | float | `0.1` |  |
| alerts.serviceHealth.enabled | bool | `true` |  |
| alerts.siren.enabled | bool | `true` |  |
| dashboards.annotations.k8s-sidecar-target-directory | string | `"/tmp/dashboards"` |  |
| dashboards.enabled | bool | `true` |  |
| dashboards.general | object | `{}` |  |
| fullnameOverride | string | `""` |  |
| grafana.datasources."datasources.yaml".apiVersion | int | `1` |  |
| grafana.datasources."datasources.yaml".datasources[0].access | string | `"proxy"` |  |
| grafana.datasources."datasources.yaml".datasources[0].isDefault | bool | `true` |  |
| grafana.datasources."datasources.yaml".datasources[0].name | string | `"Prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[0].type | string | `"prometheus"` |  |
| grafana.datasources."datasources.yaml".datasources[0].url | string | `"http://prometheus-operated:9090"` |  |
| grafana.enabled | bool | `false` |  |
| grafana.ingress.annotations."nginx.ingress.kubernetes.io/proxy-read-timeout" | string | `"3600"` |  |
| grafana.ingress.annotations."nginx.ingress.kubernetes.io/proxy-send-timeout" | string | `"3600"` |  |
| grafana.ingress.annotations."nginx.ingress.kubernetes.io/server-snippets" | string | `"location / {\n  proxysetheader Upgrade $httpupgrade;\n  proxyhttpversion 1.1;\n  proxysetheader X-Forwarded-Host $httphost;\n  proxysetheader X-Forwarded-Proto $scheme;\n  proxysetheader X-Forwarded-For $remoteaddr;\n  proxysetheader Host $host;\n  proxysetheader Connection \"upgrade\";\n  proxycachebypass $httpupgrade;\n  }\n"` |  |
| grafana.ingress.className | string | `""` |  |
| grafana.ingress.enabled | bool | `false` |  |
| grafana.ingress.hosts[0].host | string | `"chart-example.local"` |  |
| grafana.ingress.hosts[0].paths[0].path | string | `"/"` |  |
| grafana.ingress.hosts[0].paths[0].pathType | string | `"ImplementationSpecific"` |  |
| grafana.ingress.tls | list | `[]` |  |
| grafana.sidecar.dashboards.enabled | bool | `true` |  |
| grafana.smtp.existingSecret | string | `""` |  |
| grafana.smtp.passwordKey | string | `"password"` |  |
| grafana.smtp.userKey | string | `"user"` |  |
| nameOverride | string | `""` |  |
| prometheus.enableRemoteWriteReceiver | bool | `false` |  |
| prometheus.resources.limits.cpu | string | `"1"` |  |
| prometheus.resources.limits.memory | string | `"1Gi"` |  |
| prometheus.resources.requests.cpu | string | `"100m"` |  |
| prometheus.resources.requests.memory | string | `"256Mi"` |  |
| prometheus.retention | string | `"10d"` |  |
| prometheus.storageSize | string | `"10Gi"` |  |
| prometheusRule.annotations | object | `{}` |  |
| prometheusRule.enabled | bool | `true` |  |
| prometheusRule.interval | string | `"30s"` |  |
| prometheusRule.labels | object | `{}` |  |
| watchdog.webhookUrl | string | `""` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
