{{- define "common.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- with .Values.service.annotations }}
  annotations:
    {{- toYaml . | nindent 4 }}
  {{- end }}
spec:
  type: {{ .Values.service.type }}
  {{- if eq .Values.service.type "LoadBalancer" }}
  {{- if .Values.service.loadBalancerClass }}
  loadBalancerClass: {{ .Values.service.loadBalancerClass | quote }}
  {{- end }}
  {{- end }}
  selector:
    {{- include "common.selectorLabels" . | nindent 4 }}
  ports:
    - name: http
      port: {{ .Values.service.port }}
      targetPort: http
      protocol: TCP
{{- end -}}
