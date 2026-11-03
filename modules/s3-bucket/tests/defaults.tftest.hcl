mock_provider "aws" {}

run "blocks_public_access_and_uses_default_encryption" {
  command = plan
  variables {
    bucket_name = "example-secure-bucket"
    project     = "platform"
    environment = "test"
  }

  assert {
    condition     = aws_s3_bucket_public_access_block.this.block_public_acls && aws_s3_bucket_public_access_block.this.block_public_policy && aws_s3_bucket_public_access_block.this.ignore_public_acls && aws_s3_bucket_public_access_block.this.restrict_public_buckets
    error_message = "Every S3 public access block must be enabled."
  }
  assert {
    condition     = aws_s3_bucket_server_side_encryption_configuration.this.rule[0].apply_server_side_encryption_by_default.sse_algorithm == "AES256"
    error_message = "S3-managed encryption should be the default."
  }
}

run "rejects_retention_without_object_lock" {
  command = plan
  variables {
    bucket_name = "example-secure-bucket"
    project     = "platform"
    environment = "test"
    object_lock_default_retention = {
      mode = "GOVERNANCE"
      days = 30
    }
  }
  expect_failures = [aws_s3_bucket.this]
}
