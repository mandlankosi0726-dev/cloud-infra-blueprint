# CloudWatch monitoring module

Creates explicitly configured CloudWatch metric alarms. It does not guess resource dimensions or thresholds and creates no notification destinations. Supply dimensions for the exact EC2, RDS, or ALB metrics being monitored, and pass SNS topic ARNs through `alarm_actions` and `ok_actions` as appropriate.

Inputs: `project`, `environment`, `alarms` (map of descriptions, namespace, metric, statistic, period, evaluation periods, threshold, comparison, dimensions, actions, and missing-data behavior), and `tags`. Outputs are alarm ARN map and alarm names. CPU is not an application health check; combine infrastructure metrics with target health, service probes, logs, and business signals. Missing metrics can represent idle resources or telemetry failure; choose `treat_missing_data` deliberately.

CloudWatch alarms, custom metrics, logs ingestion/storage, dashboards, and SNS delivery can incur costs. Thresholds require workload-specific baselines; defaults are not provided. Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. No AWS integration test is included.
