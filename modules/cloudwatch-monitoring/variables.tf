variable "project" {
  description = "Project identifier for required tags."
  type        = string
}

variable "environment" {
  description = "Environment identifier for required tags."
  type        = string
}

variable "alarms" {
  description = "CloudWatch metric alarms. Supply dimensions appropriate to each metric's AWS namespace."
  type = map(object({
    alarm_description   = string
    namespace           = string
    metric_name         = string
    statistic           = string
    period              = number
    evaluation_periods  = number
    threshold           = number
    comparison_operator = string
    dimensions          = map(string)
    alarm_actions       = optional(list(string), [])
    ok_actions          = optional(list(string), [])
    treat_missing_data  = optional(string, "missing")
  }))
  default = {}

  validation {
    condition = alltrue([for alarm in values(var.alarms) :
      alarm.period >= 60 && alarm.evaluation_periods >= 1 &&
      contains(["GreaterThanOrEqualToThreshold", "GreaterThanThreshold", "LessThanThreshold", "LessThanOrEqualToThreshold"], alarm.comparison_operator) &&
      contains(["Average", "Minimum", "Maximum", "Sum", "SampleCount"], alarm.statistic) &&
      contains(["missing", "ignore", "breaching", "notBreaching"], alarm.treat_missing_data)
    ])
    error_message = "Alarms need a period of at least 60 seconds, positive evaluation periods, and supported comparison/statistic/missing-data values."
  }
}

variable "tags" {
  description = "Additional non-sensitive tags."
  type        = map(string)
  default     = {}
}
