local com = import 'lib/commodore.libjsonnet';
local kap = import 'lib/kapitan.libjsonnet';
local kube = import 'lib/kube.libjsonnet';
local inv = kap.inventory();
local params = inv.parameters.backup_k8up;

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

local failed_job_alert_rules = std.map(
  function(type) params.job_failed_alert_template {
    alert: params.job_failed_alert_template.alert % { type: asciiTitleCase(type) },
    expr: params.job_failed_alert_template.expr % { type: type },
  }
  , params.job_failed_alerts_for
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
          { alert: field } + params.monitoring_alerts[field]
          for field in std.sort(std.objectFields(params.monitoring_alerts))
        ] + failed_job_alert_rules,
      },
    ],
  },
});

[ alert_rules, service_monitor ]
