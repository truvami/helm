{{/*
Expand the name of the chart.
*/}}
{{- define "truvami-pulse.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "truvami-pulse.fullname" -}}
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
{{- define "truvami-pulse.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "truvami-pulse.labels" -}}
helm.sh/chart: {{ include "truvami-pulse.chart" . }}
{{ include "truvami-pulse.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "truvami-pulse.selectorLabels" -}}
app.kubernetes.io/name: {{ include "truvami-pulse.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "truvami-pulse.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "truvami-pulse.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
gRPC container port, derived from pulse.grpc.listen.address (e.g. ":5002").
*/}}
{{- define "truvami-pulse.grpcPort" -}}
{{- $address := default ":5002" .Values.pulse.grpc.listen.address -}}
{{- $port := splitList ":" $address | last -}}
{{- if not (regexMatch "^[0-9]+$" $port) -}}
{{- fail (printf "pulse.grpc.listen.address %q must end in a numeric port" $address) -}}
{{- end -}}
{{- $port -}}
{{- end }}

{{/*
Is the ThingPark downlink sender configured? Pulse builds it only when
grpc.locksmith.address is set; without it DownlinkService is not registered and
a worker-enabled process refuses to start.
*/}}
{{- define "truvami-pulse.downlinkEnabled" -}}
{{- if trim (default "" .Values.pulse.grpc.locksmith.address) -}}true{{- end -}}
{{- end }}

{{/*
Guardrails that turn pulse startup failures into template failures.

Pulse keeps active campaign UUIDs in memory and its ThingPark downlink limiter
is process-local, while ThingPark aggregates the DL_IMPACT limit by source IP.
Running more than one worker-enabled replica therefore multiplies the effective
downlink rate and splits campaign state across pods.
*/}}
{{- define "truvami-pulse.validateWorker" -}}
{{- $downlink := include "truvami-pulse.downlinkEnabled" . -}}
{{- if $downlink }}
{{- if not (index (index .Values.pulse.downlink "thingpark" | default dict) "allowed-hosts") }}
{{- fail "pulse.grpc.locksmith.address is set but pulse.downlink.thingpark.allowed-hosts is empty; pulse refuses to start without at least one allowed ThingPark host" }}
{{- end }}
{{- end }}
{{- if .Values.pulse.worker.enabled }}
{{- if not $downlink }}
{{- fail "pulse.worker.enabled=true requires pulse.grpc.locksmith.address to be set; without it the downlink sender is not configured" }}
{{- end }}
{{- if not (trim (default "" .Values.pulse.grpc.api.address)) }}
{{- fail "pulse.worker.enabled=true requires pulse.grpc.api.address to be set" }}
{{- end }}
{{- if gt (int .Values.replicaCount) 1 }}
{{- fail "pulse.worker.enabled=true requires replicaCount=1; pulse cannot coordinate campaign state or downlink rate limits across replicas" }}
{{- end }}
{{- if .Values.autoscaling.enabled }}
{{- fail "pulse.worker.enabled=true is incompatible with autoscaling.enabled=true; pulse cannot coordinate campaign state or downlink rate limits across replicas" }}
{{- end }}
{{- end }}
{{- end }}
