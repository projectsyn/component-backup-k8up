local com = import 'lib/commodore.libjsonnet';

local crd_files = [
  'k8up.io_archives',
  'k8up.io_backups',
  'k8up.io_checks',
  'k8up.io_podconfigs',
  'k8up.io_prebackuppods',
  'k8up.io_prunes',
  'k8up.io_restores',
  'k8up.io_schedules',
  'k8up.io_snapshots',
];

local crds = [
  {
    name: crd_file,
    content: com.yaml_load_all(std.extVar('output_path') + '/' + crd_file + '.yaml'),
  }
  for crd_file in crd_files
];

{
  [crd.name]: std.filter(function(it) it != null, crd.content)[0] {
    metadata+: {
      annotations+: {
        'argocd.argoproj.io/sync-options': 'ServerSideApply=true',
      },
    },
  }
  for crd in crds
}
