{{- define "common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  replicas: {{ .Values.replicas | default 1 }}
  selector:
    matchLabels:
      {{- include "common.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "common.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: app
          image: "{{ .Values.image.registry }}/{{ .Values.image.name }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ .Values.image.pullPolicy | default "IfNotPresent" }}
          ports:
            - name: http
              containerPort: {{ .Values.service.targetPort | default 8080 }}
          envFrom:
            {{- if .Values.configmap.enabled }}
            - configMapRef:
                name: {{ include "common.fullname" . }}
            {{- end }}
          readinessProbe:
            httpGet:
              path: {{ .Values.health.readinessPath }}
              port: http
            initialDelaySeconds: 10
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: {{ .Values.health.livenessPath }}
              port: http
            initialDelaySeconds: 20
            periodSeconds: 10
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
{{- end -}}
