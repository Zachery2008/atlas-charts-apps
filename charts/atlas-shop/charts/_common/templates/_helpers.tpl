{{- define "common.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := include "common.name" . -}}
{{- printf "%s" $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{- define "common.selectorLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}

{{- define "common.imageRegistry" -}}
{{- coalesce .Values.image.registry ((.Values.global).image).registry "atlas.azurecr.io" -}}
{{- end -}}

{{- define "common.imagePullPolicy" -}}
{{- coalesce .Values.image.pullPolicy ((.Values.global).image).pullPolicy "IfNotPresent" -}}
{{- end -}}

{{- define "common.replicas" -}}
{{- if kindIs "invalid" .Values.replicas -}}
{{- coalesce ((.Values.global).replicas) 1 -}}
{{- else -}}
{{- .Values.replicas -}}
{{- end -}}
{{- end -}}

{{- define "common.resources" -}}
{{- $out := dict -}}
{{- if and .Values.global .Values.global.resources -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.global.resources) -}}
{{- end -}}
{{- if .Values.resources -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.resources) -}}
{{- end -}}
{{- $out | toYaml -}}
{{- end -}}

{{- define "common.configurations" -}}
{{- $out := dict -}}
{{- if and .Values.global .Values.global.configurations -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.global.configurations) -}}
{{- end -}}
{{- if .Values.configurations -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.configurations) -}}
{{- end -}}
{{- $out | toYaml -}}
{{- end -}}

{{- define "common.serviceType" -}}
{{- coalesce .Values.service.type ((.Values.global).service).type "ClusterIP" -}}
{{- end -}}

{{- define "common.serviceAnnotations" -}}
{{- $out := dict -}}
{{- if and .Values.global .Values.global.service .Values.global.service.annotations -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.global.service.annotations) -}}
{{- end -}}
{{- if .Values.service.annotations -}}
{{- $out = mergeOverwrite $out (deepCopy .Values.service.annotations) -}}
{{- end -}}
{{- $out | toYaml -}}
{{- end -}}
