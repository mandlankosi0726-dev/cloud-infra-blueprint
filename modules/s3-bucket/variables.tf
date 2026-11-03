variable "bucket_name" {
  description = "Globally unique S3 bucket name."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9][a-z0-9.-]{1,61}[a-z0-9]$", var.bucket_name)) && !strcontains(var.bucket_name, "..")
    error_message = "bucket_name must be a valid 3-63 character lowercase S3 name without adjacent periods."
  }
}

variable "project" {
  description = "Project or platform identifier for required resource tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required resource tags."
  type        = string
}

variable "kms_key_arn" {
  description = "Optional customer-managed KMS key ARN. When null, S3-managed encryption (AES256) is used."
  type        = string
  default     = null
}

variable "versioning_enabled" {
  description = "Enable S3 object versioning."
  type        = bool
  default     = true
}

variable "lifecycle_rules" {
  description = "Optional lifecycle transitions and expiration rules. Review effects on data retention and retrieval."
  type = list(object({
    id                                 = string
    prefix                             = optional(string, "")
    expiration_days                    = optional(number)
    noncurrent_version_expiration_days = optional(number)
    abort_incomplete_multipart_days    = optional(number)
  }))
  default = []

  validation {
    condition = alltrue([for rule in var.lifecycle_rules :
      (rule.expiration_days == null || rule.expiration_days > 0) &&
      (rule.noncurrent_version_expiration_days == null || rule.noncurrent_version_expiration_days > 0) &&
      (rule.abort_incomplete_multipart_days == null || rule.abort_incomplete_multipart_days > 0) &&
      (rule.expiration_days != null || rule.noncurrent_version_expiration_days != null || rule.abort_incomplete_multipart_days != null)
    ])
    error_message = "Each lifecycle rule needs at least one positive action period."
  }

  validation {
    condition     = length(distinct([for rule in var.lifecycle_rules : rule.id])) == length(var.lifecycle_rules)
    error_message = "Lifecycle rule IDs must be unique."
  }
}

variable "access_log_bucket" {
  description = "Optional existing bucket name receiving S3 server access logs."
  type        = string
  default     = null
}

variable "access_log_prefix" {
  description = "Prefix for server access logs in the destination bucket."
  type        = string
  default     = "s3-access/"
}

variable "object_lock_enabled" {
  description = "Enable Object Lock at bucket creation. This setting cannot be disabled after creation."
  type        = bool
  default     = false
}

variable "object_lock_default_retention" {
  description = "Optional default Object Lock retention: mode GOVERNANCE or COMPLIANCE and exactly one of days or years."
  type = object({
    mode  = string
    days  = optional(number)
    years = optional(number)
  })
  default = null

  validation {
    condition = var.object_lock_default_retention == null || (
      contains(["GOVERNANCE", "COMPLIANCE"], var.object_lock_default_retention.mode) &&
      ((var.object_lock_default_retention.days != null) != (var.object_lock_default_retention.years != null)) &&
      (var.object_lock_default_retention.days == null || var.object_lock_default_retention.days > 0) &&
      (var.object_lock_default_retention.years == null || var.object_lock_default_retention.years > 0)
    )
    error_message = "Object Lock retention needs mode GOVERNANCE or COMPLIANCE and exactly one of days or years."
  }
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
