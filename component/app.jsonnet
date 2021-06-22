local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('backup-k8up', params.namespace) {
  spec+: {
    ignoreDifferences+: [
      {
        group: 'apiextensions.k8s.io',
        kind: 'CustomResourceDefinition',
        jsonPointers: [
          // Archives, Backups, Checks, Prunes, Restores
          '/spec/validation/openAPIV3Schema/properties/spec/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',

          // PreBackupPods
          '/spec/preserveUnknownFields',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/env/items/properties/valueFrom/properties/resourceFieldRef/properties/divisor/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/lifecycle/properties/postStart/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/lifecycle/properties/postStart/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/lifecycle/properties/preStop/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/lifecycle/properties/preStop/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/livenessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/livenessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/readinessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/readinessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/startupProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/startupProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/env/items/properties/valueFrom/properties/resourceFieldRef/properties/divisor/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/lifecycle/properties/postStart/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/lifecycle/properties/postStart/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/lifecycle/properties/preStop/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/lifecycle/properties/preStop/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/livenessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/livenessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/readinessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/readinessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/startupProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/ephemeralContainers/items/properties/startupProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/env/items/properties/valueFrom/properties/resourceFieldRef/properties/divisor/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/lifecycle/properties/postStart/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/lifecycle/properties/postStart/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/lifecycle/properties/preStop/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/lifecycle/properties/preStop/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/livenessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/livenessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/readinessProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/readinessProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/startupProbe/properties/httpGet/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/startupProbe/properties/tcpSocket/properties/port/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/overhead/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/volumes/items/properties/downwardAPI/properties/items/items/properties/resourceFieldRef/properties/divisor/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/volumes/items/properties/emptyDir/properties/sizeLimit/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/volumes/items/properties/ephemeral/properties/volumeClaimTemplate/properties/spec/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/volumes/items/properties/ephemeral/properties/volumeClaimTemplate/properties/spec/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/volumes/items/properties/projected/properties/sources/items/properties/downwardAPI/properties/items/items/properties/resourceFieldRef/properties/divisor/x-kubernetes-int-or-string',

          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/ports/x-kubernetes-list-map-keys',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/containers/items/properties/ports/x-kubernetes-list-type',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/ports/x-kubernetes-list-map-keys',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/initContainers/items/properties/ports/x-kubernetes-list-type',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/topologySpreadConstraints/x-kubernetes-list-map-keys',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/pod/properties/spec/properties/topologySpreadConstraints/x-kubernetes-list-type',

          // Schedules
          '/spec/validation/openAPIV3Schema/properties/spec/properties/archive/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/archive/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/backup/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/backup/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/check/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/check/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/prune/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/prune/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/resourceRequirementsTemplate/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/resourceRequirementsTemplate/properties/requests/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/restore/properties/resources/properties/limits/additionalProperties/x-kubernetes-int-or-string',
          '/spec/validation/openAPIV3Schema/properties/spec/properties/restore/properties/resources/properties/requests/additionalProperties/x-kubernetes-int-or-string',
        ],
      },
    ],
  },
};

if params.enabled then {
  backup: app,
} else {}
