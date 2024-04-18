local com = import 'lib/commodore.libjsonnet';
local inv = com.inventory();
// The hiera parameters for the component
local params = inv.parameters.backup_k8up;

local priotityclassPatch = {
  spec+: {
    template+: {
      spec+: {
        priorityClassName: params.priorityClass,
      },
    },
  },
};

local deployFile = com.yaml_load(std.extVar('output_path') + '/' + 'deployment.yaml');

{
  deployment: deployFile + priotityclassPatch,
}
