# Environment management

Keep reusable implementation in `modules/` and account-specific provider/state/inputs in consumer roots. Start from the closest `examples/` pattern, copy only its composition, and supply environment-specific values explicitly. Development, staging, production, and client environments should use separate account boundaries where practical and distinct state keys at minimum. Do not copy a development CIDR, account, region, size, or access rule into another environment without review.

Select instance/database sizing, NAT design, multi-AZ behavior, retention, notification topics, CIDR plans, KMS strategy, and public exposure from workload requirements. Store non-secret environment values in controlled variable files or CI variables; use a secret manager for runtime secrets. Keep state backend configuration free of credentials. Production roots should use protected deployment environments and reviewers before any apply.

There are no checked-in development/staging/production roots because account IDs, state buckets, regions, CIDRs, and access roles are environment-specific and unavailable here. The examples are composition templates only.
