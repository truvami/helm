# truvami-monitoring

![Version: 0.2.4](https://img.shields.io/badge/Version-0.2.4-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square)

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
| alertmanager.global.http_config.enable_http2 | bool | `true` |  |
| alertmanager.global.http_config.follow_redirects | bool | `true` |  |
| alertmanager.global.resolve_timeout | string | `"5m"` |  |
| alertmanager.global.smtp_auth_password | string | `""` |  |
| alertmanager.global.smtp_auth_username | string | `""` |  |
| alertmanager.global.smtp_from | string | `"alertmanager@truvami.com"` |  |
| alertmanager.global.smtp_smarthost | string | `"localhost:587"` |  |
| alertmanager.inhibit_rules[0].equal[0] | string | `"service"` |  |
| alertmanager.inhibit_rules[0].equal[1] | string | `"cluster"` |  |
| alertmanager.inhibit_rules[0].source_matchers[0] | string | `"severity=\"critical\""` |  |
| alertmanager.inhibit_rules[0].target_matchers[0] | string | `"severity=~\"warning|minor\""` |  |
| alertmanager.inhibit_rules[1].equal[0] | string | `"service"` |  |
| alertmanager.inhibit_rules[1].source_matchers[0] | string | `"maintenance=\"true\""` |  |
| alertmanager.inhibit_rules[1].target_matchers[0] | string | `"service=~\".*\""` |  |
| alertmanager.receivers.critical.enabled | bool | `true` |  |
| alertmanager.receivers.critical.slack.channel | string | `"#critical-alerts"` |  |
| alertmanager.receivers.critical.slack.enabled | bool | `false` |  |
| alertmanager.receivers.critical.slack.text | string | `"{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"` |  |
| alertmanager.receivers.critical.slack.title | string | `"🚨 CRITICAL: {{ .GroupLabels.alertname }}"` |  |
| alertmanager.receivers.critical.slack.webhook_url | string | `""` |  |
| alertmanager.receivers.critical.webhook.enabled | bool | `false` |  |
| alertmanager.receivers.critical.webhook.url | string | `""` |  |
| alertmanager.receivers.default.enabled | bool | `true` |  |
| alertmanager.receivers.default.webhook.enabled | bool | `false` |  |
| alertmanager.receivers.default.webhook.send_resolved | bool | `true` |  |
| alertmanager.receivers.default.webhook.text | string | `"{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"` |  |
| alertmanager.receivers.default.webhook.title | string | `"Truvami Alert: {{ .GroupLabels.alertname }}"` |  |
| alertmanager.receivers.default.webhook.url | string | `""` |  |
| alertmanager.receivers.discord.enabled | bool | `false` |  |
| alertmanager.receivers.discord.message | string | `"{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"` |  |
| alertmanager.receivers.discord.title | string | `"{{ .GroupLabels.alertname }}"` |  |
| alertmanager.receivers.discord.webhook_url | string | `""` |  |
| alertmanager.receivers.email.body | string | `"{{ range .Alerts }}\n**Alert:** {{ .Annotations.summary }}\n**Description:** {{ .Annotations.description }}\n**Severity:** {{ .Labels.severity }}\n**Cluster:** {{ .Labels.cluster }}\n**Service:** {{ .Labels.service }}\n**Started:** {{ .StartsAt }}\n{{ if .Labels.runbook_url }}**Runbook:** {{ .Labels.runbook_url }}{{ end }}\n{{ end }}\n"` |  |
| alertmanager.receivers.email.enabled | bool | `false` |  |
| alertmanager.receivers.email.from | string | `"alertmanager@truvami.com"` |  |
| alertmanager.receivers.email.subject | string | `"[{{ .Status | toUpper }}] {{ .GroupLabels.alertname }} ({{ .GroupLabels.cluster }})"` |  |
| alertmanager.receivers.email.to | string | `"alerts@truvami.com"` |  |
| alertmanager.receivers.opsgenie.api_key | string | `""` |  |
| alertmanager.receivers.opsgenie.api_url | string | `"https://api.opsgenie.com/"` |  |
| alertmanager.receivers.opsgenie.description | string | `"{{ range .Alerts }}{{ .Annotations.description }}{{ end }}"` |  |
| alertmanager.receivers.opsgenie.details.cluster | string | `"{{ .GroupLabels.cluster }}"` |  |
| alertmanager.receivers.opsgenie.details.environment | string | `"{{ .GroupLabels.environment }}"` |  |
| alertmanager.receivers.opsgenie.details.runbook | string | `"{{ .CommonAnnotations.runbook_url }}"` |  |
| alertmanager.receivers.opsgenie.details.service | string | `"{{ .GroupLabels.service }}"` |  |
| alertmanager.receivers.opsgenie.enabled | bool | `false` |  |
| alertmanager.receivers.opsgenie.message | string | `"{{ .GroupLabels.alertname }}: {{ .GroupLabels.instance }}"` |  |
| alertmanager.receivers.opsgenie.priority | string | `"{{ if eq .GroupLabels.severity \"critical\" }}P1{{ else if eq .GroupLabels.severity \"major\" }}P2{{ else }}P3{{ end }}"` |  |
| alertmanager.receivers.opsgenie.responders[0].name | string | `"DevOps"` |  |
| alertmanager.receivers.opsgenie.responders[0].type | string | `"team"` |  |
| alertmanager.receivers.opsgenie.responders[1].type | string | `"user"` |  |
| alertmanager.receivers.opsgenie.responders[1].username | string | `"on-call-engineer"` |  |
| alertmanager.receivers.opsgenie.teams | list | `[]` |  |
| alertmanager.receivers.pagerduty.client | string | `"Truvami AlertManager"` |  |
| alertmanager.receivers.pagerduty.client_url | string | `"{{ .ExternalURL }}"` |  |
| alertmanager.receivers.pagerduty.description | string | `"{{ .GroupLabels.alertname }}: {{ .GroupLabels.instance }}"` |  |
| alertmanager.receivers.pagerduty.details.cluster | string | `"{{ .GroupLabels.cluster }}"` |  |
| alertmanager.receivers.pagerduty.details.environment | string | `"{{ .GroupLabels.environment }}"` |  |
| alertmanager.receivers.pagerduty.details.service | string | `"{{ .GroupLabels.service }}"` |  |
| alertmanager.receivers.pagerduty.enabled | bool | `false` |  |
| alertmanager.receivers.pagerduty.routing_key | string | `""` |  |
| alertmanager.receivers.pagerduty.severity | string | `"{{ .GroupLabels.severity }}"` |  |
| alertmanager.receivers.slack.channel | string | `"#alerts"` |  |
| alertmanager.receivers.slack.color | string | `"{{ if eq .GroupLabels.severity \"critical\" }}danger{{ else if eq .GroupLabels.severity \"major\" }}warning{{ else }}good{{ end }}"` |  |
| alertmanager.receivers.slack.enabled | bool | `false` |  |
| alertmanager.receivers.slack.icon_emoji | string | `"🚨"` |  |
| alertmanager.receivers.slack.text | string | `"{{ range .Alerts }}{{ .Annotations.summary }}{{ if .Annotations.description }}\n{{ .Annotations.description }}{{ end }}{{ end }}"` |  |
| alertmanager.receivers.slack.title | string | `"{{ if eq .Status \"firing\" }}🔴{{ else }}🟢{{ end }} {{ .GroupLabels.alertname }}"` |  |
| alertmanager.receivers.slack.username | string | `"AlertManager"` |  |
| alertmanager.receivers.slack.webhook_url | string | `""` |  |
| alertmanager.receivers.teams.enabled | bool | `false` |  |
| alertmanager.receivers.teams.summary | string | `"{{ range .Alerts }}{{ .Annotations.summary }}{{ end }}"` |  |
| alertmanager.receivers.teams.title | string | `"{{ .GroupLabels.alertname }}"` |  |
| alertmanager.receivers.teams.webhook_url | string | `""` |  |
| alertmanager.resources.limits.cpu | string | `"500m"` |  |
| alertmanager.resources.limits.memory | string | `"512Mi"` |  |
| alertmanager.resources.requests.cpu | string | `"50m"` |  |
| alertmanager.resources.requests.memory | string | `"128Mi"` |  |
| alertmanager.route.group_by[0] | string | `"alertname"` |  |
| alertmanager.route.group_by[1] | string | `"cluster"` |  |
| alertmanager.route.group_by[2] | string | `"service"` |  |
| alertmanager.route.group_interval | string | `"5m"` |  |
| alertmanager.route.group_wait | string | `"10s"` |  |
| alertmanager.route.receiver | string | `"default-receiver"` |  |
| alertmanager.route.repeat_interval | string | `"12h"` |  |
| alertmanager.route.routes[0].group_interval | string | `"1m"` |  |
| alertmanager.route.routes[0].group_wait | string | `"0s"` |  |
| alertmanager.route.routes[0].match.severity | string | `"critical"` |  |
| alertmanager.route.routes[0].receiver | string | `"critical-alerts"` |  |
| alertmanager.route.routes[0].repeat_interval | string | `"1h"` |  |
| alertmanager.route.routes[1].group_interval | string | `"1m"` |  |
| alertmanager.route.routes[1].group_wait | string | `"0s"` |  |
| alertmanager.route.routes[1].match.alertname | string | `"Watchdog"` |  |
| alertmanager.route.routes[1].receiver | string | `"watchdog-heartbeat"` |  |
| alertmanager.route.routes[1].repeat_interval | string | `"5m"` |  |
| alertmanager.route.routes[2].group_wait | string | `"5s"` |  |
| alertmanager.route.routes[2].match_re.environment | string | `"prod|production"` |  |
| alertmanager.route.routes[2].receiver | string | `"opsgenie-production"` |  |
| alertmanager.route.routes[2].repeat_interval | string | `"5m"` |  |
| alertmanager.secrets.opsgenie_api_key.key | string | `"opsgenie-api-key"` |  |
| alertmanager.secrets.opsgenie_api_key.name | string | `"truvami-monitoring-secrets"` |  |
| alertmanager.secrets.slack_webhook_url.key | string | `"slack-webhook-url"` |  |
| alertmanager.secrets.slack_webhook_url.name | string | `"truvami-monitoring-secrets"` |  |
| alertmanager.secrets.smtp_auth_password.key | string | `"smtp-password"` |  |
| alertmanager.secrets.smtp_auth_password.name | string | `"truvami-monitoring-secrets"` |  |
| alertmanager.silences.default_duration | string | `"1h"` |  |
| alertmanager.silences.max_duration | string | `"24h"` |  |
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
| alerts.deviceHealth.excessiveUplinks.duration | string | `"1h"` |  |
| alerts.deviceHealth.excessiveUplinks.enabled | bool | `true` |  |
| alerts.deviceHealth.excessiveUplinks.severity | string | `"major"` |  |
| alerts.deviceHealth.excessiveUplinks.threshold | int | `240` |  |
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
| alerts.signalQuality.enabled | bool | `false` |  |
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
