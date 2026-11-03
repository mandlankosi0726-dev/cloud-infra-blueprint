variable "description" {
  description = "Purpose and data classification for the KMS key."
  type        = string
}

variable "project" {
  description = "Project or platform identifier for required resource tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required resource tags."
  type        = string
}

variable "key_policy_json" {
  description = "Explicit least-privilege KMS key policy JSON. Include a deliberate administrative recovery principal."
  type        = string

  validation {
    condition     = can(jsondecode(var.key_policy_json).Statement) && can(jsondecode(var.key_policy_json).Version)
    error_message = "key_policy_json must be valid IAM policy JSON with Version and Statement fields."
  }
}

variable "enable_key_rotation" {
  description = "Enable annual automatic rotation for eligible symmetric encryption keys."
  type        = bool
  default     = true
}

variable "deletion_window_in_days" {
  description = "Waiting period before a scheduled KMS key deletion, from 7 through 30 days."
  type        = number
  default     = 30

  validation {
    condition     = var.deletion_window_in_days >= 7 && var.deletion_window_in_days <= 30
    error_message = "deletion_window_in_days must be from 7 through 30."
  }
}

variable "alias_name" {
  description = "Optional alias without the alias/ prefix."
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
