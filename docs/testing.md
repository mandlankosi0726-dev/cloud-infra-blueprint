# Testing strategy

1. **Static checks:** `terraform fmt -check -recursive`, backend-disabled `terraform init`, `terraform validate`, TFLint, Checkov or Trivy, and Gitleaks. Provider packages must be downloadable. Scanners are signals that need review.
2. **Module tests:** selected modules contain Terraform native `*.tftest.hcl` plan tests using mock providers. These assert defaults, resource settings, and invalid input handling without AWS resources. Run via `./scripts/validate_modules.sh`.
3. **Plan review:** initialize a consumer root against its intended backend/account, create a saved plan, and review all changes and sensitive values. Planning can require credentials and remote data sources even though it does not create managed resources.
4. **Integration tests:** none are included or claimed. Add only with an isolated AWS test account, restricted role, opt-in, unique test naming/tags, cleanup and recovery steps, and explicit authorization for billable resources. Never run against production.

CI does not run apply. Current verification has not included live AWS plans or integration tests. A module passing `validate` does not establish that the selected provider schema, region service support, IAM policy, operational recovery, or final deployed behavior is correct.
