local kap = import 'lib/kapitan.libjsonnet';

local k8up = import 'lib/backup-k8up.libjsonnet';

local inv = kap.inventory();

local test_cases = inv.parameters.test_cases;

local create_schedule(tc, spec) =
  local pspec = if std.objectHas(spec, 'prune_spec') then
    k8up.PruneSpec(
      spec.prune_spec.schedule,
      spec.prune_spec.keep_daily,
      spec.prune_spec.keep_last
    )
  else
    {};
  local cspec = if std.objectHas(spec, 'check_schedule') then
    k8up.CheckSpec(spec.check_schedule)
  else
    {};
  k8up.Schedule(
    tc,
    std.get(spec, 'schedule', '23 * * * *'),
    keep_jobs=std.get(spec, 'keep_jobs', 3),
    backupkey=std.get(spec, 'backupkey'),
    bucket=std.get(spec, 'bucket'),
    s3secret=std.get(spec, 's3secret'),
    create_bucket=false,
    caConfigMap=std.get(spec, 'caConfigMap'),
  ).schedule + pspec + cspec;

std.mapWithKey(create_schedule, test_cases)
