{{/* vim: set filetype=mustache: */}}

{{/*
Return the proper ES image name
*/}}
{{- define "opensearch.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}


{{/*
Create a default fully qualified cluster_manager name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.cluster_manager.fullname" -}}
{{- if .Values.cluster_manager.fullnameOverride -}}
{{- .Values.cluster_manager.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-cluster-manager" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.ingest.fullname" -}}
{{- if .Values.ingest.fullnameOverride -}}
{{- .Values.ingest.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-ingest" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.coordinating.fullname" -}}
{{- if .Values.coordinating.fullnameOverride -}}
{{- .Values.coordinating.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-coordinating" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.data.fullname" -}}
{{- if .Values.data.fullnameOverride -}}
{{- .Values.data.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-data" (include "common.names.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one cluster_manager-elegible node replica has been configured.
*/}}
{{- define "opensearch.cluster_manager.enabled" -}}
{{- if or .Values.cluster_manager.autoscaling.enabled (gt (int .Values.cluster_manager.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one coordinating-only node replica has been configured.
*/}}
{{- define "opensearch.coordinating.enabled" -}}
{{- if or .Values.coordinating.autoscaling.enabled (gt (int .Values.coordinating.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one data-only node replica has been configured.
*/}}
{{- define "opensearch.data.enabled" -}}
{{- if or .Values.data.autoscaling.enabled (gt (int .Values.data.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least one ingest-only node replica has been configured.
*/}}
{{- define "opensearch.ingest.enabled" -}}
{{- if or .Values.ingest.autoscaling.enabled (gt (int .Values.ingest.replicaCount) 0) -}}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the hostname of every ElasticSearch seed node
*/}}
{{- define "opensearch.hosts" -}}
{{- $clusterDomain := .Values.clusterDomain }}
{{- $releaseNamespace := .Release.Namespace }}
{{- $clusterManagerFullname := include "opensearch.cluster_manager.fullname" . }}
{{- $coordinatingFullname := include "opensearch.coordinating.fullname" . }}
{{- $dataFullname := include "opensearch.data.fullname" . }}
{{- $ingestFullname := include "opensearch.ingest.fullname" . }}
{{- $clusterManagerFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- $coordinatingFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- $dataFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- if .Values.ingest.enabled }}
{{- $ingestFullname }}.{{ $releaseNamespace }}.svc.{{ $clusterDomain }},
{{- end -}}
{{- end -}}

{{/*
 Create the name of the cluster_manager service account to use
 */}}
{{- define "opensearch.cluster_manager.serviceAccountName" -}}
{{- if .Values.cluster_manager.serviceAccount.create -}}
    {{ default (include "opensearch.cluster_manager.fullname" .) .Values.cluster_manager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.cluster_manager.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the coordinating service account to use
 */}}
{{- define "opensearch.coordinating.serviceAccountName" -}}
{{- if .Values.coordinating.serviceAccount.create -}}
    {{ default (include "opensearch.coordinating.fullname" .) .Values.coordinating.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinating.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the data service account to use
 */}}
{{- define "opensearch.data.serviceAccountName" -}}
{{- if .Values.data.serviceAccount.create -}}
    {{ default (include "opensearch.data.fullname" .) .Values.data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the ingest service account to use
 */}}
{{- define "opensearch.ingest.serviceAccountName" -}}
{{- if .Values.ingest.serviceAccount.create -}}
    {{ default (include "opensearch.ingest.fullname" .) .Values.ingest.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.ingest.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "opensearch.metrics.fullname" -}}
{{- $name := default "metrics" .Values.metrics.nameOverride -}}
{{- if .Values.metrics.fullnameOverride -}}
{{- .Values.metrics.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.names.fullname" .) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{/*
Return the proper sysctl image name
*/}}
{{- define "opensearch.sysctl.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.sysctlImage "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "opensearch.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.image .Values.sysctlImage .Values.volumePermissions.image) "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "opensearch.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
Usage:
{{ include "opensearch.storageClass" (dict "global" .Values.global "local" .Values.cluster_manager) }}
*/}}
{{- define "opensearch.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .global -}}
    {{- if .global.storageClass -}}
        {{- if (eq "-" .global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .local.persistence.storageClass -}}
              {{- if (eq "-" .local.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .local.persistence.storageClass -}}
        {{- if (eq "-" .local.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .local.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for cronjob APIs.
*/}}
{{- define "cronjob.apiVersion" -}}
{{- if semverCompare "< 1.8-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v2alpha1" }}
{{- else if and (semverCompare ">=1.8-0" .Capabilities.KubeVersion.GitVersion) (semverCompare "< 1.21-0" .Capabilities.KubeVersion.GitVersion) -}}
{{- print "batch/v1beta1" }}
{{- else if semverCompare ">=1.21-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "batch/v1" }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "opensearch.securityadmin.fullname" -}}
{{- printf "%s-%s" (include "common.names.fullname" .) .Values.securityadmin.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "opensearch.securityadmin.serviceAccountName" -}}
{{- if .Values.securityadmin.serviceAccount.create -}}
    {{ default (include "opensearch.securityadmin.fullname" .) .Values.securityadmin.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.securityadmin.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper Opensearch securityadmin image name
*/}}
{{- define "opensearch.securityadmin.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.securityadmin.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for cluster_manager nodes.
*/}}
{{- define "opensearch.cluster_manager.http.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.http.cluster_manager.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-http-crt" (include "opensearch.cluster_manager.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for data nodes.
*/}}
{{- define "opensearch.data.http.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.http.data.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-http-crt" (include "opensearch.data.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for ingest nodes.
*/}}
{{- define "opensearch.ingest.http.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.http.ingest.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-http-crt" (include "opensearch.ingest.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for coordinating nodes.
*/}}
{{- define "opensearch.coordinating.http.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.http.coordinating.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-http-crt" (include "opensearch.coordinating.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "opensearch.http.createTlsSecret" -}}
{{- if and .Values.security.tls.http.autoGenerated (not (include "opensearch.security.http.tlsSecretsProvided" .)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for cluster_manager nodes.
*/}}
{{- define "opensearch.cluster_manager.transport.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.transport.cluster_manager.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-transport-crt" (include "opensearch.cluster_manager.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for data nodes.
*/}}
{{- define "opensearch.data.transport.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.transport.data.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-transport-crt" (include "opensearch.data.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for ingest nodes.
*/}}
{{- define "opensearch.ingest.transport.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.transport.ingest.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-transport-crt" (include "opensearch.ingest.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the opensearch TLS credentials secret for coordinating nodes.
*/}}
{{- define "opensearch.coordinating.transport.tlsSecretName" -}}
{{- $secretName := .Values.security.tls.transport.coordinating.existingSecret -}}
{{- if $secretName -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-transport-crt" (include "opensearch.coordinating.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a TLS credentials secret object should be created
*/}}
{{- define "opensearch.transport.createTlsSecret" -}}
{{- if and .Values.security.tls.transport.autoGenerated (not (include "opensearch.security.transport.tlsSecretsProvided" .)) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return true if an authentication credentials secret object should be created
*/}}
{{- define "opensearch.createSecret" -}}
{{- if not .Values.security.existingSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Opensearch authentication credentials secret name
*/}}
{{- define "opensearch.secretName" -}}
{{- coalesce .Values.security.existingSecret (include "common.names.fullname" .) -}}
{{- end -}}

{{/*
Return the Opensearch S3 credentials secret name
*/}}
{{- define "opensearch.s3Snapshots.secretName" -}}
{{- if .Values.s3Snapshots.config.s3.client.default.existingSecret -}}
{{- $secretName := .Values.s3Snapshots.config.s3.client.default.existingSecret -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-s3" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a S3 credentials secret object should be created
*/}}
{{- define "opensearch.s3Snapshots.createSecret" -}}
{{- if not .Values.s3Snapshots.config.s3.client.default.existingSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Opensearch keystore secret name
*/}}
{{- define "opensearch.extraSecretsKeystore.secretName" -}}
{{- if .Values.extraSecretsKeystore.existingSecret -}}
{{- $secretName := .Values.extraSecretsKeystore.existingSecret -}}
    {{- printf "%s" (tpl $secretName $) -}}
{{- else -}}
    {{- printf "%s-keystore" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return true if a keystore secret object should be created
*/}}
{{- define "opensearch.extraSecretsKeystore.createSecret" -}}
{{- if not .Values.extraSecretsKeystore.existingSecret }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/*
Return the Opensearch authentication credentials secret name
*/}}
{{- define "opensearch.security.http.issuerName" -}}
{{- $issuerName := .Values.security.tls.http.issuerRef.existingIssuerName -}}
{{- if $issuerName -}}
    {{- printf "%s" (tpl $issuerName $) -}}
{{- else -}}
    {{- printf "%s-http" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Return the Opensearch authentication credentials secret name
*/}}
{{- define "opensearch.security.transport.issuerName" -}}
{{- $issuerName := .Values.security.tls.transport.issuerRef.existingIssuerName -}}
{{- if $issuerName -}}
    {{- printf "%s" (tpl $issuerName $) -}}
{{- else -}}
    {{- printf "%s-transport" (include "common.names.fullname" .) -}}
{{- end -}}
{{- end -}}

{{/*
Returns true if at least 1 existing secret was provided
*/}}
{{- define "opensearch.security.http.tlsSecretsProvided" -}}
{{- $clusterManagerSecret :=.Values.security.tls.http.cluster_manager.existingSecret -}}
{{- $dataSecret :=.Values.security.tls.http.data.existingSecret -}}
{{- $coordSecret :=.Values.security.tls.http.coordinating.existingSecret -}}
{{- $ingestSecret :=.Values.security.tls.http.ingest.existingSecret -}}
{{- $ingestEnabled := .Values.ingest.enabled -}}
{{- if or $clusterManagerSecret $dataSecret $coordSecret (and $ingestEnabled $ingestSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for cluster_manager nodes */}}
{{- define "opensearch.validateValues.security.http.missingTlsSecrets.cluster_manager" -}}
{{- if and (include "opensearch.security.http.tlsSecretsProvided" .) (not .Values.security.tls.http.cluster_manager.existingSecret) -}}
opensearch: security.tls.http.cluster_manager.existingSecret
    Missing secret containing the TLS certificates for the Opensearch cluster_manager nodes.
    Provide the certificates using --set .Values.security.tls.http.cluster_manager.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for data nodes */}}
{{- define "opensearch.validateValues.security.http.missingTlsSecrets.data" -}}
{{- if and (include "opensearch.security.http.tlsSecretsProvided" .) (not .Values.security.tls.http.data.existingSecret) -}}
opensearch: security.tls.http.data.existingSecret
    Missing secret containing the TLS certificates for the Opensearch data nodes.
    Provide the certificates using --set .Values.security.tls.http.data.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for coordinating nodes */}}
{{- define "opensearch.validateValues.security.http.missingTlsSecrets.coordinating" -}}
{{- if and (include "opensearch.security.http.tlsSecretsProvided" .) (not .Values.security.tls.http.coordinating.existingSecret) -}}
opensearch: security.tls.http.coordinating.existingSecret
    Missing secret containing the TLS certificates for the Opensearch coordinating nodes.
    Provide the certificates using --set .Values.security.tls.http.coordinating.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for ingest nodes */}}
{{- define "opensearch.validateValues.security.http.missingTlsSecrets.ingest" -}}
{{- if and .Values.ingest.enabled (include "opensearch.security.http.tlsSecretsProvided" .) (not .Values.security.tls.http.ingest.existingSecret) -}}
opensearch: security.tls.http.ingest.existingSecret
    Missing secret containing the TLS certificates for the Opensearch ingest nodes.
    Provide the certificates using --set .Values.security.tls.http.ingest.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - TLS enabled but no certificates provided */}}
{{- define "opensearch.validateValues.security.tls.http" -}}
{{- if and (not .Values.security.tls.http.autoGenerated) (not (include "opensearch.security.http.tlsSecretsProvided" .)) -}}
opensearch: security.tls.transport
    In order to enable Security, it is necessary to configure TLS.
    Two different mechanisms can be used:
        - Provide an existing secret containing the TLS certificates for each role
        - Enable using auto-generated cert-manager certificates with `security.tls.http.autoGenerated=true`
    Existing secrets containing PKCS8 PEM certificates can be provided using --set Values.security.tls.http.cluster_manager.existingSecret=cluster-manager-certs,
    --set Values.security.tls.http.data.existingSecret=data-certs, --set Values.security.tls.http.coordinating.existingSecret=coordinating-certs, --set Values.security.tls.http.ingest.existingSecret=ingest-certs
{{- end -}}
{{- end -}}

{{/*
Returns true if at least 1 existing secret was provided
*/}}
{{- define "opensearch.security.transport.tlsSecretsProvided" -}}
{{- $clusterManagerSecret :=.Values.security.tls.transport.cluster_manager.existingSecret -}}
{{- $dataSecret :=.Values.security.tls.transport.data.existingSecret -}}
{{- $coordSecret :=.Values.security.tls.transport.coordinating.existingSecret -}}
{{- $ingestSecret :=.Values.security.tls.transport.ingest.existingSecret -}}
{{- $ingestEnabled := .Values.ingest.enabled -}}
{{- if or $clusterManagerSecret $dataSecret $coordSecret (and $ingestEnabled $ingestSecret) }}
    {{- true -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for cluster_manager nodes */}}
{{- define "opensearch.validateValues.security.transport.missingTlsSecrets.cluster_manager" -}}
{{- if and (include "opensearch.security.transport.tlsSecretsProvided" .) (not .Values.security.tls.transport.cluster_manager.existingSecret) -}}
opensearch: security.tls.transport.cluster_manager.existingSecret
    Missing secret containing the TLS certificates for the Opensearch cluster_manager nodes.
    Provide the certificates using --set .Values.security.tls.transport.cluster_manager.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for data nodes */}}
{{- define "opensearch.validateValues.security.transport.missingTlsSecrets.data" -}}
{{- if and (include "opensearch.security.transport.tlsSecretsProvided" .) (not .Values.security.tls.transport.data.existingSecret) -}}
opensearch: security.tls.transport.data.existingSecret
    Missing secret containing the TLS certificates for the Opensearch data nodes.
    Provide the certificates using --set .Values.security.tls.transport.data.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for coordinating nodes */}}
{{- define "opensearch.validateValues.security.transport.missingTlsSecrets.coordinating" -}}
{{- if and (include "opensearch.security.transport.tlsSecretsProvided" .) (not .Values.security.tls.transport.coordinating.existingSecret) -}}
opensearch: security.tls.transport.coordinating.existingSecret
    Missing secret containing the TLS certificates for the Opensearch coordinating nodes.
    Provide the certificates using --set .Values.security.tls.transport.coordinating.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - Existing secret not provided for ingest nodes */}}
{{- define "opensearch.validateValues.security.transport.missingTlsSecrets.ingest" -}}
{{- if and .Values.ingest.enabled (include "opensearch.security.transport.tlsSecretsProvided" .) (not .Values.security.tls.transport.ingest.existingSecret) -}}
opensearch: security.tls.transport.ingest.existingSecret
    Missing secret containing the TLS certificates for the Opensearch ingest nodes.
    Provide the certificates using --set .Values.security.tls.transport.ingest.existingSecret="my-secret".
{{- end -}}
{{- end -}}

{{/* Validate values of Opensearch - TLS enabled but no certificates provided */}}
{{- define "opensearch.validateValues.security.tls.transport" -}}
{{- if and (not .Values.security.tls.transport.autoGenerated) (not (include "opensearch.security.transport.tlsSecretsProvided" .)) -}}
opensearch: security.tls.transport
    In order to enable Security, it is necessary to configure TLS.
    Two different mechanisms can be used:
        - Provide an existing secret containing the TLS certificates for each role
        - Enable using auto-generated cert-manager certificates with `security.tls.transport.autoGenerated=true`
    Existing secrets containing PKCS8 PEM certificates can be provided using --set Values.security.tls.transport.cluster_manager.existingSecret=cluster-manager-certs,
    --set Values.security.tls.transport.data.existingSecret=data-certs, --set Values.security.tls.transport.coordinating.existingSecret=coordinating-certs, --set Values.security.tls.transport.ingest.existingSecret=ingest-certs
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "opensearch.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.tls.http" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.http.missingTlsSecrets.cluster_manager" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.http.missingTlsSecrets.data" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.http.missingTlsSecrets.coordinating" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.http.missingTlsSecrets.ingest" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.tls.transport" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.transport.missingTlsSecrets.cluster_manager" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.transport.missingTlsSecrets.data" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.transport.missingTlsSecrets.coordinating" .) -}}
{{- $messages := append $messages (include "opensearch.validateValues.security.transport.missingTlsSecrets.ingest" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/*
Sysctl set if less then
*/}}
{{- define "opensearch.sysctlIfLess" -}}
CURRENT=`sysctl -n {{ .key }}`;
DESIRED="{{ .value }}";
if [ "$DESIRED" -gt "$CURRENT" ]; then
    sysctl -w {{ .key }}={{ .value }};
fi;
{{- end -}}
