# S3 bucket module

Creates a private S3 bucket with all four public access blocks enabled, BucketOwnerEnforced ownership (ACLs disabled), default encryption, and a policy denying insecure transport. Versioning defaults on. Optional lifecycle configuration, access logging to an existing destination, and Object Lock are supported.

By default S3-managed AES256 encryption is used. Set `kms_key_arn` for a customer-managed KMS key and ensure the key policy permits the required S3 use. Set lifecycle rules explicitly; expiration permanently removes current objects and noncurrent versions according to the configured periods. Access logging requires a separately secured destination bucket and correct delivery permissions.

Object Lock is disabled by default. Enabling it is a bucket creation-time decision. Governance retention can be bypassed by principals with specific permissions; Compliance retention cannot be shortened, including by account administrators. Retention can prevent deletion and affect cost. The module does not claim immutability unless Object Lock and a default retention policy are configured. Object Lock does not replace independent backups or recovery testing.

Inputs: `bucket_name`, `project`, `environment`, optional `kms_key_arn`, `versioning_enabled`, `lifecycle_rules`, optional log destination/prefix, `object_lock_enabled`, optional `object_lock_default_retention`, and `tags`. Required Project, Environment, and ManagedBy tags are applied. Outputs: `bucket_id`, `bucket_arn`, `bucket_region`. `force_destroy` is always false and Terraform `prevent_destroy` is enabled; a deliberate teardown requires an explicit reviewed code change to remove that lifecycle guard and the bucket must be emptied separately. This is not an independent access control.

S3 storage, requests, replication, KMS requests, and retrieval can incur charges. Run plans and scans before use. Terraform `>= 1.10.0, < 2.0.0`; AWS provider `>= 5.0, < 7.0`. No AWS integration test is included.
