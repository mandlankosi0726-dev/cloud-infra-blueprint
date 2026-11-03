resource "aws_db_subnet_group" "this" {
  name       = "${var.identifier}-subnets"
  subnet_ids = var.subnet_ids
  tags = merge(var.tags, {
    Name        = "${var.identifier}-subnets"
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  })
}

resource "aws_db_instance" "this" {
  identifier                  = var.identifier
  engine                      = "postgres"
  engine_version              = var.engine_version
  instance_class              = var.instance_class
  db_name                     = var.database_name
  username                    = var.master_username
  manage_master_user_password = true
  port                        = 5432
  allocated_storage           = var.allocated_storage_gib
  max_allocated_storage       = var.max_allocated_storage_gib
  storage_type                = "gp3"
  storage_encrypted           = true
  kms_key_id                  = var.kms_key_arn
  db_subnet_group_name        = aws_db_subnet_group.this.name
  vpc_security_group_ids      = var.security_group_ids
  publicly_accessible         = false
  backup_retention_period     = var.backup_retention_days
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window
  multi_az                    = var.multi_az
  deletion_protection         = var.deletion_protection
  monitoring_interval         = var.monitoring_interval_seconds
  monitoring_role_arn         = var.monitoring_interval_seconds == 0 ? null : var.monitoring_role_arn
  auto_minor_version_upgrade  = true
  apply_immediately           = var.apply_immediately
  skip_final_snapshot         = false
  final_snapshot_identifier   = var.final_snapshot_identifier
  copy_tags_to_snapshot       = true

  tags = merge(var.tags, {
    Name        = var.identifier
    Project     = var.project
    Environment = var.environment
    ManagedBy   = "Terraform"
  })

  lifecycle {
    precondition {
      condition     = var.monitoring_interval_seconds == 0 || var.monitoring_role_arn != null
      error_message = "monitoring_role_arn is required when Enhanced Monitoring is enabled."
    }
    precondition {
      condition     = var.max_allocated_storage_gib == 0 || var.max_allocated_storage_gib >= var.allocated_storage_gib
      error_message = "max_allocated_storage_gib must be zero or at least allocated_storage_gib."
    }
  }
}
