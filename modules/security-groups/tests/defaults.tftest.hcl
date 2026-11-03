mock_provider "aws" {}

run "creates_group_without_implicit_rules" {
  command = plan
  variables {
    name        = "workload"
    description = "Private workload"
    vpc_id      = "vpc-12345678"
    project     = "platform"
    environment = "test"
  }

  assert {
    condition     = length(var.ingress_rules) == 0 && length(var.egress_rules) == 0
    error_message = "Rule inputs should default to empty lists."
  }
  assert {
    condition     = aws_security_group.this.name == "workload"
    error_message = "The group name should be passed through."
  }
}

run "rejects_rule_without_source" {
  command = plan
  variables {
    name        = "workload"
    description = "Private workload"
    vpc_id      = "vpc-12345678"
    project     = "platform"
    environment = "test"
    ingress_rules = [{
      description = "Missing source"
      ip_protocol = "tcp"
      from_port   = 443
      to_port     = 443
    }]
  }
  expect_failures = [var.ingress_rules]
}
