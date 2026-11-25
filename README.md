# ArpScayl Terraform Infrastructure Templates

Reusable AWS Terraform modules and example root configurations for ArpScayl Systems. The repository provides building blocks for networking, security groups, IAM workload roles, S3, KMS, EC2, CloudWatch alarms, RDS PostgreSQL, and Application Load Balancers. The examples show composition patterns; they are starting points for review, not universal client architectures or production-ready deployments.

**This repository never provisions infrastructure automatically.** Pull request CI formats, initializes, validates, tests, and scans configurations; it does not run `apply`. Do not point an example at a client account until its account, region, state backend, access controls, CIDRs, security requirements, costs, and recovery expectations have been reviewed and authorized.

## Contents

- [`modules/`](modules/): focused, provider-specific reusable modules.
- [`examples/`](examples/): root Terraform configurations showing module composition.
- [`ansible/`](ansible/): optional host-configuration playbooks and an AWS EC2 dynamic inventory example.
- [`docs/`](docs/): architecture, testing, state, environments, deployment, upgrades, onboarding, and troubleshooting.
- [`policies/security-baseline.md`](policies/security-baseline.md): minimum security expectations.
- [Security guide](docs/security.md): credentials, state, and scan exception handling.
- [`scripts/`](scripts/): local validation and security scan commands.
- [CI workflow](.github/workflows/terraform-validation.yml): formatting, validation, tests, lint, security scan, and documentation checks; no apply job.
- [Manual release workflow](.github/workflows/module-release.yml): creates a GitHub release for an existing reviewed version tag when deliberately dispatched; it does not provision infrastructure or publish to a module registry.

## Prerequisites

- Terraform CLI 1.10.5 (`.terraform-version`; module range `>= 1.10.0, < 2.0.0`).
- AWS provider `>= 5.0, < 7.0`; root configurations own provider configuration and AWS credential resolution.
- TFLint 0.55.x, Checkov 3.2.372 (or Trivy), and Gitleaks 8.24.2 for the full local checks.
- AWS CLI or another approved AWS authentication method only when planning against AWS. Static validation does not need AWS credentials, but it does need provider packages from the Terraform registry.

Terraform selects exact provider versions through each root's `.terraform.lock.hcl`. Commit that file in deployable roots after reviewing the provider selection. The repository keeps modules independently reusable; examples are separate Terraform roots and therefore have separate lock files after initialization.

## Choose a starting template

| Goal | Start here | What it demonstrates |
| --- | --- | --- |
| VPC and subnets | [`examples/networking-basic`](examples/networking-basic) | Public/private subnet tiers and explicit NAT mode |
| Private server | [`examples/private-ec2-workload`](examples/private-ec2-workload) | Private EC2, IMDSv2, encrypted root disk, workload role and scoped security group |
| HTTPS web pattern | [`examples/web-application`](examples/web-application) | Public ALB, private target, client CIDR restriction, target security group and TLS certificate input |

Read the selected example's `README.md` and each referenced module's README before adapting it. The private EC2 example has no NAT or VPC endpoints, so it has no external egress path. The web example does not install an application on its EC2 instance and expects an existing AMI, certificate, and working application health endpoint.

## Use an example safely

1. **Create a consumer root.** Copy an example into a new environment-specific directory or repository so its state and changes are isolated. Keep module source paths valid or update them to the actual repository URL pinned to an immutable Git tag, for example `git::https://github.com/<ORG>/arpscayl-terraform-modules.git//modules/networking?ref=v0.1.0`. Replace `<ORG>` with the repository owner; do not consume a mutable branch for production.
2. **Choose the target explicitly.** Configure the AWS provider region in the root, then confirm the active AWS account with `aws sts get-caller-identity`. Use an approved role with short-lived credentials. Do not put credentials in `.tf`, `.tfvars`, backend files, or source control.
3. **Set environment inputs.** Copy `terraform.tfvars.example` to a local `terraform.tfvars`, or use approved CI variables. Replace all placeholders: AWS region, account-specific CIDRs, availability zones, AMI, certificate ARN, client CIDRs, ownership/cost tags, and any sizing values. Never assume the sample addresses are suitable for a connected network. `.tfvars` files are ignored by Git; the `.example` files remain tracked.
4. **Configure state before shared use.** Local state is acceptable only for an isolated disposable exercise. For team, client, staging, or production use, bootstrap a versioned, encrypted, access-restricted S3 state bucket independently, then configure the root's S3 backend with `use_lockfile = true`. Follow [state management](docs/state-management.md). Backend configuration must not contain credentials.
5. **Initialize and validate.** From the example root, run `terraform init` (or `terraform init -backend=false` for local-only validation), `terraform fmt -check -recursive`, `terraform validate`, TFLint, and the security scan. See [testing](docs/testing.md).
6. **Plan and inspect.** Confirm account, region, environment, and state key; run `terraform plan -out=review.tfplan`. Review every create, update, replacement, and destroy action, cost-sensitive choice, IAM grant, public path, and unknown value. Plan files and state can contain sensitive values; restrict access and retention, and do not commit them.
7. **Authorize and apply deliberately.** Obtain the required change approval. Apply only the reviewed saved plan (`terraform apply review.tfplan`) from a trusted, protected context. Do not run `apply` on an example or client environment merely because it validates. Production deployment requires protected GitHub Environment reviewers and a least-privilege OIDC role in the consuming deployment pipeline.
8. **Verify and hand over.** Confirm deployed resources, security boundaries, logs/alarms, backup and restore, DNS/TLS, access paths, costs, and incident contacts. Record recovery steps and module source version.

The commands above do not bypass the requirement to review the plan and gain authorization. Never use `-auto-approve` as a replacement for change review. Do not use `terraform destroy` for routine cleanup in shared or production environments.

## Configure hosts with Ansible

Terraform creates and tags infrastructure; Ansible configures operating systems and services after the infrastructure is deployed. The `ansible/` directory contains an AWS EC2 dynamic inventory and a sample NGINX role. Ansible is optional and is never run automatically by Terraform or CI.

1. Install Ansible Core, the AWS SDK for Python (`boto3`), and the AWS collection from the repository root:

   ```sh
   python3 -m venv .venv
   . .venv/bin/activate
   python -m pip install --upgrade pip ansible-core boto3 ansible-lint
   ansible-galaxy collection install -r ansible/requirements.yml
   ```

2. Authenticate to the intended AWS account using an approved short-lived profile or role, and set the region used by the deployed environment. Confirm identity with `aws sts get-caller-identity`. Edit `ansible/inventories/aws_ec2.yml` and set `regions` to the target region; its sample value is `us-east-1`.
3. Ensure target instances have the tags `ManagedBy=Terraform` (added by the EC2 module) and `AnsibleRole=web`. Set `AnsibleRole=web` in the example's `tags` input only for instances intended for this sample. The inventory filters to running Terraform-managed instances, connects to their private IPs, and adds only instances tagged for the `web` role to the playbook's target group. Inspect the result before running anything:

   ```sh
   AWS_PROFILE=approved-profile make ansible-inventory
   ```

4. Provide network reachability to the private addresses through an approved VPN, bastion, or other controlled management path. Configure SSH user/key or a supported Ansible connection method for the selected AMI, using your SSH agent or local SSH configuration. Host key checking is enabled. Do not open SSH to the public internet. The sample Terraform examples do not add SSH ingress, and the private workload example has no NAT or package-repository egress; plan approved access and package connectivity separately.
5. Review the playbook and variables, then run a dry run before applying host changes:

   ```sh
   AWS_PROFILE=approved-profile make ansible-check ANSIBLE_ARGS='--user ubuntu --private-key /path/to/private-key'
   AWS_PROFILE=approved-profile \
     ANSIBLE_CONFIG=ansible/ansible.cfg \
     ansible-playbook -i ansible/inventories/aws_ec2.yml ansible/playbooks/site.yml --diff --user ubuntu --private-key /path/to/private-key
   ```

   The playbook installs NGINX, writes a sample page, and enables the service on hosts in the `web` group. Edit its role defaults or add roles for the actual workload. Use Ansible Vault or an approved secret manager for secrets; never commit credentials, private keys, vault passwords, or decrypted variables. Local AWS inventory copies named `*.local.aws_ec2.yml` are ignored by Git.

Run `make ansible-lint` for static linting. `make ansible-inventory` queries AWS and therefore requires valid credentials and AWS API access; `make ansible-check` connects to discovered hosts and should be run only after reviewing its target graph. Check mode is a preview aid and does not guarantee that every task predicts changes perfectly.

## Local checks

```sh
terraform fmt -check -recursive
./scripts/validate_modules.sh
./scripts/security_scan.sh
```

Or run `make validate` and `make security`. Validation initializes each example and module with `-backend=false`, runs `terraform validate`, and executes Terraform tests included under module `tests/` directories. Provider installation requires access to `registry.terraform.io`. Security scans detect known configuration patterns; they do not prove a configuration secure. Checkov or Trivy findings need documented review rather than blanket suppression. Integration tests that create billable AWS resources are not run by pull request CI.

## State, security, and operations

- Keep client and environment state isolated, use S3 versioning/encryption and native S3 lockfiles, and restrict object/lock access. See [state management](docs/state-management.md).
- Prefer private placement, explicit rules, least-privilege IAM, encrypted storage, secure transport, and temporary credentials. See the [security baseline](policies/security-baseline.md).
- Treat destruction, replacement, key deletion, bucket retention, database deletion, and state migration as controlled changes. Review operational notes in module READMEs.
- Cost depends on region, traffic, retention, and service choices. NAT gateways, ALBs, EC2 sizing/EBS, RDS/Multi-AZ, CloudWatch data, S3 storage/retrieval, KMS use, and data transfer are particularly relevant. No exact estimate is implied here.

## Current implementation status

The implemented module set is documented in the [module catalog](docs/module-catalog.md). Modules have local Terraform test files for important defaults and invalid inputs, but **they have not been AWS integration-tested**. Static validation is distinct from plan validation, and plan validation is distinct from applying in an isolated test account. Confirm checks in CI after provider dependencies are available before releasing. Validation does not apply infrastructure. The manual release workflow creates a GitHub release only when dispatched for an existing version tag.

## Contribute or request a module

Use [module development](docs/module-development.md). A proposal should identify one workload boundary, required inputs/outputs, secure defaults, expected costs, tests, and operations ownership. Add a module only with implementation, docs, tests, and CI validation—not an empty directory.

## Releases and compatibility

See [versioning](docs/versioning.md). Consumers should pin immutable tags. Provider version constraints express a compatibility range, not proof that every release in the range behaves identically; run validation, tests, and reviewed plans before upgrading.
# arpscayl-terraform
