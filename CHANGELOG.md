# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### CI
- Enhance CI/CD workflows with new jobs
- Enhance CI/CD workflows with new jobs (#49)
- Fix Make targets
- Update go version

### Documentation
- Ran `helm-docs`
- Used v1.14.2 to generate docs
- Run helm-docs
- Update generated READMEs
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Generate README for truvami-coverage chart
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]
- Update CHANGELOG.md [skip ci]

### Features
- Added migrateTimeout to `api`
- Add git-cliff for changelog generation and automate changelog updates
- Add truvami-stream Helm chart
- Added truvami-stream Helm chart (#54)
- Add new seedbox chart
- Add metrics and mcp server support
- Add metrics and mcp server support
- Add metrics and mcp server support
- Simplify topic config with list-based values
- Add new locksmith chart and pdb for all charts
- Add jwks to gateway
- Add rate limit configuration to values
- `--alerts-mode` flag to pod-0
- Update Go version to 1.26 in release workflow
- Bump chart versions for truvami-siren and truvami-stack to 0.4.1 and 0.1.238 respectively
- Bump truvami-siren version to 0.4.2 and update Kafka user permissions
- Add gateway.unauthorized Kafka topic to truvami-gateway chart
- Add gateway.unauthorized Kafka topic (#59)
- Add truvami-coverage Helm chart
- Add bridge.unauthorized Kafka topic to truvami-bridge chart
- Use devices list for participants

### Fixes
- Improve formatting of alert descriptions to show values with two decimal places
- Use new Traxmate counters
- Remove hardcoded dimensions for diagram generation
- Remove diagram optimization step from CI workflow
- Add missing public url
- Correct tile-server image name and bump appVersion to v0.4.0
- Add competition.enabled flag to tiler TOML config

### Refactors
- Address review comments

## [1.0.1-rc27] - 2025-11-20

### Fixes
- Update repository paths to local file references and correct monitoring version

## [1.0.1-rc25] - 2025-11-20

### Features
- Added new alerts

### Refactors
- Use redis instead of valkey dashboard

## [1.0.1-rc24] - 2025-11-19

### Documentation
- Updated docs

### Features
- Update Valkey deployment

### Fixes
- Truvami-monitoring version

## [1.0.1-rc23] - 2025-11-06

### Features
- Update truvami-monitoring chart to version 0.2.0 with enhanced AlertManager configurations and new example setups

## [1.0.1-rc22] - 2025-11-05

### Fixes
- Update device dashboard layout and replace alerts pie chart with service logs panel
- Update truvami-monitoring chart version to 0.1.92 and enable signal quality alerts

### Refactors
- Remove logs sections from service dashboards and delete uplinks pricing dashboard

## [1.0.1-rc21] - 2025-10-28

### Fixes
- Update KafkaUser resource name to match release name
- Bump truvami-siren and truvami-stack chart versions to 0.2.10 and 0.1.221 respectively

## [1.0.1-rc20] - 2025-10-28

### Fixes
- Update KAFKA_GROUP_ID environment variable to remove quotes around value

## [1.0.1-rc18] - 2025-10-28

### Features
- Bump truvami-dashboard version to 1.0.11 and update truvami-stack to use the new version

## [1.0.1-rc17] - 2025-10-28

### Features
- Update truvami-dashboard to version 1.0.10 and enhance secret management for Better Auth and Keycloak

## [1.0.1-rc16] - 2025-10-28

### Features
- Update Helm chart to version 0.1.3 and enhance secret management for Better Auth and Keycloak
- Bump chart version to 0.1.216 and update truvami-docs dependency to 0.1.3

## [1.0.1-rc15] - 2025-10-28

### Features
- Add new quality dashboard (first draft)
- Enhance alert configuration and monitoring rules for various services

## [1.0.1-rc12] - 2025-10-22

### Features
- Added logs panel to service dashboards
- Add PostgreSQL connection pooler configuration and update related templates

## [1.0.1-rc10] - 2025-10-21

### Features
- Add enableRemoteWriteReceiver option to values.yaml

## [1.0.1-rc9] - 2025-10-20

### Features
- Add truvami-docs chart

## [1.0.1-rc8] - 2025-10-17

### Features
- Add uplinks pricing dashboard with comprehensive metrics and visualizations

## [1.0.1-rc7] - 2025-10-15

### Features
- Add migration network policy and update migration job labels
- Update gateway monitoring panels to reflect LoRaWAN metrics

## [1.0.1-rc5] - 2025-10-15

### Features
- Added support for service monitor

## [1.0.1-rc4] - 2025-10-15

### Features
- Enhance device dashboard with comprehensive monitoring and fix panel issues

## [1.0.1-rc3] - 2025-10-15

### Features
- Add service dashboard for truvami-siren

## [1.0.0-rc2] - 2025-10-15

### Features
- Integrate conventional commits with helm chart releaser

## [1.0.0-rc1] - 2025-10-15

### Features
- Add ports timeline and device donut
- Add donut charts for decode errors
- Add battery chart
- Add decoder warnings charts
- Initial Helm chart setup with templates and configuration
- Pin spreading factors to colors
- With aws and loracloud solving rates
- Enable pod monitoring in PostgreSQL configuration
- Add missing uplink sequence chart
- Add buffer level by devices chart
- Update PostgreSQL configuration and resource limits
- Update truvami-monitoring to version 0.1.34 and bump truvami-stack to version 0.1.108
- Update RSSI expressions and adjust panel configurations
- Bump truvami-monitoring to version 0.1.35 and update dependencies in truvami-stack
- Bump truvami-monitoring to version 0.1.36 and update truvami-stack to version 0.1.110
- Update truvami-monitoring to version 0.1.36 and replace previous tgz file
- Bump truvami-monitoring to version 0.1.37 and update dependencies in truvami-stack
- Add alerting rule for aws position estimation
- Add two stage rules to detect offline devices
- Filter by customers and repair decoder graphs
- Add resource requests and limits configuration to values.yaml
- Display ttf pdop and satellites per device per customer
- Add 'No captured at' panel to bridge dashboard
- Color bridge errors red on dashboard
- Add ArgoCD hooks to ensure migrations run first
- Update truvami-api and truvami-monitoring versions to 0.0.21 and 0.1.50 respectively
- Bump chart version to 0.1.143 and update dependencies
- Add Redis monitoring dashboard and update dependencies
- Update truvami-siren chart to version 0.2.0 with StatefulSet support and environment variable configuration
- Enhance siren-config with improved environment setup and StatefulSet configuration
- Add Kafka Exporter dashboard and enhance Prometheus rules with dynamic alert labels
- Enhance dashboards with namespace and cluster filtering for Prometheus queries
- Update chart versions for truvami-monitoring to 0.1.58 and truvami-siren to 0.2.1
- Bump chart versions for truvami-monitoring to 0.1.59 and truvami-stack to 0.1.167; update PrometheusRule alert labels
- Update truvami-siren to version 0.2.2; modify statefulset configuration and add config items
- Bump truvami-siren and truvami-stack versions to 0.2.3 and 0.1.169 respectively; update Chart.lock and service configuration
- Bump truvami-siren version to 0.2.4; update Chart.lock and Chart.yaml
- Update severity level for Kafka consumer alerts; change from warning to major
- Bump truvami-siren version to 0.2.5; update Chart.lock and Chart.yaml
- Bump truvami-monitoring and truvami-siren versions to 0.1.60 and 0.2.6 respectively; update Chart.lock and Chart.yaml
- Add new Prometheus alert rules for consumer processing, device health, and service monitoring; update existing rules with severity adjustments
- Bump truvami-monitoring and truvami-stack versions to 0.1.61 and 0.1.173 respectively; update Chart.lock and Chart.yaml
- Add new Prometheus alert rules for position estimation, device health, gateway network, Kafka consumer, and WiFi solver error rates; adjust severity levels and descriptions
- Add Prometheus alert rules for database errors, gRPC validation, device errors, and security; set severity levels and descriptions
- Add new Prometheus alert rules for Siren service, including device health, Kafka consumer, performance, and schema validation; enhance existing rules with detailed descriptions and severity levels
- Add Prometheus alert rules for watchdog, Kafka consumer, decoder errors, and WiFi solver; enhance alert configurations with severity levels, descriptions, and new rules
- Add Prometheus alert rules for Kafka and Valkey clusters; include critical alerts for broker availability, consumer lag, and instance health with detailed descriptions and severity levels
- Update truvami-monitoring and truvami-stack chart versions to 0.1.62 and 0.1.174 respectively; include new package files
- Update Prometheus alert rules for Truvami API, Gateway, and Siren Kafka consumer; enhance descriptions, severity levels, and thresholds
- Update truvami-monitoring and truvami-stack chart versions to 0.1.63 and 0.1.175 respectively; include new package files
- Update Prometheus alert rules for device health and Siren Kafka consumer; enhance descriptions and thresholds for battery levels and message consumption
- Update truvami-monitoring and truvami-stack chart versions to 0.1.64 and 0.1.176 respectively
- Update truvami-monitoring and truvami-stack chart versions to 0.1.65 and 0.1.177 respectively; include new package files
- Add Truvami Alert Overview dashboard with detailed alert metrics and visualizations
- Enhance Valkey Cache Monitoring Dashboard and add Postgres ServiceMonitor
- Update Valkey and Gateway alert rules for improved clarity and consistency
- Refactor alertmanager configuration for improved routing and notification clarity
- Bump truvami-monitoring and truvami-stack chart versions to 0.1.66 and 0.1.178 respectively
- Add PostgreSQL support with managed and external configurations in Truvami Dashboard
- Bump chart version to 0.0.17 for truvami-dashboard
- Bump chart versions for truvami-monitoring and truvami-dashboard to 0.1.67 and 0.0.17 respectively
- Upgrade truvami-dashboard to version 1.0.0 with Better Auth integration and PostgreSQL support
- Update truvami-dashboard to version 1.0.1 with migration job and resource limits
- Bump truvami-dashboard and truvami-stack versions to 1.0.2 and 0.1.181 respectively, update migration job configuration
- Bump truvami-dashboard and truvami-stack versions to 1.0.3 and 0.1.182 respectively, update database secret references and migration job configuration
- Bump truvami-dashboard and truvami-stack versions to 1.0.4 and 0.1.183 respectively, update database name in deployment and migration configurations
- Bump truvami-dashboard and truvami-stack versions to 1.0.5 and 0.1.184 respectively, add NODE_ENV to secret configuration
- Bump truvami-dashboard and truvami-stack versions to 1.0.6 and 0.1.185 respectively, update NODE_ENV encoding in secret configuration
- Update gateway RSSI and SNR alert rules to improve monitoring accuracy
- Enhance Kafka integration alert rules for consumer lag and blockage detection
- Bump truvami-monitoring and truvami-stack versions to 0.1.68 and 0.1.186 respectively, update Chart.lock and add new tgz files
- Refactor Alertmanager configuration to use AlertmanagerConfig API and simplify routing rules
- Bump truvami-monitoring and truvami-stack versions to 0.1.69 and 0.1.187 respectively, update Chart.lock and add new tgz files
- Enhance alert summaries and descriptions for decoder errors, device offline, gateway network, and service health rules
- Bump truvami-monitoring and truvami-stack versions to 0.1.70 and 0.1.188 respectively
- Enhance alert descriptions and summaries for various monitoring rules to improve clarity and actionability
- Add Prometheus alert rules for deployment version monitoring and handling
- Bump truvami-monitoring and truvami-stack versions to 0.1.71 and 0.1.189 respectively, update Chart.lock and add new tgz files
- Simplify Prometheus alert expressions for deployment version monitoring
- Added migration env
- Add alert for devices transmitting on multiple LoRa networks
- Bump truvami-monitoring and truvami-stack versions to 0.1.74 and 0.1.192 respectively, update Chart.lock and dashboards' UIDs
- Update Prometheus rules to include node labels and adjust service names for better monitoring clarity
- Add podMonitorSelector to Prometheus spec for enhanced monitoring configuration
- Bump truvami-monitoring and truvami-stack versions to 0.1.75 and 0.1.193 respectively, update Chart.lock and fix service monitor selector
- Update Prometheus alert rules for device monitoring and Kafka integration, enhancing alert descriptions and node labels
- Add Prometheus alert rules for Truvami Go runtime metrics and service-specific monitoring
- Enhance alerting and dashboard configurations
- Add new dashboards for Truvami services and overview
- Update CI workflows to install kube-score and helm-docs with versioning
- Specify kube-score version in CI workflow installation

### Fixes
- Donut charts display the sum over the whole timespan
- Respect spreading factor filters in charts
- Donut charts now display total amounts
- Decode errors only show when greater than zero
- Update AWS Position Estimates and Bridge Service configurations
- Update truvami-monitoring version to 0.1.25 and adjust dependencies
- Increment chart version to 0.1.92
- Datasource is now working
- Update truvami-siren version to 0.1.2 and add to truvami-stack dependencies
- Bump truvami-siren version to 0.1.3 and update related configurations
- Bump truvami-siren version to 0.1.4 and update dependencies in truvami-stack
- Bump truvami-siren version to 0.1.5 and update dependencies in truvami-stack
- Bump truvami-siren version to 0.1.6 and update dependencies in truvami-stack
- Forgot donut diagram colors
- Bump chart version to 0.1.103 and update dependencies for truvami-stack
- Update truvami-decoder version to 0.0.8 and appVersion to 0.1.14-rc2-alpine; bump truvami-stack version to 0.1.105
- Correct dashboard ID and update version to 5
- Spelling and aligning
- Use proper buffer level metric
- Improve description and summary and average over 2 hours
- Update truvami-siren version to 0.1.7 and rename Kafka user
- Bump truvami-monitoring version to 0.1.40 and update storage size configuration
- Bump truvami-monitoring version to 0.1.43 and update truvami-stack version to 0.1.117
- Format JSON structure and update panel titles in uplinks.json
- Update truvami-monitoring and truvami-stack versions to 0.1.44 and 0.1.118 respectively; adjust panel height in uplinks.json
- Increment version numbers for truvami-monitoring to 0.1.46 and truvami-stack to 0.1.120; clean up namespace selectors in prometheus.yaml
- Update truvami-monitoring version to 0.1.47 and increment chart version to 0.1.121; replace old tgz files
- Update alert descriptions and timeframes for gateway signal strength and quality
- Update alertInstanceLabelFilter to use service and namespace for improved filtering
- Correct regex for version format validation and update error message

### Refactors
- Update Prometheus alert rules for device monitoring, standardize node labels and remove deprecated rules

[unreleased]: https://github.com/truvami/helm/compare/v1.0.1-rc27...HEAD
[1.0.1-rc27]: https://github.com/truvami/helm/compare/v1.0.1-rc26...v1.0.1-rc27
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
