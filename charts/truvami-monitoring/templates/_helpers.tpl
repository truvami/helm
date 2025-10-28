{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-monitoring.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-monitoring.fullname" -}}
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
{{- define "truvami-monitoring.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-monitoring.labels" -}}
helm.sh/chart: {{ include "truvami-monitoring.chart" . }}
{{ include "truvami-monitoring.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-monitoring.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-monitoring.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-monitoring.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-monitoring.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Alert configuration helper - checks if an alert group is enabled
*/}}
{{- define "truvami-monitoring.alertEnabled" -}}
{{- $alertPath := .alertPath }}
{{- $values := .values }}
{{- $enabled := true }}
{{- range $part := (split "." $alertPath) }}
{{- if hasKey $values $part }}
{{- $values = index $values $part }}
{{- else }}
{{- $enabled = false }}
{{- break }}
{{- end }}
{{- end }}
{{- if and $enabled (hasKey $values "enabled") }}
{{- $values.enabled }}
{{- else }}
{{- false }}
{{- end }}
{{- end }}

{{/*
Alert configuration helper - gets alert configuration value with fallback
*/}}
{{- define "truvami-monitoring.alertConfig" -}}
{{- $alertPath := .alertPath }}
{{- $configKey := .configKey }}
{{- $default := .default }}
{{- $values := .values }}
{{- $config := $values }}
{{- range $part := (split "." $alertPath) }}
{{- if hasKey $config $part }}
{{- $config = index $config $part }}
{{- else }}
{{- $config = dict }}
{{- break }}
{{- end }}
{{- end }}
{{- if hasKey $config $configKey }}
{{- index $config $configKey }}
{{- else }}
{{- $default }}
{{- end }}
{{- end }}
