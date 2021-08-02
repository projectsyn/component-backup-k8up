local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
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

local want_global_config = params.global_backup_config.enabled && params.global_backup_config.s3_endpoint != null;

{
  '00_namespace': kube.Namespace(params.namespace) {
    metadata+: {
      labels+: {
        SYNMonitoring: 'main',
      },
    },
  },
  [if want_global_config then '10_global_s3_credentials']:
    credentials_secret(params.global_backup_config.s3_credentials),
  [if want_global_config then '10_global_s3restore_credentials']:
    credentials_secret(params.global_backup_config.s3restore_credentials),
  [if want_global_config then '10_global_backup_secret']: global_backup_secret,
  [if params.monitoring_enabled then '30_monitoring']: monitoring,
}
