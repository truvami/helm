{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-seedbox.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-seedbox.fullname" -}}
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
{{- define "truvami-seedbox.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-seedbox.labels" -}}
helm.sh/chart: {{ include "truvami-seedbox.chart" . }}
{{ include "truvami-seedbox.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-seedbox.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-seedbox.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-seedbox.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-seedbox.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Maps ConfigMap name (created by chart or referenced when maps.existingConfigMap is set).
*/}}
{{- define "truvami-seedbox.mapsConfigMapName" -}}
{{- default (printf "%s-maps" (include "truvami-seedbox.fullname" .)) .Values.maps.existingConfigMap -}}
{{- end }}

{{/*
True when chart-managed customer maps should be mounted.
Supports top-level .Values.maps and nested .Values.seedbox.producer.maps (gitops-friendly).
*/}}
{{- define "truvami-seedbox.mapsEnabled" -}}
{{- $nested := .Values.seedbox.producer.maps | default dict -}}
{{- if or .Values.maps.enabled $nested.enabled $nested.data $nested.files -}}true{{- end -}}
{{- end }}

{{/*
Customer UUID for maps volume paths.
*/}}
{{- define "truvami-seedbox.mapsCustomerUUID" -}}
{{- $nested := .Values.seedbox.producer.maps | default dict -}}
{{- required "maps customer UUID is required (maps.customerUUID or seedbox.producer.maps.customerUUID)" (default .Values.maps.customerUUID $nested.customerUUID) -}}
{{- end }}

{{/*
Mount path for customer maps inside the container.
*/}}
{{- define "truvami-seedbox.mapsMountPath" -}}
{{- $nested := .Values.seedbox.producer.maps | default dict -}}
{{- default .Values.maps.mountPath $nested.path | default "/maps" -}}
{{- end }}

{{/*
Volume items mounting each map file under maps.customerUUID/<filename>.
*/}}
{{- define "truvami-seedbox.mapsVolumeItems" -}}
{{- $customerUUID := include "truvami-seedbox.mapsCustomerUUID" . -}}
{{- $nested := .Values.seedbox.producer.maps | default dict -}}
{{- $mapsData := .Values.maps.data -}}
{{- if $nested.files -}}
{{- $mapsData = $nested.files -}}
{{- else if $nested.data -}}
{{- $mapsData = $nested.data -}}
{{- end -}}
{{- if $mapsData -}}
{{- range $key, $_ := $mapsData }}
- key: {{ $key }}
  path: {{ $customerUUID }}/{{ $key }}
{{- end }}
{{- else -}}
{{- range $path, $_ := .Files.Glob (printf "demo-maps/%s/*" $customerUUID) }}
- key: {{ base $path }}
  path: {{ $customerUUID }}/{{ base $path }}
{{- end }}
{{- end }}
{{- end }}
