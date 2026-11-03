# Module catalog

| Module | Purpose | Security defaults / important inputs |
| --- | --- | --- |
| [`networking`](../modules/networking/README.md) | VPC, optional public/private subnet tiers, routes, IGW, and optional NAT | Private subnets do not assign public IPs; NAT defaults to none |
| [`security-groups`](../modules/security-groups/README.md) | One VPC security group with explicit ingress/egress rules | No user-defined rules by default; each rule has one source/destination |
| [`iam-role`](../modules/iam-role/README.md) | Workload role and optional EC2 instance profile | Explicit trust policy; no permissions or keys by default |
| [`s3-bucket`](../modules/s3-bucket/README.md) | Private encrypted bucket, optional lifecycle/logging/Object Lock | Public access blocked, secure transport denied, versioning on, prevent-destroy |
| [`kms-key`](../modules/kms-key/README.md) | Symmetric KMS key and optional alias | Explicit policy, rotation on, deletion window, prevent-destroy |
| [`ec2-instance`](../modules/ec2-instance/README.md) | One compute instance | No public IP, IMDSv2 required, encrypted root EBS, explicit security groups |
| [`cloudwatch-monitoring`](../modules/cloudwatch-monitoring/README.md) | Explicitly configured CloudWatch metric alarms | No invented thresholds or notification destinations |
| [`rds-postgresql`](../modules/rds-postgresql/README.md) | Private PostgreSQL RDS instance and subnet group | Private, encrypted, managed master password, backups, deletion protection |
| [`application-load-balancer`](../modules/application-load-balancer/README.md) | HTTPS ALB, target group, optional HTTP redirect | Internal by default, certificate required, deletion protection, explicit SGs |

Every module requires Terraform `>= 1.10.0, < 2.0.0` and AWS provider `>= 5.0, < 7.0`. See each module README for variables, outputs, cost, limitations, and operating instructions. None is certified production-ready solely by validation or mocked tests.
