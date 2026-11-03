#!/usr/bin/env bash
set -euo pipefail

if command -v checkov >/dev/null; then
  checkov -d . --framework terraform --quiet
elif command -v trivy >/dev/null; then
  trivy config --exit-code 1 .
else
  echo "Install Checkov or Trivy to run Terraform security scanning." >&2
  exit 127
fi

command -v gitleaks >/dev/null || { echo "gitleaks is required for secret scanning" >&2; exit 127; }
gitleaks dir . --redact
