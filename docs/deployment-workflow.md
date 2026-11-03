# Deployment workflow

1. Confirm AWS account, region, client, and environment.
2. Review configuration, versions, and state key; initialize the correct backend.
3. Run formatting, validation, lint, security scan, and tests.
4. Create a plan and review all creates, replacements, and destroys, including costs and security scope.
5. Obtain authorization under the environment's change controls; production should use protected GitHub Environment reviewers.
6. Apply only the reviewed plan from a trusted branch and least-privilege OIDC role, then verify resources and hand over monitoring, access, backups, and recovery details.

The repository workflows do not apply infrastructure or request AWS credentials. A deployment workflow must not expose credentials to forked pull requests. Use OIDC rather than long-lived access keys, restrict token permissions, and set plan artifact access and retention carefully because plans may contain sensitive values. Never use `-auto-approve` as a substitute for review.
