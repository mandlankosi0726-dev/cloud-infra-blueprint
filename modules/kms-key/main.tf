resource "aws_kms_key" "this" {
  description             = var.description
  policy                  = var.key_policy_json
  enable_key_rotation     = var.enable_key_rotation
  deletion_window_in_days = var.deletion_window_in_days
  tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_kms_alias" "this" {
  count         = var.alias_name == null ? 0 : 1
  name          = "alias/${var.alias_name}"
  target_key_id = aws_kms_key.this.key_id
}
