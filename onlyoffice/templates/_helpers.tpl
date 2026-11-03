{{- define "onlyoffice.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "onlyoffice.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name (include "onlyoffice.name" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{- define "onlyoffice.jwtSecretName" -}}
{{- if .Values.jwt.existingSecret -}}
{{- .Values.jwt.existingSecret -}}
{{- else -}}
{{- printf "%s-jwt" (include "onlyoffice.fullname" .) -}}
{{- end -}}
{{- end -}}
