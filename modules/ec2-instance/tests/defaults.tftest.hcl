mock_provider "aws" {}

run "requires_imdsv2_and_encrypted_root_volume" {
  command = plan
  variables {
    name               = "private-workload"
    project            = "platform"
    environment        = "test"
    ami_id             = "ami-0123456789abcdef0"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-12345678"
    security_group_ids = ["sg-12345678"]
  }

  assert {
    condition     = aws_instance.this.associate_public_ip_address == false && aws_instance.this.metadata_options[0].http_tokens == "required"
    error_message = "Instances must not receive a public IP and must require IMDSv2."
  }
  assert {
    condition     = aws_instance.this.root_block_device[0].encrypted
    error_message = "The root EBS volume must be encrypted."
  }
}

run "requires_security_group_selection" {
  command = plan
  variables {
    name               = "private-workload"
    project            = "platform"
    environment        = "test"
    ami_id             = "ami-0123456789abcdef0"
    instance_type      = "t3.micro"
    subnet_id          = "subnet-12345678"
    security_group_ids = []
  }
  expect_failures = [var.security_group_ids]
}
