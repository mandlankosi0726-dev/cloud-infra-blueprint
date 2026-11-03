variable "name" {
  description = "IAM role name."
  type        = string

  validation {
    condition     = can(regex("^[a-zA-Z0-9+=,.@_-]{1,64}$", var.name))
    error_message = "name must be 1-64 characters and use only AWS IAM role name characters."
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

variable "trust_policy_json" {
  description = "Explicit JSON trust policy identifying the workload principal allowed to assume this role."
  type        = string

  validation {
    condition     = can(jsondecode(var.trust_policy_json).Statement) && can(jsondecode(var.trust_policy_json).Version)
    error_message = "trust_policy_json must be valid IAM policy JSON with Version and Statement fields."
  }
}

variable "inline_policies" {
  description = "Least-privilege inline policies scoped to the workload. Empty by default."
  type = map(object({
    statements = list(object({
      effect    = optional(string, "Allow")
      actions   = list(string)
      resources = list(string)
    }))
  }))
  default = {}

  validation {
    condition = alltrue(flatten([for policy in values(var.inline_policies) : [for statement in policy.statements :
      contains(["Allow", "Deny"], statement.effect) && length(statement.actions) > 0 && length(statement.resources) > 0
    ]]))
    error_message = "Inline policy statements need a valid Effect and non-empty actions and resources."
  }

  validation {
    condition     = alltrue([for policy in values(var.inline_policies) : length(policy.statements) > 0])
    error_message = "Each inline policy must contain at least one statement."
  }
}

variable "managed_policy_arns" {
  description = "Optional reviewed managed policy ARNs for workload-specific permissions. Avoid broad policies."
  type        = set(string)
  default     = []
}

variable "permissions_boundary_arn" {
  description = "Optional permissions boundary ARN enforced for this role."
  type        = string
  default     = null
}

variable "create_instance_profile" {
  description = "Create an EC2 instance profile that contains this role."
  type        = bool
  default     = false
}

variable "max_session_duration" {
  description = "Maximum role session in seconds."
  type        = number
  default     = 3600

  validation {
    condition     = var.max_session_duration >= 3600 && var.max_session_duration <= 43200
    error_message = "max_session_duration must be from 3600 through 43200 seconds."
  }
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
