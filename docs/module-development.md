# Module development

Give each module one responsibility and include `main.tf`, `variables.tf`, `outputs.tf`, `versions.tf`, and a README. Type and validate inputs, describe defaults, pass providers from the root, tag resources consistently, and expose only composable outputs. Prefer secure defaults and explicit opt-ins for public access or cost-incurring resources.

For changes, format, initialize with backend disabled, validate, run TFLint and Checkov/Trivy, inspect generated docs and plan behavior, and explain limitations. Add Terraform tests for input validation and resource behavior where supported. Do not describe static validation as AWS integration testing. Review provider upgrades and plans before release; document breaking changes and tag immutable versions.
