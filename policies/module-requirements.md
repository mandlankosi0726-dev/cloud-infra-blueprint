# Module requirements

Reusable modules must have one clear responsibility and include `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, a README, and tests where the behavior is testable. Declare input types, useful validation, explicit secure defaults, required Project/Environment/ManagedBy tags, Terraform/provider compatibility, and outputs suitable for composition. Modules consume provider configuration from roots and never define credentials or environment-specific account IDs, production CIDRs, or client names.

Tests should cover valid inputs, invalid inputs, outputs, tags, defaults, and unsupported combinations. Document tests actually run and distinguish mocked/static validation, AWS plans, and live integration. Explain security boundaries, costs, limitations, upgrade behavior, and destructive operations. Do not create empty placeholder modules or suppress scanner findings without a recorded owner, justification, and review date.
