{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-locksmith.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-locksmith.fullname" -}}
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
{{- define "truvami-locksmith.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-locksmith.labels" -}}
helm.sh/chart: {{ include "truvami-locksmith.chart" . }}
{{ include "truvami-locksmith.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-locksmith.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-locksmith.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-locksmith.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-locksmith.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Database environment variables
Supports three modes:
1. postgres.enabled=true: uses CNPG auto-generated secret and pooler
2. database.host set: constructs URI from host/port/name with secret credentials
3. fallback: uses full URI from secret
*/}}
{{- define "truvami-locksmith.databaseEnv" -}}
{{- if .Values.postgres.enabled }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-locksmith-db-app
      key: password
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Release.Name }}-locksmith-db-app
      key: username
- name: TRUVAMI_LOCKSMITH_DATABASE_URI
  value: "postgresql://$(DB_USER):$(DB_PASSWORD)@{{ .Release.Name }}-locksmith-db-pooler:5432/app?sslmode=require"
{{- else if .Values.database.host }}
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.secretName }}
      key: password
- name: DB_USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.database.secretName }}
      key: username
- name: TRUVAMI_LOCKSMITH_DATABASE_URI
  value: "postgresql://$(DB_USER):$(DB_PASSWORD)@{{ .Values.database.host }}:{{ .Values.database.port }}/{{ .Values.database.name }}?sslmode=require"
{{- else }}
- name: TRUVAMI_LOCKSMITH_DATABASE_URI
  valueFrom:
    secretKeyRef:
      key: {{ .Values.database.secretKey }}
      name: {{ .Values.database.secretName }}
      optional: false
{{- end }}
{{- end }}
