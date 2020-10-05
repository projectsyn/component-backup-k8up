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

local alert_rules = com.namespaced(params.namespace, {
  apiVersion: 'monitoring.coreos.com/v1',
  kind: 'PrometheusRule',
  metadata: {
    name: 'k8up',
    labels: {
      prometheus: inv.parameters.synsights.prometheus.name,
      role: 'alert-rules',
    },
  },
  spec: {
    groups: [
      {
        name: 'k8up.rules',
        rules: [
          {
            alert: 'k8up_last_errors',
            annotations: {
              message: 'Last backup for PVC {{ $labels.pvc }} in namespace {{ $labels.instance }} had {{ $value }} errors',
            },
            expr: 'baas_backup_restic_last_errors{%s} > 0' %
                  com.getValueOrDefault(params.alert_rule_filters, 'namespace', ''),
            'for': '1m',
            labels: {
              severity: 'critical',
            },
          },
          {
            alert: 'K8upBackupFailed',
            expr: 'rate(k8up_jobs_failed_counter[1d]) > 0',
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'Job in {{ $labels.exported_namespace }} of type {{ $labels.jobType }} failed',
            },
          },
          {
            alert: 'K8upBackupNotRunning',
            expr: 'sum(rate(k8up_jobs_total[25h])) == 0 and on(namespace) k8up_schedules_gauge > 0',
            'for': '1m',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'No K8up jobs were run in {{ $labels.exported_namespace }} within the last 24 hours. Check the operator, there might be a deadlock',
            },
          },
          {
            alert: 'K8upJobStuck',
            expr: 'k8up_jobs_queued_gauge{jobType="backup"} > 0 and on(namespace) k8up_schedules_gauge > 0',
            'for': '24h',
            labels: {
              severity: 'critical',
            },
            annotations: {
              message: 'K8up jobs are stuck in {{ $labels.exported_namespace }} for the last 24 hours.',
            },
          },
        ],
      },
    ],
  },
});

[alert_rules, service_monitor]
