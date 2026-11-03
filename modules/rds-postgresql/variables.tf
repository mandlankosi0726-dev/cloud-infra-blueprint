variable "identifier" {
  description = "Unique RDS DB instance identifier."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,62}$", var.identifier)) && !strcontains(var.identifier, "--") && !endswith(var.identifier, "-")
    error_message = "identifier must start with a letter, use only lowercase letters, numbers, and hyphens, and contain no consecutive or trailing hyphens."
  }
}

variable "final_snapshot_identifier" {
  description = "Unique identifier for the final snapshot created when this database is deleted. Choose a fresh unique value before each approved deletion."
  type        = string

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{0,254}$", var.final_snapshot_identifier)) && !strcontains(var.final_snapshot_identifier, "--") && !endswith(var.final_snapshot_identifier, "-")
    error_message = "final_snapshot_identifier must start with a letter and use lowercase letters, numbers, and non-consecutive/non-trailing hyphens."
  }
}

variable "project" {
  description = "Project identifier for required tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required tags."
  type        = string
}

variable "engine_version" {
  description = "Explicit supported PostgreSQL engine version for the selected region."
  type        = string
}

variable "instance_class" {
  description = "RDS instance class selected for workload capacity."
  type        = string
}

variable "database_name" {
  description = "Optional initial database name."
  type        = string
  default     = null

  validation {
    condition     = var.database_name == null || can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,62}$", var.database_name))
    error_message = "database_name must be null or contain 1-63 letters, numbers, or underscores and start with a letter."
  }
}

variable "master_username" {
  description = "Master username; the password is generated and managed by RDS in Secrets Manager."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9_]{0,62}$", var.master_username))
    error_message = "master_username must contain 1-63 letters, numbers, or underscores and start with a letter."
  }
}

variable "subnet_ids" {
  description = "Private subnet IDs spanning at least two Availability Zones."
  type        = set(string)

  validation {
    condition     = length(var.subnet_ids) >= 2
    error_message = "RDS subnet groups need at least two subnet IDs in distinct Availability Zones."
  }
}

variable "security_group_ids" {
  description = "Explicit security groups controlling database ingress and egress."
  type        = set(string)

  validation {
    condition     = length(var.security_group_ids) > 0
    error_message = "At least one security group must be attached to the database."
  }
}

variable "kms_key_arn" {
  description = "Optional customer-managed KMS key ARN; otherwise RDS uses an AWS-managed key."
  type        = string
  default     = null
}

variable "allocated_storage_gib" {
  description = "Initial allocated storage in GiB."
  type        = number
  default     = 20

  validation {
    condition     = var.allocated_storage_gib >= 20
    error_message = "allocated_storage_gib must be at least 20 GiB."
  }
}

variable "max_allocated_storage_gib" {
  description = "Autoscaling storage ceiling in GiB. Set to 0 to disable storage autoscaling."
  type        = number
  default     = 100
}

variable "backup_retention_days" {
  description = "Automated backup retention from 1 to 35 days."
  type        = number
  default     = 7

  validation {
    condition     = var.backup_retention_days >= 1 && var.backup_retention_days <= 35
    error_message = "backup_retention_days must be from 1 through 35."
  }
}

variable "multi_az" {
  description = "Enable a synchronous standby in another Availability Zone. This increases cost and is not a substitute for recovery testing."
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Prevent RDS deletion until deliberately disabled."
  type        = bool
  default     = true
}

variable "monitoring_interval_seconds" {
  description = "Enhanced monitoring interval in seconds; use 0 to disable."
  type        = number
  default     = 0

  validation {
    condition     = contains([0, 1, 5, 10, 15, 30, 60], var.monitoring_interval_seconds)
    error_message = "monitoring_interval_seconds must be 0, 1, 5, 10, 15, 30, or 60."
  }
}

variable "monitoring_role_arn" {
  description = "Role ARN for Enhanced Monitoring when its interval is nonzero."
  type        = string
  default     = null
}

variable "maintenance_window" {
  description = "Optional preferred weekly maintenance window in UTC."
  type        = string
  default     = null
}

variable "backup_window" {
  description = "Optional preferred daily backup window in UTC."
  type        = string
  default     = null
}

variable "apply_immediately" {
  description = "Apply modifications immediately; false defers them to the maintenance window where possible."
  type        = bool
  default     = false
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
