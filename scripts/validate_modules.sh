#!/usr/bin/env bash
set -euo pipefail

command -v terraform >/dev/null || { echo "terraform is required" >&2; exit 127; }
terraform fmt -check -recursive

while IFS= read -r -d '' dir; do
  echo "Validating ${dir}"
  terraform -chdir="$dir" init -backend=false -input=false
  terraform -chdir="$dir" validate
done < <(find modules examples -name '*.tf' -printf '%h\0' | sort -zu)

while IFS= read -r -d '' test_dir; do
  module_dir="${test_dir%/tests}"
  echo "Testing ${module_dir}"
  terraform -chdir="$module_dir" test -no-color
done < <(find modules -type f -path '*/tests/*.tftest.hcl' -printf '%h\0' | sort -zu)

if command -v tflint >/dev/null; then
  tflint --init
  tflint --recursive
else
  echo "tflint not installed; lint step skipped" >&2
fi
