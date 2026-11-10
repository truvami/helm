{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-gateway.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-gateway.fullname" -}}
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
{{- define "truvami-gateway.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-gateway.labels" -}}
helm.sh/chart: {{ include "truvami-gateway.chart" . }}
{{ include "truvami-gateway.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-gateway.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-gateway.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-gateway.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-gateway.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
LTE Cat 1 downlinks need gateway v2.8.0-rc1 or later; older images ignore
gateway.cat1.downlinks and would silently hand out nothing. Tags that are not a
version (a digest or branch build) are accepted as they are.
*/}}
{{- define "truvami-gateway.validateCat1Downlinks" -}}
{{- if dig "cat1" "downlinks" "enabled" false .Values.gateway }}
{{- $tag := .Values.image.tag | default .Chart.AppVersion | toString }}
{{- if and (regexMatch "^v?[0-9]+\\.[0-9]+\\.[0-9]+(-[0-9A-Za-z.-]+)?$" $tag) (not (semverCompare ">=2.8.0-rc1" $tag)) }}
{{- fail (printf "gateway.cat1.downlinks.enabled=true requires gateway v2.8.0-rc1 or later, but the image tag is %q; set image.tag" $tag) }}
{{- end }}
{{- end }}
{{- end }}
