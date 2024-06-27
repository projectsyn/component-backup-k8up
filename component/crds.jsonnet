local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local prometheus = import 'lib/prometheus.libsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;

local load_crds(name) =
  std.parseJson(kap.yaml_load_stream(
    'dependencies/backup-k8up/crds/%s/%s.yaml' % [
      params.images.k8up.tag,
      name,
    ]
  ));

local syncOptionAnnotation = {
  metadata+: {
    annotations+: {
      'argocd.argoproj.io/sync-options': 'ServerSideApply=true',
    },
  },
};

local crds = [ crd + syncOptionAnnotation for crd in load_crds('02_k8up_crds') ];

{ '02_k8up_crds': crds }
