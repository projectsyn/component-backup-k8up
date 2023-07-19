local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;
local argocd = import 'lib/argocd.libjsonnet';
local instance = inv.parameters._instance;

local app = argocd.App(instance, params.namespace);

{
  [instance]: app,
}
