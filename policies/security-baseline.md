# Security baseline

- Use isolated accounts and state for client and environment boundaries.
- No public workload access unless explicitly required and reviewed; private subnets do not receive public IPs by default.
- Do not expose management or database ports broadly. Define ingress and egress narrowly in dedicated security-group modules.
- Use workload roles and temporary credentials. Do not store AWS keys in code, tfvars, backend files, or GitHub repository files; use GitHub OIDC for CI.
- Encrypt supported data, require secure transport, set deliberate backup and retention, and account for key recovery and deletion risk.
- Apply Project, Environment, and ManagedBy tags; tags must not contain secrets or personal information.
- Review plans for replacement and deletion. Terraform lifecycle protection is not a backup or access control.
- Static scanners identify known patterns but cannot certify a configuration as secure. Review exceptions with a reason and expiry.
