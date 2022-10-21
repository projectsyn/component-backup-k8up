local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local prometheus = import 'lib/prometheus.libsonnet';

local inv = kap.inventory();
local params = inv.parameters.backup_k8up;

local alertlabels = {
  syn: 'true',
  syn_component: 'backup-k8up',
};

local service_monitor = com.namespaced(params.namespace, {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'ServiceMonitor',
  metadata: {
    labels: {
      'app.kubernetes.io/instance': 'k8up',
      'app.kubernetes.io/name': 'k8up',
      prometheus: params.prometheus_name,
    },
    name: 'k8up-operator',
  },
  spec: {
    endpoints: [
      {
        interval: '10s',
        port: 'http',
      },
    ],
    selector: {
      matchLabels: {
        'app.kubernetes.io/instance': 'k8up',
        'app.kubernetes.io/name': 'k8up',
      },
    },
  },
});

local asciiTitleCase(str) = std.asciiUpper(str[0]) + str[1:];

local failed_job_types = [ 'archive', 'backup', 'check', 'prune', 'restore' ];
local render_failed_job_alert(type) =
  assert std.member(failed_job_types, type) : 'Unknown failed job type "%s"' % type;
  local alertconfig = params.job_failed_alerts_for[type];
  if alertconfig.enabled then
    com.makeMergeable(params.job_failed_alert_template) +
    com.makeMergeable(alertconfig.overrides) +
    {
      alert: super.alert % { type: asciiTitleCase(type) },
      expr: super.expr % { type: type },
      labels+: alertlabels,
    }
  else
    null;

local failed_job_alert_rules = std.filter(
  function(it) it != null,
  std.map(
    render_failed_job_alert,
    std.objectFields(params.job_failed_alerts_for)
  )
);

local alert_rules = com.namespaced(params.namespace, {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PrometheusRule',
  metadata: {
    name: 'k8up',
    labels: {
      prometheus: params.prometheus_name,
      role: 'alert-rules',
    },
  },
  spec: {
    groups: [
      {
        name: 'k8up.rules',
        rules: [
          params.monitoring_alerts[field] {
            alert: field,
            labels+: alertlabels,
          }
          for field in std.sort(std.objectFields(params.monitoring_alerts))
          if params.monitoring_alerts[field] != null
        ] + failed_job_alert_rules,
      },
    ],
  },
});

local final_alert_rules =
  if std.member(inv.applications, 'prometheus') then
    prometheus.Enable(alert_rules)
  else
    alert_rules
;

local final_service_monitor =
  if std.member(inv.applications, 'prometheus') then
    prometheus.Enable(service_monitor)
  else
    service_monitor
;

[ final_alert_rules, final_service_monitor ]
