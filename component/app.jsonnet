local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;
local argocd = import 'lib/argocd.libjsonnet';

local app = argocd.App('backup-k8up', params.namespace, secrets=true);

if params.enabled then {
  backup: app,
} else {}
