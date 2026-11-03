# KMS key module

Creates a symmetric KMS key with an explicit caller-supplied key policy, configurable automatic rotation, a 7-30 day deletion waiting period, optional alias, tags, and Terraform deletion protection enabled. The module deliberately does not invent an administrative principal or broad key policy. The caller must provide a correct recovery/admin principal and only the required key use grants.

Inputs: `description`, `project`, `environment`, `key_policy_json`, `enable_key_rotation`, `deletion_window_in_days`, optional `alias_name`, and `tags`. Required Project, Environment, and ManagedBy tags are applied. Outputs: `key_arn`, `key_id`, and `alias_name`. Terraform `prevent_destroy` is enabled; a deliberate key teardown requires a reviewed code change to remove the lifecycle guard. Policy JSON validation checks shape only; test that intended principals can administer and use the key before relying on it. Losing decrypt permissions or scheduling key deletion can make encrypted data inaccessible. Cancellation during the waiting period may be possible, but after deletion recovery is not.

Do not create a dedicated key per resource by default. Use a documented key strategy balancing access boundaries, blast radius, operational burden, and request costs. `prevent_destroy` is not a backup and can be removed from configuration; protect critical key lifecycle through permissions and review controls too.

Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. Run validation and security checks; no AWS integration test is included.
