mock_provider "aws" {}

run "requires_explicit_policy_and_enables_rotation" {
  command = plan
  variables {
    description = "Application data encryption"
    project     = "platform"
    environment = "test"
    key_policy_json = jsonencode({
      Version = "2012-10-17"
      Statement = [{
        Effect    = "Allow"
        Principal = { AWS = "arn:aws:iam::111122223333:role/example-workload" }
        Action    = ["kms:DescribeKey", "kms:Encrypt", "kms:Decrypt"]
        Resource  = "*"
      }]
    })
  }

  assert {
    condition     = aws_kms_key.this.enable_key_rotation && aws_kms_key.this.deletion_window_in_days == 30 && aws_kms_key.this.policy == var.key_policy_json
    error_message = "Rotation, deletion window, and explicit key policy must reach the KMS key."
  }
}
