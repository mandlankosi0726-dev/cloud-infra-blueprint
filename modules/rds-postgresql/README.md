# RDS PostgreSQL module

Creates a private RDS PostgreSQL instance in a subnet group spanning at least two supplied subnets. Public accessibility is disabled, security groups are explicit, storage encryption is always enabled, backups default to seven days, deletion protection defaults on, and RDS manages the master password in Secrets Manager. No password is an input or output. The module does not create database ingress rules or a customer-managed KMS key.

Inputs include the identifier, project/environment, explicit engine version and instance class, master username, private subnet IDs, security-group IDs, optional KMS key, storage limits, backup retention/window, maintenance window, Multi-AZ choice, deletion protection, and optional Enhanced Monitoring role/interval. Outputs include the endpoint address/port, identifier, initial database name, and managed secret ARN. Restrict secret access to application roles and retrieve credentials at runtime.

Multi-AZ is explicit and defaults off because it has a material cost. A managed database is not automatically highly available in the intended application sense. Automated backups and point-in-time recovery depend on retention, region/account controls, and service availability; they do not replace tested application-consistent recovery, export/restore procedures, or retention policy. Review restore targets and RPO/RTO separately.

Supply a unique `final_snapshot_identifier`; a prior final snapshot with the same name can block a later deletion. Before a deliberate deletion, choose a fresh identifier and retain the snapshot according to policy. Disable deletion protection only through a separately reviewed change. Engine versions and instance classes vary by region and may become unavailable; validate the selected version before deployment. Storage autoscaling, instance size, Multi-AZ, backup storage, and I/O are cost-sensitive.

Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. This module has not been integration-tested against AWS.
