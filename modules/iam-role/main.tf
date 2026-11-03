resource "aws_iam_role" "this" {
  name                 = var.name
  assume_role_policy   = var.trust_policy_json
  permissions_boundary = var.permissions_boundary_arn
  max_session_duration = var.max_session_duration
  tags = merge(var.tags, {
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

resource "aws_iam_role_policy" "this" {
  for_each = var.inline_policies

  name = each.key
  role = aws_iam_role.this.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [for statement in each.value.statements : {
      Effect   = statement.effect
      Action   = statement.actions
      Resource = statement.resources
    }]
  })
}

resource "aws_iam_role_policy_attachment" "managed" {
  for_each   = var.managed_policy_arns
  role       = aws_iam_role.this.name
  policy_arn = each.value
}

resource "aws_iam_instance_profile" "this" {
  count = var.create_instance_profile ? 1 : 0
  name  = var.name
  role  = aws_iam_role.this.name
  tags  = aws_iam_role.this.tags
}
