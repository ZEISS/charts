{{/*
Common labels applied to every resource rendered by this chart.
*/}}
{{- define "agentgateway-platform.labels" -}}
app.kubernetes.io/part-of: zap-agent-platform
app.kubernetes.io/managed-by: {{ .Release.Service }}
helm.sh/chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
{{- end -}}
