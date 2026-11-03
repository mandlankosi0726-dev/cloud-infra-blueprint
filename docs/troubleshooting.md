# Troubleshooting

- **Provider initialization cannot reach the registry:** check network/DNS and proxy configuration, retry `terraform init`, and use the checked-in lock file. Do not bypass provider integrity verification.
- **Backend bucket not found:** bootstrap state infrastructure independently, confirm bucket name/region and role permissions, then initialize again. Backend init does not create its bucket.
- **State lock contention:** confirm no plan/apply is active before considering stale-lock recovery. Do not delete lock objects while another run may own them.
- **Plan shows unexpected replacement/deletion:** stop. Check address changes, immutable inputs, provider upgrade, state key/account, and current infrastructure before approval. Do not apply a plan you do not understand.
- **Apply fails partway through:** inspect the error and real AWS state, preserve logs/state, and make a fresh plan after reconciliation. Terraform state is not to be hand-edited as routine recovery.
- **CIDR or subnet creation fails:** confirm VPC containment, no overlap across tiers/connected networks, AZ names in the chosen region, and one subnet per selected AZ where required.
- **Private workload cannot reach AWS APIs:** check routes, NAT or required VPC endpoints, endpoint security groups, DNS, IAM permissions, and service-specific requirements.
- **ALB targets are unhealthy:** verify target port/protocol/path, expected health response, target process, target group target type, AZ/subnet configuration, and target SG ingress from the ALB SG.
- **RDS destroy or replacement is blocked:** deletion protection and Terraform `prevent_destroy` are intentional safeguards. Confirm snapshot/retention requirements and approved change controls before changing them.
