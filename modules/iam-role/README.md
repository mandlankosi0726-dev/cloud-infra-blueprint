# IAM workload role module

Creates an IAM role from an explicit trust policy, optional inline statements, reviewed managed policy attachments, and an optional permissions boundary. An EC2 instance profile can optionally be created for the role. No policy is attached by default and no access keys are created. Supply exact principals and constrain trust with conditions (for example, GitHub OIDC audience and subject conditions).

Inputs: `name`, `project`, `environment`, `trust_policy_json`, `inline_policies`, `managed_policy_arns`, `permissions_boundary_arn`, `max_session_duration`, `create_instance_profile`, and `tags`. Required Project, Environment, and ManagedBy tags are applied. Outputs: `role_name`, `role_arn`, and optional `instance_profile_name`. Inline policy statements default to Allow; define only the required actions and resource ARNs. Wildcards should be exceptional and justified. Review managed policy contents and role trust independently; JSON syntax validation does not establish least privilege.

For GitHub Actions, configure an AWS IAM OIDC identity provider and a trust policy restricted to the expected repository, branch or protected environment. Use `id-token: write` only in the deployment job, assume the role with short-lived credentials, and never store AWS access keys in Terraform or GitHub secrets.

Run local validation and security scans. No AWS integration test is included. Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. Policy changes can expand permissions; review diffs and plans carefully.
