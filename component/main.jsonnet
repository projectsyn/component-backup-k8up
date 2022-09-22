local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local prometheus = import 'lib/prometheus.libsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;

local credentials_secret(creds) =
  kube.Secret(creds.secretname) {
    metadata+: {
      namespace: params.namespace,
    },
    // expected to be secret refs
    stringData: {
      [creds.accesskeyname]: creds.accesskey,
      [creds.secretkeyname]: creds.secretkey,
    },
  };

local global_backup_secret = kube.Secret(params.global_backup_config.backup_secret.name) {
  metadata+: {
    namespace: params.namespace,
  },
  // stringData because password comes from secret ref
  stringData: {
    password: params.global_backup_config.backup_secret.password,
  },
};

local monitoring = import 'monitoring.jsonnet';

local monitoring_labels =
  if inv.parameters.facts.distribution == 'openshift4' then
    {

      'openshift.io/cluster-monitoring': 'true',
    }
  else
    {
      SYNMonitoring: 'main',
    };

local want_global_config = params.global_backup_config.enabled && params.global_backup_config.s3_endpoint != null;

local namespace =
  if params.monitoring_enabled && std.member(inv.applications, 'prometheus') then
    prometheus.RegisterNamespace(kube.Namespace(params.namespace)) {
      metadata+: {
        labels+: monitoring_labels,
      },
    }
  else if params.monitoring_enabled then
    kube.Namespace(params.namespace) {
      metadata+: {
        labels+: monitoring_labels,
      },
    }
  else
    kube.Namespace(params.namespace)
;

{
  '00_namespace': namespace,
  [if want_global_config then '10_global_s3_credentials']:
    credentials_secret(params.global_backup_config.s3_credentials),
  [if want_global_config then '10_global_s3restore_credentials']:
    credentials_secret(params.global_backup_config.s3restore_credentials),
  [if want_global_config then '10_global_backup_secret']: global_backup_secret,
  [if params.monitoring_enabled then '30_monitoring']: monitoring,
}
