local com = import 'lib/commodore.libjsonnet';
local kube = import 'lib/kube.libjsonnet';

local inv = com.inventory();
local params = inv.parameters.backup_k8up;

local chart_output_dir = std.extVar('output_path');

local patch_registry(obj) =
  if obj.kind == 'Job' then
    obj {
      spec+: {
        template+: {
          spec+: {
            containers: [
              c {
                image: '%(registry)s/%(repository)s:%(tag)s' % params.images.kubectl,
              }
              for c in super.containers
            ],
          },
        },
      },
    }
  else
    obj;

com.fixupDir(chart_output_dir, patch_registry)
