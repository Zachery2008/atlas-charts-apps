{{- define "common.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
spec:
  replicas: {{ include "common.replicas" . }}
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
          image: "{{ include "common.imageRegistry" . }}/{{ .Values.image.name }}:{{ .Values.image.tag }}"
          imagePullPolicy: {{ include "common.imagePullPolicy" . }}
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
            {{- include "common.resources" . | nindent 12 }}
{{- end -}}
