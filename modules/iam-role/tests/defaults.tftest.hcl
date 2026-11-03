mock_provider "aws" {}

run "creates_role_with_explicit_trust_and_no_permissions" {
  command = plan
  variables {
    name        = "application-role"
    project     = "platform"
    environment = "test"
    trust_policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Principal = { Service = "ec2.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }]
    })
  }

  assert {
    condition     = aws_iam_role.this.name == "application-role" && length(var.inline_policies) == 0 && length(var.managed_policy_arns) == 0
    error_message = "Role name should pass through and permissions should remain empty by default."
  }
}

run "rejects_invalid_trust_json" {
  command = plan
  variables {
    name              = "application-role"
    project           = "platform"
    environment       = "test"
    trust_policy_json = "not-json"
  }
  expect_failures = [var.trust_policy_json]
}
