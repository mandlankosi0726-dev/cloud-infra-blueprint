# Security and threat boundaries

Follow the [security baseline](../policies/security-baseline.md). This repository contains infrastructure definitions, not client-specific authorization decisions. Before use, review trust relationships, IAM actions/resources, all ingress/egress paths, public addressing, KMS key policies, bucket policies/retention, database reachability, and state access.

AWS credentials must come from approved short-lived credential chains or GitHub OIDC. CI grants read-only repository permission for validation; any future deployment workflow must have narrowly scoped `id-token: write`, protected environments, exact account/role checks, and no credential access for untrusted pull requests.

Terraform state and saved plans may contain sensitive values. Restrict them, encrypt storage, set retention, and never commit them. Static scanners do not prove security. Record accepted findings with owner, justification, review date, and expiration; remove exceptions when no longer needed.
