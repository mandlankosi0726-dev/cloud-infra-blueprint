# EC2 instance module

Creates one EC2 instance using an explicit AMI ID, instance type, subnet, and required security groups. It does not assign a public IPv4 address, requires IMDSv2, disables metadata tags, and encrypts the root EBS volume. An IAM instance profile and detailed monitoring are optional. No SSH keys, security groups, or ingress rules are created.

Inputs: `name`, `project`, `environment`, `ami_id`, `instance_type`, `subnet_id`, `security_group_ids`, optional `iam_instance_profile_name`, root volume size/type, `monitoring_enabled`, optional sensitive `user_data`, and additional `tags`. Outputs: `instance_id`, `private_ip`, and `instance_arn`. Select an approved maintained image for the target region; the caller owns image refresh and patching. Keep user data free of credentials because it can be exposed through state and instance metadata.

Place the instance in a private subnet and use controlled access such as Systems Manager with a least-privilege instance role. Configure backups, patching, vulnerability management, application health checks, and log collection separately. Detailed monitoring, instance size, EBS, data transfer, and Systems Manager features can incur charges. The presence of an EC2 instance alone does not make a workload production-ready.

Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. Review plans and scan configuration; no AWS integration test is included.
