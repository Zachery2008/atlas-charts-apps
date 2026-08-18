{{- define "common.service" -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.fullname" . }}
  labels:
    {{- include "common.labels" . | nindent 4 }}
  {{- $anns := include "common.serviceAnnotations" . | fromYaml }}
  {{- if $anns }}
  annotations:
    {{- toYaml $anns | nindent 4 }}
  {{- end }}
spec:
  type: {{ include "common.serviceType" . }}
  {{- if eq (include "common.serviceType" .) "LoadBalancer" }}
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
