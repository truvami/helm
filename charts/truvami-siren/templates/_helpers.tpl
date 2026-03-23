{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-siren.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-siren.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "truvami-siren.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-siren.labels" -}}
helm.sh/chart: {{ include "truvami-siren.chart" . }}
{{ include "truvami-siren.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-siren.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-siren.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-siren.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-siren.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Render truvami-siren container args.
Parameters:
  - component: statefulset component label (default|retry)
  - alertsMode: optional kafka alerts mode override
*/}}
{{- define "truvami-siren.containerArgs" -}}
- /usr/bin/truvami-siren
- --config
- /etc/truvami-siren/config.yaml
{{- if .alertsMode }}
- --alerts-mode
- {{ .alertsMode }}
{{- else }}
{{- if eq .component "retry" }}
- --alerts-mode
- retry
{{- end }}
{{- end }}
{{- end }}

{{/*
Render shared truvami-siren container spec for StatefulSets.
Parameters:
  - root: chart root context
  - component: statefulset component label (default|retry)
  - retryGroupID: retry consumer group id
  - alertsMode: optional kafka alerts mode override
  - enableDeviceInactiveEvaluation: optional env override
*/}}
{{- define "truvami-siren.containerSpec" -}}
{{- $root := .root -}}
- name: {{ $root.Chart.Name }}
  # Run the wrapper script, forward args to the binary
  command:
    - /bin/bash
    - /etc/truvami-siren/set-env.sh
  args:
{{ include "truvami-siren.containerArgs" (dict "component" .component "alertsMode" .alertsMode) | nindent 4 }}
  securityContext:
    {{- toYaml $root.Values.securityContext | nindent 4 }}
  image: "{{ $root.Values.image.repository }}:{{ $root.Values.image.tag | default $root.Chart.AppVersion }}"
  imagePullPolicy: {{ $root.Values.image.pullPolicy }}
  ports:
    - name: http
      containerPort: {{ $root.Values.service.port }}
      protocol: TCP
    - name: metrics
      containerPort: 9090
      protocol: TCP
  livenessProbe:
    {{- toYaml $root.Values.livenessProbe | nindent 4 }}
  readinessProbe:
    {{- toYaml $root.Values.readinessProbe | nindent 4 }}
  resources:
    {{- toYaml $root.Values.resources | nindent 4 }}
  env:
    - name: KAFKA_GROUP_ID
      value: {{ $root.Release.Name | quote }}
    - name: KAFKA_RETRY_GROUP_ID
      value: {{ .retryGroupID | quote }}
    {{- if or .enableDeviceInactiveEvaluation (eq .component "retry") }}
    - name: ENABLE_DEVICE_INACTIVE_EVALUATION
      value: {{ .enableDeviceInactiveEvaluation | default "false" | quote }}
    {{- end }}
    - name: TRUVAMI_ENVIRONMENT
      value: {{ $root.Values.environment | default "production" | quote }}
    - name: KAFKA_SSL_KEYSTORE_LOCATION
      value: /var/run/secrets/kafka/user.p12
    - name: KAFKA_SSL_KEYSTORE_PASSWORD
      valueFrom:
        secretKeyRef:
          key: user.password
          name: "truvami-siren-kafka"
          optional: false
    - name: KAFKA_SSL_KEY_PASSWORD
      valueFrom:
        secretKeyRef:
          key: user.password
          name: "truvami-siren-kafka"
          optional: false
    - name: VALKEY_PASSWORD
      valueFrom:
        secretKeyRef:
          key: {{ $root.Values.valkey.secretKey }}
          name: {{ $root.Values.valkey.secretName }}
          optional: false
    # Downward API: pod name for ordinal detection in set-env.sh
    - name: POD_NAME
      valueFrom:
        fieldRef:
          fieldPath: metadata.name
    - name: ALERTS_DISPATCHER_WHATSAPP_PHONE_NUMBER_ID
      valueFrom:
        secretKeyRef:
          key: ALERTS_DISPATCHER_WHATSAPP_PHONE_NUMBER_ID
          name: truvami-siren
          optional: false
    - name: ALERTS_DISPATCHER_WHATSAPP_ACCESS_TOKEN
      valueFrom:
        secretKeyRef:
          key: ALERTS_DISPATCHER_WHATSAPP_ACCESS_TOKEN
          name: truvami-siren
          optional: false
  volumeMounts:
    {{- with $root.Values.volumeMounts }}
    {{- toYaml . | nindent 4 }}
    {{- end }}
{{- end }}
