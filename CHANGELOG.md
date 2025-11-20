# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1-rc25] - 2025-11-20

### Features
- Added new alerts by @michaelbeutler

### Refactors
- Use redis instead of valkey dashboard by @michaelbeutler

## [1.0.1-rc24] - 2025-11-19

### Documentation
- Updated docs by @niko-kriznik-globtim

### Features
- Update Valkey deployment by @niko-kriznik-globtim

### Fixes
- Truvami-monitoring version by @niko-kriznik-globtim

## [1.0.1-rc23] - 2025-11-06

### Features
- Update truvami-monitoring chart to version 0.2.0 with enhanced AlertManager configurations and new example setups by @michaelbeutler

## [1.0.1-rc22] - 2025-11-05

### Fixes
- Update device dashboard layout and replace alerts pie chart with service logs panel by @michaelbeutler
- Update truvami-monitoring chart version to 0.1.92 and enable signal quality alerts by @michaelbeutler

### Refactors
- Remove logs sections from service dashboards and delete uplinks pricing dashboard by @michaelbeutler

## [1.0.1-rc21] - 2025-10-28

### Fixes
- Update KafkaUser resource name to match release name by @michaelbeutler
- Bump truvami-siren and truvami-stack chart versions to 0.2.10 and 0.1.221 respectively by @michaelbeutler

## [1.0.1-rc20] - 2025-10-28

### Fixes
- Update KAFKA_GROUP_ID environment variable to remove quotes around value by @michaelbeutler

## [1.0.1-rc18] - 2025-10-28

### Features
- Bump truvami-dashboard version to 1.0.11 and update truvami-stack to use the new version by @michaelbeutler

## [1.0.1-rc17] - 2025-10-28

### Features
- Update truvami-dashboard to version 1.0.10 and enhance secret management for Better Auth and Keycloak by @michaelbeutler

## [1.0.1-rc16] - 2025-10-28

### Features
- Update Helm chart to version 0.1.3 and enhance secret management for Better Auth and Keycloak by @michaelbeutler
- Bump chart version to 0.1.216 and update truvami-docs dependency to 0.1.3 by @michaelbeutler

## [1.0.1-rc15] - 2025-10-28

### Features
- Add new quality dashboard (first draft) by @michaelbeutler
- Enhance alert configuration and monitoring rules for various services by @michaelbeutler

## [1.0.1-rc12] - 2025-10-22

### Features
- Added logs panel to service dashboards by @michaelbeutler
- Add PostgreSQL connection pooler configuration and update related templates by @michaelbeutler

## [1.0.1-rc10] - 2025-10-21

### Features
- Add enableRemoteWriteReceiver option to values.yaml by @michaelbeutler

## [1.0.1-rc9] - 2025-10-20

### Features
- Add truvami-docs chart by @michaelbeutler

## [1.0.1-rc8] - 2025-10-17

### Features
- Add uplinks pricing dashboard with comprehensive metrics and visualizations by @michaelbeutler

## [1.0.1-rc7] - 2025-10-15

### Features
- Add migration network policy and update migration job labels by @michaelbeutler
- Update gateway monitoring panels to reflect LoRaWAN metrics by @michaelbeutler

## [1.0.1-rc5] - 2025-10-15

### Features
- Added support for service monitor by @michaelbeutler

## [1.0.1-rc4] - 2025-10-15

### Features
- Enhance device dashboard with comprehensive monitoring and fix panel issues by @michaelbeutler

## [1.0.1-rc3] - 2025-10-15

### Features
- Add service dashboard for truvami-siren by @michaelbeutler

## [1.0.0-rc2] - 2025-10-15

### Features
- Integrate conventional commits with helm chart releaser by @michaelbeutler

## [1.0.0-rc1] - 2025-10-15

### Features
- Add ports timeline and device donut by @simylein
- Add donut charts for decode errors by @simylein
- Add battery chart by @simylein
- Add decoder warnings charts by @simylein
- Initial Helm chart setup with templates and configuration by @michaelbeutler
- Pin spreading factors to colors by @simylein
- With aws and loracloud solving rates by @simylein
- Enable pod monitoring in PostgreSQL configuration by @michaelbeutler
- Add missing uplink sequence chart
- Add buffer level by devices chart by @simylein
- Update PostgreSQL configuration and resource limits by @michaelbeutler
- Update truvami-monitoring to version 0.1.34 and bump truvami-stack to version 0.1.108 by @michaelbeutler
- Update RSSI expressions and adjust panel configurations by @michaelbeutler
- Bump truvami-monitoring to version 0.1.35 and update dependencies in truvami-stack by @michaelbeutler
- Bump truvami-monitoring to version 0.1.36 and update truvami-stack to version 0.1.110 by @michaelbeutler
- Update truvami-monitoring to version 0.1.36 and replace previous tgz file by @michaelbeutler
- Bump truvami-monitoring to version 0.1.37 and update dependencies in truvami-stack by @michaelbeutler
- Add alerting rule for aws position estimation by @simylein
- Add two stage rules to detect offline devices by @simylein
- Filter by customers and repair decoder graphs by @simylein
- Add resource requests and limits configuration to values.yaml by @michaelbeutler
- Display ttf pdop and satellites per device per customer by @simylein
- Add 'No captured at' panel to bridge dashboard by @michaelbeutler
- Color bridge errors red on dashboard by @michaelbeutler
- Add ArgoCD hooks to ensure migrations run first by @michaelbeutler
- Update truvami-api and truvami-monitoring versions to 0.0.21 and 0.1.50 respectively by @michaelbeutler
- Bump chart version to 0.1.143 and update dependencies by @michaelbeutler
- Add Redis monitoring dashboard and update dependencies by @michaelbeutler
- Update truvami-siren chart to version 0.2.0 with StatefulSet support and environment variable configuration by @michaelbeutler
- Enhance siren-config with improved environment setup and StatefulSet configuration by @michaelbeutler
- Add Kafka Exporter dashboard and enhance Prometheus rules with dynamic alert labels by @michaelbeutler
- Enhance dashboards with namespace and cluster filtering for Prometheus queries by @michaelbeutler
- Update chart versions for truvami-monitoring to 0.1.58 and truvami-siren to 0.2.1 by @michaelbeutler
- Bump chart versions for truvami-monitoring to 0.1.59 and truvami-stack to 0.1.167; update PrometheusRule alert labels by @michaelbeutler
- Update truvami-siren to version 0.2.2; modify statefulset configuration and add config items by @michaelbeutler
- Bump truvami-siren and truvami-stack versions to 0.2.3 and 0.1.169 respectively; update Chart.lock and service configuration by @michaelbeutler
- Bump truvami-siren version to 0.2.4; update Chart.lock and Chart.yaml by @michaelbeutler
- Update severity level for Kafka consumer alerts; change from warning to major by @michaelbeutler
- Bump truvami-siren version to 0.2.5; update Chart.lock and Chart.yaml by @michaelbeutler
- Bump truvami-monitoring and truvami-siren versions to 0.1.60 and 0.2.6 respectively; update Chart.lock and Chart.yaml by @michaelbeutler
- Add new Prometheus alert rules for consumer processing, device health, and service monitoring; update existing rules with severity adjustments by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.61 and 0.1.173 respectively; update Chart.lock and Chart.yaml by @michaelbeutler
- Add new Prometheus alert rules for position estimation, device health, gateway network, Kafka consumer, and WiFi solver error rates; adjust severity levels and descriptions by @michaelbeutler
- Add Prometheus alert rules for database errors, gRPC validation, device errors, and security; set severity levels and descriptions by @michaelbeutler
- Add new Prometheus alert rules for Siren service, including device health, Kafka consumer, performance, and schema validation; enhance existing rules with detailed descriptions and severity levels by @michaelbeutler
- Add Prometheus alert rules for watchdog, Kafka consumer, decoder errors, and WiFi solver; enhance alert configurations with severity levels, descriptions, and new rules by @michaelbeutler
- Add Prometheus alert rules for Kafka and Valkey clusters; include critical alerts for broker availability, consumer lag, and instance health with detailed descriptions and severity levels by @michaelbeutler
- Update truvami-monitoring and truvami-stack chart versions to 0.1.62 and 0.1.174 respectively; include new package files by @michaelbeutler
- Update Prometheus alert rules for Truvami API, Gateway, and Siren Kafka consumer; enhance descriptions, severity levels, and thresholds by @michaelbeutler
- Update truvami-monitoring and truvami-stack chart versions to 0.1.63 and 0.1.175 respectively; include new package files by @michaelbeutler
- Update Prometheus alert rules for device health and Siren Kafka consumer; enhance descriptions and thresholds for battery levels and message consumption by @michaelbeutler
- Update truvami-monitoring and truvami-stack chart versions to 0.1.64 and 0.1.176 respectively by @michaelbeutler
- Update truvami-monitoring and truvami-stack chart versions to 0.1.65 and 0.1.177 respectively; include new package files by @michaelbeutler
- Add Truvami Alert Overview dashboard with detailed alert metrics and visualizations by @michaelbeutler
- Enhance Valkey Cache Monitoring Dashboard and add Postgres ServiceMonitor by @michaelbeutler
- Update Valkey and Gateway alert rules for improved clarity and consistency by @michaelbeutler
- Refactor alertmanager configuration for improved routing and notification clarity by @michaelbeutler
- Bump truvami-monitoring and truvami-stack chart versions to 0.1.66 and 0.1.178 respectively by @michaelbeutler
- Add PostgreSQL support with managed and external configurations in Truvami Dashboard by @michaelbeutler
- Bump chart version to 0.0.17 for truvami-dashboard by @michaelbeutler
- Bump chart versions for truvami-monitoring and truvami-dashboard to 0.1.67 and 0.0.17 respectively by @michaelbeutler
- Upgrade truvami-dashboard to version 1.0.0 with Better Auth integration and PostgreSQL support by @michaelbeutler
- Update truvami-dashboard to version 1.0.1 with migration job and resource limits by @michaelbeutler
- Bump truvami-dashboard and truvami-stack versions to 1.0.2 and 0.1.181 respectively, update migration job configuration by @michaelbeutler
- Bump truvami-dashboard and truvami-stack versions to 1.0.3 and 0.1.182 respectively, update database secret references and migration job configuration by @michaelbeutler
- Bump truvami-dashboard and truvami-stack versions to 1.0.4 and 0.1.183 respectively, update database name in deployment and migration configurations by @michaelbeutler
- Bump truvami-dashboard and truvami-stack versions to 1.0.5 and 0.1.184 respectively, add NODE_ENV to secret configuration by @michaelbeutler
- Bump truvami-dashboard and truvami-stack versions to 1.0.6 and 0.1.185 respectively, update NODE_ENV encoding in secret configuration by @michaelbeutler
- Update gateway RSSI and SNR alert rules to improve monitoring accuracy by @michaelbeutler
- Enhance Kafka integration alert rules for consumer lag and blockage detection by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.68 and 0.1.186 respectively, update Chart.lock and add new tgz files by @michaelbeutler
- Refactor Alertmanager configuration to use AlertmanagerConfig API and simplify routing rules by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.69 and 0.1.187 respectively, update Chart.lock and add new tgz files by @michaelbeutler
- Enhance alert summaries and descriptions for decoder errors, device offline, gateway network, and service health rules by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.70 and 0.1.188 respectively by @michaelbeutler
- Enhance alert descriptions and summaries for various monitoring rules to improve clarity and actionability by @michaelbeutler
- Add Prometheus alert rules for deployment version monitoring and handling by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.71 and 0.1.189 respectively, update Chart.lock and add new tgz files by @michaelbeutler
- Simplify Prometheus alert expressions for deployment version monitoring by @michaelbeutler
- Added migration env by @michaelbeutler
- Add alert for devices transmitting on multiple LoRa networks by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.74 and 0.1.192 respectively, update Chart.lock and dashboards' UIDs by @michaelbeutler
- Update Prometheus rules to include node labels and adjust service names for better monitoring clarity by @michaelbeutler
- Add podMonitorSelector to Prometheus spec for enhanced monitoring configuration by @michaelbeutler
- Bump truvami-monitoring and truvami-stack versions to 0.1.75 and 0.1.193 respectively, update Chart.lock and fix service monitor selector by @michaelbeutler
- Update Prometheus alert rules for device monitoring and Kafka integration, enhancing alert descriptions and node labels by @michaelbeutler
- Add Prometheus alert rules for Truvami Go runtime metrics and service-specific monitoring by @michaelbeutler
- Enhance alerting and dashboard configurations by @michaelbeutler
- Add new dashboards for Truvami services and overview by @michaelbeutler
- Update CI workflows to install kube-score and helm-docs with versioning by @michaelbeutler
- Specify kube-score version in CI workflow installation by @michaelbeutler

### Fixes
- Donut charts display the sum over the whole timespan by @simylein
- Respect spreading factor filters in charts by @simylein
- Donut charts now display total amounts by @simylein
- Decode errors only show when greater than zero by @simylein
- Update AWS Position Estimates and Bridge Service configurations by @michaelbeutler
- Update truvami-monitoring version to 0.1.25 and adjust dependencies by @michaelbeutler
- Increment chart version to 0.1.92 by @michaelbeutler
- Datasource is now working by @simylein
- Update truvami-siren version to 0.1.2 and add to truvami-stack dependencies by @michaelbeutler
- Bump truvami-siren version to 0.1.3 and update related configurations by @michaelbeutler
- Bump truvami-siren version to 0.1.4 and update dependencies in truvami-stack by @michaelbeutler
- Bump truvami-siren version to 0.1.5 and update dependencies in truvami-stack by @michaelbeutler
- Bump truvami-siren version to 0.1.6 and update dependencies in truvami-stack by @michaelbeutler
- Forgot donut diagram colors by @simylein
- Bump chart version to 0.1.103 and update dependencies for truvami-stack by @michaelbeutler
- Update truvami-decoder version to 0.0.8 and appVersion to 0.1.14-rc2-alpine; bump truvami-stack version to 0.1.105 by @michaelbeutler
- Correct dashboard ID and update version to 5 by @michaelbeutler
- Spelling and aligning by @simylein
- Use proper buffer level metric by @simylein
- Improve description and summary and average over 2 hours by @simylein
- Update truvami-siren version to 0.1.7 and rename Kafka user by @michaelbeutler
- Bump truvami-monitoring version to 0.1.40 and update storage size configuration by @michaelbeutler
- Bump truvami-monitoring version to 0.1.43 and update truvami-stack version to 0.1.117 by @michaelbeutler
- Format JSON structure and update panel titles in uplinks.json by @michaelbeutler
- Update truvami-monitoring and truvami-stack versions to 0.1.44 and 0.1.118 respectively; adjust panel height in uplinks.json by @michaelbeutler
- Increment version numbers for truvami-monitoring to 0.1.46 and truvami-stack to 0.1.120; clean up namespace selectors in prometheus.yaml by @michaelbeutler
- Update truvami-monitoring version to 0.1.47 and increment chart version to 0.1.121; replace old tgz files by @michaelbeutler
- Update alert descriptions and timeframes for gateway signal strength and quality by @michaelbeutler
- Update alertInstanceLabelFilter to use service and namespace for improved filtering by @michaelbeutler
- Correct regex for version format validation and update error message by @michaelbeutler

### Refactors
- Update Prometheus alert rules for device monitoring, standardize node labels and remove deprecated rules by @michaelbeutler

### New Contributors
* @michaelbeutler made their first contribution
* @niko-kriznik-globtim made their first contribution
* @ made their first contribution
* @StefanSmile made their first contribution
* @simylein made their first contribution

[1.0.1-rc25]: https://github.com/truvami/helm/compare/v1.0.1-rc24...v1.0.1-rc25
[1.0.1-rc24]: https://github.com/truvami/helm/compare/v1.0.1-rc23...v1.0.1-rc24
[1.0.1-rc23]: https://github.com/truvami/helm/compare/v1.0.1-rc22...v1.0.1-rc23
[1.0.1-rc22]: https://github.com/truvami/helm/compare/v1.0.1-rc21...v1.0.1-rc22
[1.0.1-rc21]: https://github.com/truvami/helm/compare/v1.0.1-rc20...v1.0.1-rc21
[1.0.1-rc20]: https://github.com/truvami/helm/compare/v1.0.1-rc19...v1.0.1-rc20
[1.0.1-rc18]: https://github.com/truvami/helm/compare/v1.0.1-rc17...v1.0.1-rc18
[1.0.1-rc17]: https://github.com/truvami/helm/compare/v1.0.1-rc16...v1.0.1-rc17
[1.0.1-rc16]: https://github.com/truvami/helm/compare/v1.0.1-rc15...v1.0.1-rc16
[1.0.1-rc15]: https://github.com/truvami/helm/compare/v1.0.1-rc14...v1.0.1-rc15
[1.0.1-rc12]: https://github.com/truvami/helm/compare/v1.0.1-rc11...v1.0.1-rc12
[1.0.1-rc10]: https://github.com/truvami/helm/compare/v1.0.1-rc9...v1.0.1-rc10
[1.0.1-rc9]: https://github.com/truvami/helm/compare/v1.0.1-rc8...v1.0.1-rc9
[1.0.1-rc8]: https://github.com/truvami/helm/compare/v1.0.1-rc7...v1.0.1-rc8
[1.0.1-rc7]: https://github.com/truvami/helm/compare/v1.0.1-rc6...v1.0.1-rc7
[1.0.1-rc5]: https://github.com/truvami/helm/compare/v1.0.1-rc4...v1.0.1-rc5
[1.0.1-rc4]: https://github.com/truvami/helm/compare/v1.0.1-rc3...v1.0.1-rc4
[1.0.1-rc3]: https://github.com/truvami/helm/compare/v1.0.0-rc2...v1.0.1-rc3
[1.0.0-rc2]: https://github.com/truvami/helm/compare/v1.0.0-rc1...v1.0.0-rc2

<!-- generated by git-cliff -->
